#!/usr/bin/env bash
set -euo pipefail

function convert_xccov_to_xml {
  sed -n                                                                                       \
      -e '/:$/s/&/\&amp;/g;s/^\(.*\):$/  <file path="\1">/p'                                   \
      -e 's/^ *\([0-9][0-9]*\): 0.*$/    <lineToCover lineNumber="\1" covered="false"\/>/p'    \
      -e 's/^ *\([0-9][0-9]*\): [1-9].*$/    <lineToCover lineNumber="\1" covered="true"\/>/p' \
      -e 's/^$/  <\/file>/p'
}

function convert_xccov_to_coverage_xml {
  local xcresult="$1"

  echo '<coverage version="1">'
  xcrun xccov view --archive "$xcresult" | convert_xccov_to_xml
  echo '</coverage>'
}

function check_xcode_version() {
  local required_version="13.3"
  if [[ "$(echo -e "$1\n$required_version" | sort -V | head -n1)" != "$required_version" ]]; then
    return 0
  else
    return 1
  fi
}

# Ensure required tools are available
command -v xcrun >/dev/null 2>&1 || { echo >&2 "xcrun is required but not installed."; exit 1; }
command -v xcodebuild >/dev/null 2>&1 || { echo >&2 "xcodebuild is required but not installed."; exit 1; }

# Get Xcode version
if ! xcode_version="$(xcodebuild -version | sed -n '1s/^Xcode \([0-9.]*\)$/\1/p')"; then
  echo 'Failed to get Xcode version' 1>&2
  exit 1
elif check_xcode_version "$xcode_version"; then
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
