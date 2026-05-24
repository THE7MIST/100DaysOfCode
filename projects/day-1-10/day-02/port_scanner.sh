#!/bin/bash

# =========================================================
# Port Scanner Script
# Scans ports 1 to 1024
# Shows only open ports with service names
# =========================================================

# Ask user for hostname or IP address
echo "Enter Hostname or IP Address:"
read target

# Resolve hostname to IP
ip=$(getent hosts "$target" | awk '{ print $1 }')

# If hostname cannot be resolved
if [ -z "$ip" ]; then
    echo "Invalid hostname or IP address"
    exit 1
fi

echo ""
echo "Scanning target: $target ($ip)"
echo "Scanning ports 1 to 1024..."
echo ""

# Loop through ports 1 to 1024
for port in $(seq 1 1024)
do
    # Try connecting to the port using bash TCP feature
    timeout 1 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null

    # Check if connection was successful
    if [ $? -eq 0 ]; then

        # Get service name from /etc/services
        service=$(grep -w "$port/tcp" /etc/services | head -n 1 | awk '{print $1}')

        # If service name not found
        if [ -z "$service" ]; then
            service="unknown"
        fi

        # Display open port and service
        echo "Port $port is OPEN  Service: $service"
    fi
done

echo ""
echo "Scan completed."
