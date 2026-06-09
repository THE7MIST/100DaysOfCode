# OpenSSL Notes

## Reference

Packet Pushers Video:

https://youtu.be/17-GRHJ8I0s?si=Dm0FL04jd7nEvOnS

---

# Introduction to OpenSSL

OpenSSL is a free and open-source cryptographic software library and command-line utility used to implement secure communication over networks.

It provides support for:

* SSL (Secure Sockets Layer)
* TLS (Transport Layer Security)

These protocols secure HTTPS communication on the Internet.

Apart from SSL/TLS, OpenSSL provides:

* Encryption and Decryption
* Public and Private Key Generation
* Digital Certificate Creation
* Certificate Management
* Digital Signature Generation and Verification
* Hashing Functions
* Message Authentication

OpenSSL is widely used in:

* Web Servers
* Email Servers
* VPNs
* Cloud Systems
* Security Applications

---

# Features of OpenSSL

## SSL/TLS Support

Implements SSL and TLS protocols for secure communication.

## Key Generation

Generates:

* RSA Keys
* DSA Keys
* ECC Keys

## Certificate Management

Creates:

* Self-Signed Certificates
* Certificate Signing Requests (CSR)

## Encryption and Decryption

Encrypts and decrypts files and messages.

## Digital Signatures

Creates and verifies digital signatures.

## Hash Functions

Supports:

* SHA-256
* SHA-384
* SHA-512

---

# Applications of OpenSSL

* Securing websites using HTTPS
* Creating SSL/TLS certificates
* Encrypting sensitive files
* Implementing PKI
* Testing SSL/TLS connections
* Generating CSRs

---

# Advantages

* Free and Open Source
* Cross Platform
* Supports Many Algorithms
* Industry Standard
* Frequently Updated

---

# Installation

## Ubuntu / Debian

```bash
sudo apt install openssl libssl-dev libssl-doc -y
```

### Packages

| Package    | Purpose               |
| ---------- | --------------------- |
| openssl    | Command-line utility  |
| libssl-dev | Development libraries |
| libssl-doc | Documentation         |

---

# Version Information

## Check Version

```bash
openssl version
```

## Check Configuration Directory

```bash
openssl version -d
```

Typical contents:

| File/Directory | Purpose            |
| -------------- | ------------------ |
| openssl.cnf    | Main configuration |
| certs          | Certificates       |
| private        | Private keys       |
| cert.pem       | Certificate bundle |

---

# Key Generation Commands

```bash
openssl help | grep gen
```

```bash
openssl list -commands | grep gen
```

Examples:

* genrsa
* genpkey
* gendsa

---

# Default RSA Key Size

```bash
cat /usr/lib/ssl/openssl.cnf | grep -n5 default_bits
```

Output:

```text
default_bits = 2048
```

## Why 2048 Bits?

Benefits:

* Good Security
* Reasonable Speed
* Industry Standard

---

# RSA Key Generation

## Generate RSA Key

```bash
openssl genrsa
```

Output appears on terminal:

```text
-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----
```

### Is It Saved?

No.

Without `-out`, the key is displayed only on screen.

---

## Save RSA Key

```bash
openssl genrsa -out private.key 2048
```

or

```bash
openssl genpkey -algorithm RSA -out private.key
```

Verify:

```bash
ls
```

---

# RSA Key Size Comparison

| RSA Key Size | Security Strength | Status      |
| ------------ | ----------------- | ----------- |
| 1024         | ~80 bits          | Unsafe      |
| 2048         | ~112 bits         | Acceptable  |
| 3072         | ~128 bits         | Recommended |
| 4096         | ~140+ bits        | Very Strong |

---

# Can RSA Use Any Size?

Examples:

```bash
openssl genrsa 512
openssl genrsa 1024
openssl genrsa 2048
openssl genrsa 4096
openssl genrsa 8192
```

Practical sizes:

* 2048
* 3072
* 4096

Very large keys:

* Slow
* Memory intensive
* Impractical

---

# Why Powers of Two?

Examples:

```text
2^9  = 512
2^10 = 1024
2^11 = 2048
2^12 = 4096
```

Advantages:

* Efficient Memory Allocation
* Faster Computation
* Better Compatibility

---

# Very Large RSA Keys

Example:

```bash
openssl genrsa 40000
```

OpenSSL may allow it but:

* Extremely Slow
* Huge Memory Usage
* Not Recommended

Real-world recommendations:

* RSA 2048
* RSA 3072
* RSA 4096

---

# Key Generation Time

### Small Keys

```bash
openssl genrsa 512
```

Generated almost instantly.

### Large Keys

Take longer because RSA requires:

* Large Prime Generation
* Primality Testing
* Large Integer Arithmetic

Larger key = Longer generation time.

---

# Saving RSA Keys in PEM Format

```bash
openssl genrsa -out rsaKey2048.pem 2048
```

Verify:

```bash
ls
```

View contents:

```bash
cat rsaKey2048.pem
```

---

# PEM Format

## PEM Meaning

PEM = Privacy Enhanced Mail

Used for:

* Private Keys
* Public Keys
* Certificates
* CSRs

Example:

```text
-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----
```

### Benefits

* Human Readable
* Portable
* Easy to Copy
* Cross Platform

---

# Base64 Encoding

Actual key data is binary.

PEM converts:

```text
Binary
   ↓
Base64
   ↓
PEM File
```

Uses characters:

```text
A-Z
a-z
0-9
+
/
=
```

---

# Common Key Formats

| Format | Extension | Purpose             |
| ------ | --------- | ------------------- |
| PEM    | .pem      | Base64 Text         |
| DER    | .der      | Binary              |
| CRT    | .crt      | Certificate         |
| CER    | .cer      | Certificate         |
| KEY    | .key      | Private Key         |
| CSR    | .csr      | Certificate Request |
| PFX    | .pfx      | Certificate + Key   |
| P12    | .p12      | PKCS#12             |
| JKS    | .jks      | Java KeyStore       |

---

# Key Size Must Be Last

Wrong:

```bash
openssl genrsa 512 -out rsaKey.pem
```

Correct:

```bash
openssl genrsa -out rsaKey512.pem 512
```

---

# Inspecting RSA Keys

```bash
openssl rsa -in rsaKey512.pem -text
```

```bash
openssl rsa -in rsaKey512.pem -text -noout
```

### Difference

Without `-noout`

* Human-readable information
* PEM content

With `-noout`

* Human-readable information only

---

# RSA Components

## Modulus

Generated from:

```text
p × q
```

Where:

* p = Prime Number
* q = Prime Number

---

## Public Exponent

Usually:

```text
65537
```

Used for:

* Encryption
* Signature Verification

---

## Private Exponent

Used for:

* Decryption
* Digital Signatures

---

## Prime1 and Prime2

The two large prime numbers:

```text
p
q
```

---

## Exponent1 / Exponent2

Optimization values.

---

## Coefficient

Used by CRT (Chinese Remainder Theorem).

Speeds up RSA operations.

---

# RSA Trapdoor Function

A trapdoor function is:

```text
Easy in one direction
Hard in reverse
```

Example:

```text
17 × 23 = 391
```

Easy.

Given:

```text
391
```

Finding:

```text
17 and 23
```

Much harder.

RSA security relies on this difficulty.

---

# Why RSA Key Sizes Keep Increasing

Timeline:

```text
512
1024
2048
3072
4096
```

Reason:

Computers become faster.

Larger keys are needed for long-term security.

### Modern Recommendation

| Size | Status      |
| ---- | ----------- |
| 512  | Broken      |
| 1024 | Deprecated  |
| 2048 | Acceptable  |
| 3072 | Recommended |
| 4096 | Very Strong |

Instructor Recommendation:

```text
RSA 3072
```

---

# Elliptic Curve Cryptography (ECC)

## Generate EC Parameters

```bash
openssl genpkey \
-genparam \
-algorithm EC \
-pkeyopt ec_paramgen_curve:secp384r1
```

### Meaning

| Option            | Purpose                  |
| ----------------- | ------------------------ |
| genpkey           | Generate key material    |
| -genparam         | Generate parameters only |
| -algorithm EC     | Use ECC                  |
| -pkeyopt          | Specify option           |
| ec_paramgen_curve | Choose curve             |
| secp384r1         | NIST P-384               |

---

# What Is ECC?

ECC uses points on an elliptic curve.

RSA relies on:

```text
Prime Factorization
```

ECC relies on:

```text
Elliptic Curve Discrete Logarithm Problem
```

ECC provides equivalent security using much smaller keys.

---

# Why ECC Exists

RSA requires:

* More CPU
* More Memory
* More Bandwidth

Problematic for:

* IoT Devices
* Smart Cards
* Mobile Devices

ECC solves this.

---

# Create EC Parameter File

```bash
openssl genpkey -genparam \
-algorithm EC \
-pkeyopt ec_paramgen_curve:secp384r1 \
-out ecParam.pem
```

---

# Inspect EC Parameters

```bash
openssl ecparam -in ecParam.pem -text -noout
```

Output:

```text
EC-Parameters: (384 bit)
ASN1 OID: secp384r1
NIST CURVE: P-384
```

---

# Generate EC Key

```bash
openssl genpkey \
-paramfile ecParam.pem \
-out ecKey1.pem
```

---

# Inspect EC Key

```bash
openssl ec -in ecKey1.pem -text -noout
```

Fields:

| Field      | Meaning             |
| ---------- | ------------------- |
| priv       | Private value       |
| pub        | Public key          |
| ASN1 OID   | Curve identifier    |
| NIST CURVE | Friendly curve name |

---

# File Size Comparison

Approximate:

```text
ECC Key     ≈ 300 Bytes
RSA 2048    ≈ 1700+ Bytes
```

ECC keys are much smaller.

---

# Security Comparison

| RSA       | ECC         |
| --------- | ----------- |
| RSA 2048  | ECC 224-256 |
| RSA 3072  | ECC 256     |
| RSA 7680  | ECC 384     |
| RSA 15360 | ECC 521     |

ECC provides equivalent security with smaller keys.

---

# Direct EC Key Generation

Instead of:

```text
Generate Parameters
      ↓
Generate Key
```

Directly generate:

```bash
openssl genpkey \
-algorithm EC \
-pkeyopt ec_paramgen_curve:P-256 \
-out ecKey2.pem
```

---

# Inspect P-256 Key

```bash
openssl ec -in ecKey2.pem -text -noout
```

Output:

```text
Private-Key: (256 bit)
Curve: prime256v1
```

Equivalent:

```text
NIST P-256
```

---

# List Supported Curves

```bash
openssl ecparam -list_curves
```

Examples:

```text
secp256k1
secp384r1
secp521r1
prime256v1
```

---

# Common ECC Curves

| Curve     | Usage                 |
| --------- | --------------------- |
| P-256     | Most Common           |
| P-384     | Higher Security       |
| P-521     | Maximum NIST Security |
| secp256k1 | Bitcoin               |

Most deployments use:

* P-256
* P-384
* P-521

Because of:

* Strong Security
* Compatibility
* Industry Support

---

# Conclusion

This lab demonstrates generation and inspection of RSA and ECC keys using OpenSSL.

### RSA

Security depends on:

```text
Prime Factorization
```

Recommended:

```text
RSA 3072
```

### ECC

Security depends on:

```text
Elliptic Curve Discrete Logarithm Problem
```

Recommended:

```text
P-256
P-384
```

### Key Takeaway

ECC provides security equivalent to RSA while using much smaller keys, making it ideal for modern systems, mobile devices, IoT devices, and smart cards.

PEM remains the most common storage format because it stores binary key data as Base64-encoded text that is easy to store, transfer, and manage across platforms.
