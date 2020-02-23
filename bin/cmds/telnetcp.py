#!/usr/bin/env python

import socket
import os
import sys
import telnetlib

ipaddr = sys.argv[1]
port = sys.argv[2]
login = sys.argv[3]
password = sys.argv[4]
prompt = sys.argv[5]
src = sys.argv[6]
dst = sys.argv[7]

if dst[len(dst) - 1] == '/':
    dst = dst + os.path.basename(src)

tn = telnetlib.Telnet(ipaddr, port)
tn.read_until("ogin: ")
tn.write(login + "\n")
if password:
    tn.read_until("assword: ")
    tn.write(password + "\n")

tn.read_until(prompt)
tmpname = "__" + os.path.basename(src)

# generate data
os.system("base64 " + src + " > " + tmpname)
f = file(tmpname)

# send data
for line in f.readlines():
    tn.write("echo \"" + line + "\" >> " + tmpname + "\n")
    tn.read_until(prompt)

# transfor
tn.write("base64 -d " + tmpname + " > " + dst + "\n")
tn.read_until(prompt)

# clean up
f.close()
os.system("rm " + tmpname)
tn.write("rm " + tmpname + "\n")
tn.read_until(prompt)
tn.write("exit\n")