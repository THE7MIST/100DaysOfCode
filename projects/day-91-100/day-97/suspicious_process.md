# Suspicious Process Detector

A short Python security and system administration script that scans running Windows processes and identifies executables running from a **Temp directory**.

## Python Script

```python
import psutil

print("=== Suspicious Process Detector ===")

found = False

for p in psutil.process_iter(["pid", "name", "exe"]):
    try:
        path = p.info["exe"] or ""

        if "\\temp\\" in path.lower():
            print(f"⚠ {p.info['name']}")
            print(f"PID: {p.info['pid']}")
            print(f"Path: {path}\n")
            found = True

    except (psutil.AccessDenied, psutil.NoSuchProcess):
        pass

if not found:
    print("✓ No suspicious processes found.")
```

## Install Dependency

```powershell
python -m pip install psutil
```

## Run

```powershell
python suspicious_process.py
```

## How It Works

1. `psutil.process_iter()` scans running processes.
2. It collects the **PID, process name, and executable path**.
3. The executable path is converted to lowercase.
4. The script checks whether `\temp\` exists in the path.
5. Matching processes are displayed for investigation.
6. If nothing matches, it reports:

```text
=== Suspicious Process Detector ===
✓ No suspicious processes found.
```

## Why Check Temp?

Temporary directories are sometimes used to execute downloaded or temporary programs. Malware may also execute from these locations to avoid normal installation paths.

A process running from Temp is **not automatically malicious**. This script simply flags it as something worth investigating.

## Use Case

This is a lightweight example of:

- Process monitoring
- Endpoint security
- SysAdmin automation
- Basic threat hunting
- Python `psutil` usage

> **Note:** This is a detection/triage script, not an antivirus or malware scanner.
