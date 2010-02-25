#!/bin/bash

pacman -Qu > /tmp/pacman.txt

dane=`cat /tmp/pacman.txt |wc -l`

if 
[ "$dane" != 0 ] ;
then echo $dane
else echo System updated.
fi
