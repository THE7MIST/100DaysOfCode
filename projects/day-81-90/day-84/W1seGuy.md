# TryHackMe — W1seGuy 🔐

## Overview

Completed the **W1seGuy** challenge on TryHackMe.

This room demonstrates an important weakness of **repeating-key XOR encryption**. By knowing part of the expected plaintext, such as the standard TryHackMe flag prefix `THM{`, we can recover bytes of the XOR key and decrypt the ciphertext.

---

## Step 1 — Connect to the Challenge

The server is listening on **TCP port 1337**.

Connect using Netcat:

```bash
nc <TARGET_IP> 1337
```

The server returns an XOR-encrypted hexadecimal string:

```text
62381d2a1507113c3f1173082410114244333a06771e2262045a3c293930440429611044081f2318
```

It then asks:

```text
What is the encryption key?
```

---

## Step 2 — Identify the Encryption

The challenge tells us that the flag has been encrypted using **XOR**.

For XOR:

```text
Plaintext XOR Key = Ciphertext
```

Because XOR is reversible:

```text
Ciphertext XOR Plaintext = Key
```

This means that if we know part of the plaintext, we can recover the corresponding part of the key.

---

## Step 3 — Use the Known Flag Format

TryHackMe flags normally begin with:

```text
THM{
```

Therefore, we already know the first four plaintext characters.

The ciphertext begins with:

```text
62 38 1d 2a
```

Now XOR these ciphertext bytes with the ASCII values of:

```text
T H M {
```

---

## Step 4 — Recover the First Four Key Characters

| Plaintext | ASCII Hex | Ciphertext | XOR Result | Key Character |
|---|---:|---:|---:|---|
| `T` | `54` | `62` | `36` | `6` |
| `H` | `48` | `38` | `70` | `p` |
| `M` | `4d` | `1d` | `50` | `P` |
| `{` | `7b` | `2a` | `51` | `Q` |

This reveals:

```text
6pPQ
```

---

## Step 5 — Recover the Fifth Key Character

The challenge uses a **5-character repeating key**.

A valid TryHackMe flag ends with:

```text
}
```

Using the corresponding ciphertext byte and the known closing brace allows the fifth key byte to be recovered.

```text
0x18 XOR 0x7d = 0x65
```

ASCII:

```text
0x65 = e
```

Therefore, the complete encryption key is:

```text
6pPQe
```

---

## Step 6 — Decrypt the Ciphertext

Use Python to XOR every ciphertext byte against the repeating key.

```python
ciphertext = bytes.fromhex(
    "62381d2a1507113c3f1173082410114244333a06771e2262045a3c293930440429611044081f2318"
)

key = b"6pPQe"

flag = bytes(
    ciphertext[i] ^ key[i % len(key)]
    for i in range(len(ciphertext))
)

print("Flag 1:", flag.decode())
```

Run:

```bash
python3 solve.py
```

The decrypted first flag is:

```text
THM{p1alntExtAtt4ckcAnr3alLyhUrty0urxOr}
```

---

# Why the Attack Works

The encryption operation is:

```text
Ciphertext = Plaintext XOR Key
```

Because XOR has the property:

```text
A XOR B XOR B = A
```

we can reverse the operation:

```text
Key = Ciphertext XOR Known Plaintext
```

If an attacker knows or can accurately guess part of the plaintext, the corresponding key bytes can be recovered.

This technique is called a:

## Known-Plaintext Attack

In this challenge, the predictable flag structure:

```text
THM{...}
```

provides the known plaintext needed to begin recovering the key.

---

## Step 7 — Submit the Encryption Key

Reconnect to the service:

```bash
nc <TARGET_IP> 1337
```

When asked:

```text
What is the encryption key?
```

Enter:

```text
6pPQe
```

The server confirms the key and returns the second flag.

---

## Flag 2 🚩

```text
THM{BrUt3_ForC1nG_XOR_cAn_B3_FuN_nO?}
```

---

# Complete Attack Flow

```text
Connect with Netcat
        ↓
Receive XOR Ciphertext
        ↓
Recognize Expected THM{ Flag Format
        ↓
Use Known Plaintext
        ↓
Ciphertext XOR Plaintext
        ↓
Recover Key Bytes
        ↓
Determine 5-Character Key
        ↓
Key = 6pPQe
        ↓
Decrypt Ciphertext
        ↓
Recover Flag 1
        ↓
Submit Key to Server
        ↓
Receive Flag 2 🚩
```

---

## Commands Used

### Connect to Challenge

```bash
nc <TARGET_IP> 1337
```

### Python XOR Decryption

```bash
python3 -c "
ciphertext = bytes.fromhex('62381d2a1507113c3f1173082410114244333a06771e2262045a3c293930440429611044081f2318')
key = b'6pPQe'
flag = bytes([ciphertext[i] ^ key[i % len(key)] for i in range(len(ciphertext))])
print('Flag 1: ' + flag.decode())
"
```

---

## Key Concepts Learned

| Concept | Purpose |
|---|---|
| XOR | Symmetric bitwise operation used by the challenge |
| Repeating-key XOR | Reuses key bytes across the plaintext |
| Known plaintext | Predictable plaintext helps reveal key bytes |
| Hexadecimal | Ciphertext representation received from the server |
| ASCII | Converts characters into byte values |
| Netcat | Connects to the TCP challenge service |
| Python | Performs XOR calculations and decryption |

---

## Security Lesson

XOR itself is not inherently useless, but **reusing a short predictable XOR key is insecure**.

When an attacker knows or guesses plaintext:

```text
Known Plaintext
      XOR
Ciphertext
      ↓
Key Material
```

Predictable formats such as:

```text
THM{...}
```

make this type of cryptographic weakness easier to exploit.

---

## Conclusion

The **W1seGuy** room demonstrated how a repeating XOR key can be attacked using known plaintext.

The important idea was not simply brute-forcing the ciphertext—it was recognizing that the predictable `THM{...}` structure leaked enough information to recover the key and decrypt the message.

**Room completed. 🚩**

---

#TryHackMe #CyberSecurity #Cryptography #XOR #KnownPlaintextAttack #CTF #Python #Netcat #100DaysOfCode
