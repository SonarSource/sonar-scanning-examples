#!/usr/bin/env bash
set -euo pipefail

# Convert xccov output to SonarQube Generic Coverage format
# Supports both line coverage and branch coverage
#
# xccov output format:
#   /path/to/file.swift:
#   10: *              <- non-executable line
#   11: 0              <- uncovered line
#   12: 5              <- covered line (executed 5 times)
#   13: 2 [            <- covered line with branch info
#   (33, 9, 0)         <- branch at column 33: 9 hits on one path, 0 on other
#   ]
#
# Branch tuple format: (column, count1, count2)
#   - count1 > 0 means first branch path was executed
#   - count2 > 0 means second branch path was executed

function convert_xccov_to_xml {
  awk '
    BEGIN {
      current_file = ""
      in_branch_block = 0
    }

    # Match file path line (ends with :)
    /:$/ && !/^ *[0-9]+:/ {
      # Close previous file if any
      if (current_file != "") {
        print "  </file>"
      }
      # Extract path (remove trailing colon) and escape ampersands for XML
      path = substr($0, 1, length($0) - 1)
      gsub(/&/, "\\&amp;", path)
      print "  <file path=\"" path "\">"
      current_file = path
      in_branch_block = 0
      next
    }

    # Match branch info opening: "  NN: X ["
    /^ *[0-9]+: [0-9]+ \[$/ {
      # Parse line number (field 1 without colon)
      line_num = $1
      sub(/:$/, "", line_num)
      # Parse execution count (field 2)
      exec_count = $2 + 0
      
      current_line = line_num
      current_exec = exec_count
      total_branches = 0
      covered_branches = 0
      in_branch_block = 1
      next
    }

    # Match branch tuple: "(column, count1, count2)"
    /^\([0-9]+, [0-9]+, [0-9]+\)$/ {
      if (in_branch_block) {
        # Remove parentheses
        line = $0
        gsub(/[()]/, "", line)
        # Split by ", "
        n = split(line, vals, ", ")
        if (n >= 3) {
          count1 = vals[2] + 0
          count2 = vals[3] + 0
          
          # Each tuple represents 2 branches
          total_branches += 2
          if (count1 > 0) covered_branches++
          if (count2 > 0) covered_branches++
        }
      }
      next
    }

    # Match branch block closing: "]"
    /^\]$/ {
      if (in_branch_block) {
        covered = (current_exec > 0) ? "true" : "false"
        if (total_branches > 0) {
          printf "    <lineToCover lineNumber=\"%s\" covered=\"%s\" branchesToCover=\"%d\" coveredBranches=\"%d\"/>\n", current_line, covered, total_branches, covered_branches
        } else {
          printf "    <lineToCover lineNumber=\"%s\" covered=\"%s\"/>\n", current_line, covered
        }
        in_branch_block = 0
      }
      next
    }

    # Match uncovered line: "  NN: 0" (no branch info)
    /^ *[0-9]+: 0$/ {
      line_num = $1
      sub(/:$/, "", line_num)
      printf "    <lineToCover lineNumber=\"%s\" covered=\"false\"/>\n", line_num
      next
    }

    # Match covered line without branch info: "  NN: X" where X > 0
    /^ *[0-9]+: [1-9][0-9]*$/ {
      line_num = $1
      sub(/:$/, "", line_num)
      printf "    <lineToCover lineNumber=\"%s\" covered=\"true\"/>\n", line_num
      next
    }

    # Empty line - end of file section
    /^$/ {
      if (current_file != "") {
        print "  </file>"
        current_file = ""
      }
      next
    }

    END {
      # Close last file if needed
      if (current_file != "") {
        print "  </file>"
      }
    }
  '
}

function convert_xccov_to_coverage_xml {
  local xcresult="$1"

  echo '<coverage version="1">'
  xcrun xccov view --archive "$xcresult" | convert_xccov_to_xml
  echo '</coverage>'
}
function is_xcode_version_supported() {
  local major=${1:-0} minor=${2:-0}
  # Return 0 (success) if version is supported, 1 (failure) if not
  if (( (major >= 14) || (major == 13 && minor >= 3) )); then
    return 0  # supported
  else
    return 1  # not supported
  fi
}

# Ensure required tools are available
command -v xcrun >/dev/null 2>&1 || { echo >&2 "xcrun is required but not installed."; exit 1; }
command -v xcodebuild >/dev/null 2>&1 || { echo >&2 "xcodebuild is required but not installed."; exit 1; }

# Get Xcode version
if ! xcode_version="$(xcodebuild -version | sed -n '1s/^Xcode \([0-9.]*\)$/\1/p')"; then
  echo 'Failed to get Xcode version' 1>&2
  exit 1
elif ! is_xcode_version_supported ${xcode_version//./ }; then
  echo "Xcode version '$xcode_version' not supported, version 13.3 or above is required" 1>&2;
  exit 1
fi

# Validate input
if [[ $# -ne 1 ]]; then
  echo "Invalid number of arguments. Expecting 1 path matching '*.xcresult'"
  exit 1
fi

xcresult="$1"
if [[ ! -d "$xcresult" ]]; then
  echo "Path not found: $xcresult" 1>&2;
  exit 1
elif [[ $xcresult != *".xcresult"* ]]; then
  echo "Expecting input to match '*.xcresult', got: $xcresult" 1>&2;
  exit 1
fi

# Perform conversion
convert_xccov_to_coverage_xml "$xcresult"
