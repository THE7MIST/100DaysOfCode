# System Health Check Script (Python)

## Overview

This Python script provides a quick overview of the system's health by displaying:

* CPU usage
* Memory usage
* Disk partitions with usage greater than or equal to **80%**

It uses the **psutil** library to collect system information in a simple and cross-platform manner.

---

# Script

```python
#!/usr/bin/env python3

import psutil

print("========= SYSTEM HEALTH CHECK =========")

# 1. CPU Usage
print("\n[1] CPU Usage")

cpu = psutil.cpu_times_percent(interval=1)

print(f"User   : {cpu.user}%")
print(f"System : {cpu.system}%")
print(f"Idle   : {cpu.idle}%")

# 2. Memory Usage
print("\n[2] Memory Usage")

memory = psutil.virtual_memory()

def human_readable(size):
    units = ["B", "KB", "MB", "GB", "TB"]

    for unit in units:
        if size < 1024:
            return f"{size:.1f}{unit}"
        size /= 1024

    return f"{size:.1f}PB"

print(f"Total  : {human_readable(memory.total)}")
print(f"Used   : {human_readable(memory.used)}")
print(f"Free   : {human_readable(memory.available)}")

# 3. Disk Usage (>80%)
print("\n[3] Disk Usage Above 80%")

for partition in psutil.disk_partitions():
    try:
        usage = psutil.disk_usage(partition.mountpoint)

        if usage.percent >= 80:
            print(f"{partition.mountpoint} -> {usage.percent}%")

    except PermissionError:
        continue
```

---

# Sample Output

```text
========= SYSTEM HEALTH CHECK =========

[1] CPU Usage
User   : 3.2%
System : 1.5%
Idle   : 95.3%

[2] Memory Usage
Total  : 8.0GB
Used   : 3.6GB
Free   : 4.2GB

[3] Disk Usage Above 80%
/ -> 85.0%
```

---

# Installation

Install the required library before running the script.

```bash
pip install psutil
```

or

```bash
pip3 install psutil
```

---

# Running the Script

```bash
python3 system_health_check.py
```

---

# Module Used

| Module   | Purpose                                                       |
| -------- | ------------------------------------------------------------- |
| `psutil` | Retrieves CPU, memory, disk, network, and process information |

---

# Functions Used

## CPU Information

```python
psutil.cpu_times_percent(interval=1)
```

Returns the percentage of CPU time spent in:

* User mode
* System mode
* Idle mode

---

## Memory Information

```python
psutil.virtual_memory()
```

Returns:

* Total memory
* Used memory
* Available (free) memory
* Memory usage percentage

---

## Disk Partitions

```python
psutil.disk_partitions()
```

Lists all mounted disk partitions.

---

## Disk Usage

```python
psutil.disk_usage(path)
```

Returns:

* Total space
* Used space
* Free space
* Disk usage percentage

---

# Human Readable Function

```python
human_readable(size)
```

Converts bytes into a readable format such as:

* KB
* MB
* GB
* TB

Example:

```text
8589934592 Bytes
↓

8.0GB
```

---

# Exception Handling

```python
except PermissionError:
    continue
```

Some mounted partitions may not be accessible by the current user.

Instead of terminating the program, the script skips those partitions and continues checking the remaining ones.

---

# Use Cases

* Linux system monitoring
* Server health checks
* Python scripting practice
* DevOps automation
* Cloud instance monitoring
* Interview and lab exercises

---

# Requirements

* Python 3.x
* psutil library

Install using:

```bash
pip install psutil
```

---

# Suggested Filename

```text
system_health_check.py
```

---

# Interview Points

* `psutil` is a cross-platform Python library used for retrieving system and hardware information.
* `cpu_times_percent()` measures CPU usage over a specified interval.
* `virtual_memory()` provides detailed RAM statistics.
* `disk_partitions()` returns all mounted filesystems.
* `disk_usage()` calculates storage usage for a given mount point.
* `PermissionError` handling ensures the script continues even if certain partitions are inaccessible.
* Converting bytes into KB/MB/GB improves readability of memory values.
