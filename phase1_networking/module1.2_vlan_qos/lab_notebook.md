# Phase 1, Module 1.2 Lab Notebook
**Module:** VLAN Configuration and QoS
**Started:** February 4, 2026, 11:11 PM EST

---

## Lab 1.2.1: VLAN Fundamentals & 802.1Q Theory
**Objective:** Understand VLAN tagging and voice/data separation
**Status:** 🔄 Starting Now
**Date:** Feb 4, 2026

### Commands Used
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
```

### Observations
- 802.1Q adds 4-byte VLAN tag to Ethernet frame
- Voice VLAN 10 for IP phones, Data VLAN 20 for PCs
- 

### Questions & Challenges
- How does WSL handle VLAN tagging?
- Can I test with virtual interfaces?

---

## Lab 1.2.2: Linux VLAN Configuration
**Status:** ⏳ Pending
**Objective:** Configure persistent VLAN interfaces

---

## Lab 1.2.3: QoS and DSCP Marking
**Status:** ⏳ Pending
**Objective:** Implement priority queuing for voice traffic

---

## Lab 1.2.4: Testing and Verification
**Status:** ⏳ Pending
**Objective:** Verify VLAN isolation and QoS effectiveness
