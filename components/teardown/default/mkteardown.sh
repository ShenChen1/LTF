#!/bin/bash

set -aeu
source _shellflags

E=1
trap 'rm -f "$TMP"; exit $E' 0 1 2 3 15
TMP=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)

# teardown requirement
for setup in $SETUPREQUIREMENTS; do
    echo $setup >>"$TMP"
done

while read TEARDOWN; do
    [ "" != "$TEARDOWN" ] || continue
    echo "+++ teardown ${TEARDOWN} on ${TESTTARGET} ..."
    DEFAULTGOAL="${TESTROOT}/components/teardown/${TEARDOWN}"
    if [ -d "$DEFAULTGOAL" ]; then
        $MAKE -C "$DEFAULTGOAL" test
    else
        echo "WARNING: $DEFAULTGOAL : no such teardown directory" >&2
    fi
done <"$TMP"
E=0
