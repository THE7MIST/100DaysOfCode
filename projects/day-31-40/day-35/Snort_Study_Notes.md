# Snort Master Notes (Compact)

## Overview

**Snort** is a free and open-source **Network Intrusion Detection System (NIDS)** that can also operate as an **Intrusion Prevention System (IPS)** in inline mode.

* Developed by **Martin Roesch (1998)**
* Maintained by **Cisco Talos**
* Snort 2 is widely used in labs and legacy environments.
* Snort 3 is recommended for new deployments.

---

# IDS vs IPS

| IDS                     | IPS                                |
| ----------------------- | ---------------------------------- |
| Detects attacks         | Detects and blocks attacks         |
| Passive                 | Inline/Active                      |
| Generates alerts        | Drops or rejects malicious traffic |
| Does not modify traffic | Prevents attacks                   |

---

# Snort Architecture

```
Network
   │
Packet Capture
   │
Packet Decoder
   │
Preprocessors
   │
Detection Engine
   │
Output Modules
```

### Components

* **Packet Capture** – Captures packets using libpcap.
* **Packet Decoder** – Decodes Ethernet, IP, TCP, UDP, ICMP, etc.
* **Preprocessors** – Normalizes traffic, reassembles streams/fragments.
* **Detection Engine** – Matches packets against rules.
* **Output Modules** – Logs events and generates alerts.

---

# Operating Modes

## Sniffer Mode

Displays packets on the screen.

```bash
snort -v
```

---

## Packet Logger Mode

Stores captured packets.

```bash
snort -dev -l .
```

---

## IDS Mode

Analyzes packets and generates alerts.

```bash
snort -A console -q -c /etc/snort/snort.conf -i <interface>
```

---

## IPS Mode

Runs inline and blocks malicious packets.

---

# Installation (Ubuntu)

Update packages:

```bash
sudo apt update
```

Install Snort:

```bash
sudo apt install snort
```

During installation configure:

* Monitoring Interface
* HOME_NET (example: `192.168.1.0/24`)

Verify installation:

```bash
snort -V
```

---

# Find Network Interface

```bash
ip -br a
```

Example:

```
ens33
enp0s3
eth0
```

---

# Find HOME_NET

```bash
ip addr
```

Example:

```
192.168.1.105/24
```

Configure as:

```
192.168.1.0/24
```

---

# Enable Promiscuous Mode

```bash
sudo ip link set <interface> promisc on
```

Example:

```bash
sudo ip link set ens33 promisc on
```

Verify:

```bash
ip link show ens33
```

Look for:

```
PROMISC
```

---

# Important Files

| File                               | Purpose                |
| ---------------------------------- | ---------------------- |
| `/etc/snort/snort.conf`            | Main configuration     |
| `/etc/snort/rules/`                | Rule directory         |
| `/etc/snort/rules/local.rules`     | Custom rules           |
| `/etc/snort/classification.config` | Attack classifications |
| `/etc/snort/reference.config`      | References             |

Always create a backup before editing:

```bash
sudo cp /etc/snort/snort.conf /etc/snort/snort.conf.bak
```

---

# Snort Rule Syntax

```
action protocol src_ip src_port direction dst_ip dst_port (options)
```

Example:

```text
alert icmp any any -> any any (msg:"ICMP Detected"; sid:1000001; rev:1;)
```

---

# Rule Header

| Field            | Example |
| ---------------- | ------- |
| Action           | alert   |
| Protocol         | tcp     |
| Source IP        | any     |
| Source Port      | any     |
| Direction        | ->      |
| Destination IP   | any     |
| Destination Port | 80      |

---

# Common Rule Actions

| Action | Purpose                |
| ------ | ---------------------- |
| alert  | Alert and log          |
| log    | Log only               |
| pass   | Ignore traffic         |
| drop   | Drop packet (IPS)      |
| reject | Drop and notify sender |
| sdrop  | Silent drop            |

---

# Common Rule Options

| Option    | Purpose                |
| --------- | ---------------------- |
| msg       | Alert message          |
| sid       | Signature ID           |
| rev       | Rule revision          |
| content   | Payload matching       |
| nocase    | Ignore case            |
| flags     | TCP flags              |
| priority  | Alert severity         |
| classtype | Attack category        |
| reference | CVE/URL                |
| metadata  | Additional information |

Example:

```text
(msg:"HTTP Request"; content:"GET"; sid:1000001; rev:1;)
```

---

# Sample Rules

HTTP

```text
alert tcp any any -> any 80 (msg:"HTTP Access"; sid:1001; rev:1;)
```

SSH

```text
alert tcp any any -> any 22 (msg:"SSH Access"; sid:1002; rev:1;)
```

ICMP

```text
alert icmp any any -> any any (msg:"ICMP Ping"; sid:1003; rev:1;)
```

Nmap SYN Scan

```text
alert tcp any any -> any any (flags:S; msg:"Possible SYN Scan"; sid:1004; rev:1;)
```

---

# Rule Processing Flow

```
Incoming Packet
      │
Header Match
      │
Payload Inspection
      │
Rule Options
      │
Action
      │
Alert / Log / Drop
```

---

# IDS vs IPS Deployment

### IDS

```
Network
   │
 Switch
   │
SPAN Port
   │
 Snort IDS
```

Passive monitoring only.

### IPS

```
Internet
   │
Snort IPS
   │
Firewall
   │
Internal Network
```

Traffic passes through Snort and can be blocked.

---

# Detection Techniques

### Signature-Based

* Detects known attacks
* Fast
* Low false positives

### Anomaly-Based

* Detects unknown attacks
* Higher false positives

### Behavior-Based

* Detects suspicious long-term behavior

---

# Advantages

* Free and open source
* Real-time detection
* Highly customizable
* Large rule community
* IDS and IPS support
* SIEM integration

---

# Limitations

* Mostly signature-based
* Limited encrypted traffic inspection
* Requires rule updates
* Needs tuning to reduce false positives

---

# Common Commands

```bash
snort -V
```

```bash
snort -h
```

```bash
man snort
```

```bash
ip -br a
```

```bash
ip addr
```

```bash
sudo ip link set <interface> promisc on
```

---

# Uninstall Snort

Stop service:

```bash
sudo systemctl stop snort
sudo systemctl disable snort
```

Remove package:

```bash
sudo apt purge --autoremove -y snort
```

Delete configuration:

```bash
sudo rm -rf /etc/snort
sudo rm -rf /var/log/snort
```

Clean packages:

```bash
sudo apt autoremove
sudo apt autoclean
sudo apt clean
```

Verify removal:

```bash
snort -V
```

Expected:

```
Command 'snort' not found
```

---

# Best Practices

* Always back up `snort.conf`.
* Use `local.rules` for custom rules.
* Keep rules updated.
* Enable Promiscuous Mode for monitoring.
* Verify the correct network interface.
* Configure the correct HOME_NET.
* Test configuration before deployment.
* Prefer Snort 3 for new installations.

---

# Quick Revision

* Snort = Open-source NIDS/IPS
* IDS detects, IPS detects and blocks
* Main config: `/etc/snort/snort.conf`
* Custom rules: `/etc/snort/rules/local.rules`
* Install: `sudo apt install snort`
* Verify: `snort -V`
* Enable Promiscuous Mode
* Rule = Header + Options
* Common actions: `alert`, `log`, `pass`, `drop`, `reject`
* Important options: `msg`, `sid`, `rev`, `content`, `flags`
* Snort 3 is recommended for modern deployments.
