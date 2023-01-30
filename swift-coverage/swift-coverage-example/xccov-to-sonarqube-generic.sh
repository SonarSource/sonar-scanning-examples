#!/usr/bin/env bash
set -euo pipefail

function convert_xccov_to_xml {
  sed -n                                                                                       \
      -e '/:$/s/&/\&amp;/g;s/^\(.*\):$/  <file path="\1">/p'                                   \
      -e 's/^ *\([0-9][0-9]*\): 0.*$/    <lineToCover lineNumber="\1" covered="false"\/>/p'    \
      -e 's/^ *\([0-9][0-9]*\): [1-9].*$/    <lineToCover lineNumber="\1" covered="true"\/>/p' \
      -e 's/^$/  <\/file>/p'
}

function xccov_to_generic {
  local xcresult="$1"

  echo '<coverage version="1">'
  xcrun xccov view --archive "$xcresult" | convert_xccov_to_xml
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

xcode_version=$(check_xcode_version)
if [ $? -ne 0 ]; then
  exit -1
fi

xcresult="$1"

if (( xcode_version < 13 )); then
  echo "Xcode version not supported ($xcode_version) version 13 or above is required" 1>&2;
  exit 1
elif [[ ! -d $xcresult ]]; then
  echo "Coverage file not found at path: $xcresult" 1>&2;
  exit 1
elif [[ $xcresult != *".xcresult"* ]]; then
  echo "Expecting input to match '*.xcresult', got: $xcresult" 1>&2;
  exit 1
fi

xccov_to_generic "$xcresult"
