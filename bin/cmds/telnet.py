#!/usr/bin/env python

import os
import sys
import re

def main():

    prompt = sys.argv[5]
    args = " "
    for s in sys.argv[1:]:
        args += ('\'' + s + '\' ')

    pt = False
    l = 0
    s = ""
    exitcode = 0

    r = os.popen("telnet.exp" + args)
    lines = r.readlines()
    for line in lines:
        l += 1
        line = line.replace('\r\n', '\n')
        if l == 1 and re.search('^spawn', line):
            s += line
            continue

        if pt is False and re.search(prompt, line):
            pt = True
            s += line
            continue

        if pt is False:
            s += line
            continue

        if pt is True and re.search(prompt, line):
            s += line
            continue

        if re.search('\+\+\+\-exit\-\+\+\+ (\d+)', line):
            s += line
            exitcode = 1
            break

        sys.stdout.write(line)

    r.close()

    if pt is False:
        exitcode = 2

    if exitcode:
        sys.stderr.write(s)
        sys.stderr.write('exit ' + str(exitcode) + '\n')

    sys.exit(exitcode)

if __name__ == '__main__':
    main()