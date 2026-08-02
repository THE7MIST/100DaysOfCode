# `ssh_failure_analyzer.py` — Failed SSH Login Analyzer

## Objective

Create a Python script that:

- Accepts an authentication log file as an argument.
- Searches for failed SSH password attempts.
- Extracts the source IPv4 addresses.
- Counts failed attempts from each IP address.
- Displays only IP addresses with at least three failures.
- Sorts results from highest to lowest.
- Handles missing, invalid, and permission-restricted files.

---

## Source Code

Save the following script as `ssh_failure_analyzer.py`:

```python
import os
import re
import sys
from collections import Counter

if len(sys.argv) != 2:
    print(f"Usage: python3 {sys.argv[0]} <log-file>")
    sys.exit(1)

log_file = sys.argv[1]

if not os.path.isfile(log_file):
    print(f"Error: '{log_file}' is not a valid file.")
    sys.exit(1)

ip_counts = Counter()

try:
    with open(log_file, "r", encoding="utf-8", errors="ignore") as file:
        for line in file:
            if "Failed password" in line:
                match = re.search(
                    r"from\s+(\d{1,3}(?:\.\d{1,3}){3})",
                    line
                )

                if match:
                    ip_counts[match.group(1)] += 1

except PermissionError:
    print(f"Error: Permission denied for '{log_file}'.")
    sys.exit(1)

found = False

for ip, count in ip_counts.most_common():
    if count >= 3:
        print(f"{count} attempts\t{ip}")
        found = True

if not found:
    print("No IP address has 3 or more failed attempts.")
```

---

## Run on CentOS or RHEL

Authentication logs are commonly stored in `/var/log/secure`:

```bash
sudo python3 ssh_failure_analyzer.py /var/log/secure
```

---

## Run on Ubuntu or Debian

Authentication logs are commonly stored in `/var/log/auth.log`:

```bash
sudo python3 ssh_failure_analyzer.py /var/log/auth.log
```

---

## Example Output

```text
12 attempts	192.168.1.50
7 attempts	10.10.10.25
3 attempts	172.16.0.8
```

The results are displayed from the highest number of failed attempts to the lowest.

---

## No Suspicious IP Addresses

```text
No IP address has 3 or more failed attempts.
```

---

## Missing Argument Output

```text
Usage: python3 ssh_failure_analyzer.py <log-file>
```

---

## Invalid File Output

```text
Error: '/var/log/missing.log' is not a valid file.
```

---

## Permission Error Output

```text
Error: Permission denied for '/var/log/secure'.
```

Run the command with `sudo` when the authentication log requires elevated permissions:

```bash
sudo python3 ssh_failure_analyzer.py /var/log/secure
```

---

## How It Works

### 1. Validate the Argument

```python
if len(sys.argv) != 2:
```

The script expects exactly one user-supplied argument: the authentication log file.

---

### 2. Validate the Log File

```python
if not os.path.isfile(log_file):
```

`os.path.isfile()` verifies that the supplied path exists and points to a regular file.

---

### 3. Create an IP Counter

```python
ip_counts = Counter()
```

`Counter` stores each IP address and the number of failed attempts associated with it.

Example:

```text
192.168.1.50 → 12
10.10.10.25  → 7
172.16.0.8   → 3
```

---

### 4. Read the Log File

```python
with open(log_file, "r", encoding="utf-8", errors="ignore") as file:
```

The log file is opened in read mode.

`errors="ignore"` prevents the script from stopping when it encounters invalid text-encoding characters.

---

### 5. Find Failed Password Attempts

```python
if "Failed password" in line:
```

Only log entries containing `Failed password` are analyzed.

Example SSH failure entry:

```text
Jul 27 10:15:20 server sshd[1234]: Failed password for root from 192.168.1.50 port 52840 ssh2
```

---

### 6. Extract the Source IP Address

```python
match = re.search(
    r"from\s+(\d{1,3}(?:\.\d{1,3}){3})",
    line
)
```

The regular expression searches for an IPv4 address following the word `from`.

| Regex component | Meaning |
|---|---|
| `from\s+` | Matches `from` followed by whitespace |
| `\d{1,3}` | Matches one to three digits |
| `(?:\.\d{1,3}){3}` | Matches three additional dot-separated number groups |
| `(...)` | Captures the complete IP address |

---

### 7. Count Each Failure

```python
ip_counts[match.group(1)] += 1
```

Every matching failed attempt increases the count for that source IP address.

---

### 8. Sort the Results

```python
for ip, count in ip_counts.most_common():
```

`most_common()` returns the IP addresses ordered from the highest failure count to the lowest.

---

### 9. Display IPs with at Least Three Failures

```python
if count >= 3:
```

Only IP addresses with three or more failed attempts are displayed.

---

## Python Features Used

| Feature | Purpose |
|---|---|
| `sys.argv` | Reads the log-file path from the command line |
| `sys.exit()` | Stops the script with a failure exit status |
| `os.path.isfile()` | Validates the supplied file |
| `open()` | Reads the authentication log |
| `re.search()` | Extracts IPv4 addresses |
| `Counter` | Counts attempts from each IP |
| `most_common()` | Sorts results from highest to lowest |
| `try` / `except` | Handles permission errors |
| Boolean flag | Tracks whether qualifying results were found |

---

## Notes

- This version detects entries containing `Failed password`.
- It extracts IPv4 addresses only.
- Attempts from an IP are displayed only when the count is at least three.
- Authentication logs normally require root privileges.
- The script reads the log file but does not modify it.
- The regular expression matches IPv4-shaped values but does not independently validate that every octet is between `0` and `255`.
