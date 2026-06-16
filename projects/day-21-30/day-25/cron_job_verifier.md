# Cron Job Verifier (Bash Script)

## Aim

Create a Bash script that:

- Lists all cron jobs of the current user
- Checks whether a specific cron job exists

---

## Script

```bash
#!/bin/bash

echo "=== Current User Cron Jobs ==="
crontab -l

echo
read -p "Enter job keyword to search: " job

if crontab -l | grep -q "$job"
then
    echo "Cron job found."
else
    echo "Cron job not found."
fi
```

---

## Explanation

| Command | Purpose |
|----------|---------|
| `crontab -l` | Lists current user's cron jobs |
| `read -p` | Takes input from user |
| `grep -q` | Searches silently for a keyword |
| `if ... then` | Checks condition |
| `echo` | Displays output |

---

## Save Script

```bash
nano cronUser.sh
```

Paste the script and save.

Make executable:

```bash
chmod +x cronUser.sh
```

Run:

```bash
bash cronUser.sh
```

or

```bash
./cronUser.sh
```

---

## Sample Cron Job

Add a cron job:

```bash
crontab -e
```

Example:

```text
0 2 * * * /home/adi/backup.sh
```

View:

```bash
crontab -l
```

Output:

```text
0 2 * * * /home/adi/backup.sh
```

---

## Sample Output 1

```text
=== Current User Cron Jobs ===

0 2 * * * /home/adi/backup.sh

Enter job keyword to search: adi

Cron job found.
```

---

## Sample Output 2

```text
=== Current User Cron Jobs ===

0 2 * * * /home/adi/backup.sh

Enter job keyword to search: root

Cron job not found.
```

---

## Result

Successfully listed the current user's cron jobs and verified whether a specified cron job exists using Bash scripting.
