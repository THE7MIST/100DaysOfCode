IPTables Website Access Control Firewall

Problem Statement

Configure "iptables" as a network firewall.

- LAN Network Address: "192.168.25.0/24"
- Configure 2 clients in the network.

Create a custom chain named:

WEB_FILTER

Configure rules such that:

Client 1

Allow access only to:

- Red Hat
- Microsoft
- Oracle

Client 2

Allow access only to:

- HDFC Bank
- SBI Bank

All Clients

Allow access to:

- Google
- DNS Server "192.168.72.20"

Block all other traffic.

---

Network Topology

                    Internet
                        |
                 Firewall Server
                LAN: 192.168.25.254
                        |
        ---------------------------------
        |                               |
 Client1                         Client2
192.168.25.10                 192.168.25.20

DNS Server = 192.168.72.20

---

Step 1: Verify Client Configuration

Client 1

ip -br a
route -n
cat /etc/resolv.conf

Expected:

IP Address : 192.168.25.10/24
Gateway    : 192.168.25.254
DNS        : 192.168.72.20

Client 2

ip -br a
route -n
cat /etc/resolv.conf

Expected:

IP Address : 192.168.25.20/24
Gateway    : 192.168.25.254
DNS        : 192.168.72.20

---

Step 2: Clean Existing Rules

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

---

Step 3: Create Custom Chain

iptables -N WEB_FILTER

Verify:

iptables -L WEB_FILTER

---

Step 4: Allow Established and Related Connections

iptables -A WEB_FILTER \
-m conntrack \
--ctstate ESTABLISHED,RELATED \
-j ACCEPT

---

Step 5: Allow DNS Traffic

DNS Request (UDP)

iptables -A WEB_FILTER \
-p udp \
-s 192.168.25.0/24 \
-d 192.168.72.20 \
--dport 53 \
-j ACCEPT

DNS Response (UDP)

iptables -A WEB_FILTER \
-p udp \
-s 192.168.72.20 \
-d 192.168.25.0/24 \
--sport 53 \
-j ACCEPT

DNS Request (TCP)

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.25.0/24 \
-d 192.168.72.20 \
--dport 53 \
-j ACCEPT

DNS Response (TCP)

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.72.20 \
-d 192.168.25.0/24 \
--sport 53 \
-j ACCEPT

---

Step 6: Allow Websites for Client 1

Client IP:

192.168.25.10

Red Hat

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.25.10 \
-d www.redhat.com \
--dport 443 \
-m conntrack --ctstate NEW \
-j ACCEPT

Microsoft

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.25.10 \
-d www.microsoft.com \
--dport 443 \
-m conntrack --ctstate NEW \
-j ACCEPT

Oracle

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.25.10 \
-d www.oracle.com \
--dport 443 \
-m conntrack --ctstate NEW \
-j ACCEPT

---

Step 7: Allow Websites for Client 2

Client IP:

192.168.25.20

HDFC Bank

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.25.20 \
-d www.hdfcbank.com \
--dport 443 \
-m conntrack --ctstate NEW \
-j ACCEPT

SBI Bank

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.25.20 \
-d onlinesbi.sbi \
--dport 443 \
-m conntrack --ctstate NEW \
-j ACCEPT

---

Step 8: Allow Google for All Clients

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.25.0/24 \
-d www.google.com \
--dport 443 \
-m conntrack --ctstate NEW \
-j ACCEPT

---

Step 9: Allow Access to DNS Server Web Services

HTTP

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.25.0/24 \
-d 192.168.72.20 \
--dport 80 \
-j ACCEPT

HTTPS

iptables -A WEB_FILTER \
-p tcp \
-s 192.168.25.0/24 \
-d 192.168.72.20 \
--dport 443 \
-j ACCEPT

---

Step 10: Return to FORWARD Chain

iptables -A WEB_FILTER -j RETURN

---

Step 11: Attach Custom Chain to FORWARD

iptables -I FORWARD 1 -j WEB_FILTER

Verify:

iptables -L FORWARD --line-numbers

Expected:

1 WEB_FILTER

---

Step 12: Block Everything Else

iptables -A FORWARD -j REJECT

---

Packet Flow

FORWARD
   |
   +--> WEB_FILTER
            |
            +--> ESTABLISHED,RELATED
            |
            +--> DNS
            |
            +--> Client1 Websites
            |
            +--> Client2 Websites
            |
            +--> Google
            |
            +--> DNS Server Web Access
            |
            +--> RETURN
   |
   +--> REJECT

---

Viva Questions

Why create a custom chain?

To keep firewall rules modular, organized, and easier to maintain.

Why ESTABLISHED,RELATED first?

Allows return traffic without evaluating every rule again.

Why does DNS use both UDP and TCP?

- UDP for normal DNS queries
- TCP for large responses and zone transfers

Difference between DROP and REJECT?

DROP| REJECT
Silently discards packets| Sends an error response to sender

Why use FORWARD instead of INPUT?

Traffic is passing through the firewall.

Client → Firewall → Internet

The firewall forwards packets instead of processing them locally.

---

Important Note

Can IPTables filter websites using hostnames?

Technically, IPTables works with IP addresses, not domain names.

When a hostname is used in a rule, it is resolved once and converted to an IP address.

In production environments, website filtering is usually implemented using:

- IP Sets
- Proxy Servers
- DNS Filtering
- Next-Generation Firewalls

Hostnames are used here only for demonstration and learning purposes.
