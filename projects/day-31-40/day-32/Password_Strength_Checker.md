# Password Strength Checker Using Bash

## Objective

Create a Bash script that reads passwords from a file and classifies them as:

* WEAK
* NORMAL
* STRONG
* INVALID

based on password length and the presence of special characters.

---

# Script: `password_strn`

```bash
#!/bin/bash

read -p "Enter password file: " file

[ ! -f "$file" ] && { echo "File not found"; exit 1; }

while read -r password
do
    length=${#password}

    if [[ "$password" =~ [[:punct:]] ]]; then
        echo "$password -> STRONG"

    elif [[ $length -ge 1 && $length -le 7 && "$password" =~ ^[A-Za-z0-9]+$ ]]; then
        echo "$password -> WEAK"

    elif [[ $length -ge 8 && $length -le 12 && "$password" =~ ^[A-Za-z0-9]+$ ]]; then
        echo "$password -> NORMAL"

    else
        echo "$password -> INVALID"
    fi

done < "$file"
```

---

# Script Summary

This Bash script reads passwords from a file and classifies them based on length and the presence of special characters.

---

# Classification Rules

| Condition                                      | Result  |
| ---------------------------------------------- | ------- |
| Contains any special character (`[[:punct:]]`) | STRONG  |
| Length 1–7 and only letters/numbers            | WEAK    |
| Length 8–12 and only letters/numbers           | NORMAL  |
| Anything else                                  | INVALID |

---

# Key Commands

### Read Filename

```bash
read -p "Enter password file: " file
```

Prompts the user to enter the password file.

---

### Check File Exists

```bash
[ ! -f "$file" ] && { echo "File not found"; exit 1; }
```

Checks whether the specified file exists.

---

### Calculate Password Length

```bash
length=${#password}
```

Stores the length of the password.

---

### Detect Special Characters

```bash
[[ "$password" =~ [[:punct:]] ]]
```

Returns true if the password contains special characters such as:

```text
@ # $ % ^ & * ! _ - +
```

---

### Validate Alphanumeric Passwords

```bash
[[ "$password" =~ ^[A-Za-z0-9]+$ ]]
```

Ensures the password contains only letters and numbers.

---

# Test File: `passwd.txt`

```text
abc
hello12
admin
root123
password
welcome1
abcd1234
hello2024
user12345
testuser12
Admin123
Password99
abc@123
root#2024
hello!
Admin@123
Pass$word
Test_123
1234567890123
abcdefg@
A1b2C3!
```

---

# Classification Output

## WEAK

```text
abc
hello12
admin
root123
```

---

## NORMAL

```text
password
welcome1
abcd1234
hello2024
user12345
testuser12
Admin123
Password99
```

---

## STRONG

```text
abc@123
root#2024
hello!
Admin@123
Pass$word
Test_123
abcdefg@
A1b2C3!
```

---

## INVALID

```text
1234567890123
```

---

# Example Output

```text
abc -> WEAK
hello12 -> WEAK
password -> NORMAL
Admin123 -> NORMAL
abc@123 -> STRONG
Pass$word -> STRONG
1234567890123 -> INVALID
```

---

# Suggested Filename

```text
password_strength_checker.sh
```

---

# Limitation

A password such as:

```text
a@
```

will be classified as:

```text
STRONG
```

because the script only checks for the presence of special characters.

It does **not** verify:

* Minimum length requirements
* Uppercase letters
* Lowercase letters
* Digits
* Modern password complexity rules

A production-grade password validator would include these additional checks.

---

# Result

The Bash script successfully reads passwords from a file and classifies them as WEAK, NORMAL, STRONG, or INVALID using regular expressions, string length evaluation, and special character detection.
