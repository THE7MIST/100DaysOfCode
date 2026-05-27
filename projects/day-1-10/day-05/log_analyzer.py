# ==========================================
# Apache/Nginx Log Analyzer
# ==========================================

from collections import Counter
import os

# =========================
# Input Log File
# =========================

log_file = input("Enter log file path: ")

if not os.path.exists(log_file):
    print("Log file not found.")
    exit()

# =========================
# Variables
# =========================

total_requests = 0
error_404_count = 0
ip_list = []

# =========================
# Read and Analyze Log File
# =========================

with open(log_file, "r", encoding="utf-8") as file:

    for line in file:

        total_requests += 1

        parts = line.split()

        # Extract IP Address
        if len(parts) > 0:
            ip_list.append(parts[0])

        # Find HTTP Status Code
        if len(parts) > 8:
            status_code = parts[8]

            if status_code == "404":
                error_404_count += 1

# =========================
# Top 3 IP Addresses
# =========================

top_ips = Counter(ip_list).most_common(3)

# =========================
# Display Results
# =========================

print("\n========== LOG ANALYSIS ==========")

print(f"\nTotal Requests: {total_requests}")

print(f"Number of 404 Errors: {error_404_count}")

print("\nTop 3 IP Addresses:")

for ip, count in top_ips:
    print(f"{ip} --> {count} requests")