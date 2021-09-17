#!/bin/bash

sudo ovs-vsctl del-br ovsbr0
sudo ip l del vx11
sudo ip l del vx12
sudo ip l del vx13
sudo ip l del vx14
sudo iptables -F -t nat
sudo iptables -F -t mangle
sudo ip l del gw0

sudo /usr/local/share/openvswitch/scripts/ovs-ctl stop
sudo /usr/local/share/openvswitch/scripts/ovs-ctl start
