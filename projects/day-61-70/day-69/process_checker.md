# `process_checker.py` — Process Checker

## Objective

Create a Python script that:

- Accepts a process name as a command-line argument.
- Checks whether the process is currently running.
- Displays the PID and command name of every matching process.
- Handles a missing process name.
- Returns exit code `1` when the process is not running.
- Returns exit code `0` when at least one matching process is found.

---

## Source Code

Save the following script as `process_checker.py`:

```python
import subprocess
import sys

if len(sys.argv) != 2:
    print(f"Usage: python3 {sys.argv[0]} <process-name>")
    sys.exit(1)

process_name = sys.argv[1]

result = subprocess.run(
    ["ps", "-eo", "pid,comm"],
    capture_output=True,
    text=True
)

found = False

for line in result.stdout.splitlines()[1:]:
    parts = line.split(maxsplit=1)

    if len(parts) != 2:
        continue

    pid, command = parts

    if command == process_name:
        print(f"PID: {pid}")
        print(f"Process: {command}")
        print()
        found = True

if not found:
    print(f"Process '{process_name}' is not running.")
    sys.exit(1)
```

---

## Run the Script

```bash
python3 process_checker.py sshd
```

---

## Example Output

```text
PID: 1024
Process: sshd
```

If multiple processes have the same command name, all matching processes are displayed:

```text
PID: 1024
Process: sshd

PID: 2048
Process: sshd
```

---

## Process Not Running Output

```text
Process 'nginx' is not running.
```

The script exits with status code `1`.

---

## Missing Argument Output

```text
Usage: python3 process_checker.py <process-name>
```

---

## How It Works

### 1. Validate the Argument

```python
if len(sys.argv) != 2:
```

The script expects exactly one user-supplied argument: the process name.

If the argument is missing or more than one argument is supplied, the script displays the correct usage and exits.

---

### 2. Store the Process Name

```python
process_name = sys.argv[1]
```

The first command-line argument is stored in the `process_name` variable.

---

### 3. Run the `ps` Command

```python
result = subprocess.run(
    ["ps", "-eo", "pid,comm"],
    capture_output=True,
    text=True
)
```

The script runs:

```bash
ps -eo pid,comm
```

This command lists all running processes with their PID and command name.

| Option | Meaning |
|---|---|
| `-e` | Displays all running processes |
| `-o` | Specifies the output columns |
| `pid` | Displays the process ID |
| `comm` | Displays the executable command name |

`capture_output=True` stores the command output.

`text=True` returns the output as text instead of bytes.

---

### 4. Skip the Header

```python
for line in result.stdout.splitlines()[1:]:
```

The first line contains the headings:

```text
PID COMMAND
```

The script skips this line and processes the remaining entries.

---

### 5. Split Each Process Entry

```python
parts = line.split(maxsplit=1)
```

Each line is divided into:

- PID
- Command name

Using `maxsplit=1` ensures that the line is split into no more than two parts.

---

### 6. Compare the Command Name

```python
if command == process_name:
```

The script performs an exact comparison between the running command and the supplied process name.

For example:

```bash
python3 process_checker.py sshd
```

matches:

```text
sshd
```

but does not match:

```text
sshd-helper
```

---

### 7. Track Matching Processes

```python
found = True
```

The Boolean variable `found` records whether at least one matching process was detected.

---

### 8. Return the Exit Code

```python
if not found:
    sys.exit(1)
```

The script exits with:

| Exit code | Meaning |
|---:|---|
| `0` | At least one matching process is running |
| `1` | Missing argument or process not running |

---

## Check the Exit Code

Run the script:

```bash
python3 process_checker.py sshd
```

Then check the exit status:

```bash
echo $?
```

Possible results:

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
| `sys.argv` | Reads the process name from the command line |
| `subprocess.run()` | Executes the Linux `ps` command |
| `capture_output=True` | Captures standard output and error |
| `text=True` | Returns command output as text |
| `splitlines()` | Splits output into individual lines |
| `split(maxsplit=1)` | Separates PID and command |
| Boolean variable | Tracks whether a match was found |
| `sys.exit()` | Returns an operating-system exit code |

---

## Notes

- The script is designed for Linux and Unix-like systems.
- Process-name matching is case-sensitive.
- The script compares the executable name, not the complete command-line arguments.
- Multiple matching processes are all displayed.
- Process names must match the `comm` column exactly.
- The script can be used in monitoring scripts, cron jobs, or automation pipelines.
