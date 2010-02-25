#!/bin/bash

if echo "$@" | grep -q -e '--help' ; then
    echo "This is an example script to connect to a Bluetooth device and then restart gpsd"
    exit -1
fi

while [ -z "$GPS_MAC" ] ; do
    echo "hcitool scan"
    hcitool scan
    GPS=`hcitool scan | grep -e 'GPS' | head -1| sed 's/ //g'`
    echo ""
    GPS=${GPS#	}
    echo "GPS: $GPS"
    GPS_MAC=${GPS%	Blue*}
    GPS_MAC=${GPS%	iBT-GPS*}
    echo "GPS_MAC: '$GPS_MAC'"

    if [ -z "$GPS_MAC" ] ; then
	echo "ERROR !!!!!!!!!!!!! No GPS"
    fi
done

echo ""
echo "-----------------------------------"
echo "hcitool info $GPS_MAC"
hcitool info $GPS_MAC

echo ""
echo "-----------------------------------"
echo "hcitool cc $GPS_MAC"
hcitool dc $GPS_MAC >/dev/null 2>/dev/null
hcitool cc $GPS_MAC


echo ""
echo "-----------------------------------"
echo "hcitool lq $GPS_MAC"
hcitool lq $GPS_MAC

echo ""
echo "-----------------------------------"
echo "hcitool con"
hcitool con

echo ""
echo "-----------------------------------"
echo "rfcomm release $GPS_MAC"
rfcomm release $GPS_MAC
echo ""
echo "rfcomm bind /dev/rfcomm1 $GPS_MAC"
rfcomm bind /dev/rfcomm1 $GPS_MAC

echo ""
echo "-----------------------------------"
echo "rfcomm -a "
rfcomm -a

echo ""
echo "-----------------------------------"
echo "rfcom:"
dd if=/dev/rfcomm1 count=10

echo ""
echo "-----------------------------------"
echo "gpsd"
killall -9 gpsd
gpsd -b -n -N /dev/rfcomm1
#gpsd -n -N -D 1 /dev/rfcomm0
