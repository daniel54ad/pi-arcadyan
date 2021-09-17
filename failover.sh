#!/bin/bash

if [ $# -lt 1 ];  then
    echo "usage: ./failover.sh remote_ip"
    exit 0
fi

vCPE_IP=$1
dpid=`sudo ovs-ofctl show ovsbr0  | awk '/dpid:/ {split($3,a,":"); print a[2]}'`

echo "failover script start"
echo "eth1 is connected"
device=""
declare -A states
count_line=0
sudo dbus-monitor --system "type='signal',interface='org.freedesktop.NetworkManager.Device'" | 
while read -ra line; do
	if [[ "${line[*]}" =~ "path=/org/freedesktop/NetworkManager/Devices/" ]]; then
		device="${line[7]}"
		device="${device:5:-1}"
		# echo "${device}"
		while [[ ${count_line} -lt 3 ]]; do
			read -ra state
			states[${count_line}]="${state[1]}"
			((count_line++))
		done
		# echo ${states[@]}
		interface=`sudo dbus-send --system --dest=org.freedesktop.NetworkManager \
			--print-reply ${device} \
			org.freedesktop.DBus.Properties.Get string:org.freedesktop.NetworkManager.Device string:Interface | grep variant | awk '{printf "%s", $3}'`
		interface="${interface:1:-1}"
		# echo ${interface}
		if [[ ${states[0]} -eq 100 ]]; then
			echo "[Detect] ${interface} is connected"
			/bin/bash -c "sudo ./route-setting.sh"
			if [[ "${interface}" == "eth0" ]]; then
                                echo "eth0 alive"
                                curl -X POST http://${vCPE_IP}:8000/failover -d '{"brg":"'"$dpid"'", "dscp":"'"0"'", "type":"'"recovery"'", "interface":"'"1"'"}'
                        elif [[ "${interface}" == "eth1" ]]; then
                                echo "eth1 alive"
                                curl -X POST http://${vCPE_IP}:8000/failover -d '{"brg":"'"$dpid"'", "dscp":"'"0"'", "type":"'"recovery"'", "interface":"'"2"'"}'
                        fi
		fi
		if [[ ${states[0]} -eq 20 ]]; then
			echo "[Detect] ${interface} is disconnected"
			if [[ "${interface}" == "eth0" ]]; then
				echo "change to eth1"
				curl -X POST http://${vCPE_IP}:8000/failover -d '{"brg":"'"$dpid"'", "dscp":"'"2"'", "type":"'"failure"'", "interface":"'"1"'"}'
			elif [[ "${interface}" == "eth1" ]]; then
				echo "change to eth0"
				curl -X POST http://${vCPE_IP}:8000/failover -d '{"brg":"'"$dpid"'", "dscp":"'"1"'", "type":"'"failure"'", "interface":"'"2"'"}'
			fi
		fi
		
		count_line=0
		device=""
	fi
done
