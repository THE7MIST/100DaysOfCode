````markdown
# Suspicious File Extension Detector 🔍

A simple Python security script that scans a selected folder and identifies files with potentially risky executable or scripting extensions.

> **Note:** A flagged file is not necessarily malicious. The script only identifies file types that may deserve further inspection.

---

## Python Code

```python
from pathlib import Path

dangerous = {".exe", ".bat", ".cmd", ".ps1", ".vbs", ".scr"}

folder = Path(input("Folder path: "))

for file in folder.iterdir():
    if file.is_file() and file.suffix.lower() in dangerous:
        print(f"⚠ Suspicious: {file.name}")
````

---

## How the Code Works

### 1. Import `Path`

```python
from pathlib import Path
```

`Path` provides an easy way to work with files, folders, paths, extensions, and filenames.

---

### 2. Define Extensions to Check

```python
dangerous = {".exe", ".bat", ".cmd", ".ps1", ".vbs", ".scr"}
```

The script checks for:

| Extension | Type                           |
| --------- | ------------------------------ |
| `.exe`    | Windows executable             |
| `.bat`    | Batch script                   |
| `.cmd`    | Command script                 |
| `.ps1`    | PowerShell script              |
| `.vbs`    | VBScript                       |
| `.scr`    | Windows screensaver executable |

These files are not automatically malicious, but attackers commonly use executable and scripting formats to execute commands or payloads.

---

### 3. Ask for Folder Path

```python
folder = Path(input("Folder path: "))
```

The user enters the directory that should be scanned.

Example:

```text
C:\Users\Lenovo\Downloads
```

`Path()` converts the input into a filesystem path Python can work with.

---

### 4. Scan the Directory

```python
for file in folder.iterdir():
```

`iterdir()` goes through every item directly inside the selected folder.

---

### 5. Check Each File

```python
if file.is_file() and file.suffix.lower() in dangerous:
```

Two checks are performed:

* `file.is_file()` verifies that the item is a file.
* `file.suffix.lower()` retrieves its extension in lowercase.
* `in dangerous` checks whether the extension exists in our suspicious-extension set.

For example:

```text
Installer.EXE
```

becomes:

```text
.exe
```

and therefore matches the list.

---

### 6. Generate an Alert

```python
print(f"⚠ Suspicious: {file.name}")
```

When a matching file is detected, its filename is displayed.

Example:

```text
⚠ Suspicious: 1.ps1
⚠ Suspicious: Lenovo Vantage Installer.exe
⚠ Suspicious: WhatsApp Installer.exe
```

---

## Running the Script

Save it as:

```text
suspicious_files.py
```

Run from the VS Code terminal:

```powershell
python suspicious_files.py
```

Enter the folder:

```text
C:\Users\Lenovo\Downloads
```

---

## Working Flow

```text
User enters folder
        ↓
Python reads directory
        ↓
Check each item
        ↓
Is it a file?
        ↓
Check extension
        ↓
Matches suspicious list?
        ↓
Display warning
```

---

## Security Perspective

This script demonstrates a very basic form of **file-system security monitoring**.

Real endpoint security products go much further by checking:

* File hashes
* Digital signatures
* Process behavior
* File reputation
* Malware indicators
* Creation and modification events
* Network activity

This script provides a small and understandable starting point for those concepts.

```
```
