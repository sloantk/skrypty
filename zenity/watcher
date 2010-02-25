#!/bin/sh
# Marc Brumlik, Tailored Software Inc, Thu May 14 03:26:22 CDT 2009
#
# "watcher" was originally written as an internal function of my other
# gnome-look submission "avconvert", modified here as a stand-alone
#
# This script uses zenity to indicate progress while writing to a file.
# It is designed to run in the background and takes four arguments:
# 	$1  full path to the file being written to
# 	$2  the name for the program that is creating the file
# 		eg "ffmpeg", which will be looked for in a "ps"
# 	$3  anticipated final size of the file being watched
# 		"progress bar" indicates new files as percent of this number
# 		in BYTES (as produced by "du -a -b")
# 	$4  the PID if the process this script is started from
# 		so that it can be killed if CANCEL is clicked in this script
#
# There are two phases to this process.
# Before they begin, the script finds the PID of the program doing the writing
# by searching a "ps" for its name AND the PID if its parent.
#
# In phase 1, a simple back-and-forth indicator is shown while we wait for the
# file to be created and reach a non-zero size.  This phase  will wait for up
# to 20 seconds.  If the file never reaches non-zero size, this script exits.
#
# As soon as the file has non-zero size this script moves to phase 2.
# In phase 2, an actual %-complete progress is shown.  It will incrementally
# increase toward 100% until EITHER progress reaches 100% OR the file stops
# getting larger.  It then exits.
#
# If the user presses Cancel in either of the phases, a 'kill -9' is sent
# to the process writing the file, a confirmation is shown, and this exits.
#

case $4 in
	'')	echo "USAGE:	$0 destfile progname estsize pid &"
		echo "for simple use, progname can be arbitrary and pid=0"
		exit 0 ;;
esac

sleep 1
# yes, this isn't perfect, but the chances of it going awry are slim
pid=`ps -ef | grep " $4 " | grep "$2" | awk '{print $2}'`
z="0"
while true
do
	if test -s $1
		then	break
	fi
        for a in 10 20 30 40 50 60 70 80 90 80 70 60 50 40 30 20 10 00
        do
                test -s "$1" && break 2
                echo $a; sleep 1
		z=`expr $z + 1`
		if [ "$z" = "20" ]
			then	exit 0
		fi
        done
done | zenity --progress --auto-close --text="Waiting for $2\nto begin writing $1" || ( kill -9 $pid >/dev/null 2>&1; zenity --info --text="$2 has been CANCELLED!" )

while true
do
        newsize=`du -a -b "$1"  2>/dev/null | awk '{print $1}'`
        progress=`echo "scale=10; $newsize / $3 * 100" | bc 2>/dev/null`
	if [ "$progress" = "$oldprogress" ]
		then	break
	fi
	oldprogress=$progress
	sleep 1
	echo $progress
done | zenity --progress --percentage=01 --auto-close --text="$2 is writing to $1\nEstimate to completion..." || ( kill -9 $pid >/dev/null 2>&1; zenity --info --text="$2 has been CANCELLED!" )
