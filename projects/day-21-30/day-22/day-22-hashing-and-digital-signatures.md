# Practical 1: Generate and Compare Hash Values Using OpenSSL

## Aim

To generate MD5, SHA-256, and SHA-512 hash values of a file using OpenSSL, modify the file contents, regenerate the hashes, and compare the results to verify data integrity.

---

## Step 1: Create a Sample File

### Command

```bash
echo "Hello World" > sample.txt
```

### Verify File Content

```bash
cat sample.txt
```

Expected Output:

```text
Hello World
```

---

## Step 2: Generate MD5 Hash

### Command

```bash
openssl dgst -md5 sample.txt
```

### Explanation

| Attribute | Description |
|------------|-------------|
| dgst | Digest (hash) utility |
| -md5 | Uses MD5 algorithm |
| sample.txt | Input file |

Example Output:

```text
MD5(sample.txt)= b10a8db164e0754105b7a99be72e3fe5
```

---

## Step 3: Generate SHA-256 Hash

### Command

```bash
openssl dgst -sha256 sample.txt
```

Example Output:

```text
SHA256(sample.txt)= a591a6d40bf420404a011733cfb7b190...
```

---

## Step 4: Generate SHA-512 Hash

### Command

```bash
openssl dgst -sha512 sample.txt
```

Example Output:

```text
SHA512(sample.txt)= 2c74fd17edafd80e8447b0d46741ee24...
```

---

## Step 5: Save Hash Values

```bash
openssl dgst -md5 sample.txt > md5_before.txt

openssl dgst -sha256 sample.txt > sha256_before.txt

openssl dgst -sha512 sample.txt > sha512_before.txt
```

---

## Step 6: Modify the File

### Command

```bash
echo "Hello World Modified" > sample.txt
```

### Verify

```bash
cat sample.txt
```

Expected Output:

```text
Hello World Modified
```

---

## Step 7: Generate New MD5 Hash

```bash
openssl dgst -md5 sample.txt
```

---

## Step 8: Generate New SHA-256 Hash

```bash
openssl dgst -sha256 sample.txt
```

---

## Step 9: Generate New SHA-512 Hash

```bash
openssl dgst -sha512 sample.txt
```

---

## Step 10: Compare Original and New Hashes

Display original hashes:

```bash
cat md5_before.txt

cat sha256_before.txt

cat sha512_before.txt
```

Generate current hashes:

```bash
openssl dgst -md5 sample.txt

openssl dgst -sha256 sample.txt

openssl dgst -sha512 sample.txt
```

### Observation

Even a small modification in the file changes the entire hash value.

---

## Result

The MD5, SHA-256, and SHA-512 hash values of the file were successfully generated using OpenSSL. After modifying the file, completely different hash values were obtained, demonstrating the integrity-checking property of cryptographic hash functions.

---

## Conclusion

Hash functions generate a unique fixed-length digest for input data. Any change in the file content results in a different hash value. Therefore, hashing can be used to verify data integrity and detect unauthorized modifications.

---

# Practical 2: Digitally Sign a PDF Document Using Adobe Acrobat and a Self-Created Certificate

## Aim

To create a self-signed digital certificate using OpenSSL, digitally sign a PDF document using Adobe Acrobat, verify the digital signature, and demonstrate how hashing and digital signatures provide integrity and authenticity.

---

## Step 1: Generate a Private Key

### Command

```bash
openssl genpkey -algorithm RSA -out sign.key
```

### Explanation

| Attribute | Description |
|------------|-------------|
| genpkey | Generates a private key |
| -algorithm RSA | Uses RSA algorithm |
| -out sign.key | Saves key to sign.key |

---

## Step 2: Create a Self-Signed Certificate

### Command

```bash
openssl req -new -x509 -key sign.key -out sign.crt -days 365
```

### Sample Values

```text
Country Name: IN
State: MH
Locality: Pune
Organization: MIST
Common Name: Student
Email Address: student@mist.ac.in
```

### Explanation

| Attribute | Description |
|------------|-------------|
| req | Certificate request utility |
| -new | Creates new request |
| -x509 | Creates self-signed certificate |
| -key sign.key | Uses private key |
| -out sign.crt | Output certificate |
| -days 365 | Valid for 1 year |

---

## Step 3: Export Certificate to PKCS#12 Format

### Command

```bash
openssl pkcs12 -export -out sign.pfx -inkey sign.key -in sign.crt
```

### Explanation

| Attribute | Description |
|------------|-------------|
| pkcs12 | PKCS#12 utility |
| -export | Export certificate |
| -out sign.pfx | Output PFX file |
| -inkey sign.key | Private key |
| -in sign.crt | Certificate |

Enter a password when prompted.

---

## Step 4: Verify Certificate

### Command

```bash
openssl x509 -in sign.crt -text -noout
```

Verify:

- Subject Name
- Public Key
- Validity Period

---

## Step 5: Create a PDF Document

Create a simple PDF file:

```text
Digital Signature Demonstration
Name: Student
Roll No: XYZ
```

Save as:

```text
document.pdf
```

---

## Step 6: Import Certificate into Adobe Acrobat

1. Open Adobe Acrobat Reader
2. Edit → Preferences
3. Signatures
4. Identities & Trusted Certificates
5. More
6. Digital IDs
7. Add ID
8. Import Existing Digital ID
9. Select:

```text
sign.pfx
```

10. Enter password
11. Finish

---

## Step 7: Digitally Sign the PDF

1. Open `document.pdf`
2. Tools → Certificates
3. Digitally Sign
4. Select signature area
5. Choose imported certificate
6. Click Sign
7. Save as:

```text
document_signed.pdf
```

---

## Step 8: Verify Digital Signature

1. Open `document_signed.pdf`
2. Click Signature Panel
3. View Signature Properties
4. Verify Signature

Expected Result:

```text
Signature is Valid
Document has not been modified
```

---

## Step 9: Test Integrity

Modify the signed PDF.

Example:

```text
Change:
Name: Student

To:
Name: Student Modified
```

Save the file.

Open the PDF again.

Expected Result:

```text
Signature Invalid
Document Modified After Signing
```

---

# Working Principle

## Hashing

Before signing, Adobe computes a cryptographic hash:

```text
SHA-256(document.pdf)
```

---

## Digital Signature

The hash is encrypted using the signer's private key.

```text
Digital Signature = Encrypt(Hash, Private Key)
```

---

## Verification

The receiver:

1. Computes a new hash of the PDF
2. Decrypts the digital signature using the public key
3. Compares both hashes

If both match:

```text
Integrity Verified
Authenticity Verified
```

---

## Result

A self-signed certificate was successfully created using OpenSSL. The certificate was imported into Adobe Acrobat and used to digitally sign a PDF document. Signature verification confirmed document authenticity and integrity. Any modification to the signed document invalidated the signature.

---

## Conclusion

Digital signatures use cryptographic hashing and public-key cryptography to ensure:

- Integrity
- Authentication
- Non-repudiation

Any alteration of the signed document changes the hash value and causes signature verification to fail.
