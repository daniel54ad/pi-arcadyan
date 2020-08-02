#!/bin/bash
# usage: ./create_vxlan_tunnel.sh VNI local_ip remote_ip

if [ $# -lt 3 ];  then
    echo "usage: ./create_vxlan_tunnel.sh VNI local_ip remote_ip"
    exit 0
fi

set -x

remote_ip=$3
local_ip=$2
vni=$1


# clear old setting
sudo ovs-vsctl del-port ovsbr0 vx${vni}
sudo ip link del vx${vni}


# create vxlan interface
sudo ip link add vx${vni} type vxlan \
id ${vni} \
remote ${remote_ip} \
local ${local_ip} \
dstport 4789 \
srcport 4789 4790 \
tos inherit

sudo ip link set vx${vni} up
sudo ovs-vsctl add-port ovsbr0 vx${vni}

