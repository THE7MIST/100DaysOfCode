# PG-DITISS Coding Practice Roadmap

| S.No | Level   | Actual Q.No | Full Question Name               | Python Method 1              | Python Method 2          | Bash / Linux Method   |
| ---- | ------- | ----------- | -------------------------------- | ---------------------------- | ------------------------ | --------------------- |
| 1    | Level 1 | 5           | Password Strength + Hash Storage | `hashlib` SHA256             | `passlib` / bcrypt       | `sha256sum`           |
| 2    | Level 1 | 17          | Advanced Email + IP Extractor    | `re` module                  | `regex` library          | `grep -E`             |
| 3    | Level 1 | 2           | Log Analyzer                     | Python file handling + regex | `pandas` log parsing     | `grep + awk + sort`   |
| 4    | Level 1 | 9           | Failed Login Alert               | Python regex parser          | `collections.Counter`    | `grep auth.log`       |
| 5    | Level 1 | 10          | Cron Job Verifier                | `subprocess` + Python        | `python-crontab`         | `crontab -l`          |
| 6    | Level 2 | 7           | Disk Usage Alert Script          | `shutil.disk_usage()`        | `psutil.disk_usage()`    | `df -h`               |
| 7    | Level 2 | 20          | Automated Backup Script          | `tarfile` module             | `shutil.make_archive()`  | `tar + cron`          |
| 8    | Level 2 | 8           | Service Health Monitor           | `subprocess + systemctl`     | `psutil`                 | `systemctl/service`   |
| 9    | Level 2 | 19          | Process + Port Mapping           | `psutil`                     | `subprocess + ss`        | `ss/netstat/lsof`     |
| 10   | Level 3 | 4           | DNS Resolver Tool                | `socket.gethostbyname()`     | `dns.resolver`           | `nslookup/dig/host`   |
| 11   | Level 3 | 16          | URL Status Checker               | `requests`                   | `urllib`                 | `curl/wget`           |
| 12   | Level 3 | 13          | Network Interface Analyzer       | `psutil`                     | `netifaces + socket`     | `ip a / ifconfig`     |
| 13   | Level 4 | 3           | Brute-force Detection Script     | regex + dictionaries         | `collections.Counter`    | `grep + awk`          |
| 14   | Level 4 | 11          | File Integrity Checker           | `hashlib + os.walk()`        | `watchdog + json`        | `sha256sum + find`    |
| 15   | Level 4 | 15          | Simple Encryption Tool           | Caesar Cipher                | AES using `cryptography` | `openssl enc`         |
| 16   | Level 5 | 1           | Port Scanner (Enhanced)          | Raw `socket` programming     | `scapy/python-nmap`      | `nmap/netcat`         |
| 17   | Level 5 | 18          | Ping Sweep Tool                  | `subprocess ping`            | `scapy/raw sockets`      | `ping + fping + nmap` |

