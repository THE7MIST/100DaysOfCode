# DNS Resolver Tool (Python)

## Objective

Write a Python program that:

- Accepts a domain name as input
- Resolves the domain to its IP address
- Performs a Reverse DNS lookup
- Displays the hostname if a PTR record exists
- Handles invalid domains gracefully

---

## Suggested Filename

```text
dns_resolver.py
```

---

# Python Script

```python
import socket

def dns_resolver():
    domain = input("Enter domain name: ").strip()

    try:
        # Get IP address
        ip_address = socket.gethostbyname(domain)
        print(f"\nIP Address      : {ip_address}")

        # Reverse DNS Lookup
        try:
            hostname = socket.gethostbyaddr(ip_address)[0]
            print(f"Reverse DNS     : {hostname}")
        except socket.herror:
            print("Reverse DNS     : Not available")

    except socket.gaierror:
        print("Invalid domain name or unable to resolve.")

if __name__ == "__main__":
    dns_resolver()
```

---

## Sample Run 1

```text
Enter domain name: google.com

IP Address      : 142.250.xxx.xxx
Reverse DNS     : bom12s44-in-f14.1e100.net
```

---

## Sample Run 2

```text
Enter domain name: openai.com

IP Address      : 104.18.xxx.xxx
Reverse DNS     : Not available
```

---

## Sample Run 3

```text
Enter domain name: abcxyz123.com

Invalid domain name or unable to resolve.
```

---

# Concepts Used

- **DNS Resolution**
- **Reverse DNS Lookup**
- **Python Socket Programming**
- **Exception Handling**
- **Basic Networking**

---

# Functions Used

| Function | Purpose |
|----------|---------|
| `socket.gethostbyname(domain)` | Converts a domain name into an IP address |
| `socket.gethostbyaddr(ip)` | Performs Reverse DNS lookup (IP → Hostname) |
| `socket.gaierror` | Handles invalid domain or DNS lookup failure |
| `socket.herror` | Handles missing Reverse DNS (PTR) records |

---

# Code Explanation

## 1. Import Module

```python
import socket
```

Imports Python's networking module.

---

## 2. Read Domain Name

```python
domain = input("Enter domain name: ").strip()
```

Accepts a domain name from the user and removes any leading or trailing spaces.

---

## 3. Resolve Domain to IP

```python
ip_address = socket.gethostbyname(domain)
```

Converts the domain into its corresponding IPv4 address.

Example:

```text
google.com

↓

142.250.xxx.xxx
```

---

## 4. Reverse DNS Lookup

```python
hostname = socket.gethostbyaddr(ip_address)[0]
```

Attempts to resolve the IP address back to its hostname using a PTR record.

If no PTR record exists, the program displays:

```text
Reverse DNS : Not available
```

---

## 5. Exception Handling

```python
except socket.gaierror:
```

Handles cases where the domain cannot be resolved.

```python
except socket.herror:
```

Handles missing Reverse DNS records.

---

# Interview Questions

### What is DNS?

DNS (Domain Name System) translates human-readable domain names into IP addresses.

---

### What is Reverse DNS?

Reverse DNS maps an IP address back to its hostname using PTR records.

---

### Does every IP address have Reverse DNS?

No. Reverse DNS works only if the IP owner has configured a PTR record.

---

### Which protocol does DNS primarily use?

DNS primarily uses **UDP Port 53**.

TCP Port 53 is used for:

- Zone transfers
- Large DNS responses

---

### Why use `socket.gethostbyname()`?

To convert a domain name into an IP address before establishing a network connection.

---

### Why use `socket.gethostbyaddr()`?

To perform a Reverse DNS lookup and retrieve the hostname associated with an IP address.

---

# Key Takeaways

- Uses Python's `socket` module for DNS operations.
- Resolves domain names to IP addresses.
- Performs Reverse DNS lookups when available.
- Gracefully handles invalid domains and missing PTR records.
- Demonstrates fundamental networking and DNS concepts useful for cybersecurity and system administration.
