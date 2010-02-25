#!/bin/bash

ETH=`sudo ethtool eth0 |grep 'Link detected' |awk '{print $3}'`
#
if [ ! -e /usr/sbin/ethtool ] ; then
	echo "Zainstaluj ethtool"
fi
#
if [ "$ETH" == yes ] ; then
	netcfg2 -d wlan0 && 
	netcfg2 -u eth0-dhcp
elif [ "$ETH" == no ] ; then
	/home/skrypty/net-boot.sh
else
	echo "Brak kabla"
fi
