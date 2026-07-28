# `extension_counter.py` — File Extension Counter

## Objective

Create a Python script that:

- Accepts a directory path and file extension.
- Searches recursively through all subdirectories.
- Displays the full path of every matching file.
- Counts the total number of matching files.
- Handles invalid directories.
- Accepts extensions with or without a leading dot.

---

## Source Code

Save the following script as `extension_counter.py`:

```python
import os
import sys

# Validate command-line arguments
if len(sys.argv) != 3:
    print(f"Usage: python3 {sys.argv[0]} <directory> <extension>")
    sys.exit(1)

directory = sys.argv[1]
extension = sys.argv[2].lstrip(".")

# Validate the directory
if not os.path.isdir(directory):
    print(f"Error: '{directory}' is not a valid directory.")
    sys.exit(1)

count = 0

# Search recursively through the directory
for root, directories, files in os.walk(directory):
    for filename in files:
        if filename.lower().endswith(f".{extension.lower()}"):
            full_path = os.path.join(root, filename)
            print(full_path)
            count += 1

print()
print(f"Total .{extension} files: {count}")
```

---

## Run the Script

```bash
python3 extension_counter.py /var/log log
```

The extension can also include a leading dot:

```bash
python3 extension_counter.py /var/log .log
```

Another example:

```bash
python3 extension_counter.py /home/user/Documents txt
```

---

## Example Output

```text
/var/log/app.log
/var/log/httpd/access.log

Total .log files: 2
```

---

## No Matching Files Output

```text
Total .csv files: 0
```

---

## Invalid Directory Output

```text
Error: '/invalid/path' is not a valid directory.
```

---

## Missing Arguments Output

```text
Usage: python3 extension_counter.py <directory> <extension>
```

---

## How It Works

1. `sys.argv` reads the directory and extension from the command line.
2. `lstrip(".")` removes an optional leading dot from the extension.
3. `os.path.isdir()` checks whether the supplied directory exists.
4. `os.walk()` recursively searches the directory and its subdirectories.
5. `endswith()` checks whether each filename matches the requested extension.
6. `os.path.join()` creates the complete path of each matching file.
7. The script displays every matching path and prints the total count.

---

## Python Features Used

| Feature | Purpose |
|---|---|
| `sys.argv` | Reads command-line arguments |
| `sys.exit()` | Stops the script with an exit status |
| `os.path.isdir()` | Validates the directory |
| `os.walk()` | Searches recursively through directories |
| `os.path.join()` | Creates a full file path |
| `lstrip(".")` | Removes the optional leading dot |
| `lower()` | Makes extension matching case-insensitive |
| `endswith()` | Checks the filename extension |

---

## Notes

- The directory search is recursive.
- Extension matching is case-insensitive.
- Both `log` and `.log` are accepted as valid extension inputs.
- The script only counts regular filenames returned by `os.walk()`.
- Permission-restricted directories may require elevated privileges.
