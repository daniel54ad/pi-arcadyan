#!/bin/bash

if [ $# -lt 3 ];  then
    echo "usage: ./start_test.sh vni local_ip remote_ip"
    exit 0
fi

./pi_start.sh
sudo ./route-setting.sh
./connect-onos.sh $3
./create_vxlan_tunnel.sh $1 $2 $3
