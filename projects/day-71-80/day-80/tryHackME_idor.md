# TryHackMe IDOR Lab — User Profile Parameter Manipulation

## Objective

Practice identifying an **IDOR (Insecure Direct Object Reference)** vulnerability in a safe TryHackMe lab environment.

The task demonstrates how changing a user-controlled identifier in a URL can expose another user's data when the application does not properly enforce authorization.

---

## Lab URLs

Guest profile:

```text
http://10.48.177.41/profile.php?user=guest
```

Admin profile:

```text
http://10.48.177.41/profile.php?user=admin
```

---

## What Was Tested

The application uses the `user` query parameter to decide which profile to display.

Example:

```text
/profile.php?user=guest
```

By changing:

```text
user=guest
```

to:

```text
user=admin
```

the application returned the admin profile in the lab.

---

## Vulnerability

This behavior demonstrates **IDOR**.

IDOR occurs when an application exposes an internal object reference such as:

- User ID
- Username
- File ID
- Order ID
- Account ID

and trusts that value without verifying whether the authenticated user is authorized to access the requested object.

---

## Request Flow

```text
Browser
   |
   v
/profile.php?user=guest
   |
   | Change parameter
   v
/profile.php?user=admin
   |
   v
Admin profile data exposed
```

---

## Why the Vulnerability Exists

The vulnerable pattern is conceptually similar to:

```text
Read the value from the URL
        |
        v
Load that user's profile
        |
        v
Return the profile
```

without performing an authorization check such as:

```text
Is the logged-in user allowed to access this profile?
```

Authentication alone is not enough.

The server must also enforce **authorization** for every requested object.

---

## Impact

A real-world IDOR vulnerability may expose:

- User profiles
- Personal information
- Documents
- Account records
- Orders
- Administrative information
- Other users' resources

The exact impact depends on what objects the application exposes.

---

## Proper Remediation

Applications should:

1. Authenticate the user.
2. Identify the requested object.
3. Verify that the authenticated user is authorized to access that object.
4. Reject unauthorized access on the server side.

Conceptually:

```text
Request object
     |
     v
Authenticate user
     |
     v
Check authorization
   /     \
Allowed  Denied
  |        |
Return    403
object
```

Do not rely only on:

- Hidden buttons
- Frontend restrictions
- Difficult-to-guess IDs
- URL secrecy
- Client-side checks

Authorization must be enforced by the backend.

---

## Key Learning

Changing:

```text
?user=guest
```

to:

```text
?user=admin
```

should not be enough to access another user's profile.

The key lesson is:

> Object identifiers are not authorization controls.

Every sensitive object request must be validated against the authenticated user's permissions.

---

## Tools / Concepts Used

| Item | Purpose |
|---|---|
| Browser | Interact with the vulnerable web application |
| URL query parameter | Select the target user profile |
| `user` parameter | Object reference controlled by the client |
| Authentication | Confirms who the current user is |
| Authorization | Determines what the user is allowed to access |
| IDOR | Vulnerability caused by missing object-level authorization |

---

## Security Context

This exercise was performed in an intentionally vulnerable **TryHackMe lab environment** for learning purposes.

Do not test IDOR techniques against systems you do not own or do not have explicit authorization to assess.
