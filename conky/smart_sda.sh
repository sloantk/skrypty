#!/bin/bash

#if [ ! `whoami` == "root" ]; then
#    exec sudo $0 # możesz zastąpić "sudo" na "su -c"
#fi

# Twój skrypt (bez tego su oczywiście)

#echo "$(sudo smartctl -a /dev/sda | grep Load_Cycle_Count |awk '{print $10}')"
sudo smartctl -a /dev/sda |grep Load_Cycle_count |awk '{print $10}' > /tmp/smart_sda.txt

