# Environment Checker Script

**Filename:** `check_environment.sh`

## Objective

Verify that the system environment is ready for deploying a PKI-based HTTPS infrastructure.

The script checks:

- Root privileges
- Operating system compatibility
- Required and optional commands
- Apache service status
- Open ports
- Internet connectivity
- DNS resolution
- Apache SSL module
- Existing certificates
- Output directory
- Apache configuration
- Disk space
- Memory
- Overall deployment readiness

---

# Script Overview

This script performs a series of pre-deployment validation checks before running the PKI HTTPS deployment scripts.

It automatically reports:

- PASS
- WARN
- FAIL

for each validation step and exits with an appropriate status code.

---

# Features

- Root privilege verification
- Operating system detection
- Required command validation
- Optional tool detection
- Apache service verification
- Port availability checks
- Internet connectivity test
- DNS resolution verification
- SSL module verification
- Existing certificate detection
- Output directory validation
- Apache configuration testing
- Disk space information
- Memory information
- Deployment readiness summary

---

# Script Structure

```text
check_environment.sh
│
├── Color Definitions
├── Status Counters
├── Helper Functions
│
├── Root Check
├── Operating System Check
├── Required Commands Check
├── Optional Commands Check
├── Apache Service Check
├── Port Check
├── Internet Connectivity Check
├── DNS Check
├── Apache SSL Module Check
├── Existing Certificate Check
├── Output Directory Check
├── Apache Configuration Test
├── Disk Space Check
├── Memory Information
│
└── Summary Report
```

---

# Status Indicators

The script prints results using four status levels.

| Status | Meaning |
|---------|----------|
| PASS | Requirement satisfied |
| WARN | Non-critical issue detected |
| FAIL | Critical issue requiring attention |
| INFO | Informational message |

---

# Root Privilege Check

Checks whether the script is executed with administrative privileges.

Example

```bash
sudo ./check_environment.sh
```

If executed without root privileges, the script reports:

```text
[FAIL] Run this script using sudo.
```

---

# Operating System Detection

Reads:

```text
/etc/os-release
```

Displays the detected Linux distribution.

Supported distributions include:

- Ubuntu
- Debian

Other Linux distributions generate a warning.

---

# Required Commands Check

The script verifies the availability of the following commands:

| Command | Purpose |
|----------|----------|
| openssl | Certificate generation |
| apache2 | Apache Web Server |
| apachectl | Apache management |
| curl | HTTP requests |
| ping | Connectivity testing |
| getent | DNS resolution |
| systemctl | Service management |
| update-ca-certificates | Trust store updates |
| a2enmod | Enable Apache modules |
| a2ensite | Enable Apache sites |
| a2dissite | Disable Apache sites |

Missing commands generate FAIL messages.

---

# Optional Commands Check

Checks for:

| Command | Purpose |
|----------|----------|
| nslookup | DNS lookup |
| dig | Advanced DNS queries |

Missing optional commands generate WARN messages instead of failures.

---

# Apache Service Check

Verifies whether Apache is currently running.

Uses:

```bash
systemctl is-active apache2
```

Possible results:

```text
PASS
```

or

```text
WARN
```

---

# Port Availability Check

Checks whether Apache is listening on:

- Port 80 (HTTP)
- Port 443 (HTTPS)

Uses:

```bash
ss -tln
```

---

# Internet Connectivity Check

Tests Internet access by pinging Google's public DNS server.

```bash
ping -c 1 8.8.8.8
```

If reachable:

```text
PASS
```

Otherwise:

```text
WARN
```

---

# DNS Resolution Check

Verifies DNS functionality.

Uses:

```bash
getent hosts google.com
```

Successful lookup indicates working DNS resolution.

---

# Apache SSL Module Check

Checks whether the SSL module is enabled.

Command:

```bash
apache2ctl -M
```

Looks for:

```text
ssl_module
```

If not enabled:

```text
WARN
```

---

# Existing Certificate Check

Searches for previously generated certificates.

Files checked:

- root.crt
- sub.crt
- server.crt
- fullchain.crt

Existing files generate warning messages to prevent accidental overwriting.

---

# Output Directory Check

If:

```text
config.sh
```

exists, the script loads it and verifies whether the configured output directory already exists.

Possible outcomes:

- Output directory available
- Output directory already exists
- config.sh missing

---

# Apache Configuration Test

Runs:

```bash
apachectl configtest
```

Verifies that the Apache configuration contains no syntax errors before deployment.

---

# Disk Space Check

Displays available disk space using:

```bash
df -h /
```

Example:

```text
Available Space : 28G
```

---

# Memory Information

Displays current memory usage.

Uses:

```bash
free -h
```

Shows:

- Total RAM
- Used RAM
- Free RAM
- Buffers
- Cache
- Swap

---

# Summary Report

After completing all checks, the script prints a summary.

Example:

```text
===========================================================
SUMMARY
===========================================================

PASS : 24
WARN : 2
FAIL : 0
```

---

# Exit Status

If no failures are detected:

```text
Environment is ready for deployment.
```

Exit code:

```text
0
```

If one or more failures exist:

```text
Please resolve the failures before deploying.
```

Exit code:

```text
1
```

---

# Expected Workflow

```text
Start
   │
   ▼
Root Check
   │
   ▼
Operating System Check
   │
   ▼
Required Commands
   │
   ▼
Optional Commands
   │
   ▼
Apache Service
   │
   ▼
Port Verification
   │
   ▼
Internet Connectivity
   │
   ▼
DNS Resolution
   │
   ▼
Apache SSL Module
   │
   ▼
Certificate Check
   │
   ▼
Output Directory Check
   │
   ▼
Apache Configuration Test
   │
   ▼
Disk Space
   │
   ▼
Memory Information
   │
   ▼
Summary Report
   │
   ▼
Deployment Ready
```

---

# Result

The script successfully validates the deployment environment by checking operating system compatibility, required software, Apache configuration, network connectivity, DNS functionality, SSL support, and system resources before starting the PKI HTTPS deployment.

---

# Conclusion

`check_environment.sh` serves as a comprehensive pre-deployment validation tool. By automatically identifying missing dependencies, configuration issues, and system readiness, it helps prevent deployment failures and ensures a stable environment for PKI-based HTTPS infrastructure setup.
