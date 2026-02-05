#!/bin/bash
echo "═══════════════════════════════════════════════════════════"
echo "VoIP QUALITY MEASUREMENT LAB"
echo "═══════════════════════════════════════════════════════════"
TARGET="8.8.8.8"  # Change to your SIP server IP

echo -e "\n1. LATENCY TEST (sending 50 packets)..."
echo "-------------------------------------------"
ping -c 50 $TARGET | tail -2

echo -e "\n2. PACKET LOSS TEST (sending 100 packets)..."
echo "----------------------------------------------"
LOSS=$(ping -c 100 $TARGET | grep "packet loss" | awk '{print $6}')
echo "Packet Loss: $LOSS"

if [[ "${LOSS%%%}" < 3 ]]; then
    echo "✓ PASS: Packet loss is acceptable for VoIP"
else
    echo "✗ FAIL: Packet loss is too high for good VoIP quality"
fi

echo -e "\n3. JITTER ESTIMATION..."
echo "------------------------"
JITTER=$(ping -c 50 $TARGET | grep "rtt" | awk -F'/' '{print $5}' | awk '{print $1}')
echo "Estimated Jitter (mdev): ${JITTER}ms"

if (( $(echo "$JITTER < 30" | bc -l) )); then
    echo "✓ PASS: Jitter is acceptable for VoIP"
else
    echo "✗ FAIL: Jitter is too high for good VoIP quality"
fi

echo -e "\n4. ONE-WAY LATENCY ESTIMATE..."
echo "--------------------------------"
RTT=$(ping -c 20 $TARGET | grep "rtt" | awk -F'/' '{print $5}' | awk '{print $1}')
ONE_WAY=$(echo "scale=2; $RTT / 2" | bc)
echo "Average RTT: ${RTT}ms"
echo "Estimated One-Way Latency: ${ONE_WAY}ms"

if (( $(echo "$ONE_WAY < 150" | bc -l) )); then
    echo "✓ PASS: Latency is acceptable for VoIP (ITU-T G.114)"
else
    echo "✗ FAIL: Latency is too high for good VoIP quality"
fi

echo -e "\n═══════════════════════════════════════════════════════════"
echo "QUALITY SUMMARY"
echo "═══════════════════════════════════════════════════════════"
echo "Target: $TARGET"
echo "Latency: ${ONE_WAY}ms (target: <150ms)"
echo "Jitter: ${JITTER}ms (target: <30ms)"
echo "Packet Loss: $LOSS (target: <1%)"
echo -e "\nExpected VoIP Quality: "
if (( $(echo "$ONE_WAY < 150 && $JITTER < 30" | bc -l) )); then
    echo "★★★★☆ GOOD - Suitable for production VoIP"
else
    echo "★★☆☆☆ FAIR - May experience quality issues"
fi

