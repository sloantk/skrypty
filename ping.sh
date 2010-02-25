#!/bin/bash
#
host=192.168.1.1
ping -c 2 $host
   if [ $? -ne 0 ]
       then
        /sbin/rmmod ndiswrapper
	sleep 2
		/sbin/modprobe ndiswrapper
   fi 
