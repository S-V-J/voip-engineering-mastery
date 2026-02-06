# Quality of Service (QoS) for VoIP - Theory Deep Dive
**Study Date:** February 5, 2026
**Duration:** 90-120 minutes
**Objective:** Master QoS concepts, DSCP, and traffic prioritization

---

## Part 1: Why QoS is Critical for VoIP (20 minutes)

### The VoIP Quality Problem

**Voice Requirements:**
- **Latency:** <150ms one-way (ITU-T G.114 recommendation)
- **Jitter:** <30ms variation in packet arrival time
- **Packet Loss:** <1% acceptable for good quality
- **Bandwidth:** 64-100 Kbps per call (G.711 codec)

**What Happens Without QoS:**
```
Normal Network (No QoS):
┌─────────────────────────────────────────┐
│ All traffic treated equally             │
│ Voice competes with:                    │
│  - Large file downloads                 │
│  - Video streaming                      │
│  - Database queries                     │
│  - Email attachments                    │
│                                         │
│ Result: Voice packets delayed/dropped  │
│ User Experience: Choppy, robotic voice │
└─────────────────────────────────────────┘
```

**With QoS Enabled:**
```
QoS-Enabled Network:
┌─────────────────────────────────────────┐
│ Priority Queue 1 (Highest):             │
│  ├─ Voice packets (RTP) ──> EF (46)     │
│  └─ Sent first, never delayed           │
│                                         │
│ Priority Queue 2 (Medium):              │
│  ├─ SIP signaling ──> AF41 (34)         │
│  └─ Video conferencing                  │
│                                         │
│ Priority Queue 3 (Low):                 │
│  └─ Data traffic (best effort)          │
│                                         │
│ Result: Voice quality preserved         │
└─────────────────────────────────────────┘
```

---

## Part 2: Layer 2 vs Layer 3 QoS (30 minutes)

### QoS Operates at Two Layers

```
┌─────────────────────────────────────────────────┐
│ Layer 3 (IP Header)                             │
│ ┌─────────────┐                                 │
│ │ DSCP (6 bits│ ──> Layer 3 QoS marking         │
│ └─────────────┘                                 │
│   Values: 0-63                                  │
│   VoIP: EF (46), AF41 (34)                      │
└─────────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────┐
│ Layer 2 (802.1Q Tag)                            │
│ ┌──────────────┐                                │
│ │ PCP (3 bits) │ ──> Layer 2 QoS marking (CoS)  │
│ └──────────────┘                                │
│   Values: 0-7                                   │
│   VoIP: PCP 5                                   │
└─────────────────────────────────────────────────┘
```

### Layer 2 QoS: CoS (Class of Service)

**Location:** 802.1Q VLAN tag (PCP field)
**Scope:** Works only within local LAN (switch-to-switch)
**Limitation:** Removed when packet leaves LAN

| PCP Value | CoS Name | Traffic Type | VoIP Usage |
|-----------|----------|--------------|------------|
| 0 | Best Effort | Normal data | No |
| 1 | Background | Bulk transfers | No |
| 2 | Excellent Effort | Business data | No |
| 3 | Critical Apps | Streaming video | No |
| 4 | Video | Video conferencing | Sometimes |
| **5** | **Voice** | **VoIP RTP** | **YES** |
| 6 | Internetwork Control | Routing protocols | No |
| 7 | Network Control | Highest priority | No |

**How to Set CoS:**
```bash
# Using vconfig (Layer 2)
sudo vconfig set_egress_map eth0.10 0 5  # Map priority 0 to CoS 5

# Or in switch configuration (Cisco):
switchport voice vlan 10
mls qos trust cos
```

---

### Layer 3 QoS: DSCP (Differentiated Services Code Point)

**Location:** IP header ToS (Type of Service) field
**Scope:** Works end-to-end across routers
**Advantage:** Preserved across network boundaries

**IP Header Structure:**
```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
├─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┤
│Ver│  IHL  │      DSCP     │ECN│         Total Length          │
└───┴───────┴───────────────┴───┴───────────────────────────────┘
              6 bits        2 bits

DSCP replaces old ToS/Precedence field
Values: 0-63 (2^6 = 64 possible values)
```

---

## Part 3: DSCP Values for VoIP (45 minutes)

### DSCP Classification System

**DSCP is organized into classes:**

1. **Default Forwarding (DF):** DSCP 0 (Best Effort)
2. **Class Selector (CS):** CS0-CS7 (backward compatible)
3. **Assured Forwarding (AF):** AF11-AF43 (12 classes)
4. **Expedited Forwarding (EF):** DSCP 46 (Lowest latency)

---

### VoIP DSCP Values (MEMORIZE THESE!)

| Traffic Type | DSCP Name | Decimal | Binary | Hex | Use Case |
|--------------|-----------|---------|--------|-----|----------|
| **RTP (Voice)** | **EF** | **46** | **101110** | **0x2E** | Real-time voice media |
| **SIP Signaling** | **AF41** | **34** | **100010** | **0x22** | Call setup/teardown |
| **SIP Signaling** | **CS3** | **24** | **011000** | **0x18** | Alternative marking |
| **Video** | **AF41** | **34** | **100010** | **0x22** | Video conferencing |
| **Data** | **CS0/DF** | **0** | **000000** | **0x00** | Best effort |

---

### DSCP EF (Expedited Forwarding) - DSCP 46

**Why DSCP 46 for Voice?**
- **Highest priority** for low-latency traffic
- Routers give **immediate forwarding**
- **Minimal queuing delay**
- **Reserved bandwidth** (strict priority queue)

**Binary Breakdown:**
```
DSCP 46 = 101110 binary

Breaking it down:
101110
└─────┘
  46 in decimal

In IP header ToS field:
10111000 (DSCP 46 + ECN 00)
= 0xB8 hex
```

**How EF Works:**
```
Router Behavior with EF:

Incoming Packets:
┌─────────────────────────────────┐
│ Packet 1: Data (DSCP 0)         │ ──> Queue 3 (Low priority)
│ Packet 2: Voice (DSCP 46 = EF)  │ ──> Queue 1 (URGENT!)
│ Packet 3: Video (DSCP 34)       │ ──> Queue 2 (Medium)
│ Packet 4: Data (DSCP 0)         │ ──> Queue 3 (Low priority)
│ Packet 5: Voice (DSCP 46 = EF)  │ ──> Queue 1 (URGENT!)
└─────────────────────────────────┘

Forwarding Order:
1. Packet 2 (Voice) ──> Sent first
2. Packet 5 (Voice) ──> Sent second
3. Packet 3 (Video) ──> Sent third
4. Packet 1 (Data)  ──> Sent fourth
5. Packet 4 (Data)  ──> Sent last

Result: Voice experiences <1ms queuing delay!
```

---

### DSCP AF41 (Assured Forwarding) - DSCP 34

**Why DSCP 34 for SIP Signaling?**
- **High priority** but not as urgent as voice media
- Signaling happens before call (tolerate slight delay)
- **Assured bandwidth** but can share queue

**Binary Breakdown:**
```
DSCP 34 = 100010 binary

Breaking it down:
100010
└─────┘
  34 in decimal

AF41 notation:
AF = Assured Forwarding
4 = Class 4 (high priority)
1 = Low drop probability

In IP header ToS field:
10001000 (DSCP 34 + ECN 00)
= 0x88 hex
```

---

### Assured Forwarding (AF) Classes

**AF Classes Format:** AFxy
- **x (Class):** 1-4 (priority level, 4 = highest)
- **y (Drop Probability):** 1-3 (1 = low, 3 = high drop)

| DSCP Name | Decimal | Binary | Use Case |
|-----------|---------|--------|----------|
| AF11 | 10 | 001010 | Low priority, low drop |
| AF12 | 12 | 001100 | Low priority, medium drop |
| AF13 | 14 | 001110 | Low priority, high drop |
| AF21 | 18 | 010010 | Medium-low priority |
| AF31 | 26 | 011010 | Medium-high priority |
| **AF41** | **34** | **100010** | **High priority (SIP)** |
| AF42 | 36 | 100100 | High priority, medium drop |
| AF43 | 38 | 100110 | High priority, high drop |

**For VoIP:** Use AF41 (DSCP 34) for SIP signaling

---

## Part 4: CoS vs DSCP Comparison (15 minutes)

| Feature | CoS (Layer 2) | DSCP (Layer 3) |
|---------|---------------|----------------|
| **Location** | 802.1Q VLAN tag (PCP) | IP header ToS field |
| **Bits** | 3 bits (0-7) | 6 bits (0-63) |
| **Scope** | Local LAN only | End-to-end (across routers) |
| **Preserved?** | No (removed outside LAN) | Yes (stays in IP header) |
| **VoIP Value** | PCP 5 | DSCP 46 (EF) |
| **When to Use** | Switch-to-switch | Router-to-router, WAN |
| **Configuration** | Switch configuration | iptables, router ACLs |

**Real-World Scenario:**
```
[IP Phone] ──(CoS 5)──> [Switch] ──(DSCP 46)──> [Router] ──> [Internet] ──> [PSTN]
    ↑                      ↑                       ↑
  Layer 2              Translates               Layer 3
  CoS marking         CoS→DSCP                 DSCP preserved
                                              across WAN
```

**Key Insight:** Use BOTH!
- **CoS (PCP 5)** for local LAN priority
- **DSCP (EF 46)** for end-to-end WAN priority
- Switches translate between them: `mls qos trust dscp`

---

## Part 5: Linux QoS Implementation Methods (20 minutes)

### Method 1: iptables DSCP Marking

**Advantages:**
- Simple syntax
- Matches on ports, protocols, interfaces
- Works at packet level

**Syntax:**
```bash
# Mark packets with DSCP value
iptables -t mangle -A OUTPUT -p udp --dport 5060 -j DSCP --set-dscp 34

# Components:
-t mangle        # Use mangle table (for packet modification)
-A OUTPUT        # Append to OUTPUT chain
-p udp           # Match UDP protocol
--dport 5060     # Match destination port 5060 (SIP)
-j DSCP          # Jump to DSCP target
--set-dscp 34    # Set DSCP to 34 (AF41)
```

**Example: Complete VoIP Marking:**
```bash
# Clear existing rules
iptables -t mangle -F

# Mark SIP signaling (AF41)
iptables -t mangle -A OUTPUT -p udp --dport 5060 -j DSCP --set-dscp 34
iptables -t mangle -A OUTPUT -p tcp --dport 5060 -j DSCP --set-dscp 34
iptables -t mangle -A OUTPUT -p tcp --dport 5061 -j DSCP --set-dscp 34  # TLS

# Mark RTP media (EF)
iptables -t mangle -A OUTPUT -p udp --dport 10000:20000 -j DSCP --set-dscp 46

# Mark all Voice VLAN traffic (EF)
iptables -t mangle -A OUTPUT -o eth0.10 -j DSCP --set-dscp 46

# Verify
iptables -t mangle -L OUTPUT -n -v
```

---

### Method 2: tc (Traffic Control) - Priority Queuing

**Advantages:**
- Bandwidth reservation
- Strict priority scheduling
- Rate limiting

**What is tc?**
- Linux kernel traffic control utility
- Creates multiple queues with different priorities
- Assigns packets to queues based on DSCP/port/etc.

**Key Concepts:**

**1. qdisc (Queuing Discipline):**
- Controls how packets are queued
- Examples: PRIO, HTB, FQ_CODEL

**2. class:**
- Different traffic categories
- Each class has bandwidth allocation

**3. filter:**
- Rules to assign packets to classes
- Based on DSCP, port, source IP, etc.

**Basic tc Example:**
```bash
# Create root qdisc (HTB = Hierarchical Token Bucket)
tc qdisc add dev eth0 root handle 1: htb default 30

# Create classes (traffic categories)
tc class add dev eth0 parent 1: classid 1:1 htb rate 10mbit    # Total bandwidth
tc class add dev eth0 parent 1:1 classid 1:10 htb rate 5mbit   # Voice: 5 Mbps
tc class add dev eth0 parent 1:1 classid 1:20 htb rate 3mbit   # Video: 3 Mbps
tc class add dev eth0 parent 1:1 classid 1:30 htb rate 2mbit   # Data: 2 Mbps

# Create filters (assign packets to classes)
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 \
    match ip dsfield 0xb8 0xff flowid 1:10  # DSCP 46 (EF) → Voice class

tc filter add dev eth0 protocol ip parent 1:0 prio 2 u32 \
    match ip dsfield 0x88 0xff flowid 1:20  # DSCP 34 (AF41) → Video class
```

**Explanation:**
- `0xb8` = DSCP 46 (EF) in ToS field
- `0xff` = Bitmask to match entire ToS byte
- `flowid 1:10` = Send to class 1:10 (voice)

---

## Part 6: DSCP Hex Conversions (MUST MASTER!)

### Convert DSCP Decimal to Hex

**Formula:** DSCP value × 4 = ToS byte value

**Why × 4?**
- DSCP uses upper 6 bits of ToS byte
- Last 2 bits are ECN (always 00 for our purposes)
- Shifting left 2 bits = multiplying by 4

**Examples:**

**EF (46):**
```
DSCP 46 decimal = 101110 binary

Step 1: Add ECN bits (00)
101110 + 00 = 10111000

Step 2: Convert to hex
10111000 = 0xB8

Quick calculation:
46 × 4 = 184 decimal = 0xB8 hex
```

**AF41 (34):**
```
DSCP 34 decimal = 100010 binary

Step 1: Add ECN bits (00)
100010 + 00 = 10001000

Step 2: Convert to hex
10001000 = 0x88

Quick calculation:
34 × 4 = 136 decimal = 0x88 hex
```

**Quick Reference Table:**

| DSCP Name | Decimal | × 4 | Hex (ToS) | Binary |
|-----------|---------|-----|-----------|--------|
| CS0 (Default) | 0 | 0 | 0x00 | 00000000 |
| CS1 | 8 | 32 | 0x20 | 00100000 |
| AF41 | 34 | 136 | 0x88 | 10001000 |
| EF | 46 | 184 | 0xB8 | 10111000 |

---

## Part 7: QoS Policies and Best Practices

### Enterprise VoIP QoS Policy

**Recommended Markings:**
```
┌────────────────────────────────────────────┐
│ Traffic Type    │ Layer 2 │ Layer 3        │
├────────────────────────────────────────────┤
│ Voice (RTP)     │ CoS 5   │ DSCP EF (46)   │
│ SIP Signaling   │ CoS 3   │ DSCP AF41 (34) │
│ Video           │ CoS 4   │ DSCP AF41 (34) │
│ Critical Data   │ CoS 2   │ DSCP AF21 (18) │
│ Best Effort     │ CoS 0   │ DSCP 0         │
└────────────────────────────────────────────┘
```

### Bandwidth Reservation Guidelines

**Calculate Voice Bandwidth:**
```
Per call bandwidth:
- Codec: G.711 = 64 Kbps
- RTP overhead: 12 bytes
- UDP overhead: 8 bytes
- IP overhead: 20 bytes
- Ethernet overhead: 18 bytes

Total per call: ~87 Kbps

For 50 concurrent calls:
50 × 87 Kbps = 4.35 Mbps

Reserve: 5 Mbps for voice VLAN (with headroom)
```

---

## Study Exercises

### Exercise 1: DSCP Conversion
Convert these DSCP values to hex:
1. DSCP 24 (CS3) = _____ hex
2. DSCP 26 (AF31) = _____ hex
3. DSCP 10 (AF11) = _____ hex

### Exercise 2: Identify Traffic Type
Given these hex ToS values, identify the traffic:
1. 0xB8 = DSCP _____ = _____ traffic
2. 0x88 = DSCP _____ = _____ traffic
3. 0x00 = DSCP _____ = _____ traffic

### Exercise 3: QoS Design
Design QoS policy for:
- 100 concurrent VoIP calls
- 20 video conference streams
- 500 data users
- Total link: 100 Mbps

Calculate bandwidth allocation:
- Voice: _____ Mbps
- Video: _____ Mbps
- Data: _____ Mbps

---

## Study Checklist

- [ ] Understand why QoS is critical for VoIP
- [ ] Know the difference between CoS (Layer 2) and DSCP (Layer 3)
- [ ] Memorize: PCP 5 for voice, DSCP 46 (EF) for RTP
- [ ] Memorize: DSCP 34 (AF41) for SIP signaling
- [ ] Can convert DSCP decimal to hex (multiply by 4)
- [ ] Understand iptables DSCP marking syntax
- [ ] Know basics of tc (traffic control)
- [ ] Can calculate bandwidth requirements for VoIP

**Study Time:** Record actual time: _____ hours

**Next:** Hands-on tc implementation tomorrow!