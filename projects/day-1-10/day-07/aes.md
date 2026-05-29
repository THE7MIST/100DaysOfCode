# AES (Advanced Encryption Standard) - Complete Deep Dive

## Recommended Learning Resources

Reference 1: https://legacy.cryptool.org/en/cto/aes-step-by-step

Reference 2: https://excalidraw.com/#json=kdMKpvS2Nds7DQIMM8cD-,WtsbA9QX3GOFz8mTd2Vj0A

---

# Introduction

AES (Advanced Encryption Standard) is the most widely used symmetric encryption algorithm in the world. It protects data in web applications, banking systems, VPNs, cloud platforms, wireless networks, operating systems, and government infrastructure.

AES was standardized by the National Institute of Standards and Technology (NIST) in 2001 and is based on the Rijndael cipher developed by Joan Daemen and Vincent Rijmen.

Today, AES is considered the global standard for secure symmetric encryption.

---

# Learning Objectives

After studying this document, you should understand:

* What AES is
* Why AES replaced DES
* AES architecture
* AES encryption process
* AES decryption process
* AES state matrix
* AES rounds
* SubBytes transformation
* ShiftRows transformation
* MixColumns transformation
* AddRoundKey transformation
* AES Key Expansion
* S-Box
* Rcon
* AES security properties
* Real-world applications of AES

---

# What is AES?

AES is a symmetric block cipher.

## Symmetric Cipher

The same secret key is used for both encryption and decryption.

```text
Plaintext
    |
Encryption using Secret Key
    |
Ciphertext
    |
Decryption using Same Secret Key
    |
Original Plaintext
```

Unlike RSA, AES does not use public and private keys.

---

## Block Cipher

AES processes data in fixed-size blocks.

```text
AES Block Size = 128 bits = 16 bytes
```

Important:

The block size never changes.

AES-128, AES-192, and AES-256 all use a 128-bit block size.

Only the key size changes.

---

# History of AES

Before AES, the most common encryption standard was DES.

## DES Problems

DES used a 56-bit key.

As computing power increased, brute-force attacks became practical.

NIST initiated a competition to develop a stronger replacement.

---

## AES Competition Finalists

* MARS
* RC6
* Serpent
* Twofish
* Rijndael

Winner:

**Rijndael**

Created by:

* Joan Daemen
* Vincent Rijmen

AES became an official standard in 2001.

---

# AES Versions

| AES Version | Key Size | Block Size | Number of Rounds |
| ----------- | -------- | ---------- | ---------------- |
| AES-128     | 128 bits | 128 bits   | 10               |
| AES-192     | 192 bits | 128 bits   | 12               |
| AES-256     | 256 bits | 128 bits   | 14               |

---

# Basic Terminology

## Bit

Smallest unit of information.

```text
0 or 1
```

---

## Nibble

4 bits.

Example:

```text
1010
```

Equivalent:

```text
A (Hexadecimal)
```

---

## Byte

8 bits.

Example:

```text
01010011
```

Equivalent:

```text
53 (Hex)
```

Range:

```text
0 - 255
```

---

## Word

In AES:

```text
1 Word = 4 Bytes = 32 Bits
```

Example:

```text
2B 7E 15 16
```

---

# AES State Matrix

AES stores plaintext in a 4 × 4 matrix called the State.

Example:

```text
00 11 22 33
44 55 66 77
88 99 AA BB
CC DD EE FF
```

Stored internally as:

```text
|00 44 88 CC|
|11 55 99 DD|
|22 66 AA EE|
|33 77 BB FF|
```

All AES operations are performed on this State Matrix.

---

# AES Encryption Structure

AES encryption follows the structure below.

```text
Plaintext
    |
AddRoundKey
    |
Round 1
    |
Round 2
    |
...
    |
Final Round
    |
Ciphertext
```

---

# Initial Round

The first step is:

## AddRoundKey

The plaintext state is XORed with the original key.

```text
State XOR RoundKey
```

Example:

```text
1010
1100
----
0110
```

This operation introduces secret key material into the encryption process.

---

# AES Round Structure

For AES-128:

Rounds 1 to 9 contain:

1. SubBytes
2. ShiftRows
3. MixColumns
4. AddRoundKey

Final Round:

1. SubBytes
2. ShiftRows
3. AddRoundKey

MixColumns is omitted in the final round.

---

# SubBytes Transformation

## Purpose

Provides Confusion.

Confusion makes it difficult to predict relationships between plaintext, key, and ciphertext.

---

## How It Works

Every byte is replaced using the AES S-Box.

Example:

```text
53 → ED
00 → 63
```

---

## Why SubBytes Is Important

Without SubBytes:

* AES becomes mostly linear
* Mathematical attacks become easier
* Security is significantly reduced

SubBytes is the primary source of non-linearity in AES.

---

# AES S-Box

The AES S-Box contains 256 values.

Each possible byte value maps to exactly one substitute value.

The S-Box is constructed using:

* Multiplicative inverse in GF(2^8)
* Affine transformation

Designed to resist:

* Differential Cryptanalysis
* Linear Cryptanalysis

---

# ShiftRows Transformation

## Purpose

Provides diffusion across columns.

---

## Operation

Rows are shifted left.

Original:

```text
A B C D
E F G H
I J K L
M N O P
```

After ShiftRows:

```text
A B C D
F G H E
K L I J
P M N O
```

---

## Why ShiftRows Exists

Without ShiftRows:

Columns remain isolated.

With ShiftRows:

Bytes move between columns and spread across the state.

---

# MixColumns Transformation

## Purpose

Provides strong diffusion.

---

## Operation

Each column undergoes matrix multiplication in GF(2^8).

Input:

```text
[a]
[b]
[c]
[d]
```

Output:

```text
[a']
[b']
[c']
[d']
```

---

## AES MixColumns Matrix

```text
[02 03 01 01]
[01 02 03 01]
[01 01 02 03]
[03 01 01 02]
```

---

## Why MixColumns Is Important

After MixColumns:

Every output byte depends on multiple input bytes.

This creates the Avalanche Effect.

---

# Avalanche Effect

A desirable property in cryptography.

Changing a single input bit should alter approximately half of the output bits.

Example:

```text
HELLO
```

becomes

```text
HELLo
```

One-bit difference.

After several AES rounds:

Almost the entire ciphertext changes.

---

# AddRoundKey Transformation

## Purpose

Introduce secret key information.

---

## Operation

```text
State XOR Round Key
```

Example:

```text
D4 E0 B8 1E
A0 88 23 2A
--------------
74 68 9B 34
```

---

## Why XOR?

XOR is reversible.

```text
A XOR B XOR B = A
```

This makes encryption and decryption efficient.

---

# AES Key Expansion

## Problem

AES-128 requires:

```text
11 Round Keys
```

But only one key is supplied.

---

## Solution

Key Expansion generates all required round keys.

Also called:

```text
Key Schedule
```

---

# AES-128 Key Structure

AES-128 key:

```text
128 bits
=
16 bytes
=
4 words
```

Example:

```text
2B7E151628AED2A6ABF7158809CF4F3C
```

Split into:

```text
w0
w1
w2
w3
```

---

# Key Expansion Components

## RotWord

Rotates a word left by one byte.

Example:

```text
09 CF 4F 3C
```

becomes

```text
CF 4F 3C 09
```

---

## SubWord

Applies S-Box substitution to each byte.

Introduces non-linearity.

---

## Rcon

Round Constants.

| Round | Rcon        |
| ----- | ----------- |
| 1     | 01 00 00 00 |
| 2     | 02 00 00 00 |
| 3     | 04 00 00 00 |
| 4     | 08 00 00 00 |
| 5     | 10 00 00 00 |
| 6     | 20 00 00 00 |
| 7     | 40 00 00 00 |
| 8     | 80 00 00 00 |
| 9     | 1B 00 00 00 |
| 10    | 36 00 00 00 |

Rcon ensures every round key is unique.

---

# AES Decryption

AES decryption applies inverse operations.

Encryption:

```text
SubBytes
ShiftRows
MixColumns
AddRoundKey
```

Decryption:

```text
InvShiftRows
InvSubBytes
AddRoundKey
InvMixColumns
```

Each inverse operation exactly reverses the corresponding encryption step.

---

# Security of AES

AES is resistant to:

* Brute Force Attacks
* Differential Cryptanalysis
* Linear Cryptanalysis
* Statistical Attacks

---

## Key Space

AES-128:

```text
2^128
```

Possible keys.

AES-256:

```text
2^256
```

Possible keys.

These values are computationally infeasible to brute force.

---

# Real-World Applications

## Web Security

* HTTPS
* TLS

## Virtual Private Networks

* IPSec
* OpenVPN
* WireGuard

## Wireless Security

* WPA2
* WPA3

## Operating Systems

* BitLocker
* FileVault
* LUKS

## Cloud Platforms

* Google Drive
* Dropbox
* OneDrive

## Financial Systems

* Banking Infrastructure
* Payment Processing
* ATM Networks

---

# Strengths of AES

* Fast encryption and decryption
* Strong security
* Hardware acceleration support
* Low memory requirements
* Global standard
* Efficient on embedded devices

---

# Limitations of AES

## Key Management

If the key is stolen:

Encryption becomes useless.

---

## Side Channel Attacks

Implementation weaknesses may expose information through:

* Timing attacks
* Power analysis
* Cache attacks

These attacks target implementations, not AES itself.

---

# Frequently Asked Interview Questions

## Beginner

1. What does AES stand for?
2. What is a symmetric cipher?
3. What is AES block size?
4. Why did AES replace DES?
5. What is the difference between AES-128 and AES-256?

---

## Intermediate

1. What is the purpose of the S-Box?
2. Why is ShiftRows used?
3. What is MixColumns?
4. Why does AES use XOR?
5. What is Key Expansion?

---

## Advanced

1. Explain the AES State Matrix.
2. What is GF(2^8)?
3. Explain the Avalanche Effect.
4. How does AES resist differential cryptanalysis?
5. Why is MixColumns omitted in the final round?

---

# Complete AES Flow

```text
128-bit Key
      |
      v
Key Expansion
      |
      +--> Round Key 0
      +--> Round Key 1
      +--> Round Key 2
      +--> Round Key 3
      ...
      +--> Round Key 10

Plaintext
      |
AddRoundKey
      |
SubBytes
ShiftRows
MixColumns
AddRoundKey
      |
Repeat Rounds
      |
Final Round
(SubBytes + ShiftRows + AddRoundKey)
      |
Ciphertext
```

---

# Conclusion

AES is a symmetric 128-bit block cipher standardized by NIST and based on the Rijndael algorithm. Through the repeated application of SubBytes, ShiftRows, MixColumns, AddRoundKey, and a carefully designed Key Expansion process, AES provides strong confidentiality, excellent performance, and resistance against modern cryptanalytic attacks.

AES remains one of the most trusted and widely deployed cryptographic algorithms in the world.

