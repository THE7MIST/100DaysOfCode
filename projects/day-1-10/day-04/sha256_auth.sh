#!/bin/bash

# ==========================================
# Password Strength + Secure Hash Authentication
# ==========================================

HASH_FILE="stored_hash.txt"

echo "=========================================="
echo " Password Strength + Secure Authentication "
echo "=========================================="

echo "Choose Input Method:"
echo "1. Enter password manually"
echo "2. Read password from file"

read -p "Enter choice: " choice

# ==========================================
# INPUT HANDLING
# ==========================================

if [ "$choice" == "1" ]; then
    read -s -p "Enter Password: " password
    echo

elif [ "$choice" == "2" ]; then
    read -p "Enter password file path: " filepath

    if [ ! -f "$filepath" ]; then
        echo "Error: File does not exist."
        exit 1
    fi

    if [ ! -r "$filepath" ]; then
        echo "Error: File is not readable."
        exit 1
    fi

    password=$(cat "$filepath" | tr -d '\n')

else
    echo "Invalid choice."
    exit 1
fi

# ==========================================
# PASSWORD VALIDATION
# ==========================================

score=0

# Length Check
if [ ${#password} -gt 8 ]; then
    ((score++))
fi

# Uppercase Check
if [[ "$password" =~ [A-Z] ]]; then
    ((score++))
fi

# Lowercase Check
if [[ "$password" =~ [a-z] ]]; then
    ((score++))
fi

# Number Check
if [[ "$password" =~ [0-9] ]]; then
    ((score++))
fi

# Special Character Check
if [[ "$password" =~ [^a-zA-Z0-9] ]]; then
    ((score++))
fi

# ==========================================
# PASSWORD CATEGORY
# ==========================================

echo
echo "========== PASSWORD ANALYSIS =========="

if [ $score -le 2 ]; then
    strength="Weak"
elif [ $score -le 4 ]; then
    strength="Good"
else
    strength="Strong"
fi

echo "Password Strength: $strength"
echo "Score: $score / 5"

# ==========================================
# HASH GENERATION
# ==========================================

hash=$(echo -n "$password" | sha256sum | awk '{print $1}')

echo
echo "Generating SHA-256 Hash..."
echo "$hash" > "$HASH_FILE"

echo "Hash stored securely in: $HASH_FILE"

# ==========================================
# LOGIN PHASE
# ==========================================

echo
echo "============== LOGIN =============="

read -s -p "Re-enter Password: " login_password
echo

login_hash=$(echo -n "$login_password" | sha256sum | awk '{print $1}')

stored_hash=$(cat "$HASH_FILE")

# ==========================================
# HASH COMPARISON
# ==========================================

echo
echo "========== AUTHENTICATION =========="

if [ "$login_hash" == "$stored_hash" ]; then
    echo "Access Granted"
else
    echo "Access Denied"
fi

echo "===================================="
