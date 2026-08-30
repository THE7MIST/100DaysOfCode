# Day 100 AWS Security Auditor

## Overview

For Day 100 of the 100 Days of Code challenge, I built a Python based AWS Security Auditor.

The script connects to AWS using Boto3 and performs basic security checks across:

- EC2
- S3
- IAM

It identifies potentially risky configurations and reports them with severity levels.

---

## Script Name

```text
day100_aws_security_auditor.py
```

---

## Python Code

```python
import boto3
from datetime import datetime, timezone

REGION = "ap-south-1"

ec2 = boto3.client("ec2", region_name=REGION)
s3 = boto3.client("s3")
iam = boto3.client("iam")

findings = []

print("=" * 55)
print("       DAY 100 AWS SECURITY AUDITOR")
print("=" * 55)


def finding(severity, service, resource, issue):
    findings.append({
        "severity": severity,
        "service": service,
        "resource": resource,
        "issue": issue
    })


# EC2 SECURITY GROUP CHECK

print("\n[+] Auditing EC2 Security Groups...")

groups = ec2.describe_security_groups()["SecurityGroups"]

for sg in groups:
    for rule in sg.get("IpPermissions", []):
        for ip_range in rule.get("IpRanges", []):

            if ip_range.get("CidrIp") != "0.0.0.0/0":
                continue

            start = rule.get("FromPort")
            end = rule.get("ToPort")

            if start is None:

                finding(
                    "CRITICAL",
                    "EC2",
                    sg["GroupId"],
                    "All traffic exposed to 0.0.0.0/0"
                )

            elif start <= 22 <= end:

                finding(
                    "HIGH",
                    "EC2",
                    sg["GroupId"],
                    "SSH port 22 exposed to Internet"
                )

            elif start <= 3389 <= end:

                finding(
                    "HIGH",
                    "EC2",
                    sg["GroupId"],
                    "RDP port 3389 exposed to Internet"
                )


# S3 PUBLIC ACCESS CHECK

print("[+] Auditing S3 buckets...")

for bucket in s3.list_buckets()["Buckets"]:

    name = bucket["Name"]

    try:

        config = s3.get_public_access_block(
            Bucket=name
        )["PublicAccessBlockConfiguration"]

        if not all(config.values()):

            finding(
                "HIGH",
                "S3",
                name,
                "Public Access Block is not fully enabled"
            )

    except s3.exceptions.NoSuchPublicAccessBlockConfiguration:

        finding(
            "HIGH",
            "S3",
            name,
            "Public Access Block not configured"
        )

    except Exception as error:

        finding(
            "UNKNOWN",
            "S3",
            name,
            f"Could not evaluate bucket: {error}"
        )


# IAM MFA CHECK

print("[+] Auditing IAM MFA...")

users = iam.list_users()["Users"]

for user in users:

    username = user["UserName"]

    devices = iam.list_mfa_devices(
        UserName=username
    )["MFADevices"]

    if not devices:

        finding(
            "HIGH",
            "IAM",
            username,
            "MFA not enabled"
        )


# IAM ACCESS KEY AGE CHECK

print("[+] Auditing IAM access keys...")

for user in users:

    username = user["UserName"]

    keys = iam.list_access_keys(
        UserName=username
    )["AccessKeyMetadata"]

    for key in keys:

        if key["Status"] != "Active":
            continue

        age = (
            datetime.now(timezone.utc)
            - key["CreateDate"]
        ).days

        if age > 90:

            finding(
                "MEDIUM",
                "IAM",
                username,
                f"Active access key is {age} days old"
            )


# SECURITY REPORT

print("\n" + "=" * 55)
print("                 SECURITY REPORT")
print("=" * 55)

if not findings:

    print("\n[PASS] No configured checks produced findings.")

else:

    order = {
        "CRITICAL": 0,
        "HIGH": 1,
        "MEDIUM": 2,
        "UNKNOWN": 3
    }

    findings.sort(
        key=lambda x: order.get(x["severity"], 99)
    )

    for number, item in enumerate(findings, 1):

        print(f"\nFinding #{number}")
        print(f"Severity : {item['severity']}")
        print(f"Service  : {item['service']}")
        print(f"Resource : {item['resource']}")
        print(f"Issue    : {item['issue']}")

print("\n" + "-" * 55)
print(f"Total Findings: {len(findings)}")
print("-" * 55)
```

---

## Install Dependencies

```powershell
python -m pip install boto3
```

If AWS CLI login credentials are being used with Boto3:

```powershell
python -m pip install "botocore[crt]"
```

---

## AWS Authentication

Login to AWS:

```powershell
aws login
```

Verify authentication:

```powershell
aws sts get-caller-identity
```

Set the region:

```powershell
$env:AWS_REGION="ap-south-1"
$env:AWS_DEFAULT_REGION="ap-south-1"
```

---

## Run the Auditor

```powershell
python day100_aws_security_auditor.py
```

---

## Checks Performed

### EC2 Security Groups

The script checks for:

```text
SSH port 22 exposed to 0.0.0.0/0
RDP port 3389 exposed to 0.0.0.0/0
All traffic exposed to 0.0.0.0/0
```

Example finding:

```text
Finding #1
Severity : HIGH
Service  : EC2
Resource : sg-xxxxxxxxxxxxxxxxx
Issue    : SSH port 22 exposed to Internet
```

---

### S3 Security

The script checks whether S3 Public Access Block is fully enabled.

Potential finding:

```text
Severity : HIGH
Service  : S3
Issue    : Public Access Block is not fully enabled
```

---

### IAM MFA

The script checks IAM users for MFA devices.

Potential finding:

```text
Severity : HIGH
Service  : IAM
Issue    : MFA not enabled
```

---

### IAM Access Key Age

Active IAM access keys older than 90 days are flagged.

Example:

```text
Severity : MEDIUM
Service  : IAM
Issue    : Active access key is 145 days old
```

---

## Example Output

```text
=======================================================
       DAY 100 AWS SECURITY AUDITOR
=======================================================

[+] Auditing EC2 Security Groups...
[+] Auditing S3 buckets...
[+] Auditing IAM MFA...
[+] Auditing IAM access keys...

=======================================================
                 SECURITY REPORT
=======================================================

Finding #1
Severity : HIGH
Service  : EC2
Resource : sg-xxxxxxxxxxxxxxxxx
Issue    : SSH port 22 exposed to Internet

Finding #2
Severity : HIGH
Service  : EC2
Resource : sg-xxxxxxxxxxxxxxxxx
Issue    : SSH port 22 exposed to Internet

-------------------------------------------------------
Total Findings: 2
-------------------------------------------------------
```

---

## Architecture

```text
Python Script
     |
     v
Boto3
     |
     v
AWS APIs
     |
     +----------------+
     |        |       |
     v        v       v
    EC2      S3      IAM
     |        |       |
     +--------+-------+
              |
              v
      Security Findings
              |
              v
        Console Report
```

---

## Security Concepts Used

- Cloud security posture assessment
- EC2 security group auditing
- Public exposure detection
- S3 security configuration
- IAM MFA verification
- Access key hygiene
- Severity classification
- AWS API automation
- Boto3
- Python security automation

---

## Important Note

The auditor is read only.

It detects security issues but does not automatically modify, delete, stop, terminate, or remediate AWS resources.

Security group IDs and other AWS identifiers should be masked before posting screenshots publicly.

Example:

```text
sg-xxxxxxxxxxxxxxxxx
```

Do not publish:

```text
AWS account IDs
Access key IDs
Secret access keys
Session tokens
IAM credentials
Full ARNs containing sensitive account information
```

---

## Day 100 Summary

This project combines:

```text
Python
AWS
Boto3
EC2
S3
IAM
Cloud Security
Security Automation
```

It demonstrates how a small Python script can inspect real AWS configuration and convert infrastructure data into actionable security findings.
