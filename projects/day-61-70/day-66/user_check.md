# `user_check.sh` — User Account Checker

## Objective

Create a Bash script that:

- Accepts a username as an argument.
- Checks whether the user exists.
- Displays the user’s UID.
- Displays the user’s home directory.
- Displays the user’s login shell.
- Checks whether the user is currently logged in.
- Handles a missing or invalid username.

---

## Source Code

Save the following script as `user_check.sh`:

```bash
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username="$1"

if ! id "$username" >/dev/null 2>&1; then
    echo "Error: User '$username' does not exist."
    exit 1
fi

user_info=$(getent passwd "$username")

uid=$(echo "$user_info" | awk -F: '{print $3}')
home=$(echo "$user_info" | awk -F: '{print $6}')
shell=$(echo "$user_info" | awk -F: '{print $7}')

echo "Username: $username"
echo "UID: $uid"
echo "Home: $home"
echo "Shell: $shell"

if who | awk '{print $1}' | grep -Fxq "$username"; then
    echo "Status: Logged in"
else
    echo "Status: Not logged in"
fi
