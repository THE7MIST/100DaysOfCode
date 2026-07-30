# `large_file_finder.py` — Large File Finder

## Objective

Create a Python script that:

- Accepts a directory path and size limit in MB.
- Searches recursively through all subdirectories.
- Displays files larger than the specified size.
- Shows each matching file’s size in MB.
- Handles invalid directory paths.
- Handles invalid size input.
- Skips inaccessible or deleted files safely.
- Displays the total number of matching files.

---

## Source Code

Save the following script as `large_file_finder.py`:

```python
import os
import sys

if len(sys.argv) != 3:
    print(f"Usage: python3 {sys.argv[0]} <directory> <size-in-MB>")
    sys.exit(1)

directory = sys.argv[1]

try:
    size_limit_mb = float(sys.argv[2])
except ValueError:
    print("Error: Size must be a number.")
    sys.exit(1)

if size_limit_mb < 0:
    print("Error: Size must be zero or greater.")
    sys.exit(1)

if not os.path.isdir(directory):
    print(f"Error: '{directory}' is not a valid directory.")
    sys.exit(1)

size_limit_bytes = size_limit_mb * 1024 * 1024
count = 0

for root, directories, files in os.walk(directory):
    for filename in files:
        file_path = os.path.join(root, filename)

        try:
            file_size = os.path.getsize(file_path)

            if file_size > size_limit_bytes:
                file_size_mb = file_size / (1024 * 1024)
                print(f"{file_size_mb:.2f} MB  {file_path}")
                count += 1

        except (PermissionError, FileNotFoundError):
            continue

print()
print(f"Total files larger than {size_limit_mb} MB: {count}")
```

---

## Run the Script

```bash
python3 large_file_finder.py /var/log 5
```

This searches `/var/log` recursively and displays files larger than `5 MB`.

Another example:

```bash
python3 large_file_finder.py /home/user/Documents 100
```

---

## Example Output

```text
8.42 MB  /var/log/application.log
15.78 MB  /var/log/archive/system.log
25.10 MB  /var/log/httpd/access.log

Total files larger than 5.0 MB: 3
```

---

## No Matching Files Output

```text
Total files larger than 100.0 MB: 0
```

---

## Invalid Directory Output

```text
Error: '/invalid/path' is not a valid directory.
```

---

## Invalid Size Output

```text
Error: Size must be a number.
```

Example:

```bash
python3 large_file_finder.py /var/log five
```

---

## Negative Size Output

```text
Error: Size must be zero or greater.
```

Example:

```bash
python3 large_file_finder.py /var/log -5
```

---

## Missing Arguments Output

```text
Usage: python3 large_file_finder.py <directory> <size-in-MB>
```

---

## How It Works

### 1. Validate Command-Line Arguments

```python
if len(sys.argv) != 3:
```

The script expects two user-supplied arguments:

1. Directory path
2. Size limit in MB

---

### 2. Convert the Size Limit

```python
size_limit_mb = float(sys.argv[2])
```

Using `float()` allows both whole-number and decimal size limits.

Examples:

```text
5
10.5
100
```

---

### 3. Validate the Directory

```python
if not os.path.isdir(directory):
```

`os.path.isdir()` checks whether the supplied path exists and is a directory.

---

### 4. Convert MB to Bytes

```python
size_limit_bytes = size_limit_mb * 1024 * 1024
```

File sizes returned by Python are measured in bytes.

The conversion uses:

```text
1 MB = 1024 × 1024 bytes
```

---

### 5. Search Recursively

```python
for root, directories, files in os.walk(directory):
```

`os.walk()` searches the supplied directory and all of its subdirectories.

It returns:

| Value | Meaning |
|---|---|
| `root` | Current directory path |
| `directories` | Subdirectories inside the current directory |
| `files` | Files inside the current directory |

---

### 6. Build the Full File Path

```python
file_path = os.path.join(root, filename)
```

`os.path.join()` combines the directory path and filename safely.

---

### 7. Read the File Size

```python
file_size = os.path.getsize(file_path)
```

`os.path.getsize()` returns the file size in bytes.

---

### 8. Compare the File Size

```python
if file_size > size_limit_bytes:
```

Only files strictly larger than the supplied limit are displayed.

A file exactly equal to the limit is not included.

---

### 9. Convert the Size Back to MB

```python
file_size_mb = file_size / (1024 * 1024)
```

The size is converted to MB before being displayed.

```python
print(f"{file_size_mb:.2f} MB  {file_path}")
```

`.2f` displays the size with two decimal places.

---

### 10. Handle File Access Errors

```python
except (PermissionError, FileNotFoundError):
    continue
```

The script skips files that:

- Cannot be accessed because of permissions.
- Disappear while the directory is being scanned.

---

## Python Features Used

| Feature | Purpose |
|---|---|
| `sys.argv` | Reads command-line arguments |
| `float()` | Converts the size input to a number |
| `os.path.isdir()` | Validates the directory |
| `os.walk()` | Searches recursively |
| `os.path.join()` | Creates complete file paths |
| `os.path.getsize()` | Reads file sizes in bytes |
| `try` / `except` | Handles invalid input and inaccessible files |
| `sys.exit()` | Stops the script with an exit code |
| f-string formatting | Displays file sizes with two decimal places |

---

## Notes

- The search is recursive.
- The script displays files strictly larger than the supplied limit.
- Decimal size limits such as `2.5 MB` are supported.
- Permission-restricted files are skipped.
- The script does not modify or delete any files.
- Use elevated privileges only when scanning protected directories:

```bash
sudo python3 large_file_finder.py /var/log 5
```
