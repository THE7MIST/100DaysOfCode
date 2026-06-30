Simple Firewall Rule Generator

Filename: "firewall_rule_generator.py"

Objective

Write a Python program that:

- Accepts one or more port numbers from the user
- Allows the user to choose TCP or UDP
- Generates corresponding "iptables" firewall rules
- Displays the generated rules without executing them

---

Concepts Covered

- User input
- Lists and loops
- String formatting
- Input validation
- Basic Linux firewall ("iptables")

---

Python Script

def validate_ports(port_list):
    valid_ports = []

    for port in port_list:
        port = port.strip()

        if port.isdigit():
            port = int(port)

            if 1 <= port <= 65535:
                valid_ports.append(port)
            else:
                print(f"Invalid port: {port}")
        else:
            print(f"Invalid input: {port}")

    return valid_ports


def main():
    ports = input("Enter ports (comma separated): ")
    ports = ports.split(",")

    protocol = input("Protocol (tcp/udp): ")
    protocol = protocol.strip().lower()

    if protocol not in ["tcp", "udp"]:
        print("Invalid protocol.")
        return

    valid_ports = validate_ports(ports)

    if not valid_ports:
        print("No valid ports entered.")
        return

    print("\nGenerated iptables Rules:\n")

    for port in valid_ports:
        print(f"iptables -A INPUT -p {protocol} --dport {port} -j ACCEPT")


if __name__ == "__main__":
    main()

---

Function Explanation

"validate_ports(port_list)"

Validates the list of ports entered by the user.

Process

- Removes extra spaces
- Checks whether the value is numeric
- Converts it to an integer
- Ensures the port is between 1 and 65535
- Returns only valid ports

---

"main()"

Performs the following tasks:

1. Reads comma-separated port numbers.
2. Splits the input into a list.
3. Reads the protocol (TCP or UDP).
4. Converts the protocol to lowercase.
5. Validates the protocol.
6. Validates all port numbers.
7. Generates the corresponding "iptables" rules.

---

Example Run

Input

Enter ports (comma separated): 22,80,443
Protocol (tcp/udp): tcp

Output

Generated iptables Rules:

iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

---

Sample Generated Rules

iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

---

Input Validation

Invalid Port

Input:

22,70000,80

Output:

Invalid port: 70000

---

Invalid Input

Input:

22,http,80

Output:

Invalid input: http

---

Invalid Protocol

Input:

Protocol (tcp/udp): icmp

Output:

Invalid protocol.

---

Possible Enhancements

- Support both "ACCEPT" and "DROP" actions
- Generate "OUTPUT" and "FORWARD" chain rules
- Save generated rules to a shell script (".sh")
- Allow rules for specific source IP addresses
- Generate equivalent UFW or firewalld commands
- Remove duplicate ports automatically

---

Note

This program only generates "iptables" commands. It does not execute them, making it safe for learning, testing, and understanding Linux firewall rule syntax.

---

Result

The program successfully accepts valid port numbers and a protocol, validates the input, and generates the corresponding "iptables" firewall rules for the user.

---

Conclusion

This project demonstrates how Python can automate the generation of Linux firewall rules using basic programming concepts such as user input, validation, loops, lists, and string formatting.
