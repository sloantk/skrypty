#!/usr/bin/env bash
# rsget-mod
#
# Author: D4rky <d4nerd@gmail.com>
# Original version: Piotr Jachacy <jachacy@gmail.com>
#
# Changelog:
# 
#  0.6   - major release, rewritten almost from scratch
#          configuration and translations moved from file
#  0.5.1 - fixes for compatibility with older sh
#  0.5   - curl instead of wget, lots of minor fixes
#  0.4.1 - removing MacOS X from compatibilty mode (it's not needed)
#  0.4   - BSD / MacOS X compatibility mode, better handling 
#        of download lists, colors
#  0.3   - checking for new limits, minor changes and fixes
#  0.2.1 - minor changes
#  0.2   - english translation and update function
#  0.1   - checking if file was already downloaded and 
#        retrying download if something went wrong
#
#
#  This script depends on:
#   - wget
#   - bash or dash (other *sh were not checked)
#   - grep
#   - sed/gsed
#   - (optional) curl
#
# /* This program is free software. It comes without any warranty, to
# * the extent permitted by applicable law. You can redistribute it
# * and/or modify it under the terms of the Do What The Fuck You Want
# * To Public License, Version 2, as published by Sam Hocevar. See
# * http://sam.zoy.org/wtfpl/COPYING for more details. */ 
#

# Configuration

# Don't touch these two:
INTERNAL_VERSION=200911060
VERSION="rsget-mod 0.6 ("$INTERNAL_VERSION")"
BRANCH="stable"

FRESHLY_UPDATED=0

# Fallback configuration
_RSGET_CHECK_FOR_UPDATES=1;
_RSGET_USE_COLORS=0;
_RSGET_CONNECTION_TIMEOUT=15
_RSGET_TRIES=10;

if [ ! -d "$_RSGET_CONFIG_PATH" ]; then
	_RSGET_CONFIG_PATH="$HOME/.rsget-mod";
fi

if [ "$FRESHLY_UPDATED" -eq 1 ] || [ ! -d "$HOME/.rsget-mod" ] 2>/dev/null; then

	if [ ! -d "$HOME/.rsget-mod" ]; then
		mkdir "$HOME/.rsget-mod"
		FIRST_RUN=1
	fi
	
	wget "http://rs.nerdblog.pl/"$BRANCH"/latest/.rsget-mod/common.sh" -q -O "$HOME/.rsget-mod/common.sh"
	
	if [ ! -r "$HOME/.rsget-mod/config" ]; then 
		wget "http://rs.nerdblog.pl/"$BRANCH"/latest/.rsget-mod/config" -q -O "$HOME/.rsget-mod/config"
	fi
	
	touch "$HOME/.rsget-mod/log"
	
	# security reasons
	chmod 700 "$HOME/.rsget-mod/config"
	chmod 700 "$HOME/.rsget-mod/log"

	. "$HOME/.rsget-mod/common.sh"

	load_config

	. "$HOME/.rsget-mod/common.sh"

	wget "http://rs.nerdblog.pl/"$BRANCH"/latest/.rsget-mod/rsget_pl.lang" -q -O "$HOME/.rsget-mod/rsget_pl.lang"
	wget "http://rs.nerdblog.pl/"$BRANCH"/latest/.rsget-mod/rsget_en.lang" -q -O "$HOME/.rsget-mod/rsget_en.lang"

	. "$HOME/.rsget-mod/rsget_"$_RSGET_LANGUAGE".lang"

	whats_new


else
	# Load common functions and language file
	. "$HOME/.rsget-mod/common.sh"
	load_config
	. "$HOME/.rsget-mod/rsget_"$_RSGET_LANGUAGE".lang"
fi

# Usage
if [ -n "$(echo $@ | grep "\-\-help" )" ] || [ "$#" -eq "0" ]; then

	printf "$_LANG_USAGE" "$0"
	exit

fi

# Version 
if [ -n "$(echo $@ | grep "\-\-version" )" ]; then

	printf "$VERSION\n\n"
	exit

fi

# Update
if [ -n "$(echo $@ | grep "\-\-update" )" ]; then

	update_check
	if [ $? -eq 0 ] 2>/dev/null; then
		printf "$_LANG_NO_UPDATES"
	else
		printf "$_LANG_UPDATE_WARNING"
	fi

	read answer
	
	if [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then

		wget "http://rs.nerdblog.pl/"$BRANCH"/latest/rsget-mod.sh" -O "$0"
		if [ $? != 0 ]; then printf "$_LANG_UPDATE_WENT_WRONG"; exit; fi
		
		printf "$_LANG_UPDATE_COMPLETE"

	fi
	exit
	
fi



update_check
if [ $? -eq 1 ] 2>/dev/null; then
	printf "$_LANG_NEW_UPDATE" "$versioncheck" "$0"
fi

# If --stdin, use STDIN ;)
if [ -n "$(echo $@ | grep "\-\-stdin" )" ]; then
	while read link; do
		check_link "$link"
	done	
else
	for arg in $@; do
		check_link "$arg"
	done
fi

count_downloads

if [ -n "$error_list" ]; then
	for i in $error_list; do
		printf "$_LANG_NONEXISTENT_FILE" $0
	done;
fi

if [ -n "$download_list" ]; then
	printf "$_LANG_FILES_TO_DOWNLOAD" "$downloads_count"
	for i in $download_list; do
		download "$i";
	done;
fi


