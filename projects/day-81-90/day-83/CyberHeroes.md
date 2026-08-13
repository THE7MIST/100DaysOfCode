# TryHackMe — CyberHeroes 🦸‍♂️

## Overview

Completed the **CyberHeroes** room on TryHackMe.

This challenge focuses on basic web enumeration, source-code inspection, credential discovery, simple string manipulation, and authentication.

---

## Step 1 — Deploy the Machine

Start the vulnerable machine from the TryHackMe room and note the assigned target IP address.

If using your own machine, connect to the TryHackMe VPN:

```bash
sudo openvpn <your-thm-vpn-file>.ovpn
```

---

## Step 2 — Nmap Enumeration

Start by scanning the target to identify open ports and running services.

```bash
sudo nmap -sC -sV -Pn <TARGET_IP>
```

### Discovered Services

```text
Port 22 → SSH
Port 80 → HTTP / Apache
```

The HTTP service hosts the **CyberHeroes** web application.

---

## Step 3 — Directory Enumeration

Use Gobuster to search for potentially hidden directories and files.

```bash
gobuster dir \
-u http://<TARGET_IP> \
-w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt \
-t 50
```

No particularly useful hidden directory was required to solve the challenge.

---

## Step 4 — Explore the Website

Open the target in a browser:

```text
http://<TARGET_IP>
```

Explore the available pages and navigate to the **Login** page.

The application provides:

- Username field
- Password field
- Login functionality

---

## Step 5 — Inspect the Page Source

Instead of immediately trying password attacks, inspect the client-side source code.

In the browser:

```text
Ctrl + U
```

Search the source for interesting keywords and authentication-related values.

This revealed credentials embedded in the client-side code.

### Username

```text
h3ck3rBoi
```

### Encoded/Reversed Password

```text
54321@terceSrepuS
```

---

## Step 6 — Reverse the Password

The password appears to be stored backwards.

Use the Linux `rev` command:

```bash
echo "54321@terceSrepuS" | rev
```

Output:

```text
SuperSecret@12345
```

Therefore, the discovered credentials are:

```text
Username: h3ck3rBoi
Password: SuperSecret@12345
```

---

## Step 7 — Login

Return to the CyberHeroes login page and authenticate using the discovered credentials.

```text
Username: h3ck3rBoi
Password: SuperSecret@12345
```

Successful authentication reveals the challenge flag.

---

## Step 8 — Capture the Flag 🚩

The flag obtained from the application is:

```text
flag{edb0be532c540b1a150c3a7e85d2466e}
```

Submit the flag in the TryHackMe answer box to complete the room.

---

# Attack Flow

```text
Deploy Target
     ↓
Nmap Scan
     ↓
Discover HTTP Service
     ↓
Open Website
     ↓
Navigate to Login
     ↓
Inspect Page Source
     ↓
Discover Embedded Credentials
     ↓
Reverse Password
     ↓
Authenticate
     ↓
Capture Flag 🚩
```

---

## Commands Used

### Nmap

```bash
sudo nmap -sC -sV -Pn <TARGET_IP>
```

### Gobuster

```bash
gobuster dir \
-u http://<TARGET_IP> \
-w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt \
-t 50
```

### Reverse String

```bash
echo "54321@terceSrepuS" | rev
```

---

## Key Takeaways

This room demonstrated several important cybersecurity concepts:

- Web application enumeration
- Network service discovery with Nmap
- Directory enumeration with Gobuster
- HTML/JavaScript source inspection
- Client-side information disclosure
- Credential discovery
- Basic string manipulation
- Authentication testing

### Important Security Lesson

Sensitive information such as usernames, passwords, API keys, or authentication logic should **never be exposed in client-side source code**.

Even if a password is reversed, encoded, or otherwise lightly obfuscated, anyone who receives the frontend code can inspect and recover it.

---

## Tools Used

| Tool | Purpose |
|---|---|
| `Nmap` | Port and service enumeration |
| `Gobuster` | Directory enumeration |
| Browser DevTools / Source | Client-side inspection |
| `rev` | Reverse the discovered password |
| TryHackMe AttackBox | Lab environment |

---

## Conclusion

The **CyberHeroes** room was a useful introductory web-security challenge demonstrating why careful enumeration matters.

The key discovery did not require a complex exploit. Inspecting the application's source exposed authentication information, and a simple Linux command was enough to recover the password.

**Room completed successfully. 🚩**

---

#TryHackMe #CyberSecurity #EthicalHacking #WebSecurity #Nmap #Gobuster #Linux #CTF
