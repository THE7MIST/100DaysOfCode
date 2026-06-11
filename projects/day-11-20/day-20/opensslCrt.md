# OpenSSL Certificates

## 1. Generate Self-Signed RSA Certificate

### Command

```bash
openssl req -x509 -key rsa2048.pem -out rsaCert2048.pem
```

### Attributes

| Option               | Meaning                                |
| -------------------- | -------------------------------------- |
| openssl              | OpenSSL utility                        |
| req                  | Certificate Request utility            |
| -x509                | Generate self-signed X.509 certificate |
| -key rsa2048.pem     | Use existing RSA private key           |
| -out rsaCert2048.pem | Save certificate to file               |

### Description

Creates a self-signed X.509 certificate using an existing RSA private key.

During execution OpenSSL asks for:

* Country
* State
* Locality
* Organization
* Common Name (CN)
* Email Address

---

## 2. View Certificate Contents

### Command

```bash
cat rsaCert2048.pem
```

### Description

Displays certificate contents in PEM format.

Output begins with:

```text
-----BEGIN CERTIFICATE-----
```

and ends with:

```text
-----END CERTIFICATE-----
```

### Observation

Certificate contains:

* Subject Information
* Public Key
* Digital Signature
* Certificate Metadata

---

## 3. Display Certificate Details

### Command

```bash
openssl x509 -in rsaCert2048.pem -noout -text
```

### Attributes

| Option | Meaning                     |
| ------ | --------------------------- |
| x509   | Certificate utility         |
| -in    | Input certificate           |
| -noout | Hide PEM output             |
| -text  | Show human-readable details |

### Important Fields

#### Version

```text
Version: 3
```

#### Serial Number

Unique certificate identifier.

#### Signature Algorithm

```text
sha256WithRSAEncryption
```

#### Issuer

Entity that signed the certificate.

```text
Issuer: C=IN, ST=MH, ...
```

#### Subject

Certificate owner.

```text
Subject: C=IN, ST=MH, ...
```

#### Validity

```text
Not Before
Not After
```

Certificate start and expiry dates.

#### Public Key Algorithm

```text
rsaEncryption
```

#### Public Key

```text
Public-Key: (2048 bit)
```

#### Modulus

Main RSA public number.

#### Exponent

```text
65537
```

Standard RSA public exponent.

---

## 4. Verify RSA Private Key Details

### Command

```bash
openssl rsa -in rsa2048.pem -noout -text
```

### Attributes

| Option | Meaning                   |
| ------ | ------------------------- |
| rsa    | RSA utility               |
| -in    | Input RSA private key     |
| -noout | Hide PEM output           |
| -text  | Show readable key details |

### Important Fields

#### Modulus

```text
N = p × q
```

Main RSA public number.

#### publicExponent

```text
65537
```

Used for:

* Encryption
* Signature Verification

#### privateExponent

Secret value used for:

* Decryption
* Digital Signatures

#### prime1

First prime number (p)

#### prime2

Second prime number (q)

#### exponent1

CRT optimization value.

#### exponent2

CRT optimization value.

#### coefficient

CRT coefficient used to speed up RSA calculations.

### Observation

The modulus in:

```bash
openssl x509 -in rsaCert2048.pem -noout -text
```

and

```bash
openssl rsa -in rsa2048.pem -noout -text
```

is identical.

Reason:

The certificate contains the public key generated from the same RSA key pair.

---

# Self-Signed Certificate

## Same Issuer and Subject

For self-signed certificates:

```text
Issuer = Subject
```

Example:

```text
Issuer  = C=IN, ST=MH, ...
Subject = C=IN, ST=MH, ...
```

Reason:

The certificate signs itself.

### Display Issuer

```bash
openssl x509 -in rsaCert2048.pem -noout -issuer
```

### Display Subject

```bash
openssl x509 -in rsaCert2048.pem -noout -subject
```

---

# Multiple Certificates from One Key

Yes.

A single RSA private key can generate multiple certificates.

Example:

```bash
openssl req -x509 -key rsa2048.pem -out cert1.pem

openssl req -x509 -key rsa2048.pem -out cert2.pem

openssl req -x509 -key rsa2048.pem -out cert3.pem
```

Different:

* CN
* Organization
* Validity

Same:

* RSA Key Pair
* Public Key Modulus

---

# Provide Subject in One Command

Instead of interactive prompts:

```bash
openssl req -x509 \
-key rsa2048.pem \
-out rsaCert2048.pem \
-subj "/C=IN/ST=MH/L=Pune/O=mistofVon/CN=mist/emailAddress=mist@mist.in"
```

### Subject Fields

| Field        | Meaning             |
| ------------ | ------------------- |
| C            | Country             |
| ST           | State               |
| L            | Locality            |
| O            | Organization        |
| OU           | Organizational Unit |
| CN           | Common Name         |
| emailAddress | Email Address       |

---

# Self-Signed vs CA-Signed Certificate

| Self-Signed      | CA-Signed           |
| ---------------- | ------------------- |
| Signed by itself | Signed by CA        |
| Issuer = Subject | Issuer ≠ Subject    |
| Browser warning  | Trusted             |
| Testing/Lab use  | Production use      |
| Free             | Trusted by browsers |

### Self-Signed

```text
Issuer = Subject
```

### CA-Signed

```text
Subject = example.com
Issuer  = DigiCert
```

---

# ECC Certificate

## Generate ECC Key

```bash
openssl genpkey \
-algorithm EC \
-pkeyopt ec_paramgen_curve:P-256 \
-out ecKey.pem
```

## Generate ECC Certificate

```bash
openssl req -x509 \
-key ecKey.pem \
-out ecCert.pem
```

## View ECC Certificate

```bash
openssl x509 -in ecCert.pem -noout -text
```

Output shows:

```text
Public Key Algorithm:
id-ecPublicKey
```

instead of:

```text
rsaEncryption
```

---

# Certificate Issuer

Every valid X.509 certificate contains an Issuer.

### Self-Signed

```text
Issuer = Subject
```

### CA-Signed

```text
Issuer = Certificate Authority
```

Therefore:

```text
No Issuer
```

is not possible.

---

# Viva Questions

### How to display Issuer?

```bash
openssl x509 -in rsaCert2048.pem -noout -issuer
```

### How to display Subject?

```bash
openssl x509 -in rsaCert2048.pem -noout -subject
```

### How to identify a self-signed certificate?

```text
Issuer = Subject
```

### Can one RSA key generate multiple certificates?

```text
Yes
```

### Difference between RSA and ECC Certificates?

```text
RSA → rsaEncryption
ECC → id-ecPublicKey
```

### Can a certificate exist without an Issuer?

```text
No
```

Every X.509 certificate contains an Issuer field.
