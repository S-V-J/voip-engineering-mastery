#!/bin/bash

echo "=== Verifying DSCP Marking ==="

# Capture packets to check DSCP values
echo "Capturing 20 seconds of traffic..."
sudo timeout 20 tcpdump -i any -v -n -w dscp_test.pcap 'udp port 5060 or udp portrange 10000-20000' &
TCPDUMP_PID=$!

sleep 2

# Generate test traffic (simulate SIP)
echo "Generating SIP-like traffic on port 5060..."
nc -u 8.8.8.8 5060 <<< "TEST SIP PACKET" &

sleep 3
sudo kill $TCPDUMP_PID 2>/dev/null
wait 2>/dev/null

# Analyze DSCP values
echo -e "\n=== Analyzing DSCP Values ==="
echo "Looking for DSCP markings in captured traffic..."
sudo tcpdump -r dscp_test.pcap -v -n | grep -i "tos\|dscp" | head -10

# Extract DSCP values using tshark if available
if command -v tshark &>/dev/null; then
    echo -e "\n=== DSCP Statistics (tshark) ==="
    sudo tshark -r dscp_test.pcap -T fields -e ip.dsfield.dscp -e ip.src -e ip.dst -e udp.port | head -10
fi

ls -lh dscp_test.pcap