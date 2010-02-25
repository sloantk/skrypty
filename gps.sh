#!/bin/bash
dialog --title "GPS" --infobox "Łączenie z GPS" 3 18
sudo rfcomm connect rfcomm0 00:1F:60:20:00:43 & 
sleep 5 && 
sudo gpsd -b -n /dev/rfcomm0 &
sleep 10

dialog --clear --separate-output --title "Gps" \
--checklist \
"Zaznacz co chcesz rozłączyć:" 10 70 4 \
"1" "rfcomm" "off" \
"2" "gpsd" "off" \
2> wynik
if
cat wynik |grep 1
then sudo killall rfcomm
fi
if
cat wynik |grep 2
then sudo killall gpsd
fi
