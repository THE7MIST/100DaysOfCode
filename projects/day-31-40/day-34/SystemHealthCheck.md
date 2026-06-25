# System Health Check Script

## Overview

This Bash script provides a quick overview of the system's health by displaying:

- CPU usage
- Memory usage
- Disk partitions with usage greater than or equal to 80%

It uses standard Linux utilities (`top`, `free`, `df`) along with `awk` for formatting the output.

---

## Script

```bash
#!/bin/bash

echo "========= SYSTEM HEALTH CHECK ========="

# 1. CPU Usage
echo -e "\n[1] CPU Usage"
top -bn1 | awk '/Cpu/ {
    print "User   :", $2"%"
    print "System :", $4"%"
    print "Idle   :", $8"%"
}'

# 2. Memory Usage
echo -e "\n[2] Memory Usage"
free -h | awk 'NR==2 {
    print "Total  :", $2
    print "Used   :", $3
    print "Free   :", $4
}'

# 3. Disk Usage (>80%)
echo -e "\n[3] Disk Usage Above 80%"
df -h | awk 'NR>1 {
    usage=$5
    gsub("%","",usage)
    if (usage >= 80)
        print $6, "->", usage"%"
}'
```

---

## Sample Output

```text
========= SYSTEM HEALTH CHECK =========

[1] CPU Usage
User   : 2.4%
System : 2.4%
Idle   : 95.2%

[2] Memory Usage
Total  : 1.9Gi
Used   : 1.5Gi
Free   : 201Mi

[3] Disk Usage Above 80%
/ -> 85%
```

---

## Commands Used

### Display CPU Usage

```bash
top -bn1
```

| Option | Description |
|--------|-------------|
| `-b` | Batch mode (non-interactive) |
| `-n1` | Run one iteration |

---

### Display Memory Usage

```bash
free -h
```

| Option | Description |
|--------|-------------|
| `-h` | Human-readable output |

---

### Display Disk Usage

```bash
df -h
```

| Option | Description |
|--------|-------------|
| `-h` | Human-readable disk sizes |

---

## AWK Processing

### CPU

Extracts:

- User CPU usage
- System CPU usage
- Idle CPU percentage

---

### Memory

Reads the second line of `free -h` and prints:

- Total Memory
- Used Memory
- Free Memory

---

### Disk

Checks every mounted filesystem.

If usage is **80% or higher**, it prints:

- Mount point
- Usage percentage

---

## Example

If the output of `df -h` is:

```text
Filesystem      Size Used Avail Use% Mounted on
/dev/sda1        40G  34G    6G  85% /
```

The script prints:

```text
/ -> 85%
```

---

## Use Cases

- Quick system health monitoring
- Linux server administration
- Routine maintenance checks
- Bash scripting practice
- System monitoring automation

---

## Requirements

- Bash
- top
- free
- df
- awk

These utilities are available by default on most Linux distributions.

---

## Suggested Filename

```text
system_health_check.sh
```
