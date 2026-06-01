#!/bin/bash

# ===============================
# Automated Backup Script
# ===============================

SOURCE_DIR="/home/user/data"
BACKUP_DIR="/backup"

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# Timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Backup filename
BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

# Create compressed backup
tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup created: $BACKUP_FILE"

# Keep only latest 5 backups
cd "$BACKUP_DIR"

ls -t backup_*.tar.gz | tail -n +6 | xargs -r rm -f

echo "Old backups deleted. Only last 5 backups kept."
