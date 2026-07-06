# Nagios XI Monitoring Lab

## Objective

Deploy Nagios XI, configure monitoring for Ubuntu and Windows systems, and verify host and service status using NRPE and NSClient++.

---

# Requirements

- VMware Workstation
- Nagios XI OVA
- Ubuntu Server
- Windows Machine
- Network connectivity between all systems

---

# Part 1: Deploy Nagios XI

## Download Nagios XI

Official Download:

https://www.nagios.com/products/nagios-xi/downloads/

---

## Import the OVA

Download and extract:

```text
nagiosxi-2026R1.6-64.ova
```

Open the OVA file in VMware.

---

## Default Login

Username:

```text
root
```

Password:

```text
nagiosxi
```

---

## Find the IP Address

```bash
ip -br a
```

Example

```text
ens33    UP    192.168.74.xxx/24
```

---

## Open Nagios XI

Open your browser.

```text
http://<Nagios-XI-IP>
```

Example

```text
http://192.168.74.134
```

Login using the Nagios administrator account.

---

# Configure Linux Monitoring

Navigation

```text
Configure
        ↓
Configuration Wizards
        ↓
Linux Server
```

---

# Part 2: Configure Ubuntu Server

## Install NRPE

Update packages.

```bash
sudo apt update
```

Install NRPE and plugins.

```bash
sudo apt install nagios-nrpe-server nagios-plugins -y
```

---

## Verify NRPE

```bash
sudo systemctl status nagios-nrpe-server
```

Expected

```text
Active: active (running)
```

---

## Enable NRPE

```bash
sudo systemctl enable nagios-nrpe-server
```

---

# Configure Allowed Hosts

Edit NRPE configuration.

```bash
sudo nano /etc/nagios/nrpe.cfg
```

Find

```text
allowed_hosts=
```

Example

```text
allowed_hosts=127.0.0.1,192.168.74.134
```

Replace:

```text
192.168.74.134
```

with your Nagios XI server IP.

Verify

```bash
cat /etc/nagios/nrpe.cfg | grep allowed_hosts=
```

Example

```text
allowed_hosts=127.0.0.1,192.168.74.134
```

---

## Restart NRPE

```bash
sudo systemctl restart nagios-nrpe-server
```

---

# If NRPE Installation Fails

Install NCPA instead.

---

## Step 1: Download

```bash
cd /tmp
```

```bash
wget https://assets.nagios.com/downloads/ncpa3/ncpa-latest-1.amd64.deb
```

Verify download.

```bash
ls -lh ncpa-latest-1.amd64.deb
```

---

## Step 2: Install

```bash
sudo dpkg -i ncpa-latest-1.amd64.deb
```

If dependency errors occur

```bash
sudo apt --fix-broken install -y
```

Then install again.

```bash
sudo dpkg -i ncpa-latest-1.amd64.deb
```

---

## Step 3: Configure Community String

Edit configuration.

```bash
sudo nano /usr/local/ncpa/etc/ncpa.cfg
```

Find

```text
community_string =
```

Example

```text
community_string = cdac123
```

Verify

```bash
sudo cat /usr/local/ncpa/etc/ncpa.cfg | grep community_string
```

Example

```text
community_string = mytoken
```

---

## Restart NCPA

```bash
sudo systemctl restart ncpa_listener
```

Enable on boot.

```bash
sudo systemctl enable ncpa_listener
```

---

# Add Ubuntu Host in Nagios XI

Navigate to

```text
Configure
        ↓
Configuration Wizards
        ↓
Linux Server
```

Enter

- Host Name
- IP Address
- Monitoring Options

Continue through the wizard until Finish.

---

# Verify Monitoring

Open

```text
Home
        ↓
Service Status
```

Initially services may appear as

```text
Pending
```

Wait approximately one minute for the first checks.

---

# Part 3: Add Windows Server

## Download NSClient++

Official Website

https://nsclient.org/

---

## Install NSClient++

During installation enable

- NRPE Server
- CheckSystem
- CheckDisk
- CheckCPU

---

## Configure NSClient++

Open

```text
C:\Program Files\NSClient++\nsclient.ini
```

Find

```text
allowed hosts=
```

Example

```text
allowed hosts=192.168.74.130
```

Replace the IP with your Nagios XI server.

---

## Restart NSClient++

Open

```text
Services
```

Locate

```text
NSClient++
```

Restart the service.

---

## Configure Windows Firewall

Allow inbound TCP port

```text
5666
```

---

# Add Windows Host in Nagios XI

Navigate to

```text
Configure
        ↓
Run a Wizard
        ↓
Windows Server
```

Enter

| Field | Example |
|--------|----------|
| Host Name | Windows |
| Address | 192.168.74.132 |
| NRPE Port | 5666 |

Select monitoring checks

- CPU
- Memory
- C: Drive
- Services
- Uptime

Click

```text
Next
```

Then

```text
Finish
```

Wait approximately one minute.

---

# Verify Windows Monitoring

Open

```text
Home
        ↓
Service Status
```

Expected checks include

- CPU Usage
- Memory Usage
- Disk Usage
- Services
- Uptime

---

# Common Commands

## Ubuntu

Update

```bash
sudo apt update
```

Install NRPE

```bash
sudo apt install nagios-nrpe-server nagios-plugins -y
```

Check Status

```bash
sudo systemctl status nagios-nrpe-server
```

Enable Service

```bash
sudo systemctl enable nagios-nrpe-server
```

Restart

```bash
sudo systemctl restart nagios-nrpe-server
```

Edit Configuration

```bash
sudo nano /etc/nagios/nrpe.cfg
```

Verify Allowed Hosts

```bash
cat /etc/nagios/nrpe.cfg | grep allowed_hosts=
```

---

## NCPA

Download

```bash
wget https://assets.nagios.com/downloads/ncpa3/ncpa-latest-1.amd64.deb
```

Install

```bash
sudo dpkg -i ncpa-latest-1.amd64.deb
```

Fix Dependencies

```bash
sudo apt --fix-broken install -y
```

Edit Configuration

```bash
sudo nano /usr/local/ncpa/etc/ncpa.cfg
```

Verify Community String

```bash
sudo cat /usr/local/ncpa/etc/ncpa.cfg | grep community_string
```

Restart

```bash
sudo systemctl restart ncpa_listener
```

Enable

```bash
sudo systemctl enable ncpa_listener
```

---

# Default Ports

| Service | Port |
|----------|-----:|
| Nagios XI Web Interface | 80 / 443 |
| NRPE | 5666 |
| NCPA API | 5693 |

---

# Verification Checklist

- Nagios XI imported successfully
- Web dashboard accessible
- Ubuntu NRPE installed
- allowed_hosts configured
- NRPE service running
- Ubuntu added through Linux Server Wizard
- Windows NSClient++ installed
- allowed hosts configured
- Windows Firewall allows TCP 5666
- Windows added through Windows Server Wizard
- Service status visible in Nagios XI

---

# Workflow

```text
Import Nagios XI OVA
            │
            ▼
Find Nagios XI IP
            │
            ▼
Open Web Dashboard
            │
            ▼
Install NRPE on Ubuntu
            │
            ▼
Configure allowed_hosts
            │
            ▼
Restart NRPE
            │
            ▼
Add Ubuntu using Linux Server Wizard
            │
            ▼
Install NSClient++ on Windows
            │
            ▼
Configure allowed hosts
            │
            ▼
Allow TCP 5666 in Windows Firewall
            │
            ▼
Add Windows using Windows Server Wizard
            │
            ▼
Monitor Host and Service Status
```
