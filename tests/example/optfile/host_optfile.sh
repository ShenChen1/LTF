#!/bin/bash

file="/tmp/hosts"
cp /etc/hosts $file

echo "test case 1"
putfile "$file" __tmp
getfile __tmp
diff __tmp "$file"

echo "test case 2"
putfile "$file"
getfile "${file##*/}" __tmp1
diff __tmp1 "$file"

echo "test case 3"
putfile "$file" "$file.tmp"
getfile "$file.tmp" __tmp2
diff __tmp2 "$file"

echo "test failure 1"
putfile "$file" "./nodir/"

echo "test failure 2"
putfile "nofile" "./nodir/"
