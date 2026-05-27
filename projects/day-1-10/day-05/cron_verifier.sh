#!/bin/bash

# ==========================================
# Cron Job Verifier
# ==========================================

echo "=========================================="
echo " Current User Cron Jobs"
echo "=========================================="

# List all cron jobs
crontab -l 2>/dev/null

if [ $? -ne 0 ]; then
    echo "No cron jobs found for current user."
    exit 1
fi

echo
echo "=========================================="
echo " Verify Specific Cron Job"
echo "=========================================="

# Ask user for cron job keyword
read -p "Enter keyword or command to search: " JOB

# Check if job exists
crontab -l 2>/dev/null | grep -F "$JOB" > /dev/null

if [ $? -eq 0 ]; then
    echo "Cron job exists."
else
    echo "Cron job NOT found."
fi