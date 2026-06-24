# Bash Special Variables and Expansions Demo

## Objective

Demonstrate commonly used Bash special variables, environment variables, command substitution, arithmetic expansion, exit status, background processes, and argument handling.

---

# Script: `doller`

```bash
#!/bin/bash

echo "===== Script Information ====="

echo "Script Name      : $0"
echo "Total Arguments  : $#"
echo "All Arguments    : $@"
echo "Current PID      : $$"
echo "Parent PID       : $PPID"

echo

echo "===== Arguments ====="

echo "First Argument   : $1"
echo "Second Argument  : $2"

echo

echo "===== Variables ====="

name="Adi"
age=22

echo "Name             : $name"
echo "Age              : $age"

echo

echo "===== Environment Variables ====="

echo "User             : $USER"
echo "Home Directory   : $HOME"
echo "Current Directory: $PWD"

echo

echo "===== Command Substitution ====="

today=$(date)

echo "Current Date     : $today"

echo

echo "===== Arithmetic Expansion ====="

sum=$((10 + 20))

echo "10 + 20 = $sum"

echo

echo "===== Exit Status ====="

ls /tmp > /dev/null

echo "Exit Status of ls : $?"

echo

echo "===== Background Process ====="

sleep 30 &
echo "Background PID    : $!"

echo

echo "===== Last Argument ====="

mkdir -p demo/test

echo "Last Argument Used: $_"
```

---

# Important Bash Variables

| Variable | Meaning                           |
| -------- | --------------------------------- |
| `$0`     | Script name                       |
| `$1`     | First argument                    |
| `$2`     | Second argument                   |
| `$#`     | Number of arguments               |
| `$@`     | All arguments                     |
| `$$`     | Current script PID                |
| `$PPID`  | Parent process PID                |
| `$?`     | Exit status of previous command   |
| `$!`     | PID of last background process    |
| `$_`     | Last argument of previous command |

---

# Environment Variables

| Variable | Description               |
| -------- | ------------------------- |
| `$USER`  | Current username          |
| `$HOME`  | User home directory       |
| `$PWD`   | Present working directory |

---

# Command Substitution

## Syntax

```bash
$(command)
```

Example:

```bash
today=$(date)
```

Stores command output into a variable.

---

# Arithmetic Expansion

## Syntax

```bash
$((expression))
```

Example:

```bash
sum=$((10 + 20))
```

Output:

```text
10 + 20 = 30
```

---

# Exit Status

Every command returns an exit code.

```bash
echo $?
```

Common values:

| Exit Code | Meaning |
| --------- | ------- |
| 0         | Success |
| Non-zero  | Error   |

Example:

```bash
ls /tmp > /dev/null
echo $?
```

Output:

```text
0
```

---

# Background Process

Run a command in the background:

```bash
sleep 30 &
```

Get its PID:

```bash
echo $!
```

Example:

```text
Background PID : 4521
```

---

# Last Argument Variable

Example:

```bash
mkdir -p demo/test
echo $_
```

Output:

```text
demo/test
```

`$_` stores the last argument of the previously executed command.

---

# Sample Output

```text
===== Script Information =====

Script Name      : doller
Total Arguments  : 0
All Arguments    :
Current PID      : 4518
Parent PID       : 4003

===== Arguments =====

First Argument   :
Second Argument  :

===== Variables =====

Name             : Adi
Age              : 22

===== Environment Variables =====

User             : root
Home Directory   : /root
Current Directory: /root/abc/edf/qwer

===== Command Substitution =====

Current Date     : Wednesday 24 June 2026

===== Arithmetic Expansion =====

10 + 20 = 30

===== Exit Status =====

Exit Status of ls : 0

===== Background Process =====

Background PID    : 4521

===== Last Argument =====

Last Argument Used: demo/test
```

---

# Learning Outcomes

After completing this script, you will understand:

* Positional parameters
* Special Bash variables
* Environment variables
* Command substitution
* Arithmetic expansion
* Exit status codes
* Background jobs
* Process IDs
* Argument handling

---

# Suggested Filename

```text
bash_special_variables_demo.sh
```
