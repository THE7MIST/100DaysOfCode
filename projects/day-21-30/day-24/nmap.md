# Nmap Master Notes (Installation, Port States, Target Specification, and Verbose Mode)

## Nmap Version Updates

The video is approximately 2 years old. The core concepts remain valid, but newer Nmap releases include:

* Additional OS fingerprints
* More service fingerprints
* Updated NSE scripts
* Improved Zenmap packaging
* Better Npcap support on Windows
* Security and stability improvements

Latest Nmap releases continue to expand detection capabilities while maintaining backward compatibility.

---

# Understanding SVN

The video downloads Nmap source code using:

```bash
svn co https://svn.nmap.org/nmap/
```

## What is SVN?

SVN (Subversion) is a Version Control System.

Its purpose is to:

* Store source code
* Track revisions
* Maintain version history
* Support collaboration among developers

Think of SVN as an older alternative to Git.

### SVN Checkout

```bash
svn co https://svn.nmap.org/nmap/
```

`co` means **checkout**.

It downloads the latest Nmap source code from the official repository.

Equivalent Git command:

```bash
git clone <repository>
```

---

# Required Packages

```bash
apt install libssl-dev autoconf make g++ subversion
```

## libssl-dev

Development package for OpenSSL.

Provides:

* SSL/TLS libraries
* Header files
* Cryptographic functions

Required for:

* HTTPS probing
* SSL certificate inspection
* NSE SSL-related scripts

---

## autoconf

Automatically generates configuration scripts.

Determines:

* Operating system
* Compiler availability
* Installed libraries
* Build environment

Used by:

```bash
./configure
```

---

## make

Build automation tool.

Reads instructions from:

```text
Makefile
```

and compiles the project automatically.

---

## g++

GNU C++ Compiler.

Required because portions of Nmap are written in C and C++.

---

## subversion

Installs SVN itself.

Without it:

```bash
svn co ...
```

will not work.

---

# Installing Nmap from Source

Download source:

```bash
svn co https://svn.nmap.org/nmap/
```

Enter directory:

```bash
cd nmap
```

View configuration options:

```bash
./configure --help
```

Configure build:

```bash
./configure
```

Compile:

```bash
make
```

Install:

```bash
sudo make install
```

Verify installation:

```bash
nmap -V
```

---

# Easier Installation Method

Most users do not need source installation.

Use:

```bash
sudo apt update
sudo apt install nmap
```

Verify:

```bash
nmap -V
```

Source installation is useful only when:

* Testing newest features
* Using development builds
* Performing custom compilation

---

# Nmap Components

## Nmap

Main network scanner.

Example:

```bash
nmap 192.168.1.1
```

---

## Zenmap

Graphical interface for Nmap.

Provides:

* GUI scanning
* Scan profiles
* Visual result analysis

---

## Ncat

Advanced Netcat replacement.

Supports:

* Data transfer
* Port listening
* Encryption
* Remote connections

---

## Nping

Packet generation and testing utility.

Used for:

* ICMP testing
* TCP testing
* Packet crafting
* Latency measurement

---

## Ndiff

Compares scan results.

Useful for identifying:

* New ports
* Service changes
* Missing hosts

---

# Help Commands

Quick help:

```bash
nmap -h
```

Full manual:

```bash
man nmap
```

Version:

```bash
nmap -V
```

---

# Verbose Mode

## What is Verbose?

Verbose mode displays additional scan progress information.

Normal scan:

```bash
nmap 192.168.1.1
```

Verbose scan:

```bash
nmap -v 192.168.1.1
```

---

## Why Use Verbose Mode?

Provides visibility into:

* Host discovery
* Port scanning progress
* Open ports found
* Timing information
* Current scan stage

Useful for long scans.

---

## Verbosity Levels

### Single Verbose

```bash
nmap -v target
```

Shows:

* Host discovery
* Basic progress
* Open ports

### Double Verbose

```bash
nmap -vv target
```

Shows:

* Additional probe details
* DNS information
* More progress updates

### Higher Levels

```bash
nmap -vvv target
nmap -vvvv target
```

Each increases output detail.

Most professionals use:

```bash
-vv
```

---

# Understanding Port States

Nmap classifies ports based on responses received from the target.

---

## Open

A service is actively listening.

Example:

```text
22/tcp open ssh
80/tcp open http
443/tcp open https
```

Meaning:

Nmap contacted the port and received a response.

---

## Closed

Host is reachable but no service is listening.

Example:

```text
23/tcp closed telnet
```

Important:

Closed does not mean the host is offline.

It means the host responded.

---

## Filtered

A firewall or filtering device prevents Nmap from determining port status.

Example:

```text
80/tcp filtered http
```

Possible causes:

* Firewall
* Router filtering
* IDS/IPS devices

---

## Unfiltered

Commonly appears during ACK scans.

Meaning:

The port is reachable but Nmap cannot determine whether it is open or closed.

---

## Open|Filtered

Nmap cannot distinguish between:

* Open
* Filtered

Common with UDP scans.

Example:

```text
53/udp open|filtered domain
```

---

## Closed|Filtered

Nmap cannot determine whether the port is:

* Closed
* Filtered

Less common state.

---

# Port State Summary

| State           | Meaning                        |
| --------------- | ------------------------------ |
| Open            | Service listening              |
| Closed          | Host reachable, service absent |
| Filtered        | Firewall blocking visibility   |
| Unfiltered      | Reachable but state unclear    |
| Open|Filtered   | Open or filtered               |
| Closed|Filtered | Closed or filtered             |

---

# Scanning Multiple Targets

## Multiple Hosts

```bash
nmap 192.168.1.10 192.168.1.20 192.168.1.30
```

---

## Hostnames

```bash
nmap scanme.nmap.org example.com
```

---

# CIDR Notation

Example:

```bash
nmap 192.168.1.0/24
```

CIDR stands for:

**Classless Inter-Domain Routing**

### Common Prefixes

| CIDR | Hosts  |
| ---- | ------ |
| /32  | 1      |
| /30  | 4      |
| /29  | 8      |
| /28  | 16     |
| /24  | 256    |
| /16  | 65,536 |

Example:

```bash
nmap 10.0.0.0/24
```

Scans the entire subnet.

---

# Scanning IP Ranges

Example:

```bash
nmap 192.168.1.10-50
```

or

```bash
nmap 192.168.1.1-254
```

---

# Scanning Targets from a File

Create:

```text
targets.txt
```

Contents:

```text
192.168.1.10
192.168.1.20
scanme.nmap.org
```

Scan:

```bash
nmap -iL targets.txt
```

`-iL` means Input List.

---

# Excluding Targets

Exclude a host:

```bash
nmap 192.168.1.0/24 --exclude 192.168.1.1
```

Exclude multiple:

```bash
nmap 192.168.1.0/24 --exclude 192.168.1.1,192.168.1.5
```

---

# Excluding Using a File

Create:

```text
exclude.txt
```

Run:

```bash
nmap 192.168.1.0/24 --excludefile exclude.txt
```

---

# Selecting a Network Interface

Example:

```bash
nmap -e eth0 target
```

Other examples:

```bash
nmap -e wlan0 target
nmap -e tun0 target
```

Useful when Nmap selects the wrong interface automatically.

---

# IPv6 Scanning

Enable IPv6 mode:

```bash
nmap -6 target
```

Example:

```bash
nmap -6 scanme.nmap.org
```

IPv6 uses 128-bit addresses instead of IPv4's 32-bit addresses.

---

# Random Internet Host Scanning

Generate random targets:

```bash
nmap -iR 10
```

Scan 10 random hosts.

Examples:

```bash
nmap -iR 50
nmap -iR 100
```

Used mainly for:

* Research
* Internet surveys
* Security studies

Use responsibly.

---

# Common Beginner Mistakes

### Typo

Wrong:

```bash
namp
```

Correct:

```bash
nmap
```

### Wrong Dash

Correct:

```bash
--help
```

Not:

```text
–help
```

### Missing Privileges

Some scan types require:

```bash
sudo nmap
```

because raw packet creation needs elevated privileges.

---

# Key Takeaways

* Open means a service is listening.
* Closed means the host responded but the service is absent.
* Filtered usually indicates a firewall.
* CIDR notation enables efficient network scanning.
* `-iL` loads targets from a file.
* `--exclude` skips specified hosts.
* `-e` selects a network interface.
* `-6` enables IPv6 scanning.
* `-iR` scans random internet hosts.
* `-v` and `-vv` provide detailed scan progress.
* Source installation is optional; most users can install Nmap directly through package repositories.

## Next Topics

The next major Nmap concepts are:

1. Host Discovery (`-sn`)
2. TCP Connect Scan (`-sT`)
3. SYN Scan (`-sS`)
4. UDP Scan (`-sU`)
5. Service Detection (`-sV`)
6. OS Detection (`-O`)
7. Aggressive Scan (`-A`)
8. NSE Scripts (`--script`)
9. Timing Templates (`-T0` to `-T5`)
