#!/bin/bash

if [ `whoami` != "root" ]; then
echo "root"
else

echo "Podaj wersje nowego jadra"
read wersja

cp linux-$wersja.tar.bz2 /usr/src
cd /usr/src
tar -xf linux-$wersja.tar.bz2
rm -rf linux
echo "Podaj wersje poprzedniego jadra"
read starawersja

rm -rf linux-$starawersja.tar.bz2 linux-$starawersja linux-headers-$starawersja linux
ln -s linux-$wersja linux
cd linux
cp /boot/config-$starawersja .config
make menuconfig
make-kpkg clean
make-kpkg -initrd --revision=1 kernel_image kernel_headers modules_image
cd /usr/src
ls *.deb
exit
fi 
