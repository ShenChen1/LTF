#!/bin/bash

invoke "echo 'running on' $(whoami)"

$(${TESTANALYZER} arch)-gcc -g -o demo -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables demo.c
putfile "demo"

invoke "echo core > /proc/sys/kernel/core_pattern"

invoke "rm -f core*"
invoke "ulimit -c unlimited && chmod +x demo && ./demo"

corefile=$(invoke "ls core*")
getfile "${corefile}"
