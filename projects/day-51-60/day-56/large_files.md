# `large_files.sh`

## Objective

A Bash script that:

- Accepts a directory path as an argument.
- Finds all files larger than **100 MB**.
- Displays each file's size and full path.
- Sorts the output from largest to smallest.
- Handles invalid or missing directory arguments.

---

## Source Code

```bash
#!/bin/bash

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIR="$1"

# Check if directory exists
if [ ! -d "$DIR" ]; then
    echo "Error: '$DIR' is not a valid directory."
    exit 1
fi

# Find files larger than 100 MB, display size and path, sort descending
find "$DIR" -type f -size +100M -exec du -h {} + 2>/dev/null | sort -hr
```

---

## Make Executable

```bash
chmod +x large_files.sh
```

---

## Run

```bash
./large_files.sh /var/log
```

or

```bash
bash large_files.sh /var/log
```

---

## Why No Output?

The script only lists files **larger than 100 MB**.

Current largest files in `/var/log`:

```text
5.1M   /var/log/anaconda/journal.log
3.3M   /var/log/messages-20260629
3.3M   /var/log/messages-20260619
3.1M   /var/log/audit/audit.log
2.4M   /var/log/anaconda/syslog
```

Since none exceed **100 MB**, the script correctly produces no output.

---

## Verify

Check for files larger than 100 MB:

```bash
find /var/log -type f -size +100M -ls
```

View the largest files regardless of size:

```bash
find /var/log -type f -exec du -h {} + 2>/dev/null | sort -hr | head
```

---

## Testing

Create a temporary file larger than 100 MB:

```bash
truncate -s 101M /tmp/test-large.log
```

Run the script:

```bash
./large_files.sh /tmp
```

Expected output:

```text
101M    /tmp/test-large.log
```

Remove the test file:

```bash
rm /tmp/test-large.log
```

---

## Notes

- `-size +100M` matches files **strictly larger than 100 MiB**.
- `find` searches recursively.
- `du -h` displays human-readable sizes.
- `sort -hr` sorts results from largest to smallest.
- `2>/dev/null` suppresses permission-related error messages.
