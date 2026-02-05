#!/bin/bash

echo "=== VLAN Interface Verification ==="

# Check if VLAN interfaces exist
if ip link show eth0.10 &>/dev/null; then
    echo "✅ eth0.10 (Voice VLAN 10) exists"
else
    echo "❌ eth0.10 NOT found!"
fi

if ip link show eth0.20 &>/dev/null; then
    echo "✅ eth0.20 (Data VLAN 20) exists"
else
    echo "❌ eth0.20 NOT found!"
fi

# Show VLAN details with -d (detailed)
echo -e "\n=== Detailed VLAN Information ==="
ip -d link show eth0.10
ip -d link show eth0.20

# Test connectivity
echo -e "\n=== Testing VLAN Connectivity ==="
echo "Pinging Voice VLAN gateway (192.168.10.1)..."
ping -c 3 -I eth0.10 192.168.10.1

echo -e "\nPinging Data VLAN gateway (192.168.20.1)..."
ping -c 3 -I eth0.20 192.168.20.1

# Show ARP tables for each VLAN
echo -e "\n=== ARP Tables ==="
ip neigh show dev eth0.10
ip neigh show dev eth0.20