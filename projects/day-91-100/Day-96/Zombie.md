# Zombie Process Detector Using Python

## Overview

A small **SysAdmin health-check script** that scans running processes and reports processes with a **zombie** status.

A zombie process is a process that has finished execution but still has an entry in the operating system's process table.

---

## Python Code

Save the script as:

```text
zombie_detector.py
```

```python
import psutil

print("=== Zombie Process Detector ===")

found = False

for p in psutil.process_iter(["pid", "name", "status"]):
    if p.info["status"] == psutil.STATUS_ZOMBIE:
        print(f"⚠ PID {p.info['pid']} | {p.info['name']}")
        found = True

if not found:
    print("✓ No zombie processes found.")
```

## Install Dependency

The script uses the `psutil` Python library.

```powershell
pip install psutil
```

## Run

```powershell
python zombie_detector.py
```

## Example Output

```text
=== Zombie Process Detector ===
✓ No zombie processes found.
```

---

## How It Works

### 1. Import `psutil`

```python
import psutil
```

`psutil` provides information about running system processes.

### 2. Create Detection Flag

```python
found = False
```

This variable tracks whether a zombie process is detected.

### 3. Scan Running Processes

```python
for p in psutil.process_iter(["pid", "name", "status"]):
```

The script retrieves:

- **PID** - Process ID
- **Name** - Process name
- **Status** - Current process state

### 4. Detect Zombie Processes

```python
if p.info["status"] == psutil.STATUS_ZOMBIE:
```

If a process has zombie status, its **PID and name** are displayed.

### 5. Display Healthy Status

```python
if not found:
    print("✓ No zombie processes found.")
```

If no zombie processes are detected, the script reports that the system is clear.

---

## SysAdmin Use

This small script demonstrates:

- Process monitoring
- System health checking
- Python automation
- `psutil` usage

> **Note:** Traditional Unix-style zombie processes are mainly relevant on Linux/Unix systems and are uncommon on Windows. This script is therefore more useful on **Linux or WSL**.

## Possible Improvements

- Continuous monitoring
- Logging detected processes
- Alert notifications
- Parent-process detection
- Remote server monitoring
