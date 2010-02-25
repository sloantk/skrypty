#!/bin/sh

# copyright by Lukasz Fidosz
# distributed under the BSD license
# v 0.02
# have a fun:)

if [ $UID -ne 0 ]; then
	echo "---"
	echo "Błąd: skrypt musi zostać uruchomiony z konta root'a!"
	echo "---"
	exit
fi
if [ $# -lt 2 ]; then
	echo "---"
	echo "Informacja: $(basename $0) uzytkownik haslo"
	echo "---"
	exit
fi
cd ~/
wget http://eagle-usb.org/ueagle-atm/non-free/ueagle-data-1.1.tar.gz
mkdir -p /lib/firmware/ueagle-atm
cd /lib/firmware/ueagle-atm
tar -xzf ~/ueagle-data-1.1.tar.gz
touch /etc/ppp/peers/ueagle-atm
echo "user $1" >> /etc/ppp/peers/ueagle-atm
echo "plugin pppoatm.so 0.35" >> /etc/ppp/peers/ueagle-atm
echo "llc-encaps" >> /etc/ppp/peers/ueagle-atm
echo "noipdefault" >> /etc/ppp/peers/ueagle-atm
echo "usepeerdns" >> /etc/ppp/peers/ueagle-atm
echo "defaultroute" >> /etc/ppp/peers/ueagle-atm
echo "persist" >> /etc/ppp/peers/ueagle-atm
echo "noauth" >> /etc/ppp/peers/ueagle-atm

touch /etc/ppp/chap-secrets
echo "$1 * $2 *" >> /etc/ppp/chap-secrets

#echo "usbfs    /proc/bus/usb    usbfs  defaults  0    0" >> /etc/fstab

#echo "nameserver 194.204.152.34" > /etc/resolv.conf
#echo "nameserver 217.98.63.164" >> /etc/resolv.conf

modprobe pppoatm
modprobe ueagle-atm

rm -f ~/ueagle-data-1.1.tar.gz

echo -e "Gratuluje! Instalacja i konfiguracja przebiegły pomyślnie:)\n\n Mozesz teraz nawiązać połączenie wpisując: pppd call ueagle-atm"
