# `recent_files.sh`

## Objective

A Bash script that:

- Accepts a directory path as an argument.
- Finds all files modified within the last **24 hours**.
- Displays each file's modification time and full path.
- Shows the total number of matching files.
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

echo "Files modified in the last 24 hours:"
echo

find "$directory" -type f -mtime -1 \
    -printf "%TY-%Tm-%Td %TH:%TM:%TS %p\n" 2>/dev/null

count=$(find "$directory" -type f -mtime -1 2>/dev/null | wc -l)

echo
echo "Total recent files: $count"
```

---

## Make Executable

```bash
chmod +x recent_files.sh
```

---

## Run

Example:

```bash
./recent_files.sh /var/log
```

---

## Example Output

```text
Files modified in the last 24 hours:

2026-07-25 10:30:12.0000000000 /var/log/messages
2026-07-25 09:15:40.0000000000 /var/log/secure

Total recent files: 2
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

### 3. Find Recently Modified Files

Recursively searches for files modified within the last **24 hours**.

```bash
find "$directory" -type f -mtime -1
```

---

### 4. Display Modification Time

Formats and prints the modification timestamp along with the full file path.

```bash
-printf "%TY-%Tm-%Td %TH:%TM:%TS %p\n"
```

---

### 5. Count Matching Files

Counts the total number of recently modified files.

```bash
find "$directory" -type f -mtime -1 | wc -l
```

---

## Commands Used

| Command | Purpose |
|---------|---------|
| `find` | Recursively search for files |
| `-mtime -1` | Match files modified within the last 24 hours |
| `-printf` | Display formatted modification time and file path |
| `wc -l` | Count the number of matching files |
| `if` | Validate user input and directory |
| `exit` | Exit with an appropriate status code |

---

## Notes

- `-mtime -1` matches files modified within the previous **24 hours**.
- `-printf` formats the output without requiring additional commands.
- Searches recursively through all subdirectories.
- `2>/dev/null` suppresses permission-related error messages during the search.
