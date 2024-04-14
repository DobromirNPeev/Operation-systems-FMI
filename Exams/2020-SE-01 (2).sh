#!/bin/bash

if [[ "${#}" -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -d ${2} ]];then
        echo "Not a directory"
        exit 2
fi

file="${1}"
dir="${2}"

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN,Trunk Ports,license,SN,key" > "${file}"

while read log;do
        hostname="$(basename "${log}" .log)"
        phy="$(cat "${log}" | grep -F "Maximum Physical Interfaces" | cut -d ':' -f 2 | xargs)"
        vlans="$(cat "${log}" | grep -F "VLANs" | cut -d ':' -f 2 |xargs)"
        hosts="$(cat "${log}" | grep "Inside Hosts" | cut -d ':' -f 2|xargs)"
        failover="$(cat "${log}" | grep "Failover" | cut -d ':' -f 2|xargs)"
        vpn="$(cat "${log}" | grep "VPN-3DES-AES" | cut -d ':' -f 2|xargs)"
        peers="$(cat "${log}" | grep "*Total VPN Peers" | cut -d ':' -f 2|xargs)"
        vlan="$(cat "${log}" | grep "VLAN Trunk Ports" | cut -d ':' -f 2| xargs)"
        license="$(cat "${log}" | grep "^This platform" | sed -E "s/This platform has an? (.*) license./\1/" | xargs)"
        sn="$(cat "${log}" | grep "Serial Number" | cut -d ':' -f 2 | xargs)"
        key="$(cat "${log}" | grep "Running Activation Key" | cut -d ':' -f 2 | xargs)"
        echo "${hostname},${phy},${vlans},${hosts},${failover},${vpn},${peers},${vlan},${license},${sn},${key}" >> "${file}"
done < <(find "${dir}" -type f -name '*.log')
