#!/usr/bin/env bash
# grsget - rapidshare downloader with GUI
# Copyright (C) 2008 Marcin "chax" Łabanowski <net i-rpg chax (3@2.1)>

# Credits:
# Michał "D4rky" Matyas - http://nerdblog.pl/
#    Asked me to do this script ;p
# Piotr Jachacy - http://jachacy.jogger.pl/
#    Made original version, which was my inspiration. I took some
#    single lines / regexps from his script (rsget, located at: 
#    http://jachacy.mm5.pl/pub/rsget.sh)

# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.


ZENITY="$(type -p zenity)"
AWK="$(type -p gawk)"
CURL="$(type -p curl)"
MKTEMP="$(type -p mktemp)"
DC="$(type -p dc)"

if test "$DISPLAY" = ""; then
	echo $"No \$DISPLAY environment variable.";
	exit 1
fi;

set -u
set -e

if test "$ZENITY" = ""; then
	KDIALOG="$(type -p kdialog)"
	if test "$KDIALOG" = ""; then
		echo $"Make sure you have zenity installed. I couldn't find that (maybe set up \$PATH properly?).";
	else
		kdialog --error $"Make sure you have zenity installed. I couldn't find that (maybe set up \$PATH properly?).";
	fi;
	exit 1
fi;
if test "$AWK" = ""; then
	"$ZENITY" --error --text $"Please install gawk or modify me. Be aware, that other versions of awk may yield unexpected results.";
	exit 1;
fi;
if test "$CURL" = ""; then
	"$ZENITY" --error --text $"Please install curl.";
	exit 1;
fi;
if test "$MKTEMP" = ""; then
	mktemp() {
		ATEMP="/tmp/grsget.$RANDOM"
		rm -rf "$ATEMP";
		mkdir -p "$ATEMP";
		echo "$ATEMP"
	}
	MKTEMP="mktemp";
fi;
if test "$DC" = ""; then
	"$ZENITY" --error --text $"Please install dc. It may come in one package with bc (it does in GNU systems).";	
	exit 1;
fi;


TEMP="$("$MKTEMP" -d /tmp/grsget.XXXXXX)"
trap "rm -rf \"$TEMP\";" INT TERM EXIT

cd "$("$ZENITY" --file-selection --directory --title $"Choose destination directory")"
"$ZENITY" --text-info --editable --title $"Type here all files to download, separated by \n" > "$TEMP"/filelist.txt

cat "$TEMP"/filelist.txt | "$AWK" '/http:\/\/rapidshare\..+\/files\/[0-9]*\//' | while read; do
	fname="$(echo "$REPLY" | "$AWK" '{sub(/^.*http:\/\/rapidshare\..+\/files\/[0-9]*\//, "");print;}')";
	link="$(echo "$REPLY" | "$AWK" '{sub(/^.*http:\/\//, "http://");sub(/\s*$/, "");print;}')";

	flink="$("$CURL" -s "$link" | "$AWK" -F\" '/form id="ff"/ {print $4;}')";
	if test "$flink" = ""; then
		"$ZENITY" --warning --text "$(printf $"Could not download file \"%s\". Continuing." "$fname")" --timeout 3
		continue;
	fi;

	"$CURL" -s "$flink" -d dl.start=Free > "$TEMP"/try1.txt
	if test "$("$AWK" '/Please wait until the download is completed/' "$TEMP"/try1.txt)" != ""; then
		"$ZENITY" --warning --text "$(printf $"You (or another person from your IP address) is already downloading files. Couldn't download file \"%s\". Continuing." "$fname")" --timeout 3
		continue;
	fi;

	maxtime="$("$AWK" '/var c=/ { gsub(/[^0-9]/,""); print; }' "$TEMP"/try1.txt)"
	time="$maxtime"

	while test "$time" -gt 0; do
		echo "4k 100 $time $maxtime/100*-p" | "$DC";
		let time--;
		sleep 1;
	done | "$ZENITY" --progress --auto-close --text "$(printf $"Please wait %d seconds..." "$maxtime")";

	flink="$("$AWK" -F\" '/form name="dlf"/ { print $4; }' "$TEMP"/try1.txt)"
	i=0;
	LANG=C "$CURL" "$flink" -d mirror=on -o "$fname" -# 2>&1 | \
	"$AWK" 'BEGIN { RS="\r"; ORS="\n"; } { sub(/%/,"");print $2;fflush(); }' | \
	"$AWK" 'BEGIN { a=""; } !/100/ && !/^\s*$/ && a != $0 { a=$0;print;fflush(); } END { print 100; }' | \
	"$ZENITY" --progress --auto-close --text "$(printf $"Downloading file %s..." "$fname")";
done;

exit 0;
