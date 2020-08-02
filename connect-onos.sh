#!/bin/bash
# usage: ./connect-onos.sh onos_ip

if [ $# -lt 1 ];  then
    echo "usage: ./connect-onos.sh onos_ip"
    exit 0
fi

onos_ip=$1

set -x
sudo ovs-vsctl set-controller ovsbr0 tcp:${onos_ip}:6653

