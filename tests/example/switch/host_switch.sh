#!/bin/bash
echo "running host test ..."

make setup TESTTARGET=demo
make setup TESTTARGET=demo1

TESTTARGET=demo
echo running on ${TESTTARGET}
invoke "whoami"
echo "result:$?"

TESTTARGET=demo1
echo running on ${TESTTARGET}
invoke "whoami"
echo "result:$?"
