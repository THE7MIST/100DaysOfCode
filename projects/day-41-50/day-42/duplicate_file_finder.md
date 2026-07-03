# Duplicate File Finder using SHA-256

**Filename:** `duplicate_file_finder.py`

## Objective

Write a Python program that:

- Scans a directory and its subdirectories
- Computes the SHA-256 hash of each file
- Identifies duplicate files based on identical hashes
- Displays all duplicate file groups
- Reports if no duplicates are found

---

# Concepts Covered

- File handling
- Directory traversal (`os.walk`)
- Cryptographic hashing (`SHA-256`)
- Dictionaries
- Lists
- Exception handling
- Functions
- Input validation

---

# Python Script

```python
import os
import hashlib

def calculate_hash(file_path):
    """Return SHA-256 hash of a file."""
    sha256 = hashlib.sha256()

    try:
        with open(file_path, "rb") as file:
            while chunk := file.read(4096):
                sha256.update(chunk)
        return sha256.hexdigest()

    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return None


def find_duplicates(folder):
    hashes = {}

    for root, dirs, files in os.walk(folder):
        for filename in files:
            path = os.path.join(root, filename)

            file_hash = calculate_hash(path)

            if file_hash:
                hashes.setdefault(file_hash, []).append(path)

    duplicate_found = False

    for file_hash, file_list in hashes.items():
        if len(file_list) > 1:
            duplicate_found = True
            print("\nDuplicate Files:")
            for file in file_list:
                print(file)
            print("-" * 50)

    if not duplicate_found:
        print("No duplicate files found.")


folder_path = input("Enter folder path: ")

if os.path.exists(folder_path):
    find_duplicates(folder_path)
else:
    print("Invalid folder path.")
```

---

# Program Explanation

## `calculate_hash(file_path)`

Calculates the SHA-256 hash of a file.

### Working

- Opens the file in binary mode.
- Reads the file in 4096-byte chunks.
- Updates the SHA-256 hash object.
- Returns the hexadecimal hash value.
- Handles file read errors gracefully.

---

## `find_duplicates(folder)`

Searches the specified folder for duplicate files.

### Working

- Traverses all files using `os.walk()`.
- Computes the SHA-256 hash for each file.
- Stores hashes as dictionary keys.
- Groups files having identical hashes.
- Prints duplicate groups.

---

# Example Directory Structure

```
Documents/
│
├── report.pdf
├── copy_report.pdf
├── image.png
├── backup/
│   ├── report.pdf
│   └── notes.txt
```

---

# Example Output

```
Enter folder path: Documents

Duplicate Files:
/home/user/Documents/report.pdf
/home/user/Documents/copy_report.pdf
/home/user/Documents/backup/report.pdf
--------------------------------------------------
```

---

# Creating Test Files (Linux)

Create a test directory with duplicate files.

```bash
mkdir duplicate_test
cd duplicate_test

echo "Hello World" > file1.txt
cp file1.txt file2.txt
cp file1.txt file3.txt

echo "Python" > file4.txt
cp file4.txt file5.txt

echo "Unique File" > file6.txt
```

Directory structure:

```
duplicate_test/
├── file1.txt
├── file2.txt
├── file3.txt
├── file4.txt
├── file5.txt
└── file6.txt
```

Where:

- `file1.txt`, `file2.txt`, and `file3.txt` are duplicates.
- `file4.txt` and `file5.txt` are duplicates.
- `file6.txt` is unique.

---

# Creating Test Files (Windows Command Prompt)

```cmd
mkdir duplicate_test
cd duplicate_test

echo Hello World>file1.txt
copy file1.txt file2.txt
copy file1.txt file3.txt

echo Python>file4.txt
copy file4.txt file5.txt

echo Unique File>file6.txt
```

Run the program:

```bash
python duplicate_file_finder.py
```

Enter:

```
duplicate_test
```

---

# Sample Output

```
Enter folder path: duplicate_test

Duplicate Files:
./file1.txt
./file2.txt
./file3.txt
--------------------------------------------------

Duplicate Files:
./file4.txt
./file5.txt
--------------------------------------------------
```

---

# Time Complexity

| Operation | Complexity |
|----------|------------|
| Directory Traversal | O(n) |
| File Hashing | O(total file size) |
| Overall | O(n + total bytes read) |

Where:

- **n** = Number of files
- **total bytes read** = Combined size of all files

---

# Interview Follow-up

### How can this program be optimized?

A good answer is:

- Group files by file size first, since files with different sizes cannot be duplicates.
- Compute hashes only for files with identical sizes.
- For very large files, compare a small portion (such as the first 4 KB) before calculating the full hash.
- Use multithreading or multiprocessing to hash multiple files concurrently.
- Cache previously computed hashes when rescanning directories.

These optimizations significantly improve performance when scanning directories containing thousands of files.

---

# Advantages

- Uses SHA-256, which has an extremely low probability of collisions.
- Recursively scans subdirectories.
- Detects duplicates based on file content rather than filename.
- Handles read errors without terminating the program.
- Suitable for backup verification and storage cleanup.

---

# Limitations

- Computing SHA-256 for very large files can be time-consuming.
- Does not automatically delete duplicate files.
- Memory usage increases with the number of scanned files.
- Symbolic links and hard links are not handled separately.

---

# Applications

- Remove duplicate files
- Backup verification
- Digital forensics
- File integrity checking
- Storage optimization
- Data deduplication

---

# Result

The program successfully scans a directory, computes the SHA-256 hash of each file, identifies duplicate files based on identical hashes, and displays duplicate file groups while ignoring unique files.

---

# Conclusion

This project demonstrates how Python can automate duplicate file detection using SHA-256 hashing. It combines directory traversal, file handling, hashing, dictionaries, and exception handling to efficiently identify duplicate files based on their contents rather than filenames.
