#!/bin/bash

YELLOW='\033[1;33m'
NC='\033[0m'

set -e
set -x
cd ~

sudo apt update
sudo apt install -y build-essential libssl-dev clang automake autoconf libtool python-six python-dev-is-python2  graphviz unbound

# Install OvS 2.10.0
if [ -z "$(which ovs-vsctl)" ]; then
    echo -e "${YELLOW}[*] Begin to install OvS...${NC}"
    wget https://www.openvswitch.org/releases/openvswitch-2.10.0.tar.gz
    tar zxf openvswitch-2.10.0.tar.gz
    cd openvswitch-2.10.0
    ./configure
    make
    sudo make install
    sudo mkdir -p /usr/local/etc/openvswitch
    sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema
    sudo /usr/local/share/openvswitch/scripts/ovs-ctl start
fi
