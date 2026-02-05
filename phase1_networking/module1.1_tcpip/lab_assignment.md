# Module 1.1 Lab Assignment
**Objective:** Capture and analyze your own network traffic

## Task 1: Basic Packet Capture (20 minutes)
1. Capture 5 minutes of mixed traffic (DNS, ICMP, HTTP)
2. Save as assignment_capture.pcap
3. Count total packets
4. Identify protocol distribution

## Task 2: Subnetting Design (30 minutes)
Design subnet scheme for a company with:
- 300 IP phones
- 500 data devices
- 50 servers
- 10 SIP trunks

Starting network: 10.100.0.0/16

## Task 3: Quality Measurement (20 minutes)
1. Measure latency to 3 different public DNS servers
2. Calculate jitter for each
3. Test packet loss over 200 packets
4. Determine which would be best for VoIP

## Task 4: tcpdump Mastery (15 minutes)
Write tcpdump commands to:
1. Capture only SIP INVITE messages
2. Capture RTP from IP 192.168.1.100
3. Capture complete VoIP call (SIP+RTP)
4. Read capture and show only failed calls (4xx, 5xx)

## Deliverables:
- assignment_capture.pcap
- subnet_design.txt (with calculations)
- quality_measurements.txt (with results)
- tcpdump_commands.sh (with all commands)

## Submission:
Create a summary document showing:
- What you learned
- Challenges faced
- Commands that worked best
- Questions for next session

