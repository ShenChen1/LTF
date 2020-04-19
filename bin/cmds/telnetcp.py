#!/usr/bin/env python

import socket
import os
import sys
import telnetlib

class telnet(object):
    def __init__(self, prompt, timeout=None):
        self.__prompt = prompt
        self.__tn = None
        self.__timeout = timeout

    def __del__(self):
        if self.__tn:
            self.__tn.write("exit\n")
        self.__tn = None

    def login(self, ipaddr, port, login, password):
        try:
            tn = telnetlib.Telnet(ipaddr, port)
            tn.read_until("ogin: ")
            tn.write(login + "\n")
            if password:
                tn.read_until("assword: ")
                tn.write(password + "\n")
            tn.read_until(self.__prompt)
        except:
            raise RuntimeError("login err")
        # update handle
        self.__tn = tn

    def runcmd(self, cmd):
        try:
            ret = " || echo +++-exit-+++ $?"
            self.__tn.write(cmd + ret + "\n")
            buf = self.__tn.read_until(self.__prompt, self.__timeout)
        except:
            raise RuntimeError("runcmd err:%s" % cmd)
        else:
            buf = buf.replace(ret, " ")
            ret = "+++-exit-+++"
            if buf.find(ret) != -1:
                raise RuntimeError(buf.splitlines()[:-1])

def __build_new_dst(file, dst):
    if dst[len(dst) - 1] == '/':
        dst = dst + file
    return dst

def main():

    if len(sys.argv) != 8:
        sys.exit(1)

    (ipaddr, port, login, password, prompt, src, dst) = sys.argv[1:]

    if not os.access(src, os.R_OK):
        raise RuntimeError("file err: %s nonexistent" % src)
    dst = __build_new_dst(os.path.basename(src), dst)

    # prepare
    tn = telnet(prompt)
    tn.login(ipaddr, port, login, password)
    tmpname = "__" + os.path.basename(src)

    # generate data
    os.system("base64 " + src + " > " + tmpname)
    f = file(tmpname)

    # send data
    for line in f.readlines():
        tn.runcmd("echo -en \"" + line + "\" >> " + tmpname)

    # transfor
    tn.runcmd("base64 -d " + tmpname + " > " + dst)

    # clean up
    f.close()
    os.system("rm " + tmpname)
    tn.runcmd("rm " + tmpname)

if __name__ == '__main__':
    main()