#!/bin/bash

if [ $# -lt 2 ]; then
    echo "usage: ./change_wan.sh vCPE-Manager-IP dscp"
    exit 0
fi

dpid=`sudo ovs-ofctl show ovsbr0  | awk '/dpid:/ {split($3,a,":"); print a[2]}'`
vCPE_IP=$1
dscp=$2
echo "dpid = ${dpid}"
echo "dscp = ${dscp}"

curl -X POST http://${vCPE_IP}:8000/change_wan -d '{"brg":"'"$dpid"'", "dscp":"'"$dscp"'"}'
