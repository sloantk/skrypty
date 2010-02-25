#!/bin/sh
TITLE="`mocp -i | grep 'Title:' | sed -e 's/^.*: //'`";
if [ "$TITLE" != "" ]; then
ARTIST="`mocp -i | grep 'Artist:' | sed -e 's/^.*: //'`";
SONGTITLE="`mocp -i | grep 'SongTitle:' | sed -e 's/^.*: //'`";
ALBUM="`mocp -i | grep 'Album:' | sed -e 's/^.*: //'`";
BITRATE="`mocp -i |grep Bitrate |head -a |awk '{print $2}'`"
if [ "$ARTIST" != "" ]; then ARTIST="$ARTIST - "; fi
if [ "$ALBUM" != "" ]; then ALBUM="($ALBUM)"; fi
echo $SONGTITLE
#echo $ARTIST 
#echo $ALBUM
else echo „MOC”
fi

