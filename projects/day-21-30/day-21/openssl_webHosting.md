# Deploy HTTPS Website Using Sub CA Certificate

## Objective

Deploy a HTTPS website (`www.mist.ac.in`) using a server certificate issued by a **Sub CA**.

### Requirements

* Domain: `www.mist.ac.in`
* `subjectAltName` must contain `www.mist.ac.in`
* DNS should resolve `www.mist.ac.in → Web Server IP`
* Root CA must **not** sign server certificates directly
* Sub CA must issue server certificate
* Apache must use Server Certificate + Sub CA Chain

---

# Step 1: Create Root CA Private Key

```bash
openssl genpkey -algorithm RSA -out root.key
```

### Attributes

| Option         | Purpose              |
| -------------- | -------------------- |
| genpkey        | Generate private key |
| -algorithm RSA | Use RSA algorithm    |
| -out root.key  | Save key to file     |

---

# Step 2: Create Root CA CSR

```bash
openssl req -new -key root.key -out root.csr
```

### Attributes

| Option        | Purpose          |
| ------------- | ---------------- |
| req           | CSR utility      |
| -new          | Create CSR       |
| -key root.key | Root private key |
| -out root.csr | Output CSR       |

---

# Step 3: Create Self-Signed Root CA Certificate

```bash
openssl x509 -req -in root.csr -signkey root.key -out root.crt -days 3650
```

### Attributes

| Option            | Purpose               |
| ----------------- | --------------------- |
| x509              | Certificate utility   |
| -req              | Input is CSR          |
| -in root.csr      | CSR file              |
| -signkey root.key | Self-sign certificate |
| -out root.crt     | Certificate file      |
| -days 3650        | Valid for 10 years    |

---

# Step 4: Verify Root Certificate

```bash
openssl x509 -in root.crt -text -noout
```

---

# Step 5: Create Sub CA Extension File

```bash
nano sub.ext
```

### Contents

```ini
basicConstraints=critical,CA:TRUE,pathlen:0
keyUsage=critical,keyCertSign,cRLSign
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
```

### Purpose

| Extension   | Description               |
| ----------- | ------------------------- |
| CA:TRUE     | Marks certificate as CA   |
| pathlen:0   | No subordinate CA allowed |
| keyCertSign | Can sign certificates     |
| cRLSign     | Can sign CRLs             |

---

# Step 6: Generate Sub CA Private Key

```bash
openssl genpkey -algorithm RSA -out sub.key
```

---

# Step 7: Generate Sub CA CSR

```bash
openssl req -new -key sub.key -out sub.csr
```

---

# Step 8: Issue Sub CA Certificate

```bash
openssl x509 -req \
-in sub.csr \
-CA root.crt \
-CAkey root.key \
-CAcreateserial \
-out sub.crt \
-days 1825 \
-extfile sub.ext
```

### Verify

```bash
openssl x509 -in sub.crt -text -noout
```

---

# Step 9: Create Server Certificate Extension File

```bash
nano server.ext
```

### Contents

```ini
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth

subjectAltName=@alt_names

[alt_names]
DNS.1=www.mist.ac.in
```

### Purpose

| Extension        | Description           |
| ---------------- | --------------------- |
| CA:FALSE         | Not a CA              |
| digitalSignature | TLS signing           |
| keyEncipherment  | Key exchange          |
| serverAuth       | Server authentication |
| SAN              | Hostname validation   |

---

# Step 10: Generate Server Private Key

```bash
openssl genpkey -algorithm RSA -out server.key
```

---

# Step 11: Generate Website CSR

```bash
openssl req -new -key server.key -out server.csr
```

### Common Name

```text
www.mist.ac.in
```

---

# Step 12: Issue Website Certificate Using Sub CA

```bash
openssl x509 -req \
-in server.csr \
-CA sub.crt \
-CAkey sub.key \
-CAcreateserial \
-out server.crt \
-days 365 \
-extfile server.ext
```

---

# Step 13: Verify Website Certificate

```bash
openssl x509 -in server.crt -text -noout
```

### Verify

* Subject = `www.mist.ac.in`
* Issuer = Sub CA
* SAN contains `www.mist.ac.in`

---

# Step 14: Create Certificate Chain

```bash
cat server.crt sub.crt > fullchain.crt
```

---

# Step 15: Install Apache

```bash
sudo apt update
sudo apt install apache2 -y
```

### Verify

```bash
sudo systemctl status apache2
```

### Enable SSL

```bash
sudo a2enmod ssl
```

---

# Step 16: Create Website Directory

```bash
sudo mkdir -p /var/www/mist

sudo chown -R www-data:www-data /var/www/mist
```

### Homepage

```bash
sudo nano /var/www/mist/index.html
```

Example:

```html
<h1>Welcome to www.mist.ac.in</h1>
```

---

# Step 17: Configure HTTPS Virtual Host

```bash
sudo nano /etc/apache2/sites-available/mist.conf
```

### Configuration

```apache
<VirtualHost *:443>

    ServerName www.mist.ac.in

    DocumentRoot /var/www/mist

    SSLEngine on

    SSLCertificateFile /home/user/fullchain.crt

    SSLCertificateKeyFile /home/user/server.key

</VirtualHost>
```

Replace certificate paths as required.

---

# Step 18: Configure Apache Server Name

```bash
sudo nano /etc/apache2/apache2.conf
```

Add:

```apache
ServerName www.mist.ac.in
```

---

# Step 19: Enable Website

```bash
sudo a2ensite mist.conf

sudo systemctl reload apache2
```

---

# Step 20: Configure Name Resolution

### Local Testing Only

```bash
sudo nano /etc/hosts
```

Add:

```text
192.168.74.178 www.mist.ac.in
```

### Verify

```bash
ping www.mist.ac.in

nslookup www.mist.ac.in

getent hosts www.mist.ac.in
```

> Note: `/etc/hosts` is only for local testing. Actual deployment requires DNS A-record pointing `www.mist.ac.in` to the web server IP.

---

# Step 21: Trust Root CA

```bash
sudo cp root.crt /usr/local/share/ca-certificates/rootca.crt

sudo update-ca-certificates
```

---

# Step 22: Verify Apache Configuration

```bash
sudo apachectl configtest

sudo systemctl restart apache2

sudo systemctl status apache2
```

---

# Step 23: Verify HTTPS Website

```bash
openssl s_client -connect www.mist.ac.in:443 -showcerts
```

```bash
openssl s_client -connect www.mist.ac.in:443 -servername www.mist.ac.in
```

```bash
curl -v https://www.mist.ac.in
```

### Browser Test

```text
https://www.mist.ac.in
```

---

# Expected Certificate Chain

```text
Root CA
   ↓
Sub CA
   ↓
www.mist.ac.in
```

### Expected Result

* HTTPS enabled
* Certificate issued by Sub CA
* Domain = [www.mist.ac.in](http://www.mist.ac.in)
* SAN contains [www.mist.ac.in](http://www.mist.ac.in)
* No browser warnings after trusting Root CA

```
```
