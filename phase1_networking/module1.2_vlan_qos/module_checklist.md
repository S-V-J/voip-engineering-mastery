# Module 1.2 Completion Checklist

## VLAN Concepts Mastered
- [ ] Explain 802.1Q tagging mechanism (4-byte tag: TPID + TCI)
- [ ] Differentiate access ports vs trunk ports
- [ ] Understand native VLAN concept and security implications
- [ ] Design voice/data VLAN separation strategy
- [ ] Configure inter-VLAN routing

## Linux VLAN Configuration
- [ ] Create VLAN interfaces (eth0.10, eth0.20)
- [ ] Assign IP addresses to VLANs
- [ ] Configure persistent VLAN settings with netplan
- [ ] Verify VLAN tagging with tcpdump -e
- [ ] Test VLAN isolation between subnets

## QoS Implementation
- [ ] Mark voice packets with DSCP EF (46)
- [ ] Configure CoS/PCP bits in 802.1Q tag (PCP 5)
- [ ] Set up priority queuing with tc
- [ ] Test bandwidth reservation with iperf3
- [ ] Measure QoS impact on latency (compare with/without)

## Practical Skills
- [ ] Capture and analyze 802.1Q tagged frames
- [ ] Read VLAN ID from packet capture
- [ ] Configure iptables DSCP marking rules
- [ ] Enable IP forwarding for inter-VLAN routing
- [ ] Troubleshoot VLAN misconfiguration

## Lab Exercises Completed
- [ ] Lab 1.2.1: VLAN theory and design (10 hours)
- [ ] Lab 1.2.2: Linux VLAN configuration (15 hours)
- [ ] Lab 1.2.3: QoS implementation (20 hours)
- [ ] Lab 1.2.4: Testing and verification (15 hours)

**Date Completed:** _______________
**Total Hours Spent:** _____ / 60 hours
**Ready for Module 1.3:** [ ] YES [ ] NEED REVIEW

**Self-Assessment Questions:**
1. Can you explain why VoIP uses VLAN 10 and data uses VLAN 20?
2. What is DSCP 46 (EF) and when is it used?
3. How do you verify VLAN tagging in a packet capture?
4. What's the difference between CoS and DSCP?