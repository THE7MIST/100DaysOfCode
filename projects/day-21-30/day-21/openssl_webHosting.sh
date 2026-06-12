# Day 21 - HTTPS Website Deployment using Apache HTTPD and SSL

## Objective

Deploy a secure HTTPS website (`www.mist.ac.in`) using Apache HTTPD and SSL/TLS certificates on a RHEL/CentOS/Rocky/AlmaLinux-based Linux system.

---

# Verify Operating System

Check Linux distribution:

```bash
cat /etc/os-release
```

Observation:

* Ubuntu uses `apache2`
* RHEL/CentOS/Rocky/AlmaLinux use `httpd`

---

# Install Apache and SSL Module

Install Apache HTTP Server:

```bash
dnf install httpd -y
```

Install SSL module:

```bash
dnf install mod_ssl -y
```

---

# Start and Enable Apache

```bash
systemctl enable httpd
systemctl start httpd
systemctl status httpd
```

Purpose:

* Enable service at boot
* Start web server
* Verify service status

---

# Configure Firewall

Allow HTTP:

```bash
firewall-cmd --permanent --add-service=http
```

Allow HTTPS:

```bash
firewall-cmd --permanent --add-service=https
```

Reload firewall:

```bash
firewall-cmd --reload
```

---

# Create Website Directory

```bash
mkdir -p /var/www/mist
```

Create test webpage:

```bash
echo "<h1>Welcome to www.mist.ac.in</h1>" > /var/www/mist/index.html
```

---

# Set Permissions

For RHEL-based systems:

```bash
chown -R apache:apache /var/www/mist
```

or

```bash
chmod -R 755 /var/www/mist
```

---

# Create Virtual Host Configuration

File:

```bash
nano /etc/httpd/conf.d/mist.conf
```

Contents:

```apache
<VirtualHost *:443>

    ServerName www.mist.ac.in

    DocumentRoot /var/www/mist

    SSLEngine on

    SSLCertificateFile /root/openssl/fullchain.crt

    SSLCertificateKeyFile /root/openssl/server.key

</VirtualHost>
```

---

# Verify Apache Configuration

```bash
httpd -t
```

Expected:

```text
Syntax OK
```

---

# Restart Apache

```bash
systemctl restart httpd
```

Verify:

```bash
systemctl status httpd
```

---

# Verify HTTPS Port

```bash
ss -tulnp | grep 443
```

Expected:

```text
LISTEN *:443
```

---

# Configure Hostname Resolution

Edit hosts file:

```bash
nano /etc/hosts
```

Add:

```text
<SERVER_IP>    www.mist.ac.in
```

Example:

```text
192.168.74.178    www.mist.ac.in
```

---

# Test DNS Resolution

```bash
ping www.mist.ac.in
```

---

# Test SSL Certificate

```bash
openssl s_client -connect localhost:443 -showcerts
```

Purpose:

* Verify SSL certificate chain
* Verify HTTPS service

---

# Test Website

```bash
curl -k https://localhost
```

Expected:

```html
<h1>Welcome to www.mist.ac.in</h1>
```

---

# Important Differences

| Ubuntu        | RHEL/Rocky/CentOS |
| ------------- | ----------------- |
| apache2       | httpd             |
| a2enmod ssl   | mod_ssl package   |
| a2ensite      | Not available     |
| www-data      | apache            |
| /etc/apache2/ | /etc/httpd/       |

---

# Commands Used

```bash
cat /etc/os-release

dnf install httpd -y
dnf install mod_ssl -y

systemctl enable httpd
systemctl start httpd

firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

mkdir -p /var/www/mist

echo "<h1>Welcome to www.mist.ac.in</h1>" > /var/www/mist/index.html

chown -R apache:apache /var/www/mist

nano /etc/httpd/conf.d/mist.conf

httpd -t

systemctl restart httpd

ss -tulnp | grep 443

openssl s_client -connect localhost:443 -showcerts

curl -k https://localhost
```

---

## Conclusion

Successfully configured Apache HTTPD with SSL/TLS certificates, created a virtual host for `www.mist.ac.in`, enabled HTTPS access, configured firewall rules, and verified secure web communication using OpenSSL and Apache.
