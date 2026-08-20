# Python File Integrity Monitor

## Overview

A lightweight **File Integrity Monitoring (FIM)** script built with Python.

The script continuously monitors a file and uses **SHA-256 hashing** to detect whether its contents have been modified.

---

## Python Script

Save as:

```text
integrity_watch.py
```

```python
import hashlib
import time
from pathlib import Path

FILE = Path("test.txt")

def get_hash():
    return hashlib.sha256(FILE.read_bytes()).hexdigest()

if not FILE.exists():
    FILE.write_text("Original content")

old_hash = get_hash()

print(f"Monitoring: {FILE.resolve()}")
print("Waiting for changes...")

while True:
    time.sleep(2)

    new_hash = get_hash()

    if new_hash != old_hash:
        print("\n⚠ FILE MODIFIED!")
        print("Old SHA256:", old_hash)
        print("New SHA256:", new_hash)

        old_hash = new_hash
```

---

## Run

Open the VS Code terminal:

```powershell
python integrity_watch.py
```

Output:

```text
Monitoring: D:\learn\cdac\test.txt
Waiting for changes...
```

Now modify and save:

```text
test.txt
```

The monitor detects the change:

```text
⚠ FILE MODIFIED!

Old SHA256: 3949e2daad0ba297...
New SHA256: 5192ee3c54057dabc...
```

---

## How It Works

### 1. Select the File

```python
FILE = Path("test.txt")
```

The script monitors `test.txt`.

### 2. Calculate SHA-256

```python
hashlib.sha256(FILE.read_bytes()).hexdigest()
```

The entire file is read and converted into a **SHA-256 fingerprint**.

### 3. Store the Original Hash

```python
old_hash = get_hash()
```

This becomes the baseline.

### 4. Monitor Every 2 Seconds

```python
while True:
    time.sleep(2)
```

The script continuously recalculates the file hash.

### 5. Detect Modification

```python
if new_hash != old_hash:
```

If the hashes differ:

```text
Old Hash ≠ New Hash
        ↓
FILE MODIFIED
```

The new hash then becomes the baseline for detecting the next modification.

---

## Security Concept

This demonstrates the basic principle of **File Integrity Monitoring (FIM)**.

```text
File
 ↓
SHA-256
 ↓
Baseline Hash
 ↓
File Modified
 ↓
New SHA-256
 ↓
Compare Hashes
 ↓
Change Detected
```

Enterprise security platforms use more sophisticated forms of file integrity monitoring to detect unexpected changes to important files.

---

## Why SHA-256?

Even a small change in the file produces a significantly different hash.

For example:

```text
Original content
```

and:

```text
Original content
NEW CONTENT
```

produce different SHA-256 values.

This makes cryptographic hashes useful for detecting file modifications.

---

## Possible Improvements

The script could be extended with:

- Multiple-file monitoring
- Directory monitoring
- Modification timestamps
- Windows Event Log integration
- Email/Teams/Slack alerts
- JSON or CSV logging
- File deletion detection
- Automatic baseline generation

---

## Skills Demonstrated

- Python scripting
- `hashlib`
- SHA-256 hashing
- File handling
- Continuous monitoring
- File Integrity Monitoring
- Basic security automation

---

## Day 90/100

Built a lightweight **File Integrity Monitor in Python**.

It uses **SHA-256 hashing** to detect file modifications and reports the old and new hashes whenever a change occurs.

A small implementation of the core concept behind **File Integrity Monitoring (FIM)**.

`#100DaysOfCode` `#Python` `#CyberSecurity` `#FileIntegrity` `#SysAdmin`
