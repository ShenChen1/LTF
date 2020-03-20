#!/bin/bash

set -aeu
source _shellflags

E=1
trap 'rm -f "$TMP" "TMP1"; exit $E' 0 1 2 3 15
TMP=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
TMP1=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)

# install testhelper first
echo testhelper >"$TMP"
# setup requirement
for setup in $SETUPREQUIREMENTS; do
    echo $setup >>"$TMP"
done
# delete duplicate items
uniq "$TMP" > "$TMP1"

while read SETUP; do
    [ "" != "$SETUP" ] || continue
    echo "+++ setting up setup ${SETUP} on ${TESTTARGET} ..."
    DEFAULTGOAL="${TESTROOT}/components/setup/${SETUP}"
    if [ -d "$DEFAULTGOAL" ]; then
        $MAKE -C "$DEFAULTGOAL" test
    else
        echo "WARNING: $DEFAULTGOAL : no such setup directory" >&2
    fi
done <"$TMP1"
E=0
