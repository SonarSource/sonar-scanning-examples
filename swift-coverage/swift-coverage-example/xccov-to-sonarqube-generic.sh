#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
	echo -e "Export coverage from Xcode xcresult or xccovarchive in Sonarcube Generic Test Data format\n"
    echo "Usage: $(basename $0) <xcresult/xccovarchive> [<xcresult/xccovarchive> ...]" >&2
    exit 2
fi


for xccovarchive_file in "$@"; do
	if [[ ! -d $xccovarchive_file ]]; then
      echo "Coverage FILE NOT FOUND AT PATH: $xccovarchive_file" 1>&2;
      exit 1
    fi

    xccov_options=""
    if [[ $xccovarchive_file == *".xcresult"* ]]; then
      xccov_options="--archive"
    fi
 
	xcrun xccov view $xccov_options "$xccovarchive_file" | 
		awk '
			BEGIN {
				FS=":"
				print "<coverage version=\"1\">"
			}
			/^\//{
				if (file) print "  </file>"
				print "  <file path=\""$1"\">"
				file=1
			}
			/^ *[0-9]*: [0-9]+( \[)?/{
				gsub(/ +/,"",$1)
				gsub(/ +/,"",$2);gsub(/\[/,"",$2)
				if(int($2)>0) covered="true"; else covered="false"
				print "    <lineToCover lineNumber=\""$1"\" covered=\""covered"\"\/>"
			}
			END {
				if(file)print "  </file>"
				print "</coverage>"
			}
		'
done
