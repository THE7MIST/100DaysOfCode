# `old_logs.sh` — Old Log File Cleaner

## Objective

Create a Bash script that:

- Accepts a directory path.
- Finds all `.log` files older than 7 days.
- Displays the matching files before deletion.
- Requests confirmation before deleting them.
- Handles an invalid directory.
- Cancels safely when the user does not confirm.

---

## Source Code

Save the following script as `old_logs.sh`:

```bash
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

if [ ! -d "$directory" ]; then
    echo "Error: '$directory' is not a valid directory."
    exit 1
fi

files=$(find "$directory" -type f -name "*.log" -mtime +7 2>/dev/null)

if [ -z "$files" ]; then
    echo "No .log files older than 7 days found."
    exit 0
fi

echo "Old log files:"
echo "$files"

echo
read -p "Delete these files? (y/n): " choice

if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    find "$directory" -type f -name "*.log" -mtime +7 -delete 2>/dev/null
    echo "Old log files deleted."
else
    echo "Deletion cancelled."
fi
```

---

## Make the Script Executable

```bash
chmod +x old_logs.sh
```

---

## Run the Script

```bash
./old_logs.sh /var/log
```

For a protected directory, use:

```bash
sudo ./old_logs.sh /var/log
```

---

## Example Output

```text
Old log files:
/var/log/app-old.log
/var/log/test.log

Delete these files? (y/n): y
Old log files deleted.
```

---

## Cancellation Output

```text
Old log files:
/var/log/app-old.log
/var/log/test.log

Delete these files? (y/n): n
Deletion cancelled.
```

---

## Invalid Directory Output

```text
Error: '/invalid/path' is not a valid directory.
```

---

## No Matching Files Output

```text
No .log files older than 7 days found.
```

---

## How It Works

1. The script checks that exactly one directory argument was provided.
2. It verifies that the supplied path is a valid directory.
3. `find` searches recursively for `.log` files older than 7 days.
4. The matching file paths are displayed.
5. `read` asks the user to confirm deletion.
6. If the user enters `y` or `Y`, the files are deleted.
7. Any other response cancels the operation.

---

## Commands Used

| Command | Purpose |
|---|---|
| `find` | Searches recursively for matching log files |
| `-type f` | Restricts results to regular files |
| `-name "*.log"` | Matches files ending in `.log` |
| `-mtime +7` | Matches files modified more than 7 days ago |
| `read -p` | Prompts the user for confirmation |
| `-delete` | Deletes the matching files |
| `if` | Controls validation and confirmation logic |

---

## Notes

- The search is recursive.
- `-mtime +7` means files whose age has crossed more than seven complete 24-hour periods.
- Always review the displayed paths before confirming deletion.
- Use `sudo` only when the target directory requires elevated permissions.
