# Nmap Target Specification & Port States Notes

## Port State Summary

| State           | Meaning                     |
| --------------- | --------------------------- |
| Open            | Service listening           |
| Closed          | Host alive, no service      |
| Filtered        | Firewall blocking           |
| Unfiltered      | Reachable but state unknown |
| Open|Filtered   | Open or blocked             |
| Closed|Filtered | Closed or blocked           |

---

# Multiple Target Scanning

Scan multiple hosts:

```bash
nmap 192.168.56.10 192.168.56.20 192.168.56.30
```

Scan hostnames:

```bash
nmap scanme.nmap.org example.com
```

Useful for:

* Small lab environments
* Multiple servers
* Asset discovery

---

# CIDR Notation

CIDR = Classless Inter-Domain Routing

Format:

```text
Network/Prefix
```

Example:

```bash
nmap 192.168.56.0/24
```

### Common CIDRs

| CIDR | Hosts  |
| ---- | ------ |
| /32  | 1      |
| /30  | 4      |
| /29  | 8      |
| /28  | 16     |
| /27  | 32     |
| /24  | 256    |
| /16  | 65,536 |

Examples:

```bash
nmap 10.0.0.0/24
nmap 172.16.0.0/16
nmap 192.168.1.50/32
```

---

# IP Range Scanning

Scan specific IP ranges:

```bash
nmap 192.168.56.1-100
```

Examples:

```bash
nmap 192.168.56.50-200
nmap 192.168.56.1-254
```

Useful when only part of a subnet needs scanning.

---

# Reading Targets From a File

Create file:

```text
192.168.56.10
192.168.56.20
scanme.nmap.org
```

Scan:

```bash
nmap -iL ip.txt
```

### Meaning

```text
i = Input
L = List
```

Useful for:

* Asset inventories
* Corporate networks
* Bug bounty scopes
* Large target lists

---

# Excluding Targets

### Single Host

```bash
nmap 192.168.56.0/24 --exclude 192.168.56.1
```

### Multiple Hosts

```bash
nmap 192.168.56.0/24 --exclude 192.168.56.1,192.168.56.10
```

### Range

```bash
nmap 192.168.56.0/24 --exclude 192.168.56.50-100
```

Used to skip:

* Routers
* Firewalls
* Production servers
* Sensitive systems

---

# Excluding Hosts Using File

Create:

```text
192.168.56.1
192.168.56.2
192.168.56.3
```

Run:

```bash
nmap 192.168.56.0/24 --excludefile exclude.txt
```

### Difference

```bash
-iL
```

Targets to scan.

```bash
--excludefile
```

Targets to skip.

---

# Important Note About -f

Many beginners confuse:

```bash
-f
```

with file input.

Wrong.

Actual meaning:

```bash
nmap -f target
```

Fragment packets for firewall evasion.

---

# Selecting Network Interface

View interfaces:

```bash
ip a
```

or

```bash
ifconfig
```

Specify interface:

```bash
nmap -e eth0 target
```

Examples:

```bash
nmap -e wlan0 scanme.nmap.org
nmap -e tun0 10.10.10.10
nmap -e lo 192.168.81.128
```

Useful when:

* Multiple NICs exist
* VPN is active
* Wrong interface is selected automatically

---

# Docker Lab

Run DVWA container:

```bash
docker run -d --name vulnerable-app -p 21:21 -p 22:22 -p 80:80 vulnerables/web-dvwa
```

Get container IP:

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' vulnerable-app
```

Example output:

```text
172.17.0.2
```

Alternative mapping:

```bash
docker run -d \
--name vulnerable-app \
-p 21:21 \
-p 2222:22 \
-p 8080:80 \
vulnerables/web-dvwa
```

---

# Random Host Scanning

Scan random Internet hosts:

```bash
nmap -iR 4
```

Examples:

```bash
nmap -iR 10
nmap -iR 50
```

Used for:

* Research
* Internet surveys
* Security testing

Use responsibly.

---

# Commands to Memorize

```bash
nmap scanme.nmap.org

nmap -v scanme.nmap.org

nmap 192.168.56.0/24

nmap 192.168.56.1-100

nmap -iL ip.txt

nmap 192.168.56.0/24 --exclude 192.168.56.1

nmap 192.168.56.0/24 --excludefile exclude.txt

ip a

nmap -e eth0 scanme.nmap.org

nmap -iR 4
```

---

# Viva Questions

### What does -iL mean?

Input List. Reads targets from a file.

### What does CIDR stand for?

Classless Inter-Domain Routing.

### Difference between Closed and Filtered?

Closed:

* Host responded
* No service listening

Filtered:

* Firewall blocks determination

### What does --exclude do?

Skips specified hosts from scanning.

### What does -e do?

Forces Nmap to use a specific network interface.

### Difference between CIDR and Range Scanning?

CIDR:

```bash
nmap 192.168.56.0/24
```

Scans an entire subnet.

Range:

```bash
nmap 192.168.56.1-100
```

Scans only selected IPs.

### Difference between -iL and --excludefile?

```bash
-iL
```

Targets to scan.

```bash
--excludefile
```

Targets to skip.

---

## Key Takeaway

Before learning advanced scans such as:

```text
-sS
-sT
-sU
-sV
-O
-A
```

you must understand target specification, exclusion methods, CIDR notation, interfaces, and port states.
