# Phase 1, Module 1.2 Lab Notebook
**Module:** VLAN Configuration and QoS
**Started:** February 4, 2026, 11:11 PM EST
**Last Updated:** February 5, 2026, 7:46 PM EST

---

## Lab 1.2.1: VLAN Fundamentals & 802.1Q Theory
**Objective:** Understand VLAN tagging and voice/data separation
**Status:** 🔄 IN PROGRESS
**Started:** Feb 4, 2026
**Theory Study:** Feb 5, 2026

### Session 1: Initial Setup (Feb 4, 11:11 PM - 11:41 PM)

#### Commands Used
```bash
# VLAN interface creation
sudo ip link add link eth0 name eth0.10 type vlan id 10
sudo ip link add link eth0 name eth0.20 type vlan id 20

# IP address assignment
sudo ip addr add 192.168.10.1/24 dev eth0.10
sudo ip addr add 192.168.20.1/24 dev eth0.20

# Bring interfaces up
sudo ip link set dev eth0.10 up
sudo ip link set dev eth0.20 up

# Verify configuration
ip -d link show eth0.10
ip -d link show eth0.20

# Check routing
ip route show | grep -E "(10|20)"
```

#### Observations
- 802.1Q adds 4-byte VLAN tag to Ethernet frame
- Voice VLAN 10 for IP phones, Data VLAN 20 for PCs
- Both interfaces created successfully with UP state
- Routing table automatically populated with both subnets

#### Questions & Challenges
❓ How does WSL handle VLAN tagging?
✅ **Answered:** WSL2 abstracts VLAN tagging in kernel space

❓ Can I test with virtual interfaces?
✅ **Answered:** Yes, but 802.1Q frames not visible on wire in WSL

---

### Session 2: 802.1Q Theory Study (Feb 5, 2026, Evening)

**Study Material:** 802.1Q_study_guide.md
**Duration:** [TO BE RECORDED]
**Start Time:** [RECORD WHEN YOU START]
**End Time:** [RECORD WHEN YOU FINISH]

#### Study Notes Section

**802.1Q Tag Structure (4 bytes):**
```
┌────────────────┬─────────┬─────┬─────────────────────┐
│ TPID (16 bits) │ PCP (3) │ DEI │  VLAN ID (12 bits)  │
│     0x8100     │  0-7    │ 0/1 │      1-4094         │
└────────────────┴─────────┴─────┴─────────────────────┘
```

**My Understanding:**
[Write your understanding of each field here after studying]

**TPID (Tag Protocol Identifier):**
- 

**PCP (Priority Code Point):**
- 

**DEI (Drop Eligible Indicator):**
- 

**VLAN ID (VID):**
- 

---

**Exercise Solutions:**

**Exercise 1: Calculate TCI Value**
Given: VLAN 20, Priority 0, DEI 0

My calculations:
1. VLAN 20 in 12-bit binary: _______________
2. PCP 0 in 3-bit binary: _______________
3. DEI: _______________
4. TCI in hex: _______________

My work:
[Show your calculation steps here]

---

**Exercise 2: Decode TCI**
Given TCI: 0xA014

My answers:
1. VLAN ID: _______________
2. Priority: _______________
3. DEI set?: _______________
4. Traffic type: _______________

My reasoning:
[Explain how you decoded each value]

---

**Key Insights from 802.1Q Study:**
1. 
2. 
3. 
4. 
5. 

**Concepts I Need to Review:**
- 
- 

**Concepts I've Mastered:**
✅ 
✅ 

---

## Lab 1.2.2: Linux VLAN Configuration
**Status:** ✅ PARTIALLY COMPLETE (Scripts created, testing done)
**Objective:** Configure persistent VLAN interfaces

### Completed Tasks (Feb 4)
✅ Created create_vlans.sh script
✅ Created verify_vlans.sh script
✅ Created capture_vlan_tags.sh script
✅ Created enable_routing.sh script
✅ Tested all scripts successfully

### Observations from Testing

**VLAN Configuration Success:**
- Both VLAN interfaces show `vlan protocol 802.1Q` in detailed output
- Interface state: UP and operational
- Routing table correctly populated with both subnets
- Ping tests to gateway IPs: 0% packet loss

**VLAN Tag Capture Challenge:**
- tcpdump filter 'vlan' captured 0 packets
- **Reason:** WSL2 virtual networking doesn't emit actual 802.1Q frames on wire
- VLAN tagging happens in kernel space only
- **Learning:** This is a WSL limitation, not a configuration error
- **Real hardware:** Would show actual 802.1Q tagged frames with TPID 0x8100

**Verification Results:**
```bash
✅ eth0.10 (Voice VLAN 10) exists
✅ eth0.20 (Data VLAN 20) exists

Detailed output showed:
- vlan protocol 802.1Q id 10
- vlan protocol 802.1Q id 20

Ping results:
- Voice VLAN: 3 packets transmitted, 3 received, 0% packet loss
- Data VLAN: 3 packets transmitted, 3 received, 0% packet loss
```

---

## Lab 1.2.3: QoS and DSCP Marking
**Status:** 🔄 THEORY TONIGHT, PRACTICE TOMORROW
**Objective:** Implement priority queuing for voice traffic

### DSCP Configuration Completed (Feb 4)

**DSCP Marking Configuration:**
- Successfully created 7 iptables mangle rules
- SIP (port 5060): DSCP 0x22 (34 decimal = AF41) ✅
- RTP (ports 10000-20000): DSCP 0x2e (46 decimal = EF) ✅
- Voice VLAN: DSCP 0x2e for all traffic ✅

**Commands Used:**
```bash
# Mark SIP traffic with DSCP AF41 (34)
sudo iptables -t mangle -A OUTPUT -p udp --dport 5060 -j DSCP --set-dscp 34
sudo iptables -t mangle -A OUTPUT -p udp --sport 5060 -j DSCP --set-dscp 34

# Mark RTP traffic with DSCP EF (46)
sudo iptables -t mangle -A OUTPUT -p udp --dport 10000:20000 -j DSCP --set-dscp 46
sudo iptables -t mangle -A OUTPUT -p udp --sport 10000:20000 -j DSCP --set-dscp 46

# Mark all Voice VLAN traffic with DSCP EF
sudo iptables -t mangle -A OUTPUT -o eth0.10 -j DSCP --set-dscp 46

# Verify rules
sudo iptables -t mangle -L OUTPUT -n -v --line-numbers
```

**Results:**
```
Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 DSCP       udp  --  *      *       0.0.0.0/0            0.0.0.0/0            udp dpt:5060 DSCP set 0x22
2        0     0 DSCP       udp  --  *      *       0.0.0.0/0            0.0.0.0/0            udp spt:5060 DSCP set 0x22
[... additional rules ...]
7        0     0 DSCP       all  --  *      eth0.10  0.0.0.0/0            0.0.0.0/0            DSCP set 0x2e
```

### QoS Theory Study (Tonight - Feb 5)

**To Study:**
- [ ] DSCP vs CoS comparison
- [ ] Layer 2 vs Layer 3 QoS
- [ ] Priority queuing mechanisms
- [ ] Linux tc (traffic control) overview
- [ ] HTB (Hierarchical Token Bucket) queuing
- [ ] PRIO (Priority) queueing

**Notes from QoS Study:**
[Fill in after studying QoS theory guide]

**Key QoS Concepts:**
1. 
2. 
3. 

---

## Lab 1.2.4: Testing and Verification
**Status:** ⏳ Pending
**Objective:** Verify VLAN isolation and QoS effectiveness
**Planned:** After completing theory and tc implementation

---

## Inter-VLAN Routing Testing (Feb 4)

**IP Forwarding Status:**
- Enabled successfully: `net.ipv4.ip_forward = 1`
- Made persistent in /etc/sysctl.conf
- Required for routing between VLANs

**Inter-VLAN Routing Test:**
```bash
ping -c 3 -I eth0.10 192.168.20.1
```

**Result:**
```
From 192.168.10.1 icmp_seq=1 Destination Host Unreachable
From 192.168.10.1 icmp_seq=2 Destination Host Unreachable
From 192.168.10.1 icmp_seq=3 Destination Host Unreachable

--- 192.168.20.1 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss
```

**Analysis:**
- **Expected Behavior:** ✅ This is normal in WSL!
- **Reason:** Both VLANs are local interfaces on same host
- No actual network devices exist in other subnet to respond to ARP
- **Learning:** True inter-VLAN routing needs separate segments
- **Solution for testing:** Would need network namespaces or VMs

---

## Technical Insights Summary

### 802.1Q in WSL
- VLAN interfaces configured correctly (verified via `ip -d link show`)
- Tag structure: TPID (0x8100) + PCP + DEI + VID
- WSL abstracts VLAN tagging in virtual environment
- Physical 802.1Q frames not visible on wire

### DSCP Hexadecimal Values
- AF41 (34 decimal) = 0x22 hex
- EF (46 decimal) = 0x2e hex
- Verified in iptables mangle table output

### IP Forwarding
- Enabled successfully: `net.ipv4.ip_forward = 1`
- Made persistent in /etc/sysctl.conf
- Required for routing between VLANs (even if test failed in WSL)

---

## Questions Log

### Resolved Questions ✅
❓ **Q:** Why didn't tcpdump capture VLAN tags?  
✅ **A:** WSL2 virtual networking doesn't generate physical 802.1Q frames. Tagging is abstracted in kernel.

❓ **Q:** Why did inter-VLAN routing ping fail?  
✅ **A:** Both VLANs are local interfaces. No actual network devices exist in other subnet to respond to ARP.

❓ **Q:** What are the DSCP hex values for VoIP?  
✅ **A:** SIP signaling = 0x22 (AF41), RTP media = 0x2e (EF)

### Open Questions ❓
[Add new questions as they arise during tonight's study]

---

## Session Time Tracking

| Date | Session | Activity | Duration | Cumulative |
|------|---------|----------|----------|------------|
| Feb 4 | 1 | Environment setup & configuration | 0.5h | 0.5h |
| Feb 5 | 2 | 802.1Q theory study | [TBD] | [TBD] |
| Feb 5 | 2 | QoS theory study | [TBD] | [TBD] |

**Module 1.2 Total:** _____ / 60 hours

---

## Tonight's Study Checklist (Feb 5, 2026)

### 802.1Q Study (90 minutes)
- [ ] Read entire 802.1Q_study_guide.md
- [ ] Complete Exercise 1 (Calculate TCI)
- [ ] Complete Exercise 2 (Decode TCI)
- [ ] Fill in "My Understanding" sections above
- [ ] List 5 key insights from study
- [ ] Identify concepts needing review

### QoS Theory Study (90 minutes)
- [ ] Read QoS_theory_guide.md (to be created)
- [ ] Understand DSCP vs CoS
- [ ] Learn Layer 2 vs Layer 3 QoS
- [ ] Study Linux tc command overview
- [ ] Document key concepts

### Documentation (30 minutes)
- [ ] Update this lab notebook with tonight's learnings
- [ ] Record actual study time
- [ ] Update progress tracker
- [ ] Git commit all changes
- [ ] Push to GitHub

**Start Time:** ___:___ PM
**End Time:** ___:___ PM
**Total Time Tonight:** _____ hours

---

## Next Session Preview (Feb 6, 2026)

**Focus:** Hands-on Linux tc (traffic control) implementation

**Goals:**
- Create priority queues for voice/data
- Implement HTB (Hierarchical Token Bucket) queueing
- Test bandwidth allocation
- Verify QoS effectiveness with iperf3
- Capture and analyze QoS-marked packets

**Preparation:**
- Tonight's theory study must be solid
- Review tc command syntax
- Prepare testing scenarios

---

## Git Commits

**Session 1 (Feb 4):**
```
d91e621 - Module 1.2 VLAN & QoS environment setup complete
```

**Session 2 (Feb 5 - Tonight):**
```
[PENDING] - 802.1Q and QoS theory study complete, lab notebook updated
```

---

## Personal Notes & Reflections

**What's Working Well:**
- Professional documentation habits
- Systematic approach to learning
- Understanding WSL limitations without frustration
- Git workflow is solid

**Areas for Improvement:**
- Need to spend more time on theory before jumping to practice
- Take more frequent breaks during study sessions
- Connect new concepts to previous modules more explicitly

**Motivation Check:**
🔥 Energy Level: High
🎯 Focus Level: Strong
💪 Confidence: Growing daily
📚 Understanding: Deepening with each session

**Remember:** You're not just learning commands—you're building expertise that will set you apart in interviews and on the job!