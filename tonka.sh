#!/bin/bash

function lsbytesum

{
TotalBytes=0
for Bytes in $(ls -l | grep "^-" | awk '{ print $5 }')
do
    let TotalBytes=$TotalBytes+$Bytes
done
TotalMeg=$(echo -e "scale=3 \n$TotalBytes/1048576 \nquit" | bc)
echo -n "$TotalMeg"
}

function tonka {

local WHITE="\[\033[1;37m\]"
local LIGHT_BLUE="\[\033[1;34m\]"
local YELLOW="\[\033[1;33m\]"
local NO_COLOUR="\[\033[0m\]"
PS1="$YELLOW-$LIGHT_BLUE-(\
$YELLOW\u$LIGHT_BLUE@$YELLOW\h\
$LIGHT_BLUE)-(\
$YELLOW\$PWD\
$LIGHT_BLUE)-$YELLOW-\
\n\
$YELLOW-$LIGHT_BLUE-(\
$YELLOW\$(date +%H:%M)$LIGHT_BLUE:$YELLOW\$(date \"+%a,%d %b %y\")\
$LIGHT_BLUE:$WHITE\\$ $LIGHT_BLUE(\$(lsbytesum) MB)-$YELLOW-$NO_COLOUR "
}

