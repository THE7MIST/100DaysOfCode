# Active Connections Monitor

## Objective

Write a Bash script that:

* Displays all **ESTABLISHED** TCP connections
* Groups connections by remote IP address
* Shows the number of connections per remote IP

---

## Solution Using `ss`

```bash
#!/bin/bash

ss -tn state established | awk '
NR>1 {
    split($5, a, ":")
    ip=a[1]
    count[ip]++
}
END {
    printf "%-20s %s\n", "Remote IP", "Count"
    for (ip in count)
        printf "%-20s %d\n", ip, count[ip]
}'
```

---

## Sample Output

```text
Remote IP            Count
192.168.1.10         3
142.250.183.78       5
8.8.8.8              1
```

---

## Explanation

### `ss -tn state established`

Displays all active TCP connections.

| Option              | Description                                   |
| ------------------- | --------------------------------------------- |
| `-t`                | Show TCP connections only                     |
| `-n`                | Display numeric IP addresses and port numbers |
| `state established` | Show only established connections             |

---

### `awk`

The `awk` command processes each connection entry.

#### Extract Remote IP

```awk
split($5, a, ":")
ip=a[1]
```

Splits the remote address field and stores the IP address.

Example:

```text
192.168.1.10:443
```

becomes:

```text
a[1] = 192.168.1.10
a[2] = 443
```

---

#### Count Connections

```awk
count[ip]++
```

Uses an associative array to count how many times each IP appears.

---

#### Display Results

```awk
printf "%-20s %s\n", "Remote IP", "Count"
```

Prints table headers.

```awk
for (ip in count)
    printf "%-20s %d\n", ip, count[ip]
```

Prints each remote IP and its connection count.

---

## Alternative Solution Using `netstat`

For older systems where `ss` is unavailable:

```bash
#!/bin/bash

netstat -tn | awk '
/ESTABLISHED/ {
    split($5, a, ":")
    count[a[1]]++
}
END {
    printf "%-20s %s\n", "Remote IP", "Count"
    for (ip in count)
        printf "%-20s %d\n", ip, count[ip]
}'
```

---

## How to Verify

### Check Active Connections

```bash
netstat -tn
```

or

```bash
ss -tn
```

Look for entries containing:

```text
ESTABLISHED
```

Example:

```text
tcp 0 0 192.168.1.5:22 192.168.1.10:52344 ESTABLISHED
```

If no established connections exist, the script will display only the table header.

---

## Creating a Test Connection

### Method 1: SSH

From another machine:

```bash
ssh root@<server-ip>
```

Keep the SSH session open.

Verify:

```bash
netstat -tn | grep ESTABLISHED
```

Run the script again.

Example output:

```text
Remote IP            Count
192.168.1.10         1
```

---

### Method 2: Web Request

Open another terminal and run:

```bash
curl google.com
```

or

```bash
wget google.com
```

These commands create temporary outbound connections that may appear in the output.

---

## Debug Version

```bash
#!/bin/bash

echo "=== Active Connections ==="
netstat -tn | grep ESTABLISHED

echo
echo "=== Count by Remote IP ==="

netstat -tn | awk '
/ESTABLISHED/ {
    split($5, a, ":")
    count[a[1]]++
}
END {
    printf "%-20s %s\n", "Remote IP", "Count"
    for (ip in count)
        printf "%-20s %d\n", ip, count[ip]
}'
```

---

## Conclusion

This script helps administrators quickly identify:

* Active network connections
* Frequently connected remote hosts
* Potential connection spikes or suspicious activity

It is useful for network monitoring, troubleshooting, and basic security analysis.
