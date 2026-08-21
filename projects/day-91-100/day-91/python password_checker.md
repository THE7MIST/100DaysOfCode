# Python Password Strength Checker

## Overview

A short Python script that checks basic password strength using five criteria:

- Minimum length
- Uppercase letter
- Lowercase letter
- Number
- Special character

---

## Python Code

Save as:

```text
password_checker.py
```

```python
import re

password = input("Enter password: ")

score = sum([
    len(password) >= 8,
    bool(re.search(r"[A-Z]", password)),
    bool(re.search(r"[a-z]", password)),
    bool(re.search(r"\d", password)),
    bool(re.search(r"[^A-Za-z0-9]", password))
])

print(f"Strength: {score}/5")
print("Strong" if score >= 4 else "Weak")
```

---

## Run

Open the VS Code terminal:

```powershell
python password_checker.py
```

Example:

```text
Enter password: Aditya@123
Strength: 5/5
Strong
```

A weaker password:

```text
Enter password: asdfghjk
Strength: 2/5
Weak
```

---

## How It Works

Each condition contributes **1 point**:

| Check | Point |
|---|---:|
| 8+ characters | +1 |
| Uppercase `A-Z` | +1 |
| Lowercase `a-z` | +1 |
| Number `0-9` | +1 |
| Special character | +1 |

Maximum score:

```text
5/5
```

The final decision is:

```python
"Strong" if score >= 4 else "Weak"
```

---

## Regular Expressions

```python
[A-Z]
```

Checks for an uppercase character.

```python
[a-z]
```

Checks for a lowercase character.

```python
\d
```

Checks for a digit.

```python
[^A-Za-z0-9]
```

Checks for a character that isn't a letter or number.

---

## Flow

```text
Enter Password
      ↓
Check Length
      ↓
Check Uppercase
      ↓
Check Lowercase
      ↓
Check Number
      ↓
Check Special Character
      ↓
Calculate Score / 5
      ↓
 Strong or Weak
```

## Security Note

This is a **basic educational password-strength checker**, not a complete password-security system. Real password assessment should also consider compromised passwords, predictable patterns, and overall password length.

## Concepts Used

- Python
- Regular expressions
- Boolean conditions
- `sum()`
- User input
- Conditional expressions
- Basic password validation
