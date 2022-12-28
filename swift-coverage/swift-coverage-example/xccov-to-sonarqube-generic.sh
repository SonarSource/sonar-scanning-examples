#!/usr/bin/env bash
set -euo pipefail

function convert_file {
  local xccovarchive_file="$1"
  local file_name="$2"
  local xccov_options="$3"
  echo "  <file path=\"$file_name\">"
  xcrun xccov view $xccov_options --file "$file_name" "$xccovarchive_file" | \
    sed -n '
    s/^ *\([0-9][0-9]*\): 0.*$/    <lineToCover lineNumber="\1" covered="false"\/>/p;
    s/^ *\([0-9][0-9]*\): [1-9].*$/    <lineToCover lineNumber="\1" covered="true"\/>/p
    '
  echo '  </file>'
}

function xccov_to_generic {
  echo '<coverage version="1">'
  for xccovarchive_file in "$@"; do
    if [[ ! -d $xccovarchive_file ]]
    then
      echo "Coverage FILE NOT FOUND AT PATH: $xccovarchive_file" 1>&2;
      exit 1
    fi

    if [ $xcode_version -gt 10 ]; then # Apply optimization
       xccovarchive_file=$(optimize_format)
    fi

    local xccov_options=""
    if [[ $xccovarchive_file == *".xcresult"* ]]; then
      xccov_options="--archive"
    fi
    xcrun xccov view $xccov_options --file-list "$xccovarchive_file" | while read -r file_name; do
      convert_file "$xccovarchive_file" "$file_name" "$xccov_options"
    done
  done
  echo '</coverage>'
}

function check_xcode_version {
  xcode_major_version=`xcodebuild -version | head -n 1 | cut -d " " -f2 | cut -d . -f1`

  if [ $? -ne 0 ]; then 
    echo 'Failed to execute xcrun show-sdk-version' 1>&2
    exit -1
  fi
  echo $xcode_major_version
}

function cleanup_tmp_files {
  rm -rf tmp.json
  rm -rf tmp.xccovarchive
}

# Optimize coverage files conversion time by exporting to a clean xcodearchive directory
# Credits to silverhammermba on issue #68 for the suggestion
function optimize_format {
  cleanup_tmp_files
  xcrun xcresulttool get --format json --path "$xccovarchive_file" > tmp.json
  if [ $? -ne 0 ]; then 
    echo 'Failed to execute xcrun xcresulttool get' 1>&2
    exit -1
  fi

  # local reference=$(jq -r '.actions._values[2].actionResult.coverage.archiveRef.id._value'  tmp.json)
  local reference=$(jq -r '.actions._values[]|[.actionResult.coverage.archiveRef.id],._values'  tmp.json | grep value | cut -d : -f 2 | cut -d \" -f 2)
  if [ $? -ne 0 ]; then 
    echo 'Failed to execute jq (https://stedolan.github.io/jq/)' 1>&2
    exit -1
  fi
  # $reference can be a list of IDs (from a merged .xcresult bundle of multiple test plans)
  for test_ref in $reference; do
    xcrun xcresulttool export --type directory --path "$xccovarchive_file" --id "$test_ref" --output-path tmp.xccovarchive
    if [ $? -ne 0 ]; then 
      echo "Failed to execute xcrun xcresulttool export for reference ${test_ref}" 1>&2
      exit -1
    fi
  done
  echo "tmp.xccovarchive"
}

xcode_version=$(check_xcode_version)
if [ $? -ne 0 ]; then
  exit -1
fi

xccov_to_generic "$@"
cleanup_tmp_files