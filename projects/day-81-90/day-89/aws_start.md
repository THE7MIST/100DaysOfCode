# AWS EC2 Start Automation Using PowerShell

## Overview

This PowerShell script automates a small AWS administration task:

1. Verify that the AWS CLI session is authenticated.
2. Find stopped EC2 instances in a specified AWS Region.
3. Start all stopped instances automatically.
4. Exit safely if authentication fails or no stopped instances exist.

This is useful for learning **AWS CLI + PowerShell automation** from a cloud/system-administration perspective.

---

## PowerShell Script

Save the file as:

```text
aws_start_all.ps1
```

### Code

```powershell
$region = "ap-south-1"

Write-Host "Checking AWS login..." -ForegroundColor Cyan

aws sts get-caller-identity

if ($LASTEXITCODE -ne 0) {
    Write-Host "AWS authentication failed. Login/configure AWS CLI first." -ForegroundColor Red
    exit 1
}

Write-Host "`nFinding stopped EC2 instances..." -ForegroundColor Cyan

$ids = aws ec2 describe-instances `
    --region $region `
    --filters "Name=instance-state-name,Values=stopped" `
    --query "Reservations[].Instances[].InstanceId" `
    --output text

if ($ids -and $ids -ne "None") {

    Write-Host "Starting: $ids" -ForegroundColor Yellow

    aws ec2 start-instances `
        --instance-ids ($ids -split "\s+") `
        --region $region

    Write-Host "`nStart request sent." -ForegroundColor Green

}
else {
    Write-Host "No stopped EC2 instances found." -ForegroundColor Yellow
}
```

---

# How It Works

## 1. Set AWS Region

```powershell
$region = "ap-south-1"
```

The variable specifies the AWS Region where the script searches for EC2 instances.

---

## 2. Verify AWS Authentication

```powershell
aws sts get-caller-identity
```

AWS STS returns information about the identity currently being used by the AWS CLI.

If the session has expired, the command fails.

The script checks the exit code:

```powershell
if ($LASTEXITCODE -ne 0)
```

A non-zero exit code indicates that authentication failed.

---

## 3. Authenticate Again if Required

In my test, the existing AWS session had expired:

```text
[ERROR]: Your session has expired. Please reauthenticate.
```

I authenticated again using:

```powershell
aws login
```

After successful authentication, running:

```powershell
aws sts get-caller-identity
```

returned the AWS identity information successfully.

> **Security note:** Account IDs, User IDs, ARNs, and other identifying AWS information should be redacted before sharing screenshots publicly.

---

## 4. Find Stopped EC2 Instances

The script runs:

```powershell
aws ec2 describe-instances `
    --region $region `
    --filters "Name=instance-state-name,Values=stopped" `
    --query "Reservations[].Instances[].InstanceId" `
    --output text
```

### Breakdown

**`describe-instances`**

Retrieves EC2 instance information.

**Filter**

```text
Name=instance-state-name,Values=stopped
```

Only instances currently in the `stopped` state are selected.

**JMESPath Query**

```text
Reservations[].Instances[].InstanceId
```

Extracts only the EC2 instance IDs.

**Output**

```text
--output text
```

Returns a simple text result that PowerShell can process.

---

## 5. Check Whether Instances Were Found

```powershell
if ($ids -and $ids -ne "None")
```

The script proceeds only when stopped EC2 instance IDs are returned.

---

## 6. Start the Instances

```powershell
aws ec2 start-instances `
    --instance-ids ($ids -split "\s+") `
    --region $region
```

The instance IDs returned by AWS CLI are split into individual values:

```powershell
($ids -split "\s+")
```

They are then passed to `start-instances`.

---

## 7. No Stopped Instances

If there are no stopped instances, the script prints:

```text
No stopped EC2 instances found.
```

In my test run, authentication succeeded but there were currently **no stopped EC2 instances**, so no start operation was required.

---

# Running the Script

PowerShell execution policy may prevent local scripts from running.

For the current PowerShell process only:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

Then execute:

```powershell
.\aws_start_all.ps1
```

---

# Execution Flow

```text
Start Script
     |
     v
Check AWS Authentication
     |
     +---- Failed ----> Exit
     |
     v
Search for Stopped EC2 Instances
     |
     +---- None ----> Display Message
     |
     v
Extract Instance IDs
     |
     v
Start EC2 Instances
     |
     v
Display Result
```

---

# AWS Services and Tools Used

| Component | Purpose |
|---|---|
| PowerShell | Automation and control flow |
| AWS CLI | Communicates with AWS |
| AWS STS | Verifies current AWS identity |
| Amazon EC2 | Provides compute instances |
| JMESPath | Extracts instance IDs from AWS CLI output |

---

# What This Demonstrates

This small automation exercise covers:

- AWS CLI authentication
- AWS STS identity verification
- EC2 instance discovery
- EC2 state filtering
- JMESPath queries
- PowerShell variables
- Exit-code checking
- Conditional execution
- AWS administration automation

---

## Result

The workflow successfully:

```text
Expired AWS Session
        ↓
AWS Login
        ↓
Authentication Verified
        ↓
EC2 Instances Checked
        ↓
No Stopped Instances Found
```

The same script will automatically send a start request whenever stopped EC2 instances are detected in the configured region.
