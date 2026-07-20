# `process_check.sh`

## Objective

A Bash script that:

- Accepts a process name as an argument.
- Checks whether the process is currently running.
- Displays the PID and memory usage of each running instance.
- Displays all matching processes if multiple instances exist.
- Handles missing process-name arguments.
- Returns exit code **1** when the process is not running.

---

## Source Code

```bash
#!/bin/bash

# Check whether process name is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <process-name>"
    exit 1
fi

process="$1"

# Find process IDs
pids=$(pgrep -x "$process")

if [ -z "$pids" ]; then
    echo "Process '$process' is not running."
    exit 1
fi

echo "Process '$process' is running:"
echo

for pid in $pids; do
    memory_kb=$(ps -p "$pid" -o rss=)
    memory_mb=$(awk "BEGIN {printf \"%.2f\", $memory_kb / 1024}")

    echo "PID: $pid"
    echo "Memory: $memory_mb MB"
    echo "--------------------"
done
```

---

## Make Executable

```bash
chmod +x process_check.sh
```

---

## Run

Example:

```bash
./process_check.sh sshd
```

---

## Example Output

### Process Running

```text
Process 'sshd' is running:

PID: 1024
Memory: 8.25 MB
--------------------
```

---

### Multiple Instances

```text
Process 'sshd' is running:

PID: 1024
Memory: 8.25 MB
--------------------
PID: 1150
Memory: 6.10 MB
--------------------
```

---

### Process Not Running

```text
Process 'nginx' is not running.
```

Exit status:

```bash
echo $?
1
```

---

## How It Works

### 1. Validate Input

Ensures exactly one process name is provided.

```bash
if [ $# -ne 1 ]; then
```

---

### 2. Find Matching Processes

Uses `pgrep` to search for processes with the exact name.

```bash
pgrep -x "$process"
```

---

### 3. Check Process Availability

If no matching process is found, an error message is displayed and the script exits with status code `1`.

```bash
if [ -z "$pids" ]; then
```

---

### 4. Retrieve Memory Usage

Obtains the Resident Set Size (RSS) in kilobytes.

```bash
ps -p "$pid" -o rss=
```

---

### 5. Convert Memory to MB

Uses `awk` to convert kilobytes into megabytes with two decimal places.

```bash
awk "BEGIN {printf \"%.2f\", $memory_kb / 1024}"
```

---

### 6. Display Process Information

Prints the PID and memory usage for every matching process.

```text
PID: 1024
Memory: 8.25 MB
```

---

## Commands Used

| Command | Purpose |
|---------|---------|
| `pgrep -x` | Find processes by exact name |
| `ps` | Retrieve process memory usage |
| `awk` | Convert memory from KB to MB |
| `if` | Validate input and process status |

---

## Notes

- Supports multiple running instances of the same process.
- Returns exit code **1** when the process is not running.
- Uses RSS (Resident Set Size) to report physical memory usage.
- Useful for basic Linux process monitoring and scripting tasks.
