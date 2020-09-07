#!/bin/bash

# set multi gateway for multi uplinks
# ref: https://tldp.org/HOWTO/Adv-Routing-HOWTO/lartc.rpdb.multiple-links.html

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

default_GW=192.168.50.1

P1_NET=192.168.50.0/24
IF1=eth0
IP1=192.168.50.33
T1=table0
GW1=192.168.50.1

P2_NET=192.168.0.0/24
IF2=wlan0
IP2=192.168.0.15
T2=table1
GW2=192.168.0.1

set -x
ip route add $P1_NET dev $IF1 src $IP1 table $T1
ip route add default via $GW1 table $T1
ip route add $P2_NET dev $IF2 src $IP2 table $T2
ip route add default via $GW2 table $T2

ip route add $P1_NET dev $IF1 src $IP1
ip route add $P2_NET dev $IF2 src $IP2

ip route add default via $default_GW

ip rule add from $IP1 table $T1
ip rule add from $IP2 table $T2
