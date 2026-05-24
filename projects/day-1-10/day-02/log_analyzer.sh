#!/bin/bash

# ==========================================
# Log Analyzer Shell Script
# ==========================================

echo "Enter log file path:"
read logfile

# Check if file exists
if [ ! -f "$logfile" ]; then
    echo "File not found"
    exit 1
fi

# Total requests
total_requests=$(wc -l < "$logfile")

# Number of 404 errors
error_404=$(grep ' 404 ' "$logfile" | wc -l)

echo ""
echo "===== Log Analysis Result ====="

echo "Total Requests: $total_requests"

echo "404 Errors: $error_404"

echo ""
echo "Top 3 IP Addresses:"

# Extract IPs and count them
awk '{print $1}' "$logfile" | sort | uniq -c | sort -nr | head -3
