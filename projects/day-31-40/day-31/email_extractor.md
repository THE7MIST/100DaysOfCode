# Email Extractor Script

## Objective

Write a Bash script that:

* Accepts a filename from the user
* Extracts valid email addresses
* Removes duplicate entries
* Displays unique email addresses

---

## Bash Script

```bash
#!/bin/bash

read -p "Enter filename: " file

if [ ! -f "$file" ]; then
    echo "File not found!"
    exit 1
fi

echo "Unique email addresses:"

grep -Eo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$file" | sort -u
```

---

## Explanation

### Read Filename

```bash
read -p "Enter filename: " file
```

Prompts the user to enter the filename.

---

### Check File Exists

```bash
if [ ! -f "$file" ]; then
    echo "File not found!"
    exit 1
fi
```

Verifies that the specified file exists.

---

### Extract Email Addresses

```bash
grep -Eo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$file"
```

Options used:

| Option | Meaning                      |
| ------ | ---------------------------- |
| `-E`   | Extended Regular Expressions |
| `-o`   | Print only matching text     |

---

### Remove Duplicates

```bash
sort -u
```

* Sorts email addresses alphabetically
* Removes duplicate entries

---

## Sample Input File

Create a file named `emails.txt`

```text
Contact us at support@example.com for assistance.

Sales team:
sales@company.com
marketing@company.com

Duplicate emails:
support@example.com
SALES@company.com

Invalid emails:
user@
@test.com
abc.com
john#mail.com

Personal contacts:
john.doe@gmail.com
alice_smith123@yahoo.co.in
admin@linux.org
security-team@cdac.in
```

---

## Run the Script

```bash
chmod +x email_extractor.sh

./email_extractor.sh
```

Input:

```text
emails.txt
```

---

## Expected Output

```text
SALES@company.com
admin@linux.org
alice_smith123@yahoo.co.in
john.doe@gmail.com
marketing@company.com
sales@company.com
security-team@cdac.in
support@example.com
```

---

## Case-Insensitive Duplicate Removal

To treat:

```text
sales@company.com
SALES@company.com
```

as the same email:

```bash
grep -iEo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$file" | tr '[:upper:]' '[:lower:]' | sort -u
```

---

## Result

The script successfully extracts valid email addresses from a file and displays only unique entries using `grep` and `sort`.
