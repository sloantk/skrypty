#!/bin/bash

ETH=`sudo ethtool eth0 |grep 'Link detected' |awk '{print $3}'`
WLAN=`iwlist wlan0 scan |grep "arch-net" |sed 's:\:::g;s:\"::g;s:\ESSID::g' |awk '{print $1}'`
#
if [ ! -e /usr/sbin/iwlist ] ; then
	echo "Zainstaluj wireless_tools"
fi

if [ ! -e /usr/sbin/ethtool ] ; then
	echo "Zainstaluj ethtool"
fi
#
if [ "$WLAN" == arch-net ] && [ "$ETH" == no ] ; then
	netcfg2 -u wlan0

elif [ "$WLAN" == arch-net ] && [ "$ETH" == yes ] ; then
	netcfg2 -u wlan0
	
elif [ "$WLAN" != arch-net ] && [ "$ETH" == yes ] ; then
	netcfg2 -u eth0-dhcp
	
else
	echo "Brak sieci"
fi
