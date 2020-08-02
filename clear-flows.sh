#!/bin/bash

sudo ovs-ofctl del-flows ovsbr0
sudo ovs-ofctl add-flow ovsbr0 "priority=0,actions=NORMAL"

