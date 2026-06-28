# Enhanced Port Scanner (Python)

## Objective

Build a Python-based TCP port scanner that:

- Accepts a hostname or IP address
- Resolves hostnames to IP addresses
- Scans TCP ports **1–1024**
- Displays only **open ports**
- Shows the associated service name
- Handles invalid hostnames gracefully

---

## Concepts Covered

- Python Socket Programming
- TCP Networking
- Port Scanning
- Hostname Resolution
- Basic Network Reconnaissance
- Exception Handling

---

## Suggested Filename

```text
port_scanner.py
```

---

# Python Script

```python
#!/usr/bin/env python3

import socket

print("=" * 50)
print("        ENHANCED PORT SCANNER")
print("=" * 50)

target = input("Enter Hostname or IP: ")

# Resolve hostname
try:
    target_ip = socket.gethostbyname(target)
except socket.gaierror:
    print("\n[-] Unable to resolve hostname.")
    exit()

print(f"\nScanning Target : {target}")
print(f"IP Address      : {target_ip}")
print("-" * 50)

for port in range(1, 1025):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(0.5)

    result = sock.connect_ex((target_ip, port))

    if result == 0:
        try:
            service = socket.getservbyport(port)
        except:
            service = "Unknown"

        print(f"Port {port:<5} OPEN   ({service})")

    sock.close()

print("-" * 50)
print("Scan Complete.")
```

---

## Sample Output

```text
==================================================
        ENHANCED PORT SCANNER
==================================================

Enter Hostname or IP: scanme.nmap.org

Scanning Target : scanme.nmap.org
IP Address      : 45.33.xxx.xxx
--------------------------------------------------
Port 22    OPEN   (ssh)
Port 80    OPEN   (http)
--------------------------------------------------
Scan Complete.
```

---

# Code Explanation

## 1. Import Module

```python
import socket
```

Imports Python's networking module.

---

## 2. Read Target

```python
target = input("Enter Hostname or IP: ")
```

Accepts either:

```text
google.com
```

or

```text
192.168.1.10
```

---

## 3. Resolve Hostname

```python
socket.gethostbyname(target)
```

Converts a hostname into an IP address.

Example:

```text
google.com
↓

142.250.xxx.xxx
```

If resolution fails, a `socket.gaierror` exception is raised.

---

## 4. Scan Ports

```python
for port in range(1, 1025):
```

Scans all well-known ports from **1 to 1024**.

---

## 5. Create TCP Socket

```python
socket.socket(socket.AF_INET, socket.SOCK_STREAM)
```

- `AF_INET` → IPv4
- `SOCK_STREAM` → TCP

---

## 6. Set Timeout

```python
sock.settimeout(0.5)
```

Prevents the scanner from waiting indefinitely for filtered ports.

---

## 7. Connect to Port

```python
result = sock.connect_ex((target_ip, port))
```

Return values:

| Result | Meaning |
|--------|---------|
| 0 | Port Open |
| Non-zero | Port Closed or Filtered |

---

## 8. Get Service Name

```python
socket.getservbyport(port)
```

Examples:

| Port | Service |
|------|---------|
| 22 | ssh |
| 80 | http |
| 443 | https |
| 25 | smtp |

If no service name exists, `"Unknown"` is displayed.

---

## 9. Close Socket

```python
sock.close()
```

Releases the socket after each scan.

---

# Socket Functions Used

| Function | Purpose |
|----------|---------|
| `socket()` | Creates a TCP socket |
| `gethostbyname()` | Resolves hostname to IP |
| `connect_ex()` | Attempts a TCP connection |
| `settimeout()` | Prevents hanging connections |
| `getservbyport()` | Returns service name |
| `close()` | Closes the socket |

---

# Interview Questions

### Why use `connect_ex()` instead of `connect()`?

`connect_ex()` returns an error code instead of raising an exception, making it more efficient for scanning many ports.

---

### Why scan ports 1–1024?

These are the **well-known ports** assigned to standard services such as:

- SSH
- HTTP
- HTTPS
- FTP
- SMTP
- DNS

---

### Why is timeout required?

Some hosts silently drop packets instead of rejecting them. A timeout prevents the scanner from hanging.

---

### Why use TCP scanning?

TCP is connection-oriented and easier to scan than UDP because it provides clear connection responses.

---

### Why resolve hostnames?

Sockets communicate using IP addresses. Hostnames must be converted before attempting connections.

---

# Possible Enhancements

- Multi-threaded scanning
- Banner grabbing
- User-defined port ranges
- Save results to TXT or CSV
- Scan multiple hosts
- Colored terminal output
- Measure scan duration
- Command-line arguments using `argparse`

---

# Key Takeaways

- Uses Python's `socket` module for TCP communication.
- Resolves hostnames before scanning.
- Scans ports **1–1024**.
- Displays only open ports with service names.
- Uses timeout and exception handling for reliable scanning.
- Serves as a foundation for learning network reconnaissance and security.
