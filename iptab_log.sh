#!/bin/bash
iptables=/sbin/iptables

$iptables -N LOG_DROP
$iptables -A LOG_DROP -j LOG --log-tcp-options --log-ip-options --log-prefix '[IPTABLES DROP]: '
$iptables -A LOG_DROP -j DROP

$iptables -N LOG_ACCEPT
$iptables -A LOG_ACCEPT -j LOG --log-tcp-options --log-ip-options --log-prefix '[IPTABLES ACCEPT]: '
$iptables -A LOG_ACCEPT -j ACCEPT

