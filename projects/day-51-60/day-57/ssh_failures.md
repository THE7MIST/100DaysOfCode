# `ssh_failures.sh`

## Objective

A Bash script that:

- Accepts an authentication log file as an argument.
- Finds all failed SSH login attempts.
- Extracts the source IP addresses.
- Counts failed attempts from each IP.
- Sorts results from highest to lowest.
- Displays only IPs with **3 or more** failed attempts.
- Handles missing or invalid log-file arguments.

---

## Source Code

```bash
#!/bin/bash

# Check whether a log-file argument was provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <authentication-log-file>"
    exit 1
fi

log_file="$1"

# Check whether the file exists and is readable
if [ ! -r "$log_file" ]; then
    echo "Error: '$log_file' does not exist or is not readable."
    exit 1
fi

# Find failed SSH attempts, extract IPs, count and sort them
grep "Failed password" "$log_file" |
awk '{
    for (i = 1; i <= NF; i++) {
        if ($i == "from") {
            print $(i + 1)
        }
    }
}' |
sort |
uniq -c |
sort -nr |
awk '$1 >= 3 {
    printf "%d attempts\t%s\n", $1, $2
}'
```

---

## Make Executable

```bash
chmod +x ssh_failures.sh
```

---

## Run

```bash
./ssh_failures.sh /var/log/secure
```

If the authentication log requires elevated privileges:

```bash
sudo ./ssh_failures.sh /var/log/secure
```

---

## Example Output

```text
15 attempts    192.168.1.50
8 attempts     10.10.10.25
3 attempts     172.16.0.7
```

---

## How It Works

### 1. Validate Input

Ensures exactly one log-file argument is provided.

```bash
if [ $# -ne 1 ]; then
```

---

### 2. Validate Log File

Checks whether the specified file exists and is readable.

```bash
if [ ! -r "$log_file" ]; then
```

---

### 3. Find Failed SSH Logins

Searches for lines containing failed SSH password attempts.

```bash
grep "Failed password" "$log_file"
```

---

### 4. Extract Source IP Addresses

Uses `awk` to locate the word `from` and print the following field, which contains the source IP.

Example log:

```text
Failed password for invalid user root from 192.168.1.50 port 22 ssh2
```

Extracted:

```text
192.168.1.50
```

---

### 5. Count Attempts

Sorts IP addresses and counts duplicate occurrences.

```bash
sort | uniq -c
```

---

### 6. Sort by Highest Count

Displays IPs with the highest number of failed attempts first.

```bash
sort -nr
```

---

### 7. Filter Results

Displays only IP addresses with three or more failed login attempts.

```bash
awk '$1 >= 3'
```

---

## Commands Used

| Command | Purpose |
|---------|---------|
| `grep` | Find failed SSH login entries |
| `awk` | Extract IP addresses and format output |
| `sort` | Sort IP addresses and counts |
| `uniq -c` | Count occurrences of each IP |
| `sort -nr` | Sort numerically in descending order |

---

## Notes

- Works with authentication logs containing SSH failure messages.
- Automatically ignores IPs with fewer than three failed attempts.
- Handles invalid or unreadable log files gracefully.
- Useful for quickly identifying possible SSH brute-force attacks.
