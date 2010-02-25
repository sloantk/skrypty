#!/bin/bash

function s4ros
{
local WHITE="\[\033[1;37m\]"
local LIGHT_BLUE="\[\033[1;34m\]"
local LIGHT_GREEN="\[\033[1;32m\]"
local LIGHT_RED="\[\033[1;31m\]"
local LIGHT_PURPLE="\[\033[1;35m\]"
local YELLOW="\[\033[1;33m\]"
local NONE="\[\033[0m\]"
local KRESKI="$(echo -e "\033(0")"
local NORMAL="$(echo -e "\033(B")"
local PLIKOW="\$(ls -l | grep "^-" | wc -l)"
local KATALOGOW="\$(ls -l | grep "^d" | wc -l)"

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

PS1="\n\
$LIGHT_RED$(echo -e "\033(0")lu$(echo -e "\033(B")\
$YELLOW$PLIKOW ${LIGHT_PURPLE}plików (\$(lsbytesum) MB)\
$LIGHT_RED$(echo -e "\033(0")f$(echo -e "\033(B") \
$YELLOW$KATALOGOW ${LIGHT_PURPLE}katalogów\
\n\
$LIGHT_RED$(echo -e "\033(0")tqqqqqqqqqqu$(echo -e "\033(B")$WHITE\u\
$LIGHT_RED$(echo -e "\033(0")f@f$(echo -e "\033(B")$WHITE\h\
$LIGHT_RED$(echo -e "\033(0")tqqqqqqqqqqu$(echo -e "\033(B")$LIGHT_GREEN\$PWD\
$LIGHT_RED$(echo -e "\033(0")tqqqqqqqqqqqqqk$(echo -e "\033(B")\
\n\
$(echo -e "\033(0")mu$(echo -e "\033(B")\
$YELLOW$(date +%H:%M)\
$LIGHT_RED$(echo -e "\033(0")tu$(echo -e "\033(B")$NONE\$ "
}
