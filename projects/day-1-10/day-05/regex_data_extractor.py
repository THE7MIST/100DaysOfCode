# ==========================================
# Advanced Email + IP + URL Extractor
# ==========================================

import re
import os

# =========================
# Regex Patterns
# =========================

EMAIL_PATTERN = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'

IP_PATTERN = r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b'

URL_PATTERN = r'https?://[^\s]+|www\.[^\s]+'


# =========================
# Read File
# =========================

file_path = input("Enter file path: ")

if not os.path.exists(file_path):
    print("File not found.")
    exit()

with open(file_path, "r", encoding="utf-8") as file:
    data = file.read()


# =========================
# Extract Data
# =========================

emails = re.findall(EMAIL_PATTERN, data)
ips = re.findall(IP_PATTERN, data)
urls = re.findall(URL_PATTERN, data)


# =========================
# Remove Duplicates
# =========================

emails = list(set(emails))
ips = list(set(ips))
urls = list(set(urls))


# =========================
# Display Results
# =========================

print("\n========== EXTRACTED EMAILS ==========")

if emails:
    for email in emails:
        print(email)
else:
    print("No emails found.")


print("\n========== EXTRACTED IPv4 ADDRESSES ==========")

if ips:
    for ip in ips:
        print(ip)
else:
    print("No IPv4 addresses found.")


print("\n========== EXTRACTED URLs ==========")

if urls:
    for url in urls:
        print(url)
else:
    print("No URLs found.")


# =========================
# Optional Save to Output File
# =========================

save_choice = input("\nDo you want to save results to output.txt? (yes/no): ")

if save_choice.lower() == "yes":

    with open("output.txt", "w", encoding="utf-8") as out:

        out.write("========== EMAILS ==========\n")
        for email in emails:
            out.write(email + "\n")

        out.write("\n========== IPv4 ADDRESSES ==========\n")
        for ip in ips:
            out.write(ip + "\n")

        out.write("\n========== URLs ==========\n")
        for url in urls:
            out.write(url + "\n")

    print("Results saved to output.txt")

else:
    print("Results not saved.")