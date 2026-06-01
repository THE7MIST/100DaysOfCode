#!/bin/bash

# ===============================
# Process + Port Mapping Script
# ===============================

echo "---------------------------------------------"
echo " Process Name | PID | Port "
echo "---------------------------------------------"

# Using ss to list listening ports
ss -tulnp | tail -n +2 | while read line
do
    # Extract port
    port=$(echo "$line" | awk '{print $5}' | awk -F':' '{print $NF}')

    # Extract process info
    process_info=$(echo "$line" | grep -oP 'users:\(\("\K[^"]+|pid=\K[0-9]+' | paste - -)

    process_name=$(echo "$process_info" | awk '{print $1}')
    pid=$(echo "$process_info" | awk '{print $2}')

    if [[ -n "$process_name" && -n "$pid" ]]
    then
        echo "$process_name | $pid | $port"
    fi
done
