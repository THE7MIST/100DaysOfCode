# `disk_admin_monitor.py` — System Administrator Disk Monitor

## Objective

Create a small Python monitoring script from a **System Administrator perspective**.

The script checks:

- System hostname
- Current date and time
- Disk utilization
- Available disk space
- Whether disk usage has crossed a defined threshold

This can be useful as a simple health-check script on a Linux server.

---

## Source Code

Save the following code as `disk_admin_monitor.py`:

```python
import shutil
import socket
import datetime

THRESHOLD = 80

total, used, free = shutil.disk_usage("/")
usage = (used / total) * 100

print("=== System Admin Disk Monitor ===")
print("Host:", socket.gethostname())
print("Time:", datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
print(f"Disk Usage: {usage:.1f}%")
print(f"Free Space: {free / (1024**3):.2f} GB")

if usage >= THRESHOLD:
    print("WARNING: Disk usage is above 80%!")
else:
    print("STATUS: Disk space is healthy.")
```

---

## Run the Script

```bash
python3 disk_admin_monitor.py
```

---

## Example Output

```text
=== System Admin Disk Monitor ===
Host: web-server-01
Time: 2026-08-19 01:35:20
Disk Usage: 67.4%
Free Space: 31.82 GB
STATUS: Disk space is healthy.
```

If disk utilization reaches or exceeds `80%`:

```text
=== System Admin Disk Monitor ===
Host: web-server-01
Time: 2026-08-19 01:36:10
Disk Usage: 86.2%
Free Space: 8.47 GB
WARNING: Disk usage is above 80%!
```

---

# How It Works

## 1. Import Required Modules

```python
import shutil
import socket
import datetime
```

| Module | Purpose |
|---|---|
| `shutil` | Retrieves disk-space information |
| `socket` | Retrieves the system hostname |
| `datetime` | Retrieves the current date and time |

All three modules are part of Python's standard library.

---

## 2. Define the Warning Threshold

```python
THRESHOLD = 80
```

The administrator wants to receive a warning when disk usage reaches `80%`.

The threshold can easily be changed:

```python
THRESHOLD = 90
```

---

## 3. Get Disk Information

```python
total, used, free = shutil.disk_usage("/")
```

`shutil.disk_usage()` returns:

```text
total
used
free
```

The `/` represents the root filesystem.

---

## 4. Calculate Disk Utilization

```python
usage = (used / total) * 100
```

The percentage of disk space currently being used is calculated as:

```text
Used Space
---------- × 100
Total Space
```

---

## 5. Display the Hostname

```python
socket.gethostname()
```

This identifies which machine generated the monitoring output.

This becomes particularly useful when the same script runs across multiple servers.

Example:

```text
Host: production-server-01
```

---

## 6. Display the Timestamp

```python
datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
```

The timestamp shows exactly when the health check was performed.

Example:

```text
2026-08-19 01:35:20
```

---

## 7. Convert Free Space to GB

```python
free / (1024**3)
```

`shutil.disk_usage()` returns storage values in bytes.

The script converts the available space to GB using:

```text
1 GB = 1024 × 1024 × 1024 bytes
```

The following formatting:

```python
:.2f
```

limits the displayed value to two decimal places.

Example:

```text
Free Space: 31.82 GB
```

---

## 8. Check the Threshold

```python
if usage >= THRESHOLD:
```

If disk usage reaches or exceeds the configured threshold:

```python
print("WARNING: Disk usage is above 80%!")
```

Otherwise:

```python
print("STATUS: Disk space is healthy.")
```

---

# Monitoring Flow

```text
Start
  |
  v
Get Hostname
  |
  v
Get Current Time
  |
  v
Check Root Filesystem
  |
  v
Calculate Disk Usage %
  |
  v
Is Usage >= 80%?
  |
  +---- YES ----> WARNING
  |
  +---- NO -----> HEALTHY
```

---

# Python Features Used

| Feature | Purpose |
|---|---|
| `shutil.disk_usage()` | Retrieves filesystem usage |
| `socket.gethostname()` | Retrieves hostname |
| `datetime.datetime.now()` | Gets current time |
| `strftime()` | Formats the timestamp |
| f-strings | Formats output |
| `if/else` | Implements threshold checking |
| Variables | Store monitoring values |

---

# System Administrator Use

A system administrator could use this script for a quick server health check.

Disk monitoring is important because a full filesystem can cause:

- Applications to stop writing data
- Log files to fail
- Database operations to fail
- Package installations to fail
- Backups to fail
- Services to become unstable
- Operating-system problems

A threshold warning provides an opportunity to investigate before the filesystem becomes completely full.

---

# Possible Improvements

The script could later be extended to monitor:

- CPU utilization
- RAM utilization
- Multiple filesystems
- Running services
- System uptime
- Load average
- Network interfaces
- Large files
- Log-file growth
- Failed SSH attempts
- Process status

It could also send alerts through:

```text
Email
Slack
Microsoft Teams
Webhook
Monitoring system
```

---

# Interview Explanation

A concise interview explanation would be:

> This is a basic Python system-administration monitoring script. It uses the standard library to retrieve the hostname, timestamp, and root filesystem usage. It calculates disk utilization and compares it against an 80% threshold. If the threshold is crossed, the script generates a warning so an administrator can investigate storage consumption before the filesystem becomes full.

---

## Skills Demonstrated

- Python scripting
- Linux system administration
- Disk monitoring
- Threshold-based alerting
- Standard-library usage
- Basic infrastructure automation
