#!/bin/bash
echo "═══════════════════════════════════════════════════════════"
echo "ICMP TROUBLESHOOTING FOR VoIP"
echo "═══════════════════════════════════════════════════════════"

# Test 1: Basic connectivity to SIP server
echo -e "\n1. Testing connectivity to SIP server:"
echo "Command: ping -c 5 8.8.8.8"
ping -c 5 8.8.8.8

# Test 2: Measure round-trip time (should be <150ms for good voice)
echo -e "\n2. Measuring RTT (should be <150ms for VoIP):"
ping -c 10 8.8.8.8 | tail -1

# Test 3: Check path MTU (important for avoiding fragmentation)
echo -e "\n3. Testing MTU (VoIP packets should not fragment):"
echo "Command: ping -M do -s 1472 8.8.8.8"
ping -M do -s 1472 -c 3 8.8.8.8

# Test 4: Traceroute to identify high-latency hops
echo -e "\n4. Trace route to identify delays:"
echo "Command: traceroute -n 8.8.8.8"
traceroute -n 8.8.8.8 | head -10

# Test 5: Continuous monitoring for packet loss
echo -e "\n5. Packet loss test (30 seconds):"
echo "Command: ping -c 30 8.8.8.8 | grep loss"
ping -c 30 8.8.8.8 | grep loss

