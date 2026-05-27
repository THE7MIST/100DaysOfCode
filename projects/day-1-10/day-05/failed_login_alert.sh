#!/bin/bash

LOG_FILE="/var/log/auth.log"

echo "========== Failed Login Attempts =========="

grep "Failed password" "$LOG_FILE" | tail -10 | while read line
do
    DATE=$(echo $line | awk '{print $1, $2, $3}')
    USER=$(echo $line | awk '{print $(NF-5)}')
    IP=$(echo $line | awk '{print $(NF-3)}')

    echo "Date: $DATE"
    echo "User: $USER"
    echo "IP: $IP"
    echo "--------------------------------"
done