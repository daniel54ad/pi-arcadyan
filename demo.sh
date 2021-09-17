#!/bin/bash

if [ $# -lt 5 ];  then
    echo "usage: ./start_test.sh vni_1 local_ip_1 vni_2 local_ip_2 remote_ip"
    exit 0
fi

sudo ip l set eth1 up
sudo dhclient eth1

./pi_start.sh
sudo ./route-setting.sh
./connect-onos.sh $5
./create_vxlan_tunnel.sh $1 $2 $5
./create_vxlan_tunnel.sh $3 $4 $5
