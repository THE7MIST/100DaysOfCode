# `backup.sh` — Compressed Backup Script

## Objective

Create a Bash script that:

- Accepts a source directory and a backup directory.
- Creates a compressed `.tar.gz` backup.
- Adds the current date and time to the backup filename.
- Handles an invalid source directory.
- Creates the backup directory when it does not exist.
- Reports whether the backup succeeded or failed.

---

## Source Code

Save the following script as `backup.sh`:

```bash
#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <source-directory> <backup-directory>"
    exit 1
fi

source_dir="$1"
backup_dir="$2"

if [ ! -d "$source_dir" ]; then
    echo "Error: '$source_dir' is not a valid directory."
    exit 1
fi

mkdir -p "$backup_dir"

folder_name=$(basename "$source_dir")
timestamp=$(date +"%Y-%m-%d_%H%M")
backup_file="$backup_dir/${folder_name}_${timestamp}.tar.gz"

tar -czf "$backup_file" -C "$(dirname "$source_dir")" "$folder_name"

if [ $? -eq 0 ]; then
    echo "Backup created:"
    echo "$backup_file"
else
    echo "Error: Backup failed."
    exit 1
fi
```

---

## Make the Script Executable

```bash
chmod +x backup.sh
```

---

## Run the Script

```bash
./backup.sh /home/user/project /home/user/backups
```

---

## Example Output

```text
Backup created:
/home/user/backups/project_2026-07-27_0215.tar.gz
```

---

## Invalid Source Directory Output

```text
Error: '/home/user/missing-project' is not a valid directory.
```

---

## Missing Arguments Output

```text
Usage: ./backup.sh <source-directory> <backup-directory>
```

---

## Backup Failure Output

```text
Error: Backup failed.
```

---

## How It Works

1. The script verifies that exactly two arguments were supplied.
2. It checks whether the source directory exists.
3. `mkdir -p` creates the backup directory when required.
4. `basename` extracts the source folder name.
5. `date` generates a timestamp in `YYYY-MM-DD_HHMM` format.
6. `tar -czf` creates a gzip-compressed archive.
7. The script checks the exit status of `tar`.
8. It prints the generated backup path when successful.

---

## Commands Used

| Command | Purpose |
|---|---|
| `mkdir -p` | Creates the backup directory if it does not exist |
| `basename` | Extracts the final directory name from a path |
| `dirname` | Extracts the parent directory from a path |
| `date` | Generates the current date and time |
| `tar -czf` | Creates a gzip-compressed tar archive |
| `$?` | Stores the exit status of the previous command |
| `if` | Controls validation and success handling |

---

## Understanding the `tar` Command

```bash
tar -czf "$backup_file" -C "$(dirname "$source_dir")" "$folder_name"
```

| Option | Meaning |
|---|---|
| `-c` | Creates a new archive |
| `-z` | Compresses the archive using gzip |
| `-f` | Specifies the archive filename |
| `-C` | Changes directory before adding files to the archive |

Using `-C` prevents the archive from storing the complete absolute source path.

---

## Notes

- The backup filename contains the source folder name and current timestamp.
- Running the script multiple times produces separate timestamped backups.
- Existing backup files are not deleted automatically.
- The user must have read permission for the source directory.
- The user must have write permission for the backup directory.
- Use `sudo` only when the source or destination requires elevated permissions.
