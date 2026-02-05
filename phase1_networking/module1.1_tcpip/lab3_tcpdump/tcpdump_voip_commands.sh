#!/bin/bash
# VoIP-Focused tcpdump Commands

echo "═══════════════════════════════════════════════════════════"
echo "TCPDUMP COMMANDS FOR VoIP ANALYSIS"
echo "═══════════════════════════════════════════════════════════"

# 1. Capture SIP traffic (port 5060)
echo -e "\n1. Capture SIP signaling:"
echo "sudo tcpdump -i any -n -s 0 -w sip_capture.pcap 'port 5060'"

# 2. Capture RTP media (ports 10000-20000)
echo -e "\n2. Capture RTP media streams:"
echo "sudo tcpdump -i any -n -s 0 -w rtp_capture.pcap 'udp portrange 10000-20000'"

# 3. Capture both SIP and RTP
echo -e "\n3. Capture complete VoIP call (SIP + RTP):"
echo "sudo tcpdump -i any -n -s 0 -w voip_complete.pcap 'port 5060 or (udp portrange 10000-20000)'"

# 4. Capture from specific IP
echo -e "\n4. Capture VoIP traffic from specific IP phone:"
echo "sudo tcpdump -i any -n -s 0 -w phone_traffic.pcap 'host 192.168.1.100 and (port 5060 or udp portrange 10000-20000)'"

# 5. Read and filter capture
echo -e "\n5. Read capture and show only INVITE messages:"
echo "tcpdump -r sip_capture.pcap -A | grep -i INVITE"

# 6. Count packets by type
echo -e "\n6. Count SIP methods in capture:"
echo "tcpdump -r sip_capture.pcap -n | grep -oP '(INVITE|REGISTER|BYE|ACK|CANCEL)' | sort | uniq -c"

# 7. Extract SIP headers
echo -e "\n7. Show SIP Call-IDs:"
echo "tcpdump -r sip_capture.pcap -A | grep -i 'Call-ID:'"

# 8. Capture with timestamp
echo -e "\n8. Capture with microsecond timestamps:"
echo "sudo tcpdump -i any -n -tttt -s 0 -w timestamped.pcap 'port 5060'"

# 9. Real-time monitoring
echo -e "\n9. Monitor SIP traffic in real-time (no file):"
echo "sudo tcpdump -i any -n -A 'port 5060'"

# 10. Rotating capture files
echo -e "\n10. Capture with file rotation (100MB files):"
echo "sudo tcpdump -i any -n -s 0 -w voip-%Y%m%d-%H%M%S.pcap -C 100 'port 5060'"

