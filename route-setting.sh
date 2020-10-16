#!/bin/bash

# set multi gateway for multi uplinks
# ref: https://tldp.org/HOWTO/Adv-Routing-HOWTO/lartc.rpdb.multiple-links.html

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


IF1=eth0
T1=table1

IF2=eth1
T2=table2

IP1=`ip addr show ${IF1} | awk '/inet / {split($2,a,"/"); print a[1]}'`
IP2=`ip addr show ${IF2} | awk '/inet / {split($2,a,"/"); print a[1]}'`

default_GW=${IP1}

GW1=`ip route show default dev ${IF1}| awk '{print $3}'`
GW2=`ip route show default dev ${IF2}| awk '{print $3}'`

P1_NET=`ip route show dev ${IF1} | awk '/kernel/ {print $1}'`
P2_NET=`ip route show dev ${IF2} | awk '/kernel/ {print $1}'`

echo "IP1 = $IP1"
echo "IP2 = $IP2"
echo "Gateway1 = $GW1"
echo "Gateway2 = $GW2"
echo "P1_NET = $P1_NET"
echo "P2_NET = $P2_NET"

set -x
ip route add $P1_NET dev $IF1 src $IP1 table $T1
ip route add default via $GW1 dev $IF1 table $T1
ip route add $P2_NET dev $IF2 src $IP2 table $T2
ip route add default via $GW2 dev $IF2 table $T2

ip route add $P1_NET dev $IF1 src $IP1
ip route add $P2_NET dev $IF2 src $IP2

ip route add default via $default_GW

ip rule add from $IP1 table $T1 priority 1000
ip rule add from $IP2 table $T2 priority 1001
