#/bin/bash

cat dvips/a_*.enc enc/missing.enc |
sed -e 's/^.*\[//' -e 's/^%.*$//' |
tr " " "\n" |
grep -v "^/\.notdef$" |
grep '^/' |
sort -u
