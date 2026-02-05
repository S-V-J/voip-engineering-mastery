#!/bin/bash
# VoIP VLAN Configuration Script
# Creates Voice VLAN 10 and Data VLAN 20

echo "=== Creating VLAN Interfaces ==="

# Load 8021q module if not loaded
sudo modprobe 8021q

# Create Voice VLAN 10 interface
echo "Creating eth0.10 (Voice VLAN)..."
sudo ip link add link eth0 name eth0.10 type vlan id 10

# Create Data VLAN 20 interface
echo "Creating eth0.20 (Data VLAN)..."
sudo ip link add link eth0 name eth0.20 type vlan id 20

# Assign IP addresses
echo "Assigning IP addresses..."
sudo ip addr add 192.168.10.1/24 dev eth0.10  # Voice gateway
sudo ip addr add 192.168.20.1/24 dev eth0.20  # Data gateway

# Bring interfaces up
echo "Activating interfaces..."
sudo ip link set dev eth0.10 up
sudo ip link set dev eth0.20 up

# Display configuration
echo -e "\n=== VLAN Configuration Complete ==="
echo "Voice VLAN 10:"
ip addr show eth0.10
echo -e "\nData VLAN 20:"
ip addr show eth0.20

# Show routing table
echo -e "\n=== Routing Table ==="
ip route show | grep -E "(10|20)"

echo -e "\n✅ VLANs created successfully!"