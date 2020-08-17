#!/bin/bash

##### Install default for BRG-ovs
if [ $# -lt 1 ];  then
    echo "usage: ./install_default_flow.sh ONOS_IP"
    exit 0
fi

BASEDIR=$(dirname $0)

ONOS_IP=$1

OVS_URI="of:0000$(ip link show ovsbr0 | awk '/link\/ether/ {print $2}'| sed 's/://g')" 

cat ${BASEDIR}\/flow-logical.json | sed \
-e "s|\$OVS_URI|${OVS_URI}|g" \
-e '/\/\//d' \
> default-flow.json

curl -X POST --user onos:rocks -H "content-type:application/json" -d @default-flow.json http://${ONOS_IP}:8181/onos/v1/flows

echo -e '\033[0;32m\n=== POST Default Flows finish ===\033[0m'
