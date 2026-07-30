# `disk_monitor.py` — Disk Usage Monitor

## Objective

Create a Python script that:

- Accepts a disk-usage threshold as a command-line argument.
- Checks mounted filesystems.
- Excludes temporary filesystems such as `tmpfs` and `devtmpfs`.
- Displays a warning for every filesystem whose usage is greater than or equal to the threshold.
- Handles invalid threshold input.
- Returns exit code `1` when at least one filesystem crosses the threshold.
- Returns exit code `0` when all checked filesystems remain below the threshold.

---

## Source Code

Save the following script as `disk_monitor.py`:

```python
import shutil
import subprocess
import sys

if len(sys.argv) != 2:
    print(f"Usage: python3 {sys.argv[0]} <threshold-percentage>")
    sys.exit(1)

try:
    threshold = int(sys.argv[1])
except ValueError:
    print("Error: Threshold must be a number.")
    sys.exit(1)

if threshold < 1 or threshold > 100:
    print("Error: Threshold must be between 1 and 100.")
    sys.exit(1)

result = subprocess.run(
    ["df", "-P", "-x", "tmpfs", "-x", "devtmpfs"],
    capture_output=True,
    text=True,
    check=True
)

warning_found = False

for line in result.stdout.splitlines()[1:]:
    parts = line.split()

    if len(parts) < 6:
        continue

    filesystem = parts[0]
    usage = int(parts[4].replace("%", ""))
    mount_point = parts[5]

    if usage >= threshold:
        print(
            f"WARNING: {filesystem} mounted on {mount_point} "
            f"is {usage}% full"
        )
        warning_found = True

if warning_found:
    sys.exit(1)

print(f"All filesystems are below {threshold}% usage.")
```

---

## Run the Script

```bash
python3 disk_monitor.py 80
```

This checks whether any mounted filesystem is at least `80%` full.

---

## Warning Output

```text
WARNING: /dev/sda1 mounted on / is 86% full
WARNING: /dev/sdb1 mounted on /data is 92% full
```

Because at least one filesystem crossed the threshold, the script exits with status code `1`.

---

## Healthy Output

```text
All filesystems are below 80% usage.
```

When no filesystem reaches the threshold, the script exits with status code `0`.

---

## Missing Argument Output

```text
Usage: python3 disk_monitor.py <threshold-percentage>
```

---

## Invalid Threshold Output

```text
Error: Threshold must be a number.
```

Example:

```bash
python3 disk_monitor.py eighty
```

---

## Out-of-Range Threshold Output

```text
Error: Threshold must be between 1 and 100.
```

Examples:

```bash
python3 disk_monitor.py 0
python3 disk_monitor.py 150
```

---

## How It Works

### 1. Validate the Argument

```python
if len(sys.argv) != 2:
```

The script expects exactly one user-supplied argument: the threshold percentage.

### 2. Convert the Threshold

```python
threshold = int(sys.argv[1])
```

The value is converted from text to an integer. Invalid text raises `ValueError`, which the script handles.

### 3. Validate the Range

```python
if threshold < 1 or threshold > 100:
```

Only values from `1` to `100` are accepted.

### 4. Run `df`

```python
result = subprocess.run(
    ["df", "-P", "-x", "tmpfs", "-x", "devtmpfs"],
    capture_output=True,
    text=True,
    check=True
)
```

This executes:

```bash
df -P -x tmpfs -x devtmpfs
```

| Option | Meaning |
|---|---|
| `-P` | Uses a predictable POSIX output format |
| `-x tmpfs` | Excludes `tmpfs` |
| `-x devtmpfs` | Excludes `devtmpfs` |

### 5. Parse the Output

The script skips the heading line, splits each remaining line into columns, and extracts:

- filesystem name,
- usage percentage,
- mount point.

### 6. Compare Usage

```python
if usage >= threshold:
```

A warning is shown when usage is equal to or greater than the threshold.

### 7. Return the Exit Code

| Exit code | Meaning |
|---:|---|
| `0` | All filesystems are below the threshold |
| `1` | Invalid input or at least one filesystem reached the threshold |

---

## Check the Exit Code

```bash
python3 disk_monitor.py 80
echo $?
```

Possible output:

```text
0
```

or:

```text
1
```

---

## Python Features Used

| Feature | Purpose |
|---|---|
| `sys.argv` | Reads the command-line threshold |
| `int()` | Converts text to an integer |
| `try` / `except` | Handles invalid numeric input |
| `subprocess.run()` | Executes the `df` command |
| `splitlines()` | Splits output into lines |
| `split()` | Splits each line into columns |
| `replace()` | Removes the `%` symbol |
| `sys.exit()` | Returns an exit status |
| Boolean flag | Tracks whether a warning was found |

---

## Notes

- The script is intended for Linux or Unix-like systems.
- Temporary filesystems are excluded to reduce unnecessary alerts.
- A filesystem exactly at the threshold also triggers a warning.
- The imported `shutil` module is unused and may be removed.
- Because `check=True` is used, a failed `df` command raises `subprocess.CalledProcessError`.
- The exit code makes the script suitable for cron jobs and monitoring tools.
