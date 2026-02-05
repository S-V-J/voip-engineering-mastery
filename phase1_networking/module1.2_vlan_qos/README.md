# Module 1.2: VLAN Configuration & QoS for VoIP

**Duration:** 60 hours (2 weeks)
**Objective:** Master VLAN segmentation and Quality of Service for voice networks

## Module Overview

### What You'll Learn
1. **802.1Q VLAN Tagging**
   - Ethernet frame structure with VLAN tag
   - TPID, PCP, DEI, VID fields
   - Access vs trunk port configuration

2. **Voice/Data Separation**
   - Why separate VLANs for voice and data
   - IP addressing schemes (VLAN 10: 192.168.10.0/24, VLAN 20: 192.168.20.0/24)
   - Inter-VLAN routing setup

3. **QoS Implementation**
   - DSCP marking (EF=46 for RTP, AF41=34 for SIP)
   - Layer 2 CoS/PCP priority (5 for voice)
   - Traffic prioritization with Linux tc

4. **Testing & Verification**
   - Packet capture of tagged frames
   - QoS effectiveness measurement
   - VLAN isolation testing

## Lab Structure

```
module1.2_vlan_qos/
├── lab1_vlan_basics/        # Theory and design
├── lab2_linux_vlans/         # Configuration commands
├── lab3_qos_implementation/  # DSCP and priority queuing
├── lab4_testing/             # Verification and testing
├── lab_notebook.md           # Your working notes
├── module_checklist.md       # Progress tracking
└── README.md                 # This file
```

## Prerequisites
- Module 1.1 TCP/IP completed ✓
- Ubuntu 22.04 WSL2
- VLAN tools: vlan, bridge-utils, iproute2
- Root/sudo access

## Expected Outcomes
By completing this module, you will:
- Configure production-ready VLAN infrastructure
- Implement enterprise-grade QoS for VoIP
- Troubleshoot VLAN and QoS issues
- Design multi-VLAN network topologies

## Time Allocation
- Week 1: VLAN fundamentals and configuration (30 hours)
- Week 2: QoS implementation and testing (30 hours)

## Next Steps
1. Install required tools (see below)
2. Review VLAN theory content
3. Complete hands-on labs in sequence
4. Document all configurations
5. Pass module assessment