#!/bin/bash

YELLOW='\033[1;33m'
NC='\033[0m'

set -e
set -x
cd ~

sudo apt update
sudo apt install -y build-essential libssl-dev clang automake autoconf libtool python-pyftpdlib python-six python-dev python-tftpy graphviz unbound

# Install OvS 2.11.4
if [ -z "$(which ovs-vsctl)" ]; then
    echo -e "${YELLOW}[*] Begin to install OvS...${NC}"
    wget https://www.openvswitch.org/releases/openvswitch-2.11.4.tar.gz
    tar zxf openvswitch-2.11.4.tar.gz
    cd openvswitch-2.11.4
    ./configure
    make
    sudo make install
    sudo mkdir -p /usr/local/etc/openvswitch
    sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema
    sudo /usr/local/share/openvswitch/scripts/ovs-ctl start
fi

# Finish
sudo touch /etc/rc.local
sudo chmod 777 /etc/rc.local
sudo printf "#!/bin/bash\nexit 0\n" > /etc/rc.local
sudo sed -i "/exit 0$/i ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                     --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                     --private-key=db:Open_vSwitch,SSL,private_key \
                     --certificate=db:Open_vSwitch,SSL,certificate \
                     --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                     --pidfile --detach \novs-vsctl --no-wait init \novs-vswitchd --pidfile --detach" /etc/rc.local

echo -e "${YELLOW}*** Installation Finished! ***${NC}"

# start script of ubuntu 18.04

sudo touch /etc/systemd/system/rc-local.service
sudo chmod 777 /etc/systemd/system/rc-local.service

sudo printf "[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/rc-local.service

sudo systemctl enable rc-local

sudo systemctl start rc-local.service

sudo ovs-vsctl --version
