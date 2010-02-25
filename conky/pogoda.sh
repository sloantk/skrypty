#!/bin/bash

# Katalog, w którym znajduje się skrypt
sciezka=/home/sloan/skrypty/conky

# Kod miasta
kod=492795

plik=/tmp/pogoda.txt
# sprawdzenie czy serwer jest dostępny
if [ `ping -c1 98.136.138.31 | grep from | wc -l` -eq 0 ]
  then
	echo "Serwis niedostępny"
  else
	# pobieranie informacji
 	w3m -dump http://weather.yahoo.com/forecast/"$kod"_c.html | grep -A21 "Current" | sed 's/DEG/°/g' > $plik

	# ustalenie wartości zmiennych
	stan=`head -n3 $plik | tail -n1`
	temp=`tail -n1 $plik | awk '{print $1}'`
	tempo=`head -n6 $plik | tail -n1`
	cisn=`head -n8 $plik | tail -n1`
	wiatr=`head -n16 $plik | tail -n1`
	wilg=`head -n10 $plik | tail -n1`
	wsch=`head -n18 $plik | tail -n1`
	zach=`head -n20 $plik | tail -n1`
	if [ `cat "$sciezka"/pogoda.sh | grep -x "# $stan" | wc -l` -eq 0 ]
	  then
		stanpl=$stan
	  else
		stanpl=`cat "$sciezka"/pogodynka.sh | grep -xA1 "# $stan" | tail -n1 | awk '{print $2,$3,$4,$5,$6,$7}'`
	fi
	
	# formatowanie informacji wyjściowej
	# dostępne zmienne:
	# $stan		opis stanu po angielsku
	# $stanpl	opis stanu po polsku
	# $temp		temperatura powietrza
	# $tempo	temperatura odczuwalna
	# $cisn		ciśnienie atmosferyczne
	# $wiatr	kierunek, siła wiatru
	# $wilg		wilgotność powietrza
	# $wsch		godzina wschodu słońca
	# $zach		godzina zachodu słońca
	
        #echo $stanpl
	echo $temp C  /  $tempo C
	#echo Cisnienie $cisn hPa

fi

