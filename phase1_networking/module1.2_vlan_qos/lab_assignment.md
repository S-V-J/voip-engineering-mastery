# Module 1.2 Lab Assignment
**Due:** Complete before moving to Module 1.3
**Objective:** Design and implement VLAN + QoS for VoIP

## Task 1: VLAN Configuration (15 points)
1. Create Voice VLAN 10 and Data VLAN 20
2. Assign appropriate IP addresses
3. Capture and analyze 802.1Q tagged frames
4. Submit: create_vlans.sh script and vlan_tagged.pcap

## Task 2: QoS Implementation (20 points)
1. Implement DSCP marking for SIP (AF41) and RTP (EF)
2. Configure iptables mangle rules
3. Verify DSCP values in packet capture
4. Submit: dscp_marking.sh and dscp_test.pcap

## Task 3: Inter-VLAN Routing (15 points)
1. Enable IP forwarding
2. Test connectivity between VLANs
3. Document routing table
4. Submit: enable_routing.sh and routing_test.txt

## Task 4: Network Design (20 points)
Design complete VLAN topology for:
- 200 IP phones
- 300 PCs
- 10 servers
- Include IP addressing, QoS, security rules
- Submit: network_design.txt with diagrams

## Task 5: Performance Testing (15 points)
1. Test VLAN isolation (ping should fail)
2. Measure QoS impact with iperf3
3. Capture and analyze performance
4. Submit: performance_results.txt

## Task 6: Troubleshooting Scenario (15 points)
**Problem:** Voice quality is poor, calls are choppy
- Use tcpdump to capture traffic
- Analyze jitter, packet loss, latency
- Identify root cause (missing QoS? Wrong VLAN?)
- Propose solution
- Submit: troubleshooting_report.txt

## Deliverables Checklist:
- [ ] create_vlans.sh (working script)
- [ ] vlan_tagged.pcap (with 802.1Q tags)
- [ ] dscp_marking.sh (iptables rules)
- [ ] dscp_test.pcap (showing DSCP values)
- [ ] enable_routing.sh (IP forwarding enabled)
- [ ] routing_test.txt (test results)
- [ ] network_design.txt (complete design)
- [ ] performance_results.txt (testing data)
- [ ] troubleshooting_report.txt (analysis)

## Grading Rubric:
- **90-100:** All tasks complete, excellent documentation
- **80-89:** Most tasks complete, good understanding
- **70-79:** Basic tasks complete, needs improvement
- **<70:** Incomplete, revisit concepts

## Submission:
Create a summary report showing:
- What you learned about VLANs
- How QoS improves VoIP quality
- Challenges faced and solutions
- Questions for next module

**Time Estimate:** 20-30 hours total