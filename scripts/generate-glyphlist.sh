#/bin/bash

cat dvips/*.enc |
sed -e 's/^.*\[//' -e 's/^%.*$//' |
tr " " "\n" |
grep -v "^/\.notdef$" |
grep '^/' |
sort -u
