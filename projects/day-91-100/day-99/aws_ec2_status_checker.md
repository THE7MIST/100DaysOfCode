# AWS EC2 Status Checker Using Lambda

## Day 99 - AWS + Python Automation

A serverless Python project that uses **AWS Lambda + Boto3** to retrieve information about EC2 instances.

The project can be created, deployed, and tested directly from the **AWS Console using a mobile phone**, without AWS CLI or CloudShell.

---

## AWS Lambda Function

**Function Name:**

```text
EC2-Status-Checker
```

**Runtime:**

```text
Python 3.x
```

**Region:**

```text
ap-south-1
```

---

## Python Code

File inside Lambda:

```text
lambda_function.py
```

```python
import boto3

ec2 = boto3.client("ec2", region_name="ap-south-1")

def lambda_handler(event, context):

    response = ec2.describe_instances()

    instances = []

    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:

            name = "Unnamed"

            for tag in instance.get("Tags", []):
                if tag["Key"] == "Name":
                    name = tag["Value"]

            instances.append({
                "Name": name,
                "InstanceId": instance["InstanceId"],
                "State": instance["State"]["Name"],
                "PrivateIP": instance.get("PrivateIpAddress", "N/A"),
                "PublicIP": instance.get("PublicIpAddress", "N/A")
            })

    return {
        "InstanceCount": len(instances),
        "Instances": instances
    }
```

---

## Test Event

**Test Event Name:**

```text
TestEC2Status
```

**Event JSON:**

```json
{}
```

The function does not require input parameters, so an empty JSON object is sufficient.

---

## Required IAM Permission

The Lambda execution role needs permission to describe EC2 instances.

A least-privilege policy for this project is:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    }
  ]
}
```

`Resource: "*"` is required because the `DescribeInstances` EC2 API action does not support resource-level permissions.

---

## How It Works

```text
Mobile Phone
     |
     v
AWS Console
     |
     v
AWS Lambda
     |
     | boto3
     v
EC2 API
     |
     v
DescribeInstances
     |
     v
Instance Information
```

The Lambda function:

1. Creates an EC2 client using Boto3.
2. Calls `describe_instances()`.
3. Iterates through returned EC2 instances.
4. Finds the `Name` tag when available.
5. Collects the instance ID and current state.
6. Retrieves private and public IP addresses.
7. Returns the information as structured output.

---

## Example Result

```json
{
  "InstanceCount": 1,
  "Instances": [
    {
      "Name": "WebServer",
      "InstanceId": "i-xxxxxxxxxxxxxxxxx",
      "State": "running",
      "PrivateIP": "172.31.10.20",
      "PublicIP": "13.x.x.x"
    }
  ]
}
```

---

## AWS Services Used

- AWS Lambda
- Amazon EC2
- AWS IAM
- Boto3
- AWS Console

---

## Concepts Demonstrated

- Python automation
- AWS SDK for Python (Boto3)
- Serverless computing
- AWS API interaction
- IAM permissions
- EC2 administration
- Cloud automation
- Mobile cloud administration

---

## Security

The Lambda function only requires:

```text
ec2:DescribeInstances
```

It does not need permission to:

```text
Start instances
Stop instances
Terminate instances
Create instances
Modify instances
```

This follows the AWS **principle of least privilege**.

---

## Project Summary

This project demonstrates how Python code running inside AWS Lambda can communicate directly with AWS EC2 APIs through Boto3.

The entire workflow can be managed from a mobile browser:

```text
Write Python
      ↓
Deploy Lambda
      ↓
Run Test Event
      ↓
Call EC2 API
      ↓
Receive Instance Status
```

No local Python installation, AWS CLI, SSH session, or CloudShell environment is required.
