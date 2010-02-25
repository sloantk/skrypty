#!/bin/sh
#Poczatek skryptu /etc/rc.d/firewall.start
#/etc/rc.d/iptables stop
#rm /etc/iptables/iptables.rules

iptables=/usr/sbin/iptables

modprobe ip_tables
modprobe ip_conntrack
modprobe ip_conntrack_ftp

$iptables -P INPUT DROP
$iptables -P OUTPUT DROP
$iptables -P FORWARD DROP

# wylaczamy odpowiedzi na pingi
/bin/echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all
# ochrona przed atakiem typu Smurf
/bin/echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
# Nie aktceptujemy pakietow "source route"
/bin/echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route
# Nie przyjmujemy pakietow ICMP rediect, ktore moga zmienic nasza tablice rutingu
/bin/echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
# Wlaczamy ochrone przed blednymi komunikatami ICMP error
/bin/echo "1" > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
# wszystkie karty nie beda przyjmowaly pakietow z sieci innych niz te z tablicy rutingu
echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter;
# Wlacza logowanie dziwnych (spoofed, source routed, redirects) pakietow
/bin/echo "1" > /proc/sys/net/ipv4/conf/all/log_martians
# W kernelu 2.4 nie trzeba wlaczac opcji ip_always_defrag

$iptables -A INPUT -i lo -j ACCEPT
$iptables -A OUTPUT -o lo -j ACCEPT 

$iptables -N syn-flood
$iptables -A INPUT -i wlan0 -p tcp --syn -j syn-flood
$iptables -A syn-flood -m limit --limit 1/s --limit-burst 4 -j RETURN
$iptables -A syn-flood -j LOG --log-level debug --log-prefix "IPT SYN-FLOOD: "
$iptables -A syn-flood -j DROP

$iptables -A INPUT -i wlan0 -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT
$iptables -A OUTPUT -o wlan0 -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT 

$iptables -A INPUT -i wlan0 -p tcp ! --syn -m state --state NEW -j LOG --log-level debug --log-prefix "IPT NEW: "
$iptables -A INPUT -i wlan0 -p tcp ! --syn -m state --state NEW -j DROP

$iptables -A INPUT -i wlan0 -f -j LOG --log-level debug --log-prefix "IPT FRAGMENTS: "
$iptables -A INPUT -i wlan0 -f -j DROP

# lancuch INPUT
#$iptables -A INPUT -p tcp --sport 1024: --dport  22 -m state --state NEW -j ACCEPT   # ssh na obu kartach
$iptables -A INPUT -p tcp --dport  53 -m state --state NEW -j ACCEPT
$iptables -A INPUT -p tcp --sport 1024: --dport 113 -m state --state NEW -j REJECT --reject-with icmp-port-unreachable   # identd
$iptables -A INPUT -p tcp --sport 1024: --dport  50003 -m state --state NEW -j ACCEPT
$iptables -A INPUT -p udp --sport 1024: --dport  50004 -m state --state NEW -j ACCEPT
#$iptables -A INPUT -p tcp --sport 1024: --dport  4662 -m state --state NEW -j ACCEPT
#$iptables -A INPUT -p udp --sport 1024: --dport  4664 -m state --state NEW -j ACCEPT
#$iptables -A INPUT -p udp --sport 1024: --dport  4672 -m state --state NEW -j ACCEPT

$iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$iptables -A INPUT -j LOG --log-level debug --log-prefix "IPT INPUT: "
$iptables -A INPUT -j DROP

# lancuch OUTPUT
$iptables -A OUTPUT -m state ! --state INVALID -j ACCEPT
$iptables -A OUTPUT -j LOG --log-level debug --log-prefix "IPT OUTPUT: "
$iptables -A OUTPUT -j DROP

#/etc/rc.d/iptables save
#/etc/rc.d/iptables start
