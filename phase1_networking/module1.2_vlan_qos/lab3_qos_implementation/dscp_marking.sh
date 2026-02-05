#!/bin/bash

echo "=== Implementing DSCP Marking for VoIP ==="

# Flush existing iptables mangle rules
sudo iptables -t mangle -F

# Mark SIP traffic (UDP 5060) with DSCP AF41 (34)
echo "Marking SIP signaling with DSCP 34 (AF41)..."
sudo iptables -t mangle -A OUTPUT -p udp --dport 5060 -j DSCP --set-dscp 34
sudo iptables -t mangle -A OUTPUT -p udp --sport 5060 -j DSCP --set-dscp 34
sudo iptables -t mangle -A OUTPUT -p tcp --dport 5060 -j DSCP --set-dscp 34
sudo iptables -t mangle -A OUTPUT -p tcp --sport 5060 -j DSCP --set-dscp 34

# Mark RTP traffic (UDP 10000-20000) with DSCP EF (46)
echo "Marking RTP media with DSCP 46 (EF)..."
sudo iptables -t mangle -A OUTPUT -p udp --dport 10000:20000 -j DSCP --set-dscp 46
sudo iptables -t mangle -A OUTPUT -p udp --sport 10000:20000 -j DSCP --set-dscp 46

# Mark traffic from Voice VLAN with DSCP EF
echo "Marking all Voice VLAN traffic with DSCP 46..."
sudo iptables -t mangle -A OUTPUT -o eth0.10 -j DSCP --set-dscp 46

# Display rules
echo -e "\n=== DSCP Marking Rules ==="
sudo iptables -t mangle -L OUTPUT -n -v --line-numbers

# Save rules (optional - for persistence)
# sudo iptables-save > /etc/iptables/rules.v4

echo -e "\n✅ DSCP marking configured!"