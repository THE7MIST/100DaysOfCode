# ==========================================
# Password Strength + Secure Hash Storage
# ==========================================

import hashlib
import os
import re

DB_FILE = "auth_db.txt"


# =========================
# Password Strength Checker
# =========================
def check_strength(password):
    score = 0

    # Length check
    if len(password) >= 8:
        score += 1

    # Uppercase letter
    if re.search(r"[A-Z]", password):
        score += 1

    # Lowercase letter
    if re.search(r"[a-z]", password):
        score += 1

    # Number
    if re.search(r"[0-9]", password):
        score += 1

    # Special character
    if re.search(r"[!@#$%^&*(),.?\":{}|<>]", password):
        score += 1

    # Strength result
    if score <= 2:
        return "Weak"
    elif score == 3 or score == 4:
        return "Good"
    else:
        return "Strong"


# =========================
# SHA-256 Hash Generator
# =========================
def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()


# =========================
# Register User
# =========================
def register():
    username = input("Enter username: ")
    password = input("Enter password: ")

    strength = check_strength(password)
    print(f"Password Strength: {strength}")

    hashed_password = hash_password(password)

    with open(DB_FILE, "a") as file:
        file.write(f"{username}:{hashed_password}\n")

    print("User registered successfully.")
    print("Password stored securely as SHA-256 hash.")


# =========================
# Login User
# =========================
def login():
    username = input("Enter username: ")
    password = input("Enter password: ")

    hashed_input = hash_password(password)

    if not os.path.exists(DB_FILE):
        print("No users registered yet.")
        return

    with open(DB_FILE, "r") as file:
        users = file.readlines()

    for user in users:
        stored_username, stored_hash = user.strip().split(":")

        if username == stored_username:
            if hashed_input == stored_hash:
                print("Login Successful.")
            else:
                print("Incorrect Password.")
            return

    print("Username not found.")


# =========================
# Main Menu
# =========================
while True:
    print("\n===== MENU =====")
    print("1. Register")
    print("2. Login")
    print("3. Exit")

    choice = input("Enter choice: ")

    if choice == "1":
        register()

    elif choice == "2":
        login()

    elif choice == "3":
        print("Exiting program...")
        break

    else:
        print("Invalid choice.")