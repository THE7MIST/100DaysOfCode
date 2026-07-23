# `empty_files.sh`

## Objective

A Bash script that:

- Accepts a directory path as an argument.
- Finds all empty files recursively.
- Displays the full path of each empty file.
- Shows the total number of empty files.
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

# Display all empty files
find "$directory" -type f -empty 2>/dev/null

# Count empty files
count=$(find "$directory" -type f -empty 2>/dev/null | wc -l)

echo
echo "Total empty files: $count"
```

---

## Make Executable

```bash
chmod +x empty_files.sh
```

---

## Run

Example:

```bash
./empty_files.sh /var/log
```

---

## Example Output

```text
/var/log/test.log
/var/log/old/empty.txt

Total empty files: 2
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

### 3. Find Empty Files

Recursively searches for regular files that are empty.

```bash
find "$directory" -type f -empty
```

---

### 4. Count Empty Files

Counts the total number of empty files found.

```bash
find "$directory" -type f -empty | wc -l
```

---

## Commands Used

| Command | Purpose |
|---------|---------|
| `find` | Recursively search for empty regular files |
| `-type f` | Match only regular files |
| `-empty` | Match files with zero bytes |
| `wc -l` | Count the number of matching files |
| `if` | Validate user input and directory |
| `exit` | Exit with an appropriate status code |

---

## Notes

- Searches recursively through all subdirectories.
- Displays the full path of every empty file found.
- Counts only **regular empty files** (`-type f -empty`).
- `2>/dev/null` suppresses permission-related error messages during the search.
