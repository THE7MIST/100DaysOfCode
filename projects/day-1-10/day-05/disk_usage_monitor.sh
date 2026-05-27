#!/bin/bash

# ==========================================
# Disk Usage Alert Script
# ==========================================

LOG_FILE="/var/log/disk_alert.log"
THRESHOLD=80

echo "Checking disk usage..."

# Get disk usage percentage of root partition
USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

# Check if usage exceeds threshold
if [ "$USAGE" -gt "$THRESHOLD" ]; then

    MESSAGE="$(date) WARNING: Disk usage is at ${USAGE}%"

    echo "$MESSAGE" | sudo tee -a "$LOG_FILE"

    echo "Alert logged to $LOG_FILE"

else
    echo "Disk usage is normal: ${USAGE}%"
fi