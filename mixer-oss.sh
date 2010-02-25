#!/bin/sh

# ossv4 volume osd for notify-osd
# depends on: notify-osd, ossvol
# v1.0 by sen

MIXER_CONTROL="vmix0-outvol"

if [ "$1" = '-i' ]; then
    ossvol -i 1
elif [ "$1" = '-d' ]; then
    ossvol -d 1
elif [ "$1" = '-t' ]; then
    ossvol -t
else
    exit 1
fi
VOLUME=$(echo "$(printf "%02.0f" $(ossmix |grep vmix0-outvol |awk '{ print $4 }' |sed 's:0::g;s:[.]::g'))*4" |bc)
echo "Głośność: $VOLUME%" |  aosd_cat  -p 4 --x-offset=-10 --y-offset=-30 --font="bitstream bold 32" --fore-color="#00E010" --transparency=1 -f 100 -o 100 --fade-full=2000
