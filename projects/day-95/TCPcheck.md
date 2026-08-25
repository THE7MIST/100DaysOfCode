Python TCP Port Checker
Overview
A short Python script that checks whether common TCP ports are reachable on a target host.
It tests:
Port 22 — SSH
Port 80 — HTTP
Port 443 — HTTPS
Port 3389 — RDP
Python Code
Save the script as:
port_checker.py
import socket

host = input("Host/IP: ")
ports = [22, 80, 443, 3389]

for port in ports:
    s = socket.socket()
    s.settimeout(1)

    if s.connect_ex((host, port)) == 0:
        print(f"✓ Port {port}: OPEN")
    else:
        print(f"✗ Port {port}: CLOSED")

    s.close()
Run
Open the VS Code terminal and run:
python port_checker.py
Enter a host or IP address:
Host/IP: 127.0.0.1
Example output:
✗ Port 22: CLOSED
✓ Port 80: OPEN
✗ Port 443: CLOSED
✗ Port 3389: CLOSED
How It Works
Import socket
import socket
The socket module allows Python to create network connections.
Read the Target
host = input("Host/IP: ")
The user provides the hostname or IP address to test.
Define Ports
ports = [22, 80, 443, 3389]
The script checks a small list of common TCP service ports.
Create a Socket
s = socket.socket()
A TCP socket is created for each connection attempt.
Set Timeout
s.settimeout(1)
Each connection attempt waits for a maximum of one second.
Test the Port
s.connect_ex((host, port))
connect_ex() attempts to connect to the target.
If it returns 0, the TCP connection succeeded and the port is reported as open.
Close the Socket
s.close()
The socket is closed after every test.
Common Ports
Port
Service
22
SSH
80
HTTP
443
HTTPS
3389
Remote Desktop Protocol
Use Case
This is a small SysAdmin and networking diagnostic script for quickly checking TCP connectivity to known services.
It can help answer questions such as:
Is SSH reachable?
Is a web server responding?
Is HTTPS available?
Is RDP reachable?
Use it only against systems you own or are authorized to test.
Skills Demonstrated
Python
TCP sockets
Port connectivity testing
Timeouts
Loops
Basic network troubleshooting
