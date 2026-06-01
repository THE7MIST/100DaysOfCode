# Classical Symmetric Ciphers in CrypTool 1

## Introduction

The **Encrypt/Decrypt → Symmetric (Classic)** menu in CrypTool 1 contains several classical cryptographic algorithms.

```text
Encrypt/Decrypt
 └─ Symmetric (Classic)
      ├─ Caesar / ROT-13
      ├─ Vigenère
      ├─ Hill
      ├─ Substitution / Atbash
      ├─ Playfair
      ├─ ADFGVX
      ├─ Byte Addition
      ├─ XOR
      ├─ Vernam / One-Time Pad (OTP)
      ├─ Homophonic
      ├─ Permutation / Transposition
      ├─ Solitaire
      └─ Scytale / Rail Fence
```

Most of these are **classical symmetric ciphers**, meaning the same key is used for both encryption and decryption.

---

# 1. Caesar Cipher (ROT-n)

## Concept

Each letter is shifted by a fixed number of positions in the alphabet.

### Example (Shift = 3)

```text
A → D
B → E
C → F
```

### Plaintext

```text
HELLO
```

### Ciphertext

```text
KHOOR
```

### Formula

```text
E(x) = (x + k) mod 26
```

Where:

* x = Plaintext letter
* k = Shift value

### Advantages

* Simple to understand
* Fast encryption

### Disadvantages

* Only 25 possible keys
* Easily broken using brute force

---

# 2. Vigenère Cipher

## Concept

Uses a keyword instead of a single shift value.

### Plaintext

```text
ATTACKATDAWN
```

### Key

```text
LEMON
```

### Repeated Key

```text
LEMONLEMONLE
```

### Ciphertext

```text
LXFOPVEFRNHR
```

### Working

| Letter | Key | Shift |
| ------ | --- | ----- |
| A      | L   | 11    |
| T      | E   | 4     |
| T      | M   | 12    |

Each character uses a different Caesar shift.

### Security

Stronger than Caesar Cipher.

### Weakness

Can be broken using:

* Frequency Analysis
* Kasiski Examination

---

# 3. Hill Cipher

## Concept

Uses matrix mathematics for encryption.

### Key Matrix

```text
| 3  3 |
| 2  5 |
```

### Plaintext

```text
HI
```

### Conversion

```text
H = 7
I = 8
```

The plaintext vector is multiplied by the key matrix to generate ciphertext.

### Features

* Encrypts blocks of letters
* Provides diffusion
* Uses linear algebra

### Weakness

If sufficient plaintext-ciphertext pairs are known, the key matrix can be recovered.

---

# 4. Substitution Cipher

## Concept

Each letter is replaced by another letter according to a predefined mapping.

### Example Mapping

```text
A → Q
B → W
C → E
```

### Plaintext

```text
HELLO
```

### Ciphertext

```text
ITSSG
```

### Security

More secure than Caesar Cipher.

### Weakness

Vulnerable to frequency analysis.

---

# 5. Atbash Cipher

## Concept

Uses a reversed alphabet.

```text
A ↔ Z
B ↔ Y
C ↔ X
```

### Example

```text
HELLO
```

becomes

```text
SVOOL
```

### Historical Note

Atbash is an ancient Hebrew substitution cipher.

---

# 6. Playfair Cipher

## Concept

Encrypts pairs of letters (digraphs) instead of single letters.

Uses a 5 × 5 matrix.

### Keyword

```text
MONARCHY
```

### Matrix

```text
M O N A R
C H Y B D
E F G I K
L P Q S T
U V W X Z
```

### Plaintext

```text
HELLO
```

### Pairs

```text
HE LL OX
```

### Ciphertext

```text
CF PP NA
```

### Advantages

* Hides single-letter frequencies
* More secure than simple substitution

---

# 7. ADFGVX Cipher

## Concept

German military cipher used during World War I.

Combines:

1. Polybius Square
2. Columnar Transposition

### Symbols Used

```text
A D F G V X
```

### Example Flow

```text
HELLO
   ↓
DF AG GX ...
   ↓
Columnar Transposition
   ↓
Ciphertext
```

### Security

Very strong for its historical period.

---

# 8. Byte Addition Cipher

## Concept

Operates directly on byte values.

### Formula

```text
Cipher = Plain + Key
```

Performed modulo 256.

### Example

```text
65 + 3 = 68
```

```text
A → D
```

### Usage

Useful when working with binary files.

---

# 9. XOR Cipher

## Concept

Uses the Exclusive OR (XOR) operation.

### Truth Table

| A | B | XOR |
| - | - | --- |
| 0 | 0 | 0   |
| 0 | 1 | 1   |
| 1 | 0 | 1   |
| 1 | 1 | 0   |

### Example

Plaintext

```text
1010
```

Key

```text
1100
```

Ciphertext

```text
0110
```

### Important Property

```text
Plain XOR Key = Cipher
Cipher XOR Key = Plain
```

### Usage

Widely used in modern cryptographic systems.

---

# 10. Vernam Cipher / One-Time Pad (OTP)

## Concept

The only encryption system proven to provide perfect secrecy.

### Requirements

* Truly random key
* Key length equals message length
* Key used only once

### Example

Message

```text
HELLO
```

Random Key

```text
XMCKL
```

Encryption is performed character-by-character.

### Security

Claude Shannon proved OTP provides:

```text
Perfect Secrecy
```

### Weakness

Secure key distribution is difficult.

---

# 11. Homophonic Cipher

## Concept

A single plaintext letter may map to multiple ciphertext symbols.

### Example

```text
E → 15, 22, 41, 88
```

Since E appears frequently, multiple mappings help hide statistical patterns.

### Advantage

More resistant to frequency analysis than standard substitution ciphers.

---

# 12. Permutation / Transposition Cipher

## Concept

Letters remain unchanged.

Only their positions are rearranged.

### Plaintext

```text
HELLO
```

### Rearranged

```text
LEHOL
```

### Key Point

Characters are not substituted.

Only reordered.

---

# 13. Solitaire Cipher

## Concept

Designed by Bruce Schneier.

Uses a standard deck of 52 playing cards.

### Steps

1. Move Joker A
2. Move Joker B
3. Triple Cut
4. Count Cut
5. Generate Keystream

### Encryption Flow

```text
HELLO
   ↓
Generated Keystream
   ↓
Ciphertext
```

### Historical Note

Featured in the novel *Cryptonomicon*.

---

# 14. Scytale Cipher

## Concept

Ancient Spartan military transposition cipher.

A message is written around a cylindrical rod.

### Example

Message

```text
HELLOWORLD
```

Wrapped Around Rod

```text
HLOOL
ELWRD
```

Read Row-Wise

```text
HLOOLELWRD
```

### Requirement

The receiver must possess a rod of the same diameter to decrypt the message.

---

# 15. Rail Fence Cipher

## Concept

A transposition cipher that writes text in a zig-zag pattern.

### Example (3 Rails)

Plaintext

```text
WEAREDISCOVERED
```

Pattern

```text
W   E   C   R
 E R D S O E E
  A   I   V   D
```

Ciphertext

```text
WECRERDSOEEAIVD
```

### Classification

Transposition Cipher.

---

# Relative Security Ranking

| Cipher       | Security Level        |
| ------------ | --------------------- |
| Caesar       | Very Weak             |
| Atbash       | Very Weak             |
| Substitution | Weak                  |
| Rail Fence   | Weak                  |
| Playfair     | Medium                |
| Vigenère     | Medium                |
| Hill         | Medium                |
| ADFGVX       | Strong (Historically) |
| XOR          | Depends on Key        |
| Vernam / OTP | Theoretically Perfect |
| Solitaire    | Strong                |
| AES          | Extremely Strong      |

---

# Important Exam Ciphers

The most commonly asked ciphers in cryptography practical examinations, laboratory assessments, and viva examinations are:

* Caesar Cipher
* Vigenère Cipher
* Playfair Cipher
* Hill Cipher
* Rail Fence Cipher
* Vernam Cipher (OTP)
* XOR Cipher
* ADFGVX Cipher

These algorithms form the foundation for understanding modern cryptographic systems and classical encryption techniques.

