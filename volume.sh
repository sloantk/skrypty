#! /bin/bash

case "$1" in

+)
  notify-send -t 700 "volume:  `amixer set Master 4+ | awk '/''Front Left:'/' { print $5 "   " $6 }' | head -1 | sed 's:\[::g;s:\]::g'`"
;;

-)
  notify-send -t 700 "volume:  `amixer set Master 4- | awk '/''Front Left:'/' { print $5 "   " $6 }' | head -1 | sed 's:\[::g;s:\]::g'`"
;;

0)
  if amixer get Master | grep -q "off" 
  then
    notify-send -t 700 "volume: `amixer set Master unmute | awk '/''Front Left:'/' { print $5 "   " $6 }' | head -1 | sed 's:\[::g;s:\]::g'`" 
  else
    notify-send -t 700 "volume: `amixer set Master mute | awk '/''Front Left:'/' { print $5 "   " $6 }' | head -1 | sed 's:\[::g;s:\]::g'`" 
  fi
;;

esac
