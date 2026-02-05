#!/bin/bash

echo "=== Enabling Inter-VLAN Routing ==="

# Check current IP forwarding status
echo "Current IP forwarding status:"
sysctl net.ipv4.ip_forward

# Enable IP forwarding (temporary - until reboot)
echo "Enabling IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1

# Make it persistent (survives reboot)
if ! grep -q "net.ipv4.ip_forward=1" /etc/sysctl.conf 2>/dev/null; then
    echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
    echo "✅ IP forwarding will persist after reboot"
fi

# Verify
echo -e "\n=== Verification ==="
sysctl net.ipv4.ip_forward

# Test routing between VLANs
echo -e "\n=== Testing Inter-VLAN Routing ==="
echo "Routing table:"
ip route show

echo -e "\nTrying to route from VLAN 10 to VLAN 20..."
# This will work if both VLANs are on same host
ping -c 3 -I eth0.10 192.168.20.1

echo -e "\n✅ Inter-VLAN routing enabled!"