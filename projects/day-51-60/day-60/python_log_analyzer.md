# `python_log_analyzer.sh`

## Objective

A Bash script that:

- Accepts a Python application log file as an argument.
- Checks whether the log file exists and is readable.
- Counts the total occurrences of:
  - `ERROR`
  - `WARNING`
  - `CRITICAL`
- Displays the five most recent `ERROR` and `CRITICAL` log entries.
- Returns exit code **1** when at least one `CRITICAL` error is found.
- Handles missing or invalid log-file arguments.

---

## Source Code

```bash
#!/bin/bash

# Check argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log-file>"
    exit 1
fi

log_file="$1"

# Check whether the file exists and is readable
if [ ! -r "$log_file" ]; then
    echo "Error: '$log_file' does not exist or is not readable."
    exit 1
fi

# Count log levels
error_count=$(grep -c "ERROR" "$log_file")
warning_count=$(grep -c "WARNING" "$log_file")
critical_count=$(grep -c "CRITICAL" "$log_file")

echo "ERROR: $error_count"
echo "WARNING: $warning_count"
echo "CRITICAL: $critical_count"

echo
echo "Recent errors:"

grep -E "ERROR|CRITICAL" "$log_file" | tail -n 5

# Return exit code 1 if CRITICAL errors exist
if [ "$critical_count" -gt 0 ]; then
    exit 1
fi

exit 0
```

---

## Make Executable

```bash
chmod +x python_log_analyzer.sh
```

---

## Run

```bash
./python_log_analyzer.sh app.log
```

---

## Example Output

```text
ERROR: 12
WARNING: 7
CRITICAL: 2

Recent errors:
2026-07-21 10:18:05 ERROR Database connection failed
2026-07-21 10:19:41 ERROR Failed to authenticate user
2026-07-21 10:20:11 CRITICAL Application stopped
2026-07-21 10:21:30 ERROR Unable to write log file
2026-07-21 10:22:31 CRITICAL Service terminated
```

---

## Invalid File

```text
Error: 'app.log' does not exist or is not readable.
```

---

## Exit Status

Check the exit code after execution:

```bash
echo $?
```

| Exit Code | Meaning |
|-----------|---------|
| `0` | No `CRITICAL` errors found |
| `1` | One or more `CRITICAL` errors found |

---

## How It Works

### 1. Validate Input

Ensures exactly one log file is provided.

```bash
if [ $# -ne 1 ]; then
```

---

### 2. Validate Log File

Checks that the log file exists and is readable.

```bash
if [ ! -r "$log_file" ]; then
```

---

### 3. Count Log Levels

Counts occurrences of each log level.

```bash
grep -c "ERROR" "$log_file"
grep -c "WARNING" "$log_file"
grep -c "CRITICAL" "$log_file"
```

---

### 4. Display Recent Errors

Shows the last five `ERROR` or `CRITICAL` log entries.

```bash
grep -E "ERROR|CRITICAL" "$log_file" | tail -n 5
```

---

### 5. Return Exit Status

Returns exit code `1` if any `CRITICAL` log entries are found.

```bash
if [ "$critical_count" -gt 0 ]; then
    exit 1
fi
```

---

## Commands Used

| Command | Purpose |
|---------|---------|
| `grep -c` | Count matching log entries |
| `grep -E` | Match multiple log levels using a regular expression |
| `tail` | Display the five most recent matching log entries |
| `if` | Validate input and determine exit status |
| `exit` | Return the appropriate exit code |

---

## Notes

- Supports any plain-text Python application log.
- Reports counts for `ERROR`, `WARNING`, and `CRITICAL`.
- Displays only the five most recent `ERROR` and `CRITICAL` entries.
- Returns exit code `1` whenever at least one `CRITICAL` entry is detected, making it suitable for monitoring scripts and CI/CD pipelines.
