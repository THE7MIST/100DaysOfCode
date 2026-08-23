````markdown
# Windows Failed Login Detector Using Python

A small **System Administration / Blue Team Python script** that checks Windows Security Event Logs for recent failed login attempts.

Windows records failed authentication attempts using **Event ID 4625**. This script uses Python to execute a PowerShell command and retrieve the five most recent events.

---

## Python Script

Save the following as:

`failed_login_detector.py`

```python
import subprocess

cmd = [
    "powershell",
    "-Command",
    "Get-WinEvent -FilterHashtable @{LogName='Security';Id=4625} -MaxEvents 5 | Select TimeCreated,Message"
]

result = subprocess.run(cmd, capture_output=True, text=True)

if result.stdout:
    print("⚠ Recent Failed Login Attempts:\n")
    print(result.stdout)
else:
    print("✓ No failed logins found.")
````

---

## How It Works

### 1. Import subprocess

```python
import subprocess
```

The `subprocess` module allows Python to execute external programs and commands.

Here, Python uses it to execute **PowerShell**.

---

### 2. Create the PowerShell Command

```python
cmd = [
    "powershell",
    "-Command",
    "Get-WinEvent -FilterHashtable @{LogName='Security';Id=4625} -MaxEvents 5 | Select TimeCreated,Message"
]
```

The important command is:

```powershell
Get-WinEvent -FilterHashtable @{LogName='Security';Id=4625} -MaxEvents 5
```

It searches:

* Log: `Security`
* Event ID: `4625`
* Maximum results: `5`

**Event ID 4625** represents a failed Windows logon attempt.

The command then selects:

```powershell
TimeCreated,Message
```

This displays when the event occurred and its associated information.

---

### 3. Execute PowerShell

```python
result = subprocess.run(cmd, capture_output=True, text=True)
```

`subprocess.run()` executes the command.

* `capture_output=True` captures the PowerShell output.
* `text=True` returns the result as readable text.

The output is stored in:

```python
result.stdout
```

---

### 4. Check the Results

```python
if result.stdout:
```

If failed-login events were returned, the script displays:

```text
⚠ Recent Failed Login Attempts:
```

followed by the event information.

If nothing is returned:

```python
else:
    print("✓ No failed logins found.")
```

Output:

```text
✓ No failed logins found.
```

---

## Running in VS Code

Open the VS Code terminal and run:

```powershell
python failed_login_detector.py
```

For access to the Windows **Security** log, you may need to run VS Code or the terminal with **Administrator privileges**.

---

## Example Output

When no recent failed login events are found:

```text
✓ No failed logins found.
```

When events exist:

```text
⚠ Recent Failed Login Attempts:

TimeCreated          Message
-----------          -------
8/24/2026 01:20 AM   An account failed to log on...
```

---

## Why This Is Useful

This demonstrates a basic combination of:

* Python automation
* Windows administration
* Windows Event Logs
* Authentication monitoring
* PowerShell integration
* Blue Team security concepts

It can later be extended into a small **brute-force detection tool** by counting repeated failed authentication attempts and generating an alert when a threshold is exceeded.

---

## Security Concept

**Windows Event ID 4625**

> An account failed to log on.

Security monitoring platforms and SIEM systems can use these authentication events to identify repeated failures and potentially suspicious login activity.

```
```
