#!/bin/bash

sudo ovs-vsctl del-br ovsbr0
sudo ip l del vx11
sudo iptables -F -t nat
sudo iptables -F -t mangle

sudo /usr/local/share/openvswitch/scripts/ovs-ctl stop
sudo /usr/local/share/openvswitch/scripts/ovs-ctl start
