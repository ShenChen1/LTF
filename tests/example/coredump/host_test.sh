#!/bin/bash

invoke "echo 'running on' $(whoami)"

$(${TESTANALYZER} arch)-gcc -g -o demo -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables demo.c
$(${TESTANALYZER} arch)-objcopy --only-keep-debug demo demo.dbg
$(${TESTANALYZER} arch)-objcopy --strip-debug demo
$(${TESTANALYZER} arch)-objcopy --add-gnu-debuglink=demo.dbg demo
putfile "demo"

invoke "echo core > /proc/sys/kernel/core_pattern"

invoke "rm -f core*"
invoke "ulimit -c unlimited && chmod +x demo && ./demo"

corefile=$(invoke "ls core*")
getfile "${corefile}"
