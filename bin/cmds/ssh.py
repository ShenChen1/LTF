#!/usr/bin/env python

import os
import sys
import re

def main():

    args = " "
    for s in sys.argv[1:]:
        args += ('\'' + s + '\' ')

    pw = False
    l = 0
    s = ""
    exitcode = 0

    r = os.popen("ssh.exp" + args)
    lines = r.readlines()
    for line in lines:
        l += 1
        line = line.replace('\r\n', '\n')
        if l == 1 and re.search('^spawn', line):
            s += line
            continue

        if pw is False and re.search('assword:', line):
            pw = True
            s += line
            continue

        if pw is False:
            s += line
            continue

        if re.search('\+\+\+\-exit\-\+\+\+ (\d+)', line):
            s += line
            exitcode = 1
            break

        sys.stdout.write(line)

    r.close()

    if pw is False:
        exitcode = 2

    if exitcode:
        sys.stderr.write(s)
        sys.stderr.write('exit ' + str(exitcode) + '\n')

    sys.exit(exitcode)

if __name__ == '__main__':
    main()