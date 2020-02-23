#!/bin/bash

echo "try to reboot ..."
invoke "reboot"
waitprompt
make setup

invoke "ifconfig"
echo "result:$?"
