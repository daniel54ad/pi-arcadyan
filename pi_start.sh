#!/bin/bash
# usage: ./pi_start.sh WAN_INTERFACE

if [ $# -lt 1 ];  then
    echo "usage: ./pi_start.sh WAN_INTERFACE"
    exit 0
fi

WAN_INTERFACE=$1

# link
sudo ip link set eth1 up && sudo ovs-vsctl add-port ovsbr0 eth1
sudo ip link set eth2 up && sudo ovs-vsctl add-port ovsbr0 eth2


sudo ip addr add 192.168.100.100/24 dev dhcper
sudo ip link set dhcper up
sudo ovs-vsctl add-port ovsbr0 dhcper

sudo sysctl -w net.ipv4.ip_forward=1
sudo service dnsmasq start

# NAT
sudo iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o ${WAN_INTERFACE} -j MASQUERADE

