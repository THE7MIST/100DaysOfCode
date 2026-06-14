# Diffie-Hellman (DH) Key Exchange - Complete Notes

## What is Diffie-Hellman?

Diffie-Hellman (DH) is a key exchange protocol used to securely establish a shared secret key between two parties over an insecure communication channel.

It was proposed by Whitfield Diffie and Martin Hellman in 1976.

The purpose of DH is to allow two parties to generate the same secret key without transmitting that key across the network.

The shared secret is later used with symmetric encryption algorithms such as AES or ChaCha20.

---

# Historical Background

Before Diffie-Hellman, secure communication required parties to exchange secret keys through a secure channel.

Diffie-Hellman was the first practical public-key protocol that solved the key distribution problem.

It laid the foundation for modern public-key cryptography.

---

# Why Do We Need Diffie-Hellman?

In symmetric encryption both users need the same secret key.

Problem:

```text
Alice ---- Secret Key ---- Bob
```

If an attacker intercepts the key during transmission, communication becomes insecure.

Diffie-Hellman solves this by allowing Alice and Bob to create the same secret key independently without sending it directly.

---

# Key Distribution Problem

The major challenge in symmetric cryptography is securely distributing secret keys.

If the key is exposed during transmission:

* Confidentiality is lost.
* Attackers can decrypt communication.

Diffie-Hellman was designed specifically to solve this problem.

---

# Mathematical Foundation

Diffie-Hellman is based on:

* Modular Arithmetic
* Discrete Logarithm Problem (DLP)

The operation:

```text
g^x mod p
```

is easy to compute.

However, given:

```text
g
p
g^x mod p
```

finding:

```text
x
```

is computationally difficult.

This one-way property provides security.

---

# Basic Concepts

## Prime Number (p)

A large prime number known to everyone.

Example:

```text
p = 13
```

## Generator (g)

A special number called a primitive root.

Example:

```text
g = 6
```

## Private Keys

Alice:

```text
a = 3
```

Bob:

```text
b = 10
```

These values remain secret.

---

# Public and Private Parameters

## Public Parameters

Known to everyone:

```text
Prime Number (p)
Generator (g)
```

Example:

```text
p = 13
g = 6
```

## Private Parameters

Known only to the owner:

```text
a
b
```

---

# Generator (Primitive Root)

The generator g produces many values in the finite field through modular arithmetic.

A good generator provides:

* Strong security
* Uniform key distribution
* Efficient implementation

---

# Working of Diffie-Hellman

## Step 1: Public Parameters

```text
p = 13
g = 6
```

---

## Step 2: Alice Generates Public Value

Alice chooses:

```text
a = 3
```

Calculates:

```text
A = g^a mod p

A = 6^3 mod 13
A = 8
```

Alice sends:

```text
A = 8
```

to Bob.

---

## Step 3: Bob Generates Public Value

Bob chooses:

```text
b = 10
```

Calculates:

```text
B = g^b mod p

B = 6^10 mod 13
B = 4
```

Bob sends:

```text
B = 4
```

to Alice.

---

## Step 4: Alice Computes Shared Secret

```text
S = B^a mod p

S = 4^3 mod 13
S = 12
```

---

## Step 5: Bob Computes Shared Secret

```text
S = A^b mod p

S = 8^10 mod 13
S = 12
```

---

# Result

Both obtain:

```text
S = 12
```

Shared Secret:

```text
Alice Secret = 12
Bob Secret = 12
```

---

# Why Does It Work?

Alice computes:

```text
S = (g^b)^a mod p
```

Bob computes:

```text
S = (g^a)^b mod p
```

Both become:

```text
g^(ab) mod p
```

Since:

```text
ab = ba
```

both obtain the same secret.

---

# Shared Secret

The output of Diffie-Hellman is called the shared secret.

The shared secret is usually not used directly.

Instead it is passed through a Key Derivation Function (KDF) to create encryption keys.

Example algorithms:

* AES
* ChaCha20

---

# Session Keys

A session key is a temporary key used for one communication session.

Benefits:

* Improved security
* Limits damage if compromised
* Supports Forward Secrecy

---

# Security of Diffie-Hellman

An attacker can see:

```text
p
g
A
B
```

But cannot easily determine:

```text
a
b
```

because doing so requires solving the Discrete Logarithm Problem.

---

# Computational Diffie-Hellman Assumption (CDH)

Given:

```text
g
g^a
g^b
```

it is difficult to compute:

```text
g^(ab)
```

without knowing a or b.

---

# Decisional Diffie-Hellman Assumption (DDH)

Given:

```text
g
g^a
g^b
g^c
```

it is difficult to determine whether:

```text
c = ab
```

or not.

Many cryptographic protocols rely on DDH.

---

# Finite Fields

Traditional Diffie-Hellman operates in finite fields.

Finite fields provide predictable arithmetic properties and make the Discrete Logarithm Problem computationally difficult.

---

# Group Theory

Diffie-Hellman relies on mathematical groups.

Properties:

* Closure
* Associativity
* Identity
* Inverse

These properties allow both parties to derive the same shared secret.

---

# Man-in-the-Middle (MITM) Attack

Basic Diffie-Hellman does not authenticate users.

Example:

```text
Alice <---- Eve ----> Bob
```

Eve establishes separate keys with Alice and Bob.

Result:

* Alice thinks she is talking to Bob.
* Bob thinks he is talking to Alice.
* Eve can read communications.

---

# Authentication Problem

Diffie-Hellman provides key exchange but not authentication.

To prevent MITM attacks, use:

* Digital Signatures
* Certificates
* PKI

---

# Solution to MITM

Authentication mechanisms:

* X.509 Certificates
* PKI
* Digital Signatures

Used in:

* TLS
* HTTPS
* SSH
* VPNs

---

# Perfect Forward Secrecy (PFS)

Perfect Forward Secrecy means:

Compromise of long-term keys does not expose past session keys.

Benefits:

* Protects old communications
* Limits impact of key compromise

---

# Ephemeral Keys

Ephemeral keys are temporary keys.

Characteristics:

* Used once
* Discarded after session
* Improve privacy
* Enable PFS

---

# Types of Diffie-Hellman

## Static Diffie-Hellman

Long-term public/private keys.

---

## DHE (Ephemeral Diffie-Hellman)

New keys generated for every session.

Provides:

```text
Perfect Forward Secrecy
```

---

## ECDH (Elliptic Curve Diffie-Hellman)

Uses elliptic curve mathematics.

Advantages:

* Smaller keys
* Faster operations
* Less memory usage

Common curves:

* P-256
* P-384
* Curve25519

---

## ECDHE (Ephemeral ECDH)

Most modern HTTPS websites use ECDHE.

Benefits:

* Perfect Forward Secrecy
* Faster than traditional DH
* Strong security

TLS 1.3 primarily uses ECDHE.

---

# Diffie-Hellman in TLS

When a browser connects to a website:

```text
Client ↔ Server
```

DH/ECDH establishes a shared session key.

Then encryption algorithms use that key.

```text
DH   = Key Exchange
AES  = Encryption
```

---

# Hybrid Cryptography

Modern systems combine:

1. Diffie-Hellman for key exchange
2. AES or ChaCha20 for encryption
3. HMAC for integrity

This combination is called hybrid cryptography.

---

# Diffie-Hellman vs RSA

| Feature         | Diffie-Hellman     | RSA                     |
| --------------- | ------------------ | ----------------------- |
| Purpose         | Key Exchange       | Encryption & Signatures |
| Shared Secret   | Yes                | No                      |
| Forward Secrecy | Yes                | No                      |
| Security Basis  | Discrete Logarithm | Prime Factorization     |
| TLS Usage       | Modern Standard    | Historical              |

---

# Real-World Parameters

Recommended sizes:

| Algorithm  | Recommended Size   |
| ---------- | ------------------ |
| DH         | 2048-bit or higher |
| ECDH       | P-256              |
| ECDH       | P-384              |
| Curve25519 | Preferred          |

Small examples are used only for learning.

Real deployments use very large values.

---

# Quantum Computing Impact

Large-scale quantum computers could weaken classical Diffie-Hellman.

Shor's Algorithm can solve:

* Integer Factorization
* Discrete Logarithms

Researchers are developing:

* Post-Quantum Cryptography
* Quantum-Resistant Key Exchange

---

# Importance of Randomness

Security depends heavily on random private keys.

Weak randomness can produce predictable keys.

Therefore cryptographically secure random number generators (CSPRNGs) are required.

---

# Applications

* HTTPS/TLS
* SSH
* IPSec
* OpenVPN
* WireGuard
* Signal
* WhatsApp
* Cloud Security

---

# Advantages

* Secure key exchange
* Secret key never transmitted
* Widely adopted
* Supports Perfect Forward Secrecy
* Foundation of modern secure communication

---

# Disadvantages

* Vulnerable to MITM without authentication
* Computational overhead
* Requires large parameters
* Does not encrypt data itself

---

# Exam Viva Questions

### What is Diffie-Hellman?

A key exchange protocol used to establish a shared secret over an insecure channel.

### What is the main purpose of DH?

Secure key exchange.

### Does DH encrypt data?

No.

### What mathematical problem secures DH?

Discrete Logarithm Problem.

### What attack affects basic DH?

Man-in-the-Middle attack.

### How is MITM prevented?

Using certificates, digital signatures, and PKI.

### What is Perfect Forward Secrecy?

Compromise of long-term keys does not expose past session keys.

### What is ECDH?

Elliptic Curve Diffie-Hellman.

### What is exchanged in DH?

Only public values.

The secret key is never transmitted.

---

# Exam Definition

Diffie-Hellman Key Exchange is a public-key cryptographic protocol that allows two parties to establish a common secret key over an insecure communication channel without transmitting the secret key itself. The security of the protocol relies on the difficulty of solving the Discrete Logarithm Problem.
