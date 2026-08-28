# Network Connection Watcher

A short Python script that displays active established network connections and the process responsible for each connection.

It provides a lightweight view of:

- Process name
- PID
- Local IP and port
- Remote IP and port
- Established TCP connections

---

## Python Script

Save the script as:

```text
network_watcher.py
```

```python
import psutil

print("=== Active Network Connections ===\n")

for c in psutil.net_connections(kind="inet"):
    if c.raddr and c.status == "ESTABLISHED":
        try:
            p = psutil.Process(c.pid)

            print(f"{p.name():20} PID:{c.pid}")
            print(f"Local : {c.laddr.ip}:{c.laddr.port}")
            print(f"Remote: {c.raddr.ip}:{c.raddr.port}\n")

        except:
            pass
```

---

## Install Dependency

The script uses the `psutil` library.

```powershell
python -m pip install psutil
```

---

## Run

```powershell
python network_watcher.py
```

---

## Example Output

```text
=== Active Network Connections ===

chrome.exe           PID:14220
Local : 192.168.1.5:51842
Remote: 142.250.183.14:443

Code.exe             PID:9844
Local : 192.168.1.5:52103
Remote: 13.107.42.16:443
```

---

## How It Works

### 1. Import `psutil`

```python
import psutil
```

`psutil` provides information about processes, CPU, memory, disks, and network connections.

---

### 2. Get Network Connections

```python
psutil.net_connections(kind="inet")
```

This returns Internet-based network connections, including IPv4 and IPv6 TCP/UDP sockets.

---

### 3. Check for Remote Connections

```python
if c.raddr and c.status == "ESTABLISHED":
```

The script displays only connections that:

- Have a remote endpoint.
- Are currently in the `ESTABLISHED` state.

---

### 4. Identify the Process

```python
p = psutil.Process(c.pid)
```

The PID associated with the connection is used to retrieve process information.

---

### 5. Display Process Information

```python
print(f"{p.name():20} PID:{c.pid}")
```

This shows:

```text
Process Name
PID
```

---

### 6. Display the Local Endpoint

```python
print(f"Local : {c.laddr.ip}:{c.laddr.port}")
```

Example:

```text
Local : 192.168.1.5:51842
```

This is the IP address and port being used by your computer.

---

### 7. Display the Remote Endpoint

```python
print(f"Remote: {c.raddr.ip}:{c.raddr.port}")
```

Example:

```text
Remote: 142.250.183.14:443
```

This represents the remote system the process is communicating with.

---

## Connection Flow

```text
Running Process
      ↓
Local IP : Port
      ↓
Network
      ↓
Remote IP : Port
```

Example:

```text
chrome.exe
    ↓
192.168.1.5:51842
    ↓
Internet
    ↓
142.250.183.14:443
```

---

## Why It Is Useful

This provides basic **endpoint network visibility**.

A SysAdmin or security analyst can use this type of information to investigate:

- Unexpected outbound connections
- Unknown processes communicating externally
- Suspicious remote IP addresses
- Applications creating many connections
- Network troubleshooting issues

---

## Security Perspective

Endpoint security tools commonly correlate:

```text
Process
   +
PID
   +
Local Port
   +
Remote IP
   +
Remote Port
```

This helps analysts understand which applications are responsible for network activity.

This script demonstrates a simplified version of that concept.

---

## Important Note

A remote connection is **not automatically suspicious**.

Browsers, update services, cloud applications, messaging clients, and operating-system components regularly create outbound connections.

The output should be treated as information for further investigation.

---

## Possible Improvements

The script could later be extended to:

- Resolve remote IP addresses to hostnames.
- Flag unusual destination ports.
- Log connections to a file.
- Detect newly created connections.
- Count connections per process.
- Display executable paths.
- Generate alerts for unknown processes.
- Compare destination IPs against an allowlist.

---

## Concepts Demonstrated

- Python scripting
- `psutil`
- Process monitoring
- TCP networking
- Endpoint visibility
- SysAdmin automation
- Blue Team monitoring
