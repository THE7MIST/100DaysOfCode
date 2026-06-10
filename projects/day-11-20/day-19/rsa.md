# RSA (Extracted & Cleaned Notes)

## RSA Communication

**Alice → Bob**

Ciphertext = `E(M, PubB)`

Encrypt the message using **Bob's Public Key**.

**Bob**

Message = `D(C, PrivB)`

Decrypt the ciphertext using **Bob's Private Key**.

---

# How RSA Works

## Step 1: Choose Two Prime Numbers

```text
p = 2
q = 7
```

---

## Step 2: Calculate N

Formula:

```text
N = p × q
```

Calculation:

```text
N = 2 × 7
N = 14
```

---

## Step 3: Calculate Euler's Totient Function

Formula:

```text
φ(N) = (p − 1)(q − 1)
```

Calculation:

```text
φ(N) = (2 − 1)(7 − 1)
     = 1 × 6
     = 6
```

---

## Step 4: Choose Public Exponent (e)

Conditions:

```text
1 < e < φ(N)
```

and

```text
gcd(e, φ(N)) = 1
```

Possible values:

```text
1  2  3  4  5  6
           ↑
         e = 5
```

Verification:

```text
gcd(5, 6) = 1
```

Therefore:

```text
e = 5
```

### Public Key

```text
(e, N)
(5, 14)
```

This key is published publicly.

---

## Step 5: Choose Private Exponent (d)

Condition:

```text
d × e ≡ 1 (mod φ(N))
```

Substituting values:

```text
d × 5 ≡ 1 (mod 6)
```

Checking values:

```text
5 × 1 = 5   mod 6 = 5
5 × 2 = 10  mod 6 = 4
5 × 3 = 15  mod 6 = 3
5 × 4 = 20  mod 6 = 2
5 × 5 = 25  mod 6 = 1 ✓
```

Therefore:

```text
d = 5
```

### Private Key

```text
(d, N)
(5, 14)
```

---

# Encryption Example

### Plaintext

```text
B = 2
```

Alphabet Mapping:

```text
A = 1
B = 2
C = 3
D = 4
...
```

Encryption Formula:

```text
C = M^e mod N
```

Substitute values:

```text
C = 2^5 mod 14
```

```text
= 32 mod 14
= 4
```

Because:

```text
14 × 2 = 28
32 − 28 = 4
```

Cipher Value:

```text
4
```

Mapping back:

```text
4 → D
```

### Ciphertext

```text
D
```

---

# Decryption Example

### Ciphertext

```text
D = 4
```

Decryption Formula:

```text
M = C^d mod N
```

Substitute values:

```text
M = 4^5 mod 14
```

```text
= 1024 mod 14
= 2
```

Mapping back:

```text
2 → B
```

### Recovered Plaintext

```text
B
```

---

# Relationship Between 5 and 14

In this RSA example:

```text
5  → Public Exponent (e)
14 → Modulus (N = p × q)
```

They are not directly related except that together they form the Public Key:

```text
Public Key = (5, 14)
```

The important requirement is:

```text
gcd(5, φ(14))
= gcd(5, 6)
= 1
```

Therefore, `5` is a valid public exponent because it is coprime with `φ(N)`.

---

# Important Correction

⚠️ This example is only for learning RSA concepts.

Using:

```text
p = 2
q = 7
```

is mathematically correct for demonstration but **not secure**.

Real RSA implementations use very large prime numbers.

Typical RSA key sizes:

| Key Size | Status      |
| -------- | ----------- |
| 1024-bit | Deprecated  |
| 2048-bit | Acceptable  |
| 3072-bit | Recommended |
| 4096-bit | Very Strong |

### Real-World RSA Requirements

* Use very large prime numbers.
* Public and private keys must be generated securely.
* Typical key lengths are 2048-bit, 3072-bit, or 4096-bit.
* Small values such as `p = 2` should never be used in production systems.

---

## Conclusion

RSA is an asymmetric cryptographic algorithm that uses a pair of keys:

* **Public Key** for encryption
* **Private Key** for decryption

Its security relies on the difficulty of factoring very large numbers into their prime factors. The example above demonstrates the RSA workflow using small numbers for educational purposes, while real-world RSA uses large prime numbers and strong key lengths to provide secure communication.
