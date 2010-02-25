#!/bin/bash
cd /home/sloan/Router/openwrt/svn/trunk/bin/brcm-2.4
tftp 192.168.1.1
rexmt 1
binary
trace
put openwrt-brcm-2.4-squashfs.trx
