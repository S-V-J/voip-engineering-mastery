# VoIP Engineering Lab - Environment Setup Documentation
**Setup Date:** February 1, 2026, 5:43 AM EST
**System:** WSL2 Ubuntu 22.04.1 LTS (Jammy)
**Status:** ✅ COMPLETE AND VERIFIED

---

## 🖥️ System Information

### WSL Configuration
- **Kernel:** 6.6.87.2-microsoft-standard-WSL2
- **Distribution:** Ubuntu 22.04.1 LTS (Jammy)
- **Architecture:** x86_64 (64-bit)
- **Working Directory:** `/home/voiplearner/voip`
- **User:** voiplearner

### Network Configuration
```
Interface: eth0
IP Address: 172.21.113.117/20
Gateway: 172.21.112.1
Network: 172.21.112.0/20
MTU: 1492
MAC: 00:15:5d:29:c4:6e

DNS Server: 10.255.255.254
```

### Loopback Interface
```
Interface: lo
IP: 127.0.0.1/8
Additional IP: 10.255.255.254/32
```

---

## 📦 Installed Tools Verification

### Networking Tools
✅ **wireshark** - GUI packet analyzer
✅ **tcpdump** - Command-line packet capture
✅ **tshark** - Terminal-based Wireshark
✅ **nmap** - Network discovery and security auditing
✅ **netcat** - Network connection utility
✅ **ip** - Advanced network configuration
✅ **openssl** - Cryptography and SSL/TLS toolkit

### Additional Available Tools
✅ **curl** - HTTP client
✅ **ping** - ICMP echo testing
✅ **nslookup** - DNS query tool
✅ **ss** - Socket statistics

### Tools to Install (Phase-specific)
- strongswan (for VPN labs in Module 1.3)
- vlan utilities (for VLAN labs in Module 1.2)
- Additional SIP tools (Phase 2+)

---

## 📁 Directory Structure Created

```
/home/voiplearner/voip/
├── MASTER_PROGRESS_TRACKER.md
├── ENV_SETUP_COMPLETE.md (this file)
├── phase1_networking/
│   ├── module1.1_tcpip/
│   │   ├── lab1_wireshark/
│   │   │   ├── network_interfaces.txt
│   │   │   ├── routing_table.txt
│   │   │   ├── dns_config.txt
│   │   │   ├── active_connections.txt
│   │   │   └── first_capture.pcap ✅
│   │   ├── lab2_subnetting/
│   │   ├── lab3_tcpdump/
│   │   ├── lab4_protocols/
│   │   └── lab_notebook.md
│   ├── module1.2_vlan_qos/
│   └── module1.3_vpn_tls/
├── phase2_protocols/
├── phase3_kamailio/
├── phase4_enterprise/
├── phase5_diameter/
├── phase6_ims/
├── phase7_cpp/
├── phase8_database/
├── phase9_security/
└── phase10_capstone/
```

---

## 🔬 First Lab Completion: Packet Capture

### Lab 1.1.1: Network Traffic Analysis ✅

**Objective:** Capture and analyze network packets
**Status:** COMPLETED
**File:** `/home/voiplearner/voip/phase1_networking/module1.1_tcpip/lab1_wireshark/first_capture.pcap`
**Size:** 3.7 KB
**Packets Captured:** 32 packets

### Traffic Captured
1. **ICMP Echo Request/Reply** (ping to 8.8.8.8)
   - 5 requests, 5 replies
   - RTT: min=81.7ms, avg=88.8ms, max=99.1ms
   - 0% packet loss ✅

2. **DNS Queries** (UDP port 53)
   - google.com → 142.250.206.78
   - github.com → 20.207.73.82
   - example.com → 104.18.26.120, 104.18.27.120

3. **HTTP Connection** (TCP port 80)
   - Three-way handshake (SYN, SYN-ACK, ACK)
   - HTTP HEAD request to example.com
   - HTTP 200 OK response
   - Graceful connection termination (FIN)

### Network Observations
- **Latency to Google DNS:** ~88ms average (acceptable for India to US)
- **DNS Resolution:** Working correctly through 10.255.255.254
- **HTTP Connectivity:** Successful TCP connection and data transfer
- **No Packet Loss:** All ICMP packets received

---

## 🎓 Skills Verified

### Completed Tasks
✅ WSL navigation and Linux command line
✅ Network interface discovery (`ip addr show`, `ip route show`)
✅ DNS configuration analysis (`/etc/resolv.conf`)
✅ Active connection monitoring (`ss -tulpn`)
✅ Packet capture with `tcpdump`
✅ PCAP file creation and verification
✅ Basic packet analysis
✅ Traffic generation (ping, nslookup, curl)

### Command Proficiency Demonstrated
```bash
# Network Information
ip addr show
ip route show
ss -tulpn

# Packet Capture
sudo tcpdump -i any -w file.pcap 'filter'
sudo tcpdump -r file.pcap -n

# Traffic Generation
ping -c 5 8.8.8.8
nslookup domain.com
curl -I http://example.com

# File Operations
ls -lh
cat file.txt | tee output.txt
tree
```

---

## 🔍 System Services Detected

From `ss -tulpn` output:
- **DNS Service:** Port 53 (systemd-resolved)
- **PostgreSQL:** Port 5432, 5433 (local database)
- **Node.js Application:** Port 36641
- **HTTP Service:** Port 8001
- **Chronyd NTP:** Port 323 (time synchronization)

---

## 🌐 Network Connectivity Tests

### Successful Connections
✅ **Google DNS (8.8.8.8)** - 88ms latency
✅ **Google.com** - DNS resolution and ICMP
✅ **GitHub.com** - DNS resolution to 20.207.73.82
✅ **Example.com** - Full HTTP connection (TCP 3-way handshake)

### Internet Gateway
- Gateway IP: 172.21.112.1
- Route: Default via eth0
- NAT: Working (outbound connections successful)

---

## 📊 Packet Capture Analysis

### Protocol Distribution
```
Total Packets: 32
- ICMP: 10 packets (echo request/reply pairs)
- DNS (UDP 53): 10 packets (queries and responses)
- HTTP (TCP 80): 12 packets (connection setup, data, teardown)
```

### Traffic Direction
```
Outbound (Out): 11 packets
Inbound (In): 21 packets
```

### TCP Connection Analysis (HTTP to example.com)
1. **SYN** → Initial connection request
2. **SYN-ACK** ← Server accepts connection
3. **ACK** → Client confirms
4. **PSH** → Client sends HTTP HEAD request (76 bytes)
5. **ACK** ← Server acknowledges
6. **PSH** ← Server sends HTTP 200 response (274 bytes)
7. **ACK** → Client acknowledges
8. **FIN** → Client closes connection
9. **FIN** ← Server confirms close
10. **ACK** → Final acknowledgment

**Result:** Perfect TCP connection lifecycle demonstrated! ✅

---

## 🎯 Environment Readiness Checklist

### System Prerequisites
- [x] WSL2 installed and running
- [x] Ubuntu 22.04 LTS configured
- [x] Network connectivity verified
- [x] Internet access working
- [x] DNS resolution functional

### Tools and Utilities
- [x] tcpdump installed and working
- [x] Wireshark/tshark available
- [x] Network utilities (ip, ss, ping, nslookup)
- [x] Text editors (nano, vim)
- [x] File operations (tree, tee)

### Directory Structure
- [x] Main working directory created
- [x] Phase directories organized
- [x] Module subdirectories ready
- [x] Lab folders structured

### Documentation
- [x] Progress tracker initialized
- [x] Lab notebook created
- [x] Network configuration documented
- [x] First packet capture completed

---

## 🚀 Ready for Module 1.1: TCP/IP Deep Dive

Your environment is **100% ready** for VoIP engineering training!

### What's Working
✅ Packet capture and analysis
✅ Network connectivity
✅ DNS resolution
✅ TCP/UDP protocols
✅ Command-line proficiency

### Next Steps
1. Begin TCP/IP protocol deep dive
2. Learn UDP vs TCP for VoIP
3. Master Wireshark filtering
4. Complete subnetting exercises
5. Understand VoIP quality metrics

---

## 📌 Quick Reference Commands

### Daily Startup
```bash
cd /home/voiplearner/voip
pwd
ip addr show
```

### Packet Capture Template
```bash
# Capture for 60 seconds
sudo timeout 60 tcpdump -i any -w capture_$(date +%Y%m%d_%H%M%S).pcap 'your_filter'

# Read capture
sudo tcpdump -r capture_file.pcap -n

# Count packets by protocol
sudo tcpdump -r capture.pcap -n | awk '{print $5}' | cut -d: -f1 | sort | uniq -c
```

### Progress Tracking
```bash
# View progress
cat /home/voiplearner/voip/MASTER_PROGRESS_TRACKER.md

# Update lab notebook
cd phase1_networking/module1.1_tcpip
nano lab_notebook.md
```

---

## 🎓 Your Learning Journey Begins Here

**Total Training:** 1,600 hours across 10 phases
**Current Phase:** Phase 1 - Networking Fundamentals (180 hours)
**Current Module:** Module 1.1 - TCP/IP Protocol Stack (60 hours)
**Environment Status:** ✅ READY FOR TRAINING

**You are cleared for takeoff! 🚀**

---

**Documentation Created:** February 1, 2026
**Last Updated:** February 1, 2026
**Status:** Production-Ready Environment
**Next Action:** Begin Module 1.1 TCP/IP Learning Content