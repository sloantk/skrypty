#!/bin/bash
echo "`mocp -i |grep State |awk '{print $2}'` / `mocp -i |grep Bitrate |head -1 |awk '{print $2}'`"
