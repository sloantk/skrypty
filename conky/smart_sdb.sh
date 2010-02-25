#!/bin/bash

#if [ ! `whoami` == "root" ]; then
#    exec sudo $0 # możesz zastąpić "sudo" na "su -c"
#fi

# Twój skrypt (bez tego su oczywiście)

#echo "$(sudo smartctl -a /dev/sdb | grep Load_Cycle_Count |awk '{print $10}')"
smartctl -a /dev/sdb |grep Load_Cycle_Count |awk '{print $10}' > /tmp/smart_sdb.txt

