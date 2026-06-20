# Disk Usage Alert Script

## Objective

Write a Bash script that:

* Monitors root (`/`) filesystem disk usage
* Displays current disk usage percentage
* Logs a warning when usage exceeds a defined threshold
* Stores alerts in a log file

---

# Script

```bash
#!/bin/bash

LOGFILE="/var/log/disk_alert.log"

usage=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

echo "Usage = $usage"

if [ "$usage" -gt 75 ]
then
    echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: Disk usage is ${usage}%" >> "$LOGFILE"
fi
```

---

# Sample Output

```text
Usage = 79
```

If usage exceeds 75%, an entry is added to:

```text
/var/log/disk_alert.log
```

Example:

```text
2026-06-20 22:45:31 WARNING: Disk usage is 79%
```

---

# Explanation

## Log File

```bash
LOGFILE="/var/log/disk_alert.log"
```

Stores warning messages in a log file.

---

## Get Disk Usage

```bash
usage=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
```

### `df /`

Displays disk usage for the root filesystem.

Example:

```text
Filesystem      Size Used Avail Use% Mounted on
/dev/sda1        50G  40G   10G  80% /
```

### `awk`

```awk
NR==2 {gsub("%","",$5); print $5}
```

| Component         | Purpose                  |
| ----------------- | ------------------------ |
| `NR==2`           | Process second line only |
| `$5`              | Use% column              |
| `gsub("%","",$5)` | Remove `%` symbol        |
| `print $5`        | Print usage value        |

Result:

```text
80
```

---

## Display Usage

```bash
echo "Usage = $usage"
```

Shows current disk utilization percentage.

---

## Threshold Check

```bash
if [ "$usage" -gt 75 ]
```

Checks whether disk usage is greater than 75%.

| Operator | Meaning      |
| -------- | ------------ |
| `-gt`    | Greater Than |

---

## Log Warning

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: Disk usage is ${usage}%" >> "$LOGFILE"
```

Adds a timestamped warning to the log file.

Example:

```text
2026-06-20 22:45:31 WARNING: Disk usage is 79%
```

---

# Verification

Check current disk usage:

```bash
df -h
```

Run the script:

```bash
bash diskMonitor
```

View alert logs:

```bash
cat /var/log/disk_alert.log
```

---

# Result

The script successfully monitors disk usage on the root filesystem and records a warning in a log file whenever disk utilization exceeds the defined threshold.

---

# Conclusion

This script provides a simple disk monitoring solution using Bash, `df`, and `awk`. It can be used as a foundation for automated monitoring tasks and can be scheduled using cron for periodic disk space checks.
