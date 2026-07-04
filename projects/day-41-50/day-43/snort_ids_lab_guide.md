# Snort IDS/IPS Lab Guide

## Objective

Configure **Snort IDS/IPS** to detect and prevent common network attacks using custom Snort rules.

---

# Lab Environment

| Component | IP Address |
|-----------|------------|
| Web Server | 192.168.74.10 |
| Kali Linux | 192.168.74.20 |
| HOME_NET | Web Server |
| EXTERNAL_NET | any |
| Rules File | `/etc/snort/rules/local.rules` |

---

# Recommended Lab Flow

For every exercise, document:

1. Objective
2. Attack Description
3. Snort Rule
4. Rule Explanation
5. Restart Snort
6. Execute attack from Kali
7. Capture alert
8. Take screenshots
9. Result
10. Conclusion

Restart Snort:

```bash
sudo systemctl restart snort
```

Monitor alerts:

```bash
sudo tail -f /var/log/snort/alert
```

Take screenshots of:

- Kali attack command
- Snort alert
- Wireshark capture (optional)

---

# Lab 1 — Oversized ICMP Echo Request (>128 Bytes)

## Objective

Detect ICMP Echo Requests whose payload size exceeds 128 bytes.

### IDS Rule

```snort
alert icmp any any -> $HOME_NET any (
msg:"LAB-01 Oversized ICMP Echo Request (>128 Bytes)";
itype:8;
dsize:>128;
sid:1000001;
rev:1;
)
```

### IPS Rule

```snort
drop icmp any any -> $HOME_NET any (
msg:"IPS BLOCK: Oversized ICMP Packet";
itype:8;
dsize:>128;
sid:2000001;
rev:1;
)
```

### Kali Test

Linux:

```bash
ping -s 200 192.168.74.10
```

Scapy:

```python
send(IP(dst="192.168.74.10")/ICMP()/("A"*200))
```

---

# Lab 2 — ICMP Flood

## Objective

Detect more than 30 ICMP Echo Requests within 60 seconds.

### IDS Rule

```snort
alert icmp any any -> $HOME_NET any (
msg:"LAB-02 ICMP Flood Detected";
itype:8;
detection_filter:track by_src,count 30,seconds 60;
sid:1000002;
rev:1;
)
```

### IPS Rule

```snort
drop icmp any any -> $HOME_NET any (
msg:"IPS BLOCK: ICMP Flood";
itype:8;
detection_filter:track by_src,count 30,seconds 60;
sid:2000002;
rev:1;
)
```

### Kali Test

```bash
ping -f 192.168.74.10
```

or

```bash
hping3 --icmp --flood 192.168.74.10
```

Scapy:

```python
send(IP(dst="192.168.74.10")/ICMP(),count=40)
```

---

# Lab 3 — TCP SYN Flood

## Objective

Detect excessive SYN packets targeting the web server.

### IDS Rule

```snort
alert tcp any any -> $HOME_NET 80 (
msg:"LAB-03 TCP SYN Flood";
flags:S;
detection_filter:track by_src,count 20,seconds 60;
sid:1000003;
rev:1;
)
```

### IPS Rule

```snort
drop tcp any any -> $HOME_NET 80 (
msg:"IPS BLOCK: TCP SYN Flood";
flags:S;
detection_filter:track by_src,count 20,seconds 60;
sid:2000003;
rev:1;
)
```

### Kali Test

```bash
hping3 -S -p 80 --flood 192.168.74.10
```

Scapy:

```python
send(IP(dst="192.168.74.10")/TCP(dport=80,flags="S"),count=30)
```

---

# Lab 4 — SSH Brute Force

## Objective

Detect repeated SSH login attempts.

### IDS Rule

```snort
alert tcp any any -> $HOME_NET 22 (
msg:"LAB-04 SSH Brute Force Attempt";
detection_filter:track by_src,count 10,seconds 60;
sid:1000004;
rev:1;
)
```

### IPS Rule

```snort
drop tcp any any -> $HOME_NET 22 (
msg:"IPS BLOCK: SSH Brute Force";
flags:S;
detection_filter:track by_src,count 10,seconds 60;
sid:2000004;
rev:1;
)
```

### Kali Test

```bash
hydra -l root -P rockyou.txt ssh://192.168.74.10
```

or

```bash
for i in {1..20}
do
ssh fake@192.168.74.10
done
```

---

# Lab 5 — Detect Kali Linux User-Agent

## Objective

Detect HTTP requests containing the Kali Linux User-Agent.

### IDS Rule

```snort
alert http any any -> any any (
msg:"LAB-05 Possible Kali Linux User-Agent";
content:"Kali Linux";
sid:1000005;
rev:1;
)
```

### Kali Test

```bash
curl -A "Kali Linux" http://192.168.74.10
```

---

# Lab 6 — Gmail Access Detection

## Objective

Detect DNS queries for Gmail.

### IDS Rule

```snort
alert udp any any -> any 53 (
msg:"LAB-06 Gmail DNS Query";
content:"gmail";
nocase;
sid:1000006;
rev:1;
)
```

### Kali Test

```bash
firefox https://gmail.com
```

or

```bash
curl https://gmail.com
```

---

# Lab 7 — Facebook Access Detection

## Objective

Detect DNS queries for Facebook.

### IDS Rule

```snort
alert udp any any -> any 53 (
msg:"LAB-07 Facebook DNS Query";
content:"facebook";
nocase;
sid:1000007;
rev:1;
)
```

### Kali Test

```bash
curl https://facebook.com
```

---

# Lab 8 — Instagram Access Detection

## Objective

Detect DNS queries for Instagram.

### IDS Rule

```snort
alert udp any any -> any 53 (
msg:"LAB-08 Instagram DNS Query";
content:"instagram";
nocase;
sid:1000008;
rev:1;
)
```

### Kali Test

```bash
curl https://instagram.com
```

---

# Lab 9 — Port Scan Detection

## Objective

Detect TCP port scans.

### IDS Rule

```snort
alert tcp any any -> $HOME_NET any (
msg:"LAB-09 Port Scan";
flags:S;
threshold:type both,track by_src,count 20,seconds 10;
sid:1000009;
rev:1;
)
```

### Kali Test

```bash
nmap -Pn 192.168.74.10
```

or

```bash
nmap -p- 192.168.74.10
```

---

# Lab 10 — Detect Nmap Scan Types

## SYN Scan

```bash
nmap -sS 192.168.74.10
```

```snort
alert tcp any any -> $HOME_NET any (
msg:"LAB-10 Nmap SYN Scan";
flags:S;
sid:1000010;
rev:1;
)
```

---

## FIN Scan

```bash
nmap -sF 192.168.74.10
```

```snort
alert tcp any any -> $HOME_NET any (
msg:"LAB-10 Nmap FIN Scan";
flags:F;
sid:1000011;
rev:1;
)
```

---

## NULL Scan

```bash
nmap -sN 192.168.74.10
```

```snort
alert tcp any any -> $HOME_NET any (
msg:"LAB-10 Nmap NULL Scan";
flags:0;
sid:1000012;
rev:1;
)
```

---

## XMAS Scan

```bash
nmap -sX 192.168.74.10
```

```snort
alert tcp any any -> $HOME_NET any (
msg:"LAB-10 Nmap XMAS Scan";
flags:FPU;
sid:1000013;
rev:1;
)
```

---

## Version Detection

```bash
nmap -sV 192.168.74.10
```

---

## OS Detection

```bash
nmap -O 192.168.74.10
```

---

# Lab 11 — SQL Injection Detection

## Objective

Detect common SQL Injection attempts.

### IDS Rule

```snort
alert tcp any any -> $HOME_NET 80 (
msg:"LAB-11 SQL Injection";
content:"' OR 1=1";
nocase;
http_uri;
sid:1000014;
rev:1;
)
```

---

## Install Apache & PHP

```bash
sudo apt update
sudo apt install apache2 php -y
```

---

## Create Vulnerable Login Page

```bash
sudo nano /var/www/html/login.php
```

Paste:

```php
<?php
$username = $_GET['username'] ?? '';
$password = $_GET['password'] ?? '';

echo "<h2>Simple Login Page</h2>";

if ($username != "" || $password != "") {

$query = "SELECT * FROM users WHERE username='$username' AND password='$password'";

echo "<b>Generated SQL Query:</b><br>";
echo "<pre>$query</pre>";

if ($username == "admin" && $password == "admin123") {
echo "<h3 style='color:green;'>Login Successful</h3>";
}
else {
echo "<h3 style='color:red;'>Login Failed</h3>";
}
}
?>

<form method="GET">
Username:
<input type="text" name="username"><br><br>

Password:
<input type="password" name="password"><br><br>

<input type="submit" value="Login">
</form>
```

Restart Apache:

```bash
sudo systemctl restart apache2
```

---

## Kali Test

Normal login:

```text
http://192.168.74.135/login.php?username=admin&password=admin123
```

SQL Injection:

```text
http://192.168.74.135/login.php?username=' OR 1=1--&password=test
```

or

```bash
curl "http://192.168.74.135/login.php?username=' OR 1=1--&password=test"
```

---

# Lab 12 — Cross Site Scripting (XSS)

## Objective

Detect XSS payloads.

### IDS Rule

```snort
alert http any any -> $HOME_NET 80 (
msg:"LAB-12 XSS Attack";
content:"<script>";
nocase;
http_uri;
sid:1000015;
rev:1;
)
```

### Kali Test

```text
http://192.168.74.10/search.php?q=<script>alert(1)</script>
```

or

```bash
curl "http://192.168.74.10/?q=<script>alert(1)</script>"
```

---

# Lab 13 — Directory Traversal

## Objective

Detect attempts to access parent directories.

### IDS Rule

```snort
alert http any any -> $HOME_NET 80 (
msg:"LAB-13 Directory Traversal";
content:"../";
http_uri;
sid:1000016;
rev:1;
)
```

### Kali Test

```text
http://192.168.74.10/../../etc/passwd
```

or

```bash
curl "http://192.168.74.10/../../etc/passwd"
```

Encoded payload:

```bash
curl "http://192.168.74.10/%2e%2e/%2e%2e/etc/passwd"
```

---

# Common Snort Rule Attributes

| Attribute | Purpose | Example |
|----------|---------|---------|
| `msg` | Alert message | `msg:"SQL Injection"` |
| `sid` | Signature ID | `sid:1000001` |
| `rev` | Rule revision | `rev:1` |
| `itype` | ICMP type | `itype:8` |
| `dsize` | Payload size | `dsize:>128` |
| `flags:S` | SYN packets | SYN Scan |
| `flags:F` | FIN packets | FIN Scan |
| `flags:P` | PSH packets | PSH traffic |
| `flags:U` | URG packets | Urgent packets |
| `flags:FPU` | FIN+PSH+URG | XMAS Scan |
| `content` | Search for text | `content:"gmail"` |
| `nocase` | Case-insensitive match | Matches `Admin`, `ADMIN` |
| `http_uri` | Search only URI | Detect SQLi/XSS in URL |
| `http_header` | Search HTTP headers | User-Agent detection |
| `tls.sni` | Search TLS SNI | HTTPS domain detection |
| `detection_filter` | Detect high-rate traffic | Flood attacks |
| `threshold` | Reduce duplicate alerts | Port scan detection |

---

# detection_filter vs threshold

## detection_filter

- Detects high-rate attacks.
- Alerts after a specified number of packets within a time window.

Example:

```snort
detection_filter:track by_src,count 30,seconds 60;
```

Used for:

- SYN Flood
- ICMP Flood
- SSH Brute Force

---

## threshold

- Limits repeated alerts.
- Prevents log flooding.

Example:

```snort
threshold:type both,track by_src,count 20,seconds 10;
```

Used for:

- Port Scan Detection

---

# Common TCP Flags

| Flag | Meaning | Common Use |
|------|---------|------------|
| S | SYN | Connection initiation |
| A | ACK | Established connection |
| F | FIN | Connection termination / FIN Scan |
| R | RST | Reset connection |
| P | PSH | Push data immediately |
| U | URG | Urgent data |
| FPU | FIN + PSH + URG | XMAS Scan |
| 0 | No Flags | NULL Scan |

---

# Result

Snort successfully detects and optionally blocks various network attacks, including:

- Oversized ICMP packets
- ICMP floods
- TCP SYN floods
- SSH brute-force attacks
- Kali Linux User-Agent
- Gmail, Facebook, and Instagram access
- Port scans
- Nmap scan techniques
- SQL Injection
- Cross-Site Scripting (XSS)
- Directory Traversal

---

# Conclusion

This lab demonstrates how Snort can be configured as both an Intrusion Detection System (IDS) and an Intrusion Prevention System (IPS) using custom rules. By writing signatures for common attacks and validating them from a Kali Linux machine, administrators gain practical experience in detecting and mitigating network-based threats.
