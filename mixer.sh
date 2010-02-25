#!/bin/bash

case $1 in
up) a="Głośność: `amixer set Master 1%+ unmute | grep % | awk '{print $4}' | head -1 | sed 's:\[::g;s:\]::g'`" ;;
down) a="Głośność: `amixer set Master 1%- unmute | grep % | awk '{print $4}' | head -1 | sed 's:\[::g;s:\]::g'`" ;;
mute) 
case `amixer set Master toggle | grep Mono: | awk '{print $6}' | head -1 | sed 's:\[::g;s:\]::g'` in
            off) a="Mute" ;;
             *) a="Unmute - `amixer get Master | grep Mono: | awk '{print $4}' | head -1 | sed 's:\[::g;s:\]::g'`" ;;
             esac ;;
*) echo "Usage: $0 { up | down | mute }"  ;;
esac

killall aosd_cat &> /dev/null
echo "$a" |  aosd_cat  -p 4 --x-offset=-10 --y-offset=-30 --font="bitstream bold 32" --fore-color="#00E010" --transparency=1 --fade-full=2000
#--fore-color="#dfe2e8"
