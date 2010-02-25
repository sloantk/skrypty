#!/bin/bash
# 
# Bash script for Toshiba Portege R500 users
# Saves power by disconnecting some hardware
#
# Sebastian 'night' £uczak <http://night.jogger.pl>
# Under GNU/GPL


# system functions

function help(){
	echo "usage: $0 {start|stop}";
	exit 0;
}

function warning(){
	echo -e "Before running script please remove all cards (PCMCIA, SD) and turn off wireless kill sitch\nThen please press ENTER...";
	read n;
}

# check of capabilities

if [ $EUID -ne 0 ]
then
	echo "You must be root to do that!";
	exit 1;
fi

if [ -z $1 ]
then
	help
fi

if [ $1 == "-h" ]
then
	help
fi

function wifi(){
	case "$1" in
		"stop") rmmod iwl4965 1> /dev/null 2> /dev/null;
			rmmod ohci1394 ieee1394 iwlwifi_mac80211 aes_i586 cfg80211;
			echo "Wi-Fi network card is now OFF";;
		"start") modprobe cfg80211;
			modprobe aes_i586;
			modprobe iwlwifi_mac80211;
			modprobe ieee1394;
			modprobe ohci1394;
			modprobe iwl4965;
			echo "Wi-Fi network card is now ON";;
		*) echo "Wi-Fi network card switch"
	esac
}

function nfs(){
	case "$1" in
		"stop") rmmod nfs nfs_acl lockd 2> /dev/null;
			echo "NFS is now OFF";;
		"start") modprobe lockd;
			modprobe nfs_acl;
			modprobe nfs;
			echo "NFS is now ON";;
		*) "NFS switch"
	esac
}

function sdreader(){
	case "$1" in
		"stop") rmmod sdhci mmc_block mmc_core 2> /dev/null; 
			echo "SD card reader is now OFF";;
		"start") modprobe mmc_core;
			modprobe mmc_block;
			modprobe sdhci;
			echo "SD card reader is now ON";;
		*) echo "SC card reader switch"
	esac
}


function lcd(){
	case "$1" in
		"stop") toshset -inten 1 1> /dev/null;
			echo "LCD backlight set on lowest";;
		"start") toshset -inten 7 1> /dev/null;
			echo "LCD backlight set on highest";;
		*) echo "LCD brightness switch"
	esac
}
	
function bluetooth(){
	case "$1" in
		"stop") toshset -bluetooth off 1> /dev/null;
			/etc/init.d/bluetooth stop 1> /dev/null;
			rmmod hci_usb rfcomm l2cap bluetooth 2> /dev/null;
			echo "Bluetooth stack is now OFF";;
		"start") modprobe rfcomm;
			modprobe l2cap;
			modprobe bluetooth;
			modprobe hci_usb;
			/etc/init.d/bluetooth start 1> /dev/null;
			#toshset -bluetooth on 1> /dev/null;
			echo "Bluetooth stack is now ON";;
		*) echo "Bluetooth stack switch"
	esac
}

function usb(){
	case "$1" in
		"start") modprobe uhci_hcd;
			modprobe ehci_hcd;
			modprobe libusual;
			modprobe usb_storage;
			echo "USB ports are now ON";;
		"stop") rmmod usb_storage libusual ehci_hcd uhci_hcd usb_storage libusual ehci_hcd uhci_hcd 2> /dev/null;
			echo "USB ports are now OFF";;
		*) echo "USB ports switch."
	esac
}

function cdrom(){
	case "$1" in
		"start") modprobe sr_mod cdrom 2> /dev/null;
			echo "CDROM drive is now ON";;
		"stop") rmmod sr_mod cdrom 2> /dev/null;
			echo "CDROM drive is now OFF";;
		*) echo "CDROM drive switch"
	esac
}

function sound(){
	case "$1" in
		"stop") killall kmix 2> /dev/null; 
			/etc/init.d/alsa-utils stop 1> /dev/null; 
			rmmod  snd_hda_intel  snd_pcm_oss  snd_mixer_oss snd_pcm  snd_timer  snd_hwdep snd_page_alloc  snd soundcore 2> /dev/null;
			echo "Sound subsystem is now OFF";;
		"start") modprobe snd-hda-intel;
			modprobe snd-pcm-oss;
			modprobe snd-mixer-oss;
			modprobe snd-pcm;
			modprobe snd-timer;
			modprobe snd-hwdep;
			modprobe snd-page-alloc;
			modprobe snd;
			modprobe soundcore;
			/etc/init.d/alsa-utils start 1> /dev/null;
			echo "Sound subsystem is now ON";;
		*) echo "Sound subsystem switch"
	esac
}

function parallel(){
	case "$1" in
		"stop") rmmod lp parport_pc ppdev parport 2> /dev/null;
			echo "Parallel port is now OFF";;
		"start") modprobe parport;
			modprobe ppdev;
			modprobe parport_pc;
			modprobe lp;
			echo "Parallel port is now ON";;
		*) echo "Parallel port switch"
	esac
}

function pcspkr(){
	case "$1" in
		"stop") rmmod pcspkr 2> /dev/null;
			echo "PC Speaker is now OFF";;
		"start") modprobe pcspkr;
			echo "PC Speaker is now ON";;
		*) echo "PC Speaker switch"
	esac
}

function pcmcia(){
	case "$1" in
		"stop") rmmod pata_pcmcia pcmcia yenta_socket rsrc_nonstatic pcmcia_core 2> /dev/null;
			echo "PCMCIA port is now OFF";;
		"start") modprobe pcmcia-core;
			modprobe rsrc-nonstatic;
			modprobe yenta-socket;
			modprobe pcmcia;
			modprobe pata_pcmcia;
			echo "PCMCIA port is now ON";;
		*) echo "PCMCIA port switch"
	esac
}

case "$1" in
	"stop") sound start;
		cdrom start;
		bluetooth start;
		lcd start;
		sdreader start;
		nfs start;
		parallel start;
		pcmcia start;
		pcspkr start;
		usb start;
		wifi start;
		echo "0" > /sys/devices/system/cpu/sched_mc_power_savings;;
		
	"start") warning; 
		sound stop;
		cdrom stop;
		bluetooth stop;
		lcd stop;
		sdreader stop;
		nfs stop;
		parallel stop;
		pcspkr stop;
		pcmcia stop;
		usb stop;
		wifi stop;
		echo 1500 > /proc/sys/vm/dirty_writeback_centisecs;
		killall -9 artsd 2> /dev/null;
		echo "1" > /sys/devices/system/cpu/sched_mc_power_savings;;
	*) echo -e "Toshiba Portege R500 power saving script, type -h for help\nSebastian 'night' £uczak <http://night.jogger.pl>\n"
esac

exit 0
