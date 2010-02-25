#!/bin/bash
#U='Mozilla/5.0 (Windows; U; Windows NT 5.1; pl; rv:1.9.0.5) Gecko/2008120122 Firefox/3.0.5'
#cookie="~/.mozilla/firefox/45d84as5.default/cookies.txt"
#wget -D "www.rapidshare.com" -U "$U" --load-cookies "$cookie" $rslink

msg() {
	if   [ "$2" = "==" ]; then
		printf "\e[0;1;33m==> \e[0;1;32m%s\e[0m\n" "$1"
	elif [ "$2" = ".." ]; then
		printf "> %s " "$1"
	elif [ -z "$2" ]; then
		printf "> %s\n" "$1"
	else
		printf "\r> %s\e[1m%3s%s\e[0m" $"Czekaj:" "$1" "$2"
	fi
}
msg_done() { printf "\e[1m%s\e[0m.\n" "pomyślnie"; }
msg_fail() { printf "\e[1m%s\e[0m.\n" "niepowodzeniem"; }

count() {
	local x="${1:-0}" s="${2:-s}" i
	for i in $(seq $x -1 1); do
		msg "$i" "$s"
		sleep 1$s
	done
	printf "\r"
}

pobierz() {
	# 255 		- ściągasz pliki
	# 254			- błędny/nieistniejacy url rapida
	# 200			- ponów pobieranie
	# 1-100 	- zarezerwowane dla wgeta
	msg $"Wczytuje informacje ze żródła.."

	local link="$1" cwait=""
	link="$(wget "$link" -q -O - | sed -e '/form id="ff"/!d; s/.*action="\(.*\)"\s.*/\1/')"

	if [ -n "$link" ]; then
		link=$(wget --post-data "dl.start=Free" $link -q -O -)

		if [  -n "$(echo "$link" | sed '/Please wait until the download is completed/!d')" ]; then
			msg $"Sciągasz inne pliki.." "=="
			exit 255
		elif [  -n "$(echo "$link" | sed '/You have reached the download limit for free-users. Would you like more/!d')" ]; then
			cwait=$(
				echo "$link" \
				| sed '/Instant download access! Or try again in about/!d
				s/.*about \([0-9]*\) minutes.*/\1/'
			)
			count "$cwait" m

			msg "Ponawiam próbę.."

			return 200
		else
			cwait="$(echo "$link" | sed '/var c/!d; s/var c=\([0-9]*\);.*/\1/')"

			count "$cwait" s

			link=$(echo "$link" | sed '/form name="dlf"/!d; s/.*action="\(.*\)"\s.*/\1/')
			msg "Rozpoczynam pobieranie.."
			wget -nc --post-data "mirror=on" "$link" -O "${fname}.part"; err="$?"
			msg "Zapisywanie zakończone" ".."
			if [ "$err" = "0" ]; then
				msg_done
				msg "Zmiana nazwy pliku zakończona" ".."
				mv "${fname}.part" "${fname}" && msg_done || msg_fail
			else
				msg_fail
			fi
			return $err
		fi	
					
	else
		return 254
	fi


}


#if [ "$1" = "-i" ] && [ -n "$2" ]
#then
#	for x in $(cat $2)
#	do
#		if [ -n "$x" ]
#		then
#			pobierz "$x"
#		fi
#	done
	
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
	printf "%s\n\n" "Wersja publiczna 0.1 by 3ED 2009 - GPL3"
	printf "%s\n" "Użycie: rsget [URL]..."
else
	for i in $@; do
		url="$i"
		fname="$(echo "$url"|sed 's/^.*\/\(.*$\)/\1/')"
		retry=0
		if [ -e "${fname}.part" ]; then
			rm "${fname}.part"
		fi
		if [ -e "${fname}" ]; then
			errcode=0
		else
			errcode="200"
			msg $"Pobieranie pliku:"" \"$fname\".." "=="
		fi
		until [ "$errcode" -le "0" -o "$retry" -gt "10" ]; do
			pobierz "$url"
			errcode="$?"
			let retry++
		done
		[ "$errcode" = "254" ] && msg $"Download failed, file location \"%f\" don't exist" "=="
	done
	
fi

exit 0
