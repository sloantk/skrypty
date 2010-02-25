#!/bin/bash
yum check-update > /tmp/yum.txt
cat /tmp/yum.txt |grep 2 |wc -l > /tmp/yum.txt
#rm /tmp/yum.txt

