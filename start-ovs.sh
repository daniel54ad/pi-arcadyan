#!/bin/bash

sudo /usr/local/share/openvswitch/scripts/ovs-ctl start

sudo ovs-ofctl show ovsbr0
if [ $? -ne 0 ]; then
	echo "add br ovsbr0"
	sudo ovs-vsctl add-br ovsbr0
fi
sudo ovs-vsctl show

