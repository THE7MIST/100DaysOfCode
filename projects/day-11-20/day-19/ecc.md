# Elliptic Curve Cryptography (ECC) – Simple Notes

## What is ECC?

Elliptic Curve Cryptography (ECC) is a public-key cryptography system developed in the mid-1980s.

Like RSA, ECC uses:

* **Public Key** → Shared with everyone
* **Private Key** → Kept secret

ECC is widely used in:

* HTTPS/TLS
* SSH
* Cryptocurrencies (Bitcoin, Ethereum)
* Digital Signatures

---

# Public Key Cryptography Concept

Public-key cryptography relies on a **Trapdoor Function**.

### Easy Direction

```text
A → B
```

Easy to calculate.

### Hard Direction

```text
B → A
```

Extremely difficult to reverse.

This one-way property provides security.

---

# RSA vs ECC

## RSA Security

RSA depends on the difficulty of:

**Prime Factorization**

Example:

```text
N = p × q
```

Finding **N** is easy.

Finding **p** and **q** from a very large **N** is extremely difficult.

---

## ECC Security

ECC depends on:

**Elliptic Curve Discrete Logarithm Problem (ECDLP)**

Given:

```text
P
Q = nP
```

Finding **Q** is easy.

Finding **n** is extremely difficult.

---

# Why ECC is Popular

ECC provides the same security with much smaller keys.

| ECC Key Size | Equivalent RSA Key Size |
| ------------ | ----------------------- |
| 256-bit      | 3072-bit                |
| 384-bit      | 7680-bit                |

## Benefits

* Smaller keys
* Faster computations
* Less CPU usage
* Less memory usage
* Better performance on mobile and IoT devices

---

# What is an Elliptic Curve?

Typical equation:

### Properties

* Symmetric about the x-axis
* A straight line intersects the curve at a maximum of 3 points

### Illustration

```text
      •
     / \
    /   \
   /     \

   \     /
    \   /
     \ /
      •
```

(Actual ECC curves are smooth mathematical curves.)

---

# Basic ECC Idea

Choose a starting point:

```text
P
```

Apply a special operation repeatedly called:

* Point Addition
* Point Multiplication

---

# Point Multiplication

Start with:

```text
P
```

Repeated additions:

```text
2P = P + P
3P = P + P + P
4P = P + P + P + P
```

General form:

```text
Q = nP
```

Where:

* P = Base Point
* n = Secret Number
* Q = Resulting Point

---

# Private Key

The private key is:

```text
n
```

Example:

```text
n = 25
```

Keep this value secret.

---

# Public Key

Calculate:

```text
Q = nP
```

Example:

```text
Q = 25P
```

Publish:

```text
P and Q
```

---

# Why is ECC Secure?

Suppose an attacker knows:

```text
P
Q
```

They must determine:

```text
n
```

by solving:

```text
Q = nP
```

This is known as the:

**Elliptic Curve Discrete Logarithm Problem (ECDLP)**

No practical algorithm currently exists to solve this efficiently for properly selected curves.

---

# ECC Key Generation

## Step 1

Choose an elliptic curve.

---

## Step 2

Select a Base Point:

```text
P
```

---

## Step 3

Choose a random secret number:

```text
n
```

This becomes the **Private Key**.

---

## Step 4

Compute:

```text
Q = nP
```

This becomes the **Public Key**.

---

# Final Keys

## Private Key

```text
n
```

## Public Key

```text
(P, Q)
```

where:

```text
Q = nP
```

---

# ECC Workflow

```text
Public Key
(P, Q = nP)
      │
      ▼

Alice ------------------> Bob

Encrypt / Verify
using Public Key

Decrypt / Sign
using Private Key (n)
```

---

# ECC Advantages Over RSA

| Feature        | ECC       | RSA      |
| -------------- | --------- | -------- |
| Key Size       | Small     | Large    |
| Speed          | Faster    | Slower   |
| CPU Usage      | Lower     | Higher   |
| Storage        | Less      | More     |
| Mobile Devices | Excellent | Moderate |

---

# Real-World Usage

## ECC-256

Equivalent to:

```text
RSA-3072
```

Commonly used in TLS certificates.

---

## ECC-384

Equivalent to:

```text
RSA-7680
```

Used for highly sensitive government and enterprise systems.

---

# F5 BIG-IP Support

F5 BIG-IP supports:

* ECC 256-bit keys
* ECC 384-bit keys

---

# Quick Exam Points

1. ECC is a public-key cryptography system.
2. ECC security is based on the Elliptic Curve Discrete Logarithm Problem (ECDLP).
3. RSA security is based on Prime Factorization.
4. A 256-bit ECC key ≈ 3072-bit RSA key.
5. A 384-bit ECC key ≈ 7680-bit RSA key.
6. Private Key = n.
7. Public Key = Q = nP.
8. ECC provides strong security with smaller key sizes.
9. ECC is widely used in TLS, SSH, cryptocurrencies, and digital signatures.
10. F5 BIG-IP supports 256-bit and 384-bit ECC keys.

---

# Conclusion

ECC is a modern public-key cryptography system that provides strong security using significantly smaller key sizes than RSA. Its security is based on the Elliptic Curve Discrete Logarithm Problem (ECDLP), making it highly efficient for mobile devices, IoT systems, smart cards, TLS certificates, cryptocurrencies, and digital signatures. Because of its speed, low resource consumption, and strong security, ECC is widely used in modern cryptographic implementations.
