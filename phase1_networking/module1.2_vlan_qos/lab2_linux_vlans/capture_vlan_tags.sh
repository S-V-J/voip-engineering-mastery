#!/bin/bash

echo "=== Capturing VLAN Tagged Frames ==="
echo "Starting 30-second capture on eth0..."
echo "Generating traffic on both VLANs..."

# Start packet capture in background
sudo timeout 30 tcpdump -i eth0 -e -nn -w vlan_tagged.pcap 'vlan' &
TCPDUMP_PID=$!

sleep 2

# Generate traffic on Voice VLAN
echo "Generating Voice VLAN traffic..."
ping -c 5 -I eth0.10 192.168.10.1 &

# Generate traffic on Data VLAN
echo "Generating Data VLAN traffic..."
ping -c 5 -I eth0.20 192.168.20.1 &

# Wait for traffic generation
wait

# Wait for tcpdump to finish
wait $TCPDUMP_PID

# Analyze the capture
echo -e "\n=== Analyzing VLAN Tags ==="
echo "VLAN 10 packets:"
sudo tcpdump -r vlan_tagged.pcap -e -nn 'vlan 10' | head -5

echo -e "\nVLAN 20 packets:"
sudo tcpdump -r vlan_tagged.pcap -e -nn 'vlan 20' | head -5

echo -e "\n=== VLAN Tag Statistics ==="
sudo tcpdump -r vlan_tagged.pcap -e -nn | grep -oP 'vlan \d+' | sort | uniq -c

ls -lh vlan_tagged.pcap