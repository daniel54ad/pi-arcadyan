#!/bin/bash
# usage: ./connect-onos.sh onos_ip

if [ $# -lt 1 ];  then
    echo "usage: ./connect-onos.sh onos_ip"
    exit 0
fi

onos_ip=$1

set -x
sudo ovs-vsctl set-controller ovsbr0 tcp:${onos_ip}:6653

echo "send flow to onos"
sleet 5
# sent default flow to ONOS
curl -X POST --user onos:rocks -H "content-type:application/json" -d @default-flow.json http://${onos_ip}:8181/onos/v1/flows

echo "finish"
