#!/bin/sh
STATE="`mocp -i |grep State |awk '{print $2}'`";
TOTAL="`mocp -i |grep TotalTime |awk '{print $2}'`";
LEFT="`mocp -i |grep TimeLeft |awk '{print $2}'`";
if [ "$STATE" = PLAY ]; then 
echo $TOTAL/$LEFT
fi
