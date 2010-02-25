#!/bin/bash

a=$(zenity  --list  --text "Łączenie się z internetem przez PLAY" --title="PLAY Internet" --radiolist  --column "Wybierz" --column "Sposób połączenia" TRUE "USB" FALSE "Bluetooth");
if [ "$a" == USB ]; then
	sudo wvdial -C /etc/wvdial-usb.conf &> /dev/null
#else
#zenity --info --no-wrap --text="Sprawdź, czy telefon jest podłączony"
#exit 1
fi

if [ "$a" == Bluetooth ]; then
	sudo rfcomm connect rfcomm0 00:24:03:C2:80:28 4 &
	sleep 5 &&
	sudo wvdial -C /etc/wvdial-bluetooth.conf &
fi
 
sleep 5 &&

b=ifconfig |grep ppp0 |awk '{print $1}'
if [ "b" == ppp0 ]; then
zenity --info --no-wrap --timeout 5 --text="Połączono z PLAY"
fi

zenity --question --no-wrap --text="Jeżeli chcesz rozłączyć Play naciśnij "Rozłącz"" --ok-label="Rozłącz"
if [ "$?" = 0 ]; then
sudo killall wvdial & sudo killall rfcomm
fi
