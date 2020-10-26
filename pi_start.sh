#!/bin/bash
# usage: ./pi_start.sh 

# wan interface: eth0, eth1

if [ $# -lt 0 ];  then
    echo "usage: ./pi_start.sh"
    exit 0
fi

# link of device-connect
sudo ip link set eth2 up && sudo ovs-vsctl add-port ovsbr0 eth2

sudo ovs-vsctl add-port ovsbr0 gw0 -- set interface gw0 type=internal
sudo ip addr add 192.168.100.100/24 dev gw0
sudo ip link set gw0 up

# start dnsmasq
sudo sysctl -w net.ipv4.ip_forward=1

sudo service unbound stop

sudo service dnsmasq start

# mark by DCSP
sudo iptables -t mangle -A PREROUTING -m dscp --dscp 1 -j MARK --set-mark 1
sudo iptables -t mangle -A PREROUTING -m dscp --dscp 2 -j MARK --set-mark 2

# ip rule
sudo ip rule add fwmark 1 table table1 priority 100
sudo ip rule add fwmark 2 table table2 priority 101

# NAT
sudo iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o eth1 -j MASQUERADE

sudo sysctl -w net.ipv4.conf.all.rp_filter=2
