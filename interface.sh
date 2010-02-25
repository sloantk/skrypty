#!/bin/bash
#
# skrypt kontroluje dany interfejs sieciowy czy wystepuje pobieranie danych
# a jesli tak to z jaką prędkością. Mozna go dowolnie skonfigurowac do wlasnych
# potrzeb aby wykryc brak porzadanego ruchu
#
#by seba
#
##################Config####################

INTERFACE="eth0"	# monitorowany interfejs

DIRECTION="RX"		# RX dla pobierania, TX dla wysylania

LIMIT=10000		# próg średniej prędkości pobierania, jeśli po wykonaniu pomiaru
		        # prędkość będzie niższa niż zadana, to znaczy, że interfejs jest nieaktywny

L_POM=60		# długość pomiaru (w sek.)

#################end config#################

while :
do

SUMA=0
X=1
while [ $X -le $L_POM ]; do
 ZM1=`ifconfig $INTERFACE | grep "$DIRECTION bytes" | cut -d: -f2 | cut -d" " -f1`
 sleep 1
 ZM2=`ifconfig $INTERFACE | grep "$DIRECTION bytes" | cut -d: -f2 | cut -d" " -f1`
 ROZNICA=`expr $ZM2 - $ZM1`
 SUMA=$[SUMA + $ROZNICA]
 WYNIK=`expr $SUMA / $X`
 X=$[X + 1]
done

#echo wynik=$WYNIK		# mozna odkomentowac aby sprawdzic ruch w stanie 
				# spoczynku. Podaje srednia liczbe pobranych
				# bajtow w okreslonym czasie

if [ $WYNIK -gt $LIMIT ]
then
 echo Interfejs $INTERFACE aktywny
else
 echo Interfejs $INTERFACE nieaktywny
 # miejsce na akcję systemu po wykryciu braku ruchu
fi

done
