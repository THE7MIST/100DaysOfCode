# `file_count.sh`

## Objective

A Bash script that:

- Accepts a directory path as an argument.
- Counts the total number of regular files.
- Includes files inside all subdirectories.
- Handles missing or invalid directory arguments.

---

## Source Code

```bash
#!/bin/bash

# Check whether a directory argument was provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

# Check whether the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: '$directory' is not a valid directory."
    exit 1
fi

# Count all regular files recursively
count=$(find "$directory" -type f 2>/dev/null | wc -l)

echo "Total files: $count"
```

---

## Make Executable

```bash
chmod +x file_count.sh
```

---

## Run

Example:

```bash
./file_count.sh /var/log
```

---

## Example Output

```text
Total files: 42
```

---

## Invalid Directory

```text
Error: '/invalid/path' is not a valid directory.
```

---

## How It Works

### 1. Validate Input

Ensures exactly one directory argument is provided.

```bash
if [ $# -ne 1 ]; then
```

---

### 2. Validate Directory

Checks whether the supplied path exists and is a directory.

```bash
if [ ! -d "$directory" ]; then
```

---

### 3. Count Files

Recursively searches for all regular files and counts them.

```bash
find "$directory" -type f
```

---

### 4. Count Results

Counts the number of matching files.

```bash
wc -l
```

---

## Commands Used

| Command | Purpose |
|---------|---------|
| `find` | Recursively search for regular files |
| `wc -l` | Count the number of matching files |
| `if` | Validate user input and directory |
| `exit` | Exit with an appropriate status code |

---

## Notes

- Counts **only regular files** (`-type f`).
- Includes files inside all nested subdirectories.
- Does not count directories, symbolic links, or special files.
- `2>/dev/null` suppresses permission-related error messages during the search.
