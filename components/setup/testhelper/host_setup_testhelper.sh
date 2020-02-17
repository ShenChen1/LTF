#!/bin/bash

set -aeu
source _shellflags

echo -n "checking if testhelper is reachable -"

TMPFILE="$(mktemp /tmp/setupttestexecdXXXXXXXXX)"
trap 'rm -f "$TMPFILE"' 0 1 2 3 15

for i in {1..5}
do
    if invoke true 2>>"$TMPFILE"
    then
        rm -f "$TMPFILE"
        echo " yes"
        exit 0
    else
        echo -n "-"
        sleep 1
        echo "---- retry to connect ($i/5)----">>"$TMPFILE"
    fi
done
echo " no"
egrep -q '^FA|cannot open connection|make setup' $TMPFILE || cat "$TMPFILE" >&2
rm -f "$TMPFILE"

if invoke_ssh "ls /tmp/testhelperd" >/dev/null 2>&1; then
    echo "found testhelper ..."
else
    echo "creating testhelper ..."
    cd  "${TESTROOT}/src/testhelper/"
    makecall CROSS_COMPILE="$("${TESTANALYZER}" "arch")-"
 
    echo "copying testhelper ...."
    putfile_ssh testhelperd /tmp/
fi

echo "invoking testhelper ..."
PORT="$("${TESTANALYZER}" "port")"
invoke_ssh "rm -rf /tmp/testhelper_$PORT && mkdir -p /tmp/testhelper_$PORT && mv /tmp/testhelperd /tmp/testhelper_$PORT"
invoke_ssh "cd /tmp/testhelper_$PORT && ./testhelperd -d -p $PORT > /dev/null" 

echo -n "checking if testhelper is running - "
if invoke true 2>/dev/null
then
    echo yes
else
    echo no
    exit 1
fi
exit $?
