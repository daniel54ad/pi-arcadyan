#!/bin/bash

device_mac=50:3e:aa:bb:6b:34

#sudo ovs-ofctl add-flow ovsbr0 "in_port:eth1, actions=output:vx11"
#sudo ovs-ofctl add-flow ovsbr0 "in_port:vx11, actions=output:eth1"

sudo ovs-ofctl add-flow ovsbr0 "dl_src=${device_mac}, actions=output:vx11"
sudo ovs-ofctl add-flow ovsbr0 "dl_dst=${device_mac}, actions=output:eth1"

