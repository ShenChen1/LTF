#!/bin/bash
echo "running host test ..."

compile "hello.c"
putfile "__hello"
invoke "chmod +x __hello && ./__hello > __tmp.log"
getfile "__tmp.log"
cat "__tmp.log"
path="$(invoke "find /tmp/testhelper* -name __tmp.log")"
getfile_ssh "$path" "__tmp.log.1"
cat "__tmp.log.1"

invoke "ls 123"
echo "result:$?"
