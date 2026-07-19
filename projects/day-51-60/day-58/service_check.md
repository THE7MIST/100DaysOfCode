# `service_check.sh`

## Objective

A Bash script that:

- Accepts a systemd service name as an argument.
- Checks whether the service exists.
- Displays whether the service is running or stopped.
- Attempts to start the service if it is stopped.
- Verifies whether the service started successfully.
- Handles missing or invalid service names.

---

## Source Code

```bash
#!/bin/bash

# Check whether a service name was provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

service="$1"

# Add .service when not provided
if [[ "$service" != *.service ]]; then
    service="${service}.service"
fi

# Check whether the service exists
if ! systemctl list-unit-files --type=service --all |
    awk '{print $1}' |
    grep -Fxq "$service"; then

    echo "Error: Service '$service' does not exist."
    exit 1
fi

# Check whether the service is running
if systemctl is-active --quiet "$service"; then
    echo "$service is running."
else
    echo "$service is stopped."
    echo "Attempting to start $service..."

    systemctl start "$service"

    # Verify whether it started successfully
    if systemctl is-active --quiet "$service"; then
        echo "$service started successfully."
    else
        echo "Error: Failed to start $service."
        exit 1
    fi
fi
```

---

## Make Executable

```bash
chmod +x service_check.sh
```

---

## Run

For SSH service:

```bash
sudo ./service_check.sh sshd
```

For Apache on CentOS/RHEL:

```bash
sudo ./service_check.sh httpd
```

For Apache on Ubuntu/Debian:

```bash
sudo ./service_check.sh apache2
```

---

## Example Output

### Service Running

```text
sshd.service is running.
```

---

### Service Stopped

```text
sshd.service is stopped.
Attempting to start sshd.service...
sshd.service started successfully.
```

---

### Invalid Service

```text
Error: Service 'abcservice.service' does not exist.
```

---

## How It Works

### 1. Validate Input

Ensures exactly one service name is provided.

```bash
if [ $# -ne 1 ]; then
```

---

### 2. Normalize Service Name

Automatically appends `.service` if it is omitted.

```bash
if [[ "$service" != *.service ]]; then
    service="${service}.service"
fi
```

---

### 3. Verify Service Exists

Checks the list of available systemd services.

```bash
systemctl list-unit-files --type=service --all
```

---

### 4. Check Service Status

Determines whether the service is currently active.

```bash
systemctl is-active --quiet "$service"
```

---

### 5. Start Service if Stopped

Attempts to start the service.

```bash
systemctl start "$service"
```

---

### 6. Verify Startup

Confirms whether the service started successfully.

```bash
systemctl is-active --quiet "$service"
```

---

## Commands Used

| Command | Purpose |
|---------|---------|
| `systemctl list-unit-files` | Verify that the service exists |
| `systemctl is-active` | Check whether the service is running |
| `systemctl start` | Start the service |
| `awk` | Extract service names |
| `grep -Fxq` | Match the exact service name |

---

## Notes

- Automatically accepts service names with or without the `.service` suffix.
- Requires `sudo` privileges when starting or managing system services.
- Works on Linux systems using **systemd**.
- Useful for basic service monitoring and administration tasks.
