# High Memory Process Detector Using Python

A simple **System Administration monitoring script** that detects Windows processes consuming more than a specified amount of RAM.

## Python Script

```python
import psutil

LIMIT = 300  # MB

print("=== High Memory Process Detector ===\n")

for process in psutil.process_iter(["pid", "name", "memory_info"]):
    try:
        memory = process.info["memory_info"].rss / (1024 ** 2)

        if memory > LIMIT:
            print(f"⚠ {process.info['name']}")
            print(f"  PID: {process.info['pid']} | RAM: {memory:.1f} MB")

    except (psutil.NoSuchProcess, psutil.AccessDenied):
        pass
```

## How It Works

### 1. Import `psutil`

```python
import psutil
```

`psutil` provides information about running processes and system resources.

Install it using:

```powershell
pip install psutil
```

### 2. Set Memory Threshold

```python
LIMIT = 300
```

Any process consuming more than **300 MB RAM** is reported.

### 3. Scan Running Processes

```python
psutil.process_iter(["pid", "name", "memory_info"])
```

The script collects:

- Process name
- PID
- Memory information

### 4. Convert RAM to MB

```python
memory = process.info["memory_info"].rss / (1024 ** 2)
```

`RSS` represents the physical RAM currently occupied by the process.

### 5. Detect High Memory Usage

```python
if memory > LIMIT:
```

Processes exceeding the threshold are displayed.

Example:

```text
⚠ chrome.exe
  PID: 16080 | RAM: 637.6 MB

⚠ explorer.exe
  PID: 18680 | RAM: 334.4 MB
```

## Run

Save as:

```text
process_monitor.py
```

Then run:

```powershell
python process_monitor.py
```

## SysAdmin Use

This small script can help identify:

- Resource-heavy applications
- Runaway processes
- Unexpected memory consumption
- Processes requiring further investigation

It can later be extended with **CPU monitoring, automatic logging, alerts, and process termination**.
