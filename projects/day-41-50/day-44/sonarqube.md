# Deploying SonarQube and Scanning a Vulnerable Repository


## Objective

Deploy SonarQube using Docker and perform static code analysis on the **Damn Vulnerable Python Web Application (DVPWA)** repository.

---

# Tasks

1. Deploy SonarQube Dashboard
2. Access the SonarQube Dashboard
3. Prepare the Vulnerable Repository
4. Create a SonarQube Project
5. Generate an Authentication Token
6. Set Up and Run SonarScanner
7. Review Scan Results

---


---

# Part 1: Deploy SonarQube

## Pull SonarQube Image

```bash
docker pull sonarqube
```

---

## Create Docker Network

```bash
docker network create sonar-network
```

---

## Deploy PostgreSQL Database

```bash
docker run -d \
  --name sonarqube-db \
  --network sonar-network \
  -e POSTGRES_USER=sonar \
  -e POSTGRES_PASSWORD=sonar \
  -e POSTGRES_DB=sonarqube \
  postgres:alpine
```

### Database Configuration

| Parameter | Value |
|-----------|-------|
| Database | sonarqube |
| Username | sonar |
| Password | sonar |

---

## Deploy SonarQube

```bash
docker run -d \
  --name sonarqube \
  --network sonar-network \
  -p 9000:9000 \
  -e SONAR_JDBC_URL=jdbc:postgresql://sonarqube-db:5432/sonarqube \
  -e SONAR_JDBC_USERNAME=sonar \
  -e SONAR_JDBC_PASSWORD=sonar \
  sonarqube
```

---

## Verify Containers

```bash
docker ps
```

---

## Verify Network Interface

```bash
ip -br a
```

---

# Access SonarQube Dashboard

Open:

```text
http://localhost:9000
```

Default Credentials

| Username | Password |
|----------|----------|
| admin | admin |

---

## Change Default Password

Example:

```text
Admin@123456789
```

After changing the password, the SonarQube dashboard appears.

---

# Part 2: Prepare the Vulnerable Repository

Clone the DVPWA repository.

```bash
git clone https://github.com/anxolerd/dvpwa.git
```

Move into the project directory.

```bash
cd dvpwa
```

Verify the repository contents.

```bash
ls -la
```

Expected files include:

```text
app.py
config.py
requirements.txt
templates/
static/
```

---

# Part 3: Create a SonarQube Project

## Step 1

Open the dashboard.

```text
http://localhost:9000
```

Login using the administrator account.

---

## Step 2

Create a new project.

Navigation:

```text
Projects
    ↓
Create Project
```

or

```text
Create New Project
```

---

## Step 3

Enter Project Details.

| Field | Value |
|-------|-------|
| Project Display Name | DVPWA |
| Project Key | dvpwa |

Click:

```text
Set Up
```

---

## Step 4

Select Project Type.

Choose:

```text
Custom
```

Then choose:

```text
Locally
```

---

# Part 4: Generate Authentication Token

SonarQube will prompt for a token.

Example

```text
Token Name:
scanner-token
```

Click

```text
Generate
```

Example generated token:

```text
sqp_xxxxxxxxxxxxxxxxxxxxxxxxx
```

Example:

```text
sqp_961148e6ee44eede4e4e1b4a4d6af0ad23ff060a
```

> **Important:** Copy the token immediately. SonarQube displays it only once.

---

# Step 5: Select Language

Choose

```text
Python
```

Then choose

```text
Other (SonarScanner)
```

SonarQube displays example scanner commands.

You can close this page because the scanner will be configured manually.

---

# Option 1: Using PySonar

Install PySonar.

```bash
pip install pysonar
```

Run the scan.

```bash
pysonar \
  --sonar-host-url=http://localhost:9000 \
  --sonar-token=sqp_961148e6ee44eede4e4e1b4a4d6af0ad23ff060a \
  --sonar-project-key=dvpwa
```

---

# Option 2: Using SonarScanner Docker Image

Pull the scanner image.

```bash
docker pull sonarsource/sonar-scanner-cli:latest
```

Run the scanner.

```bash
docker run --rm \
  --network host \
  -v $(pwd):/usr/src \
  sonarsource/sonar-scanner-cli \
  -Dsonar.projectKey=dvpwa \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=YOUR_TOKEN
```

Replace:

```text
YOUR_TOKEN
```

with the authentication token generated from SonarQube.

---

# Part 5: Run the Scan

After the scanner completes successfully, open the dashboard.

Project:

```text
dvpwa
```

or directly open:

```text
http://localhost:9000/dashboard?id=dvpwa
```

---

# Part 6: Review Scan Results

If the dashboard displays:

```text
Processing
```

wait approximately:

```text
30–60 seconds
```

Refresh the page.

The analysis results will then appear.

---

# Information Available on Dashboard

The dashboard displays:

- Bugs
- Vulnerabilities
- Security Hotspots
- Code Smells
- Duplicated Code
- Coverage
- Maintainability Rating
- Reliability Rating
- Security Rating
- Technical Debt
- Overall Quality Gate Status

---

# Useful Commands

Pull SonarQube

```bash
docker pull sonarqube
```

Create Network

```bash
docker network create sonar-network
```

Run PostgreSQL

```bash
docker run -d \
--name sonarqube-db \
--network sonar-network \
-e POSTGRES_USER=sonar \
-e POSTGRES_PASSWORD=sonar \
-e POSTGRES_DB=sonarqube \
postgres:alpine
```

Run SonarQube

```bash
docker run -d \
--name sonarqube \
--network sonar-network \
-p 9000:9000 \
-e SONAR_JDBC_URL=jdbc:postgresql://sonarqube-db:5432/sonarqube \
-e SONAR_JDBC_USERNAME=sonar \
-e SONAR_JDBC_PASSWORD=sonar \
sonarqube
```

Check Running Containers

```bash
docker ps
```

Check IP Address

```bash
ip -br a
```

Clone Repository

```bash
git clone https://github.com/anxolerd/dvpwa.git
```

Enter Repository

```bash
cd dvpwa
```

List Files

```bash
ls -la
```

Install PySonar

```bash
pip install pysonar
```

Run PySonar

```bash
pysonar \
--sonar-host-url=http://localhost:9000 \
--sonar-token=YOUR_TOKEN \
--sonar-project-key=dvpwa
```

Pull SonarScanner

```bash
docker pull sonarsource/sonar-scanner-cli:latest
```

Run SonarScanner

```bash
docker run --rm \
--network host \
-v $(pwd):/usr/src \
sonarsource/sonar-scanner-cli \
-Dsonar.projectKey=dvpwa \
-Dsonar.sources=. \
-Dsonar.host.url=http://localhost:9000 \
-Dsonar.token=YOUR_TOKEN
```

Open Dashboard

```text
http://localhost:9000
```

Project Dashboard

```text
http://localhost:9000/dashboard?id=dvpwa
```

---

# Workflow Summary

```text
Pull SonarQube Image
        ↓
Create Docker Network
        ↓
Deploy PostgreSQL
        ↓
Deploy SonarQube
        ↓
Open Dashboard
        ↓
Change Default Password
        ↓
Clone DVPWA Repository
        ↓
Create SonarQube Project
        ↓
Generate Authentication Token
        ↓
Install SonarScanner / PySonar
        ↓
Run Static Code Analysis
        ↓
Open Project Dashboard
        ↓
Review Bugs, Vulnerabilities, Code Smells and Security Issues
```
