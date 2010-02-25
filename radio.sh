#!/bin/bash
##################################################################
# Nazwy i adresy stacji radiowych zaczerpnięte ze skryptu:       #
# http://www.supermegazord.pl/paczki/radio/                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Autor: 3ED <krzysztof1987@gmail.com>  http://3ed.jogger.pl/    #
##################################################################

# Lokalizacje radiowych list
for i in "/home/sloan/skrypty/radio/dradio.lista" "$HOME/.dradio.lista"; do
	if [ -r "$i" ]; then . $i; fi
done

play() {
	dialog --infobox 'Odtwarzam strumień:
'"$2"'

>>> '"$1"' <<<

Aby przerwac i powrocic do menu nacisnij "q"
Regulacja glosnosci "vol- 9" i "vol+ 0"
Pauza "p", wyciszenie "m"' 10 50
mplayer -really-quiet $2 &> /dev/null
}

typeset tmp=/tmp/.radio.name
typeset -i e=0

until [ "$e" != "0" ]; do
	e=1
	eval $(echo 'dialog --cancel-label "Zakończ" --ok-label "Odtwarzaj" --menu "Wybierz stację" 24 40 40 '$(
		for i in ${!NAME[*]}; do echo '"'"${NAME[$i]}"'" ""'; done|sort
	)' 2> $tmp; e=$?')
	if [ "$e" != "0" ]; then
		break
	else
		e=1
	fi
	NAMESEL="$(cat $tmp)"
	for i in ${!NAME[*]}; do
		if [ "${NAME[$i]}" = "${NAMESEL}" ]; then
			e=0
			play "${NAME[$i]}" "${ADRESS[$i]}"
		fi
	done
done
clear

