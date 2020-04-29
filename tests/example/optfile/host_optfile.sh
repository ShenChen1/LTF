#!/bin/bash

file="./__tmpdir/binary"
mkdir -p $(dirname $file)
dd if=/dev/urandom of="$file" bs=1M count=2

#method="_ssh"
#method="_telnet"

echo "test case 1"
"putfile${method}" "$file" __tmp
"getfile${method}" __tmp
diff __tmp "$file"

echo "test case 2"
"putfile${method}" "$file"
"getfile${method}" "${file##*/}" __tmp1
diff __tmp1 "$file"

echo "test case 3"
"putfile${method}" "$file" "/tmp/$(basename ${file}.tmp)"
"getfile${method}" "/tmp/$(basename ${file}.tmp)" __tmp2
diff __tmp2 "$file"

echo "test failure 1"
"putfile${method}" "$file" "./nodir/"
echo "result:$?"

echo "test failure 2"
"putfile${method}" "nofile" "./nodir/"
echo "result:$?"

exit 0
