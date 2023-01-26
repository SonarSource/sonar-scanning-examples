#!/usr/bin/env bash
set -euo pipefail

function convert_xccov_to_xml {
    sed -n                                                                                       \
        -e '/:$/s/&/\&amp;/g;s/^\(.*\):$/  <file path="\1">/p'                                   \
        -e 's/^ *\([0-9][0-9]*\): 0.*$/    <lineToCover lineNumber="\1" covered="false"\/>/p'    \
        -e 's/^ *\([0-9][0-9]*\): [1-9].*$/    <lineToCover lineNumber="\1" covered="true"\/>/p' \
        -e 's/^$/  <\/file>/p'
}

function convert_archive {
  local xccovarchive_file="$1"
  xcrun xccov view --archive "$xccovarchive_file" | convert_xccov_to_xml
}

function xccov_to_generic {
  echo '<coverage version="1">'
  for xccovarchive_file in "$@"; do
    if [[ ! -d $xccovarchive_file ]]; then
      echo "Coverage file not found at path: $xccovarchive_file" 1>&2;
      exit 1
    elif (( xcode_version < 13 )); then
      echo "Xcode version not supported ($xcode_version) version 13 or above is required" 1>&2;
      exit 1
    elif [[ $xccovarchive_file != *".xcresult"* ]]; then
      echo "Incorrect test results path. Required *.xcresult: $xccovarchive_file" 1>&2;
      exit 1
    fi

    convert_archive "$xccovarchive_file"
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

xcode_version=$(check_xcode_version)
if [ $? -ne 0 ]; then
  exit -1
fi

xccov_to_generic "$@"
