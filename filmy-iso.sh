#!/bin/bash
for i in "/home/sloan/skrypty/filmy.lista"; do
	if [ -r "$i" ]; then . $i; fi
done

play() {
	dialog --infobox 'Odtwarzam film:
'"$2"'

>>> '"$1"' <<<

Aby przerwac i powrocic do menu nacisnij "CTRL+q"
Pauza "p", wyciszenie "m"' 10 50
cvlc --fullscreen --aspect-ratio 16:10 --play-and-exit $2 &> /dev/null
}

typeset tmp=/tmp/.film.name
typeset -i e=0

until [ "$e" != "0" ]; do
	e=1
	eval $(echo 'dialog --cancel-label "Zakoñcz" --ok-label "Odtwarzaj" --menu "Wybierz film" 40 40 40 '$(
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


