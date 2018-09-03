#!/usr/bin/env bash
set -euo pipefail

function convert_file {
  local xccovarchive_file="$1"
  local file_name="$2"
  echo "  <file path=\"$file_name\">"
  xcrun xccov view --file "$file_name" "$xccovarchive_file" | \
    sed -n '
    s/^ *\([0-9][0-9]*\): 0.*$/    <lineToCover lineNumber="\1" covered="false"\/>/p;
    s/^ *\([0-9][0-9]*\): [1-9].*$/    <lineToCover lineNumber="\1" covered="true"\/>/p
    '
  echo '  </file>'
}

function xccov_to_generic {
  echo '<coverage version="1">'
  for xccovarchive_file in "$@"; do
    xcrun xccov view --file-list "$xccovarchive_file" | while read -r file_name; do
      convert_file "$xccovarchive_file" "$file_name"
    done
  done
  echo '</coverage>'
}

xccov_to_generic "$@"
