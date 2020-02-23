#!/bin/bash

file="/etc/hosts"

echo "test 1"
putfile "$file" __tmp
getfile __tmp
diff __tmp "$file"

echo "test 2"
putfile "$file"
getfile "${file##*/}" __tmp1
diff __tmp1 "$file"

echo "test 3"
putfile "$file" "$file"
getfile "$file" __tmp2
diff __tmp2 "$file"
