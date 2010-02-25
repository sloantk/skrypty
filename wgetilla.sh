#!/bin/bash
#
# wgetilla - wget z powiadomieniem
# równie dobrze to może być prozilla, curl czy aria2
# by Michał Bentkowski (mr.ecik@gmail.com)
# licensed under GPLv2+
# requires: notify-send ( paczka libnotify.rpm )
 
# PRZYKŁAD:
# Jako "download manager" do firefox z wtyczką Flashgot :
# polecenie:
#	/usr/bin/gnome-terminal
# parametry:
# 	-x wgetilla [URL] -P [FOLDER]
# dzięki opcji -P mamy automatyczne sortowanie ściąganych plików
 
NOTIFY_SEND=/usr/bin/notify-send
 
# ICONS: (change if you don't like them ;-))
ICON_OK=messagebox_info
ICON_ERR=messagebox_critical
 
# PATHS: (change them if it's needed)
GET=/usr/bin/wget
#GET=/usr/bin/proz
#GET=/usr/bin/curl
#GET=/usr/bin/aria2c
 
# just run "get" with given parameters
$GET $@
EXIT=$?
 
# check whether $DISPLAY exists,
# if not, exit with get's exit code
[ "x$DISPLAY" == "x" ] && exit $EXIT
 
# don't notify if "--help" was invoked
for p in $*; do [[ "$p" == "--help" ]] && exit $EXIT; done
 
if [ "x$EXIT" == "x0" ]; then
  $NOTIFY_SEND -i $ICON_OK "Download OK: $*"
else
  $NOTIFY_SEND -i $ICON_ERR "Download ERROR: $*"
fi
exit $EXIT

