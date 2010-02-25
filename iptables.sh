#!/bin/sh

################
# Konfiguracja #
################

F="/sbin/iptables"
LOG="ipt#"

#interfejs globalny - dla sieci zewnetrznej
G_NET_NAME="wlan0"
G_NET_IP=""

#ustawienie modulow i konfiguracji jadra
/sbin/modprobe ip_tables
/sbin/modprobe ip_conntrack
/sbin/modprobe ip_nat_ftp
/sbin/modprobe ip_conntrack_ftp

echo "1" > /proc/sys/net/ipv4/ip_forward

#dynamiczny przydzial adresu
#echo "1" > /proc/sys/net/ipv4/ip_dynaddr

#ignorowanie ICMP echo request wysylanych na adres rozgloszeniowy
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

#ochrona przed SYN flood
echo "1" > /proc/sys/net/ipv4/tcp_syncookies

#refuse source routed packets
echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route

echo "1" > /proc/sys/net/ipv4/conf/all/secure_redirects

#walidacja zrodla za pomoca reversed path (RFC1812).
echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter

#logowanie pakietow z nieprawidlowych adresow
echo "1" > /proc/sys/net/ipv4/conf/all/log_martians

#################
# INICJALIZACJA #
#################

echo "Ustawienia polityki dla lancuchow standardowych..."
$F -P INPUT ACCEPT
$F -P FORWARD ACCEPT
$F -P OUTPUT ACCEPT
$F -t nat -P PREROUTING ACCEPT
$F -t nat -P OUTPUT ACCEPT
$F -t nat -P POSTROUTING ACCEPT
$F -t mangle -P PREROUTING ACCEPT
$F -t mangle -P OUTPUT ACCEPT
$F -t mangle -P INPUT ACCEPT
$F -t mangle -P FORWARD ACCEPT
$F -t mangle -P POSTROUTING ACCEPT

echo "Czyszczenie regul dla lancuchow standardowych..."
$F -F
$F -t nat -F
$F -t mangle -F

echo "Kasowanie wszystkich niestandardowych lancuchow..."
$F -X
$F -t nat -X
$F -t mangle -X

if [ "$1" = "stop" ]
then
	echo "Firewall zostal wylaczony."
	exit 0
fi

echo "Ustawienia polityki lancuchow standardowych..."
$F -P INPUT DROP
$F -P OUTPUT DROP
$F -P FORWARD DROP

echo "Tworzenie niestandardowych lancuchow regul..."
$F -N bledne_pakiety
$F -N bledne_pakiety_tcp
$F -N pakiety_icmp
$F -N tcp_wchodzace
$F -N tcp_wychodzace
$F -N udp_wchodzace
$F -N udp_wychodzace

##################
# bledne_pakiety #
##################
echo "Tworzenie regul dla lancucha bledne_pakiety..."

$F -A bledne_pakiety -p ALL -m state --state INVALID -j LOG --log-prefix "$LOG bledne_pakiety "
$F -A bledne_pakiety -p ALL -m state --state INVALID -j DROP
$F -A bledne_pakiety -p tcp -j bledne_pakiety_tcp
$F -A bledne_pakiety -p ALL -j RETURN

######################
# bledne_pakiety_tcp #
######################
echo "Tworzenie regul dla lancucha bledne_pakiety_tcp..."
#dla gate
$F -A bledne_pakiety_tcp -p tcp -i $L_NET_NAME -j RETURN

$F -A bledne_pakiety_tcp -p tcp ! --syn -m state --state NEW -j LOG --log-prefix "$LOG bledne_pakiety_tcp "
$F -A bledne_pakiety_tcp -p tcp ! --syn -m state --state NEW -j DROP

$F -A bledne_pakiety_tcp -p tcp --tcp-flags ALL NONE -j LOG --log-prefix "$LOG bledne_pakiety_tcp "
$F -A bledne_pakiety_tcp -p tcp --tcp-flags ALL NONE -j DROP

$F -A bledne_pakiety_tcp -p tcp --tcp-flags ALL ALL -j LOG --log-prefix "$LOG bledne_pakiety_tcp "
$F -A bledne_pakiety_tcp -p tcp --tcp-flags ALL ALL -j DROP

$F -A bledne_pakiety_tcp -p tcp --tcp-flags ALL FIN,URG,PSH -j LOG --log-prefix "$LOG bledne_pakiety_tcp "
$F -A bledne_pakiety_tcp -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP

$F -A bledne_pakiety_tcp -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j LOG --log-prefix "$LOG bledne_pakiety_tcp "
$F -A bledne_pakiety_tcp -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

$F -A bledne_pakiety_tcp -p tcp --tcp-flags SYN,RST SYN,RST -j LOG --log-prefix "$LOG bledne_pakiety_tcp "
$F -A bledne_pakiety_tcp -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

$F -A bledne_pakiety_tcp -p tcp --tcp-flags SYN,FIN SYN,FIN -j LOG --log-prefix "$LOG bledne_pakiety_tcp "
$F -A bledne_pakiety_tcp -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP

$F -A bledne_pakiety_tcp -p tcp -j RETURN

################
# pakiety_icmp #
################
echo "Tworzenie regul dla lancucha pakiety_icmp..."

$F -A pakiety_icmp --fragment -p ICMP -j LOG --log-prefix "$LOG pakiety_icmp fragmenty "
$F -A pakiety_icmp --fragment -p ICMP -j DROP

#pingowanie i logowanie pingowania
# $F -A pakiety_icmp -p ICMP -s 0/0 --icmp-type 8 -j LOG --log-prefix "$LOG pakiety_icmp "
# $F -A pakiety_icmp -p ICMP -s 0/0 --icmp-type 8 -j ACCEPT

#ping - zachaszowac w przypadku odsloniecia powyzszych regul
$F -A pakiety_icmp -p ICMP -s 0/0 --icmp-type 8 -j DROP
#Time Exceeded
$F -A pakiety_icmp -p ICMP -s 0/0 --icmp-type 11 -j ACCEPT

$F -A pakiety_icmp -p ICMP -j RETURN

#################
# tcp_wchodzace #
#################
echo "Tworzenie regul dla lancucha tcp_wchodzace..."

#ident request
#reject zamiast drop w celu unikniecia opoznien przy polaczeniach
$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 113 -j REJECT
#FTP client (data port non-PASV)
#$F -A tcp_wchodzace -p TCP -s 0/0 --source-port 20 -j ACCEPT
#FTP control
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 21 -j ACCEPT
# Passive FTP
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port : -j ACCEPT
#ssh
$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 22 -j ACCEPT
#HTTP
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 80 -j ACCEPT
#HTTPS
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 443 -j ACCEPT
#SMTP
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 25 -j ACCEPT
#POP3
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 110 -j ACCEPT
#SSL POP3
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 995 -j ACCEPT
#IMAP4
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 143 -j ACCEPT
#SSL IMAP4
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 993 -j ACCEPT
#ICQ File Transfers & Other Advanced Features
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port : -j ACCEPT
#MSN Messenger File Transfers
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port : -j ACCEPT
#NFS Server - portmapper
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - statd
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - NFS daemon
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - lockd
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - mountd
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - quotad
#$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port  -j ACCEPT
#User specified allowed TCP protocol
$F -A tcp_wchodzace -p TCP -s 0/0 --destination-port 6998 -j ACCEPT

#nie pasujace: powrot i logowanie
$F -A tcp_wchodzace -p TCP -j RETURN

##################
# tcp_wychodzace #
##################
echo "Tworzenie regul dla lancucha tcp_wychodzace..."

#Blokowanie FTP Data
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 20 -j REJECT
#Blokowanie FTP Control
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 21 -j REJECT
#Blokowanie SSH
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 22 -j REJECT
#Blokowanie Telnet
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 23 -j REJECT
#Blokowanie HTTP
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 80 -j REJECT
#Blokowanie HTTPS
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 443 -j REJECT
#Blokowaie SMTP
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 25 -j REJECT
#Blokowaie POP3
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 110 -j REJECT
#Blokowaie POP3SSL
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 995 -j REJECT
#Blokowaie IMAP4
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 143 -j REJECT
#Blokowaie IMAP4SSL
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 993 -j REJECT
#Blokowanie NEWS
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 119 -j REJECT
#Blokowanie IRC
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port : -j REJECT
#Blokowaie AIM
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 5190 -j REJECT
#Blokowaie AIM Images
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 4443 -j REJECT
#Blokowaie MSN Messenger
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port 1863 -j REJECT
#Blokowany zakres portow
#$F -A tcp_wychodzace -p TCP -s 0/0 --destination-port  -j REJECT
#blokowanie gg
#$F -A tcp_wychodzace -p TCP -s 0/0 -d 217.17.41.0/24 -j REJECT
#$F -A tcp_wychodzace -p TCP -s 0/0 -d 217.17.33.0/24 -j REJECT

#nie pasujace ACCEPT
$F -A tcp_wychodzace -p TCP -s 0/0 -j ACCEPT

#################
# udp_wchodzace #
#################
echo "Tworzenie regul dla lancucha udp_wchodzace..."

#Drop netbios calls
$F -A udp_wchodzace -p UDP -s 0/0 --destination-port 137 -j DROP
$F -A udp_wchodzace -p UDP -s 0/0 --destination-port 138 -j DROP

#ident - reject zamiast drop w celu unikniecia opoznien w polaczeniach
$F -A udp_wchodzace -p UDP -s 0/0 --destination-port 113 -j REJECT

#NTP
#$F -A udp_wchodzace -p UDP -s 0/0 --destination-port 123 -j ACCEPT
#DNS
#$F -A udp_wchodzace -p UDP -s 0/0 --destination-port 53 -j ACCEPT
#zewnetrzny server DHCP
#$F -A udp_wchodzace -p UDP -s 0/0 --source-port 68 --destination-port 67 -j ACCEPT
#NFS Server - portmapper
#$F -A udp_wchodzace -p UDP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - statd
#$F -A udp_wchodzace -p UDP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - NFS daemon
#$F -A udp_wchodzace -p UDP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - lockd
#$F -A udp_wchodzace -p UDP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - mountd
#$F -A udp_wchodzace -p UDP -s 0/0 --destination-port  -j ACCEPT
#NFS Server - quotad
#$F -A udp_wchodzace -p UDP -s 0/0 --destination-port  -j ACCEPT
#dopuszczalny zakres portow udp
$F -A udp_wchodzace -p UDP -s 0/0 --destination-port 6880 -j ACCEPT

#nie pasujace - powrot i logowanie
$F -A udp_wchodzace -p UDP -j RETURN

##################
# udp_wychodzace #
##################
echo "Tworzenie regul dla lancucha udp_wychodzace..."

#Blokowany zakres portow
#$F -A udp_wychodzace -p UDP -s 0/0 --destination-port  -j REJECT
#blokowanie gg
#$F -A udp_wychodzace -p UDP -s 0/0 -d 217.17.41.0/24 -j REJECT
#$F -A udp_wychodzace -p UDP -s 0/0 -d 217.17.33.0/24 -j REJECT

#nie pasujace ACCEPT
$F -A udp_wychodzace -p UDP -s 0/0 -j ACCEPT

#########
# INPUT #
#########

echo "Tworzenie regul dla lancucha INPUT..."

$F -A INPUT -p ALL -i lo -j ACCEPT
$F -A INPUT -p ALL -j bledne_pakiety

#DOCSIS compliant cable modems
#Drop without logging.
$F -A INPUT -p ALL -d 224.0.0.1 -j DROP

#Ustanowione polaczenia
$F -A INPUT -p ALL -i $G_NET_NAME -m state --state ESTABLISHED,RELATED -j ACCEPT

#reszta do odpowiednich lancuchow
$F -A INPUT -p ICMP -i $G_NET_NAME -j pakiety_icmp
$F -A INPUT -p TCP -i $G_NET_NAME -j tcp_wchodzace
$F -A INPUT -p UDP -i $G_NET_NAME -j udp_wchodzace

#zatrzymanie rozgloszen
$F -A INPUT -p ALL -d 255.255.255.255 -j DROP

#nie pasujace - logowanie
$F -A INPUT -j LOG --log-prefix "$LOG INPUT:99 "

###########
# FORWARD #
###########
#dla gate caly
echo "Tworzenie regul dla lancucha FORWARD..."

#nie pasujace - loguj
$F -A FORWARD -j LOG --log-prefix "$LOG FORWARD:99 "

##########
# OUTPUT #
##########

echo "Tworzenie regul dla lancucha OUTPUT..."

$F -A OUTPUT -m state -p icmp --state INVALID -j DROP
$F -A OUTPUT -p ALL -s 127.0.0.1 -j ACCEPT
$F -A OUTPUT -p ALL -o lo -j ACCEPT

$F -A OUTPUT -p ALL -o $G_NET_NAME -j ACCEPT

#nie pasujace - loguj
$F -A OUTPUT -j LOG --log-prefix "$LOG OUTPUT:99 "

################
# mangle table #
################
echo "Tworzenie regul dla mangle table..."


