#!/bin/bash
#
host=192.168.1.5
ping -I wlan0 -c 2 $host
   if [ $? -ne 1 ]
       then
        echo "Działa."
else
echo "Nie działa"
   fi 
