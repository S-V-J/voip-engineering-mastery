#!/bin/bash
echo "═══════════════════════════════════════════════════════════"
echo "DNS RESOLUTION FOR SIP SERVERS"
echo "═══════════════════════════════════════════════════════════"

# Standard A record lookup
echo -e "\n1. A Record Lookup:"
echo "Command: nslookup kamailio.org"
nslookup kamailio.org

# SRV record lookup (SIP uses SRV records for service discovery)
echo -e "\n2. SRV Record Lookup for SIP:"
echo "Command: dig _sip._udp.example.com SRV"
echo "(SIP clients look for _sip._udp.domain or _sip._tcp.domain)"

# Example SRV record format:
echo -e "\n3. SRV Record Format:"
echo "_sip._udp.example.com. 3600 IN SRV 10 50 5060 sip1.example.com."
echo "                                    |  |  |    |"
echo "                                    |  |  |    +-- Target host"
echo "                                    |  |  +------- Port (5060)"
echo "                                    |  +---------- Weight"
echo "                                    +------------- Priority"

# Test with dig (if installed)
if command -v dig &> /dev/null; then
    echo -e "\n4. Using dig for detailed DNS query:"
    dig kamailio.org +short
fi

