# Fail2Ban SSH Brute Force Protection Lab

## Objective

Install and configure Fail2Ban to protect SSH against brute-force login attempts.

### Requirements

* Detect 5 invalid login attempts within 3 minutes
* Ban the IP address for 2 minutes after the first offense
* Ban the IP address for 4 minutes after the second offense

---

# Step 1: Install Fail2Ban

Install the Fail2Ban package.

```bash
yum install epel-release -y && yum install fail2ban -y
```

### Purpose

Fail2Ban monitors log files and automatically blocks IP addresses that perform repeated failed login attempts.

---

# Step 2: Start and Enable Fail2Ban

```bash
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### Verify Service Status

```bash
sudo systemctl status fail2ban
```

Expected:

```text
fail2ban.service - Fail2Ban Service
Loaded: loaded
Active: active (running)
```

---

# Step 3: Create Local Configuration File

Create a local copy of the configuration file.

```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

### Verify

```bash
ls /etc/fail2ban
```

Expected files:

```text
action.d
fail2ban.d
jail.conf
jail.local
filter.d
jail.d
paths-common.conf
paths-fedora.conf
fail2ban.conf
```

### Purpose

Custom settings should be stored in `jail.local` instead of modifying the default configuration.

---

# Step 4: Configure SSH Protection

Create a dedicated SSH jail configuration.

```bash
sudo vim /etc/fail2ban/jail.d/sshd.local
```

Add:

```ini
[sshd]
enabled = true
findtime = 180
maxretry = 5
bantime = 120
```

### Parameter Explanation

| Parameter      | Meaning                                              |
| -------------- | ---------------------------------------------------- |
| enabled        | Enable SSH protection                                |
| findtime = 180 | Monitor failed logins within 180 seconds (3 minutes) |
| maxretry = 5   | Ban after 5 failed login attempts                    |
| bantime = 120  | Ban IP for 120 seconds (2 minutes)                   |

Save and exit:

```text
Esc :wq
```

### Verify

```bash
cat /etc/fail2ban/jail.d/sshd.local
```

Expected:

```ini
[sshd]
enabled = true
findtime = 180
maxretry = 5
bantime = 120
```

---

# Step 5: Restart Fail2Ban

Apply the new configuration.

```bash
sudo systemctl restart fail2ban
```

### Verify

```bash
sudo systemctl status fail2ban
```

Expected:

```text
Active: active (running)
```

---

# Step 6: Enable and Start Service

```bash
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

---

# Step 7: Check Available Jails

Display active jails.

```bash
sudo fail2ban-client status
```

Example:

```text
Status
|- Number of jail: 1
`- Jail list: sshd
```

---

# Step 8: Check SSH Jail Status

```bash
sudo fail2ban-client status sshd
```

Example:

```text
Status for the jail: sshd

|- Filter
|  |- Currently failed: 0
|  |- Total failed: 0
|
`- Actions
   |- Currently banned: 0
   |- Total banned: 0
   `- Banned IP list:
```

---

# Step 9: Test Brute Force Protection

## Check Server IP

```bash
ip -br a
```

Example:

```text
lo        UNKNOWN    127.0.0.1/8
ens160    UP         192.168.74.214/24
ens224    UP         192.168.35.254/24
ens256    UP         192.168.25.254/24
```

---

## From Another Machine

Attempt incorrect SSH logins repeatedly.

```bash
ssh root@192.168.74.214
```

Example:

```text
root@192.168.74.214's password:
Permission denied, please try again.

root@192.168.74.214's password:
Permission denied, please try again.

root@192.168.74.214: Permission denied
(publickey,gssapi-keyex,gssapi-with-mic,password)
```

After 5 failed attempts within 3 minutes, the source IP should be banned automatically.

---

# Verify Ban

Check jail status again:

```bash
sudo fail2ban-client status sshd
```

Expected:

```text
Currently banned: 1
Banned IP list:
192.168.x.x
```

---

# Incremental Ban Configuration

The previous configuration satisfies:

```text
5 failed attempts
Within 3 minutes
Ban for 2 minutes
```

To double the ban duration on repeated offenses, add:

```ini
[DEFAULT]
bantime.increment = true
bantime.factor = 2
```

Example:

| Offense | Ban Time   |
| ------- | ---------- |
| First   | 2 Minutes  |
| Second  | 4 Minutes  |
| Third   | 8 Minutes  |
| Fourth  | 16 Minutes |

Restart Fail2Ban:

```bash
sudo systemctl restart fail2ban
```

---

# Important Commands

Check service:

```bash
systemctl status fail2ban
```

Check all jails:

```bash
fail2ban-client status
```

Check SSH jail:

```bash
fail2ban-client status sshd
```

Unban an IP:

```bash
fail2ban-client set sshd unbanip <IP_ADDRESS>
```

Restart service:

```bash
systemctl restart fail2ban
```

---

# Result

Fail2Ban was successfully installed and configured to monitor SSH login attempts. IP addresses generating five failed login attempts within three minutes are automatically banned, helping protect the server from brute-force attacks.

---

# Conclusion

Fail2Ban provides an effective layer of defense against SSH brute-force attacks by monitoring authentication logs and dynamically blocking malicious IP addresses. Using incremental bans further strengthens protection against repeated offenders.
