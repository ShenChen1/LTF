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

# start setup
INVOKE_METHOD=$("${TESTANALYZER}" "setupmethod")
if invoke "ls /tmp/testhelperd" >/dev/null 2>&1; then
    echo "found testhelper ..."
else
    echo "creating testhelper ..."
    makecall -C "${TESTHELPER_SRCDIR}" CROSS_COMPILE="$("${TESTANALYZER}" "arch")-"
    echo "copying testhelper ...."
    putfile "${TESTHELPERD}" /tmp/
fi

echo "invoking testhelper ..."
PORT="$("${TESTANALYZER}" "port")"
invoke "rm -rf /tmp/testhelper_$PORT && mkdir -p /tmp/testhelper_$PORT && mv /tmp/testhelperd /tmp/testhelper_$PORT"
invoke "cd /tmp/testhelper_$PORT && chmod +x ./testhelperd && ./testhelperd -d -p $PORT -v > /dev/null" 

echo -n "checking if testhelper is running - "
INVOKE_METHOD=testhelper
if invoke true 2>/dev/null
then
    echo yes
else
    echo no
    exit 1
fi
exit $?
