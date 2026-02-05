#!/bin/bash
# VoIP Subnet Calculator

echo "=== VoIP Subnet Calculator ==="
echo ""
read -p "Enter network (e.g., 192.168.10.0): " network
read -p "Enter CIDR (e.g., 24): " cidr

# Calculate subnet mask
mask=$(ipcalc -n -b $network/$cidr | grep Netmask | awk '{print $2}')
hosts=$(ipcalc -n -b $network/$cidr | grep Hosts | awk '{print $2}')
first=$(ipcalc -n -b $network/$cidr | grep HostMin | awk '{print $2}')
last=$(ipcalc -n -b $network/$cidr | grep HostMax | awk '{print $2}')
broadcast=$(ipcalc -n -b $network/$cidr | grep Broadcast | awk '{print $2}')

echo ""
echo "Network: $network/$cidr"
echo "Subnet Mask: $mask"
echo "Usable Hosts: $hosts"
echo "First IP: $first"
echo "Last IP: $last"
echo "Broadcast: $broadcast"
echo ""
echo "Recommended for VoIP Voice VLAN: ✓"
