# PKI HTTPS Verification Troubleshooting Notes
https://github.com/THE7MIST/pki/tree/main/CA_cer

## Situation

The HTTPS site is already serving the correct certificate chain, but the browser still shows **Not Secure** or warns that the issuer is not recognized.

This usually means the **certificate chain is valid**, but the **browser trust store** is not fully trusting the Root CA yet, or the browser is still using cached state.

---

## What the evidence shows

### Certificate chain is correct

The following commands confirm that the server certificate is valid and chained correctly:

```bash
openssl verify -CAfile root.crt -untrusted sub.crt server.crt
```

Expected result:

```text
server.crt: OK
```

That means:

- `server.crt` was issued by `sub.crt`
- `sub.crt` was issued by `root.crt`
- the chain is structurally correct

---

### TLS handshake is correct

```bash
openssl s_client -connect localhost:443 -servername www.mistofvon.in -showcerts
```

The output shows:

- leaf certificate: `www.mistofvon.in`
- issuer of leaf: `subca`
- issuer of sub CA: `rootCA`
- verification return code: `0 (ok)`

That means Apache is presenting the correct certificate chain.

---

## Why the browser may still show Not Secure

The most common reasons are:

1. The Root CA is not trusted by the browser profile.
2. Firefox was open when the Root CA was imported.
3. Firefox is using a separate certificate store, especially on Snap installations.
4. The browser cache or DNS cache still contains the old state.
5. The hostname in the browser does not match the certificate SAN.
6. Apache is serving a different virtual host than expected.

---

## Check the hostname first

Make sure the browser URL exactly matches the certificate SAN:

```text
www.mistofvon.in
```

If the certificate was issued for:

```text
www.mistofvon.in
```

then opening:

```text
https://localhost
```

or

```text
https://www.mist.in
```

will not give a clean trusted result unless those names are also inside the SAN.

---

## Check Apache virtual hosts

Use:

```bash
sudo apachectl -S
```

This shows which virtual host Apache is serving.

If multiple SSL vhosts exist, Apache may be serving the wrong one.

Also check for missing document roots or misconfigured vhosts.

---

## Check SSL config files

Search all enabled site configs:

```bash
grep -i SSL /etc/apache2/sites-available/*.conf
```

Verify that the correct vhost file contains:

```apache
SSLEngine on
SSLCertificateFile /root/pkicert/fullchain.crt
SSLCertificateKeyFile /root/pkicert/server.key
```

If needed, the certificate file should include both:

- server certificate
- Sub CA certificate

Example:

```bash
cat server.crt sub.crt > fullchain.crt
```

---

## Should the Root CA be added manually to the browser?

### Yes, for browser trust

If the Root CA is private and self-created, Firefox and Chrome will not trust it automatically.

You must import the Root CA into the browser trust store or operating system trust store.

---

## Ubuntu system trust

You already did the right system-level step:

```bash
sudo cp root.crt /usr/local/share/ca-certificates/rootca.crt
sudo update-ca-certificates
```

This updates the Linux trust store.

However, Firefox may still use its own certificate database.

---

## Firefox trust store issue

Firefox often uses its own certificate store, especially with Snap builds.

That is why importing the Root CA into Ubuntu alone may not be enough.

You used:

```bash
certutil -A -d sql:/home/ubuntu/snap/firefox/common/.mozilla/firefox/etfznv8f.default -n "rootca" -t "CT,C,C" -i /home/ubuntu/pkicert/root.crt
```

Then verified:

```bash
certutil -L -d sql:/home/ubuntu/snap/firefox/common/.mozilla/firefox/etfznv8f.default | grep rootca
```

Expected:

```text
rootca    CT,C,C
```

That means the Root CA was added to Firefox correctly.

---

## Where to run the Firefox command

Run the Firefox-related commands on the machine where **Firefox is installed and where you want the browser to trust the Root CA**.

If you are testing on the Ubuntu desktop machine, then the command belongs there, not on the web server.

For Firefox import and refresh, use the Ubuntu desktop machine that opens the site in the browser.

---

## Firefox refresh sequence

After importing the Root CA:

```bash
pkill firefox
sleep 2
firefox &
```

This forces Firefox to reload its trust database.

If Firefox was already open during import, restart is required.

---

## Best browser-side sequence

1. Import Root CA into Firefox profile
2. Verify certificate presence with `certutil -L`
3. Close Firefox completely
4. Reopen Firefox
5. Revisit the site using the exact SAN name

---

## If the browser still shows Not Secure

Try these checks:

### 1. Confirm the cert SAN

Your certificate must include:

```text
www.mistofvon.in
```

### 2. Confirm the browser profile

Make sure `certutil` was pointed at the correct Firefox profile directory.

### 3. Confirm Apache is using the right certificate files

The vhost should point to the correct `fullchain.crt` and `server.key`.

### 4. Confirm host resolution

If needed for local testing, `/etc/hosts` can resolve the name to the server IP, but this is not actual DNS.

### 5. Clear browser cache

Sometimes browser cache or HSTS state causes old trust behavior.

---

## OpenSSL checks that should already be green

These should all succeed:

```bash
openssl verify -CAfile root.crt -untrusted sub.crt server.crt
```

```bash
openssl s_client -connect localhost:443 -servername www.mistofvon.in -showcerts
```

If both succeed, the PKI chain is fine.

---

## Recommended fix order

### On the server

1. Confirm Apache uses the correct vhost.
2. Confirm Apache uses `fullchain.crt`.
3. Confirm `server.key` matches `server.crt`.
4. Confirm SAN contains `www.mistofvon.in`.

### On the client browser machine

1. Import Root CA into Ubuntu trust store.
2. Import Root CA into Firefox profile using `certutil`.
3. Restart Firefox.
4. Open the exact hostname from the SAN.

---

## Important conclusion

If:

- `openssl verify` says `OK`
- `openssl s_client` says `Verify return code: 0 (ok)`
- Apache is serving the correct certificate chain
- Firefox Root CA import shows `rootca    CT,C,C`

then the **certificate chain is valid**.

At that point, any remaining **Not Secure** message is usually a **browser trust, profile, cache, or hostname mismatch issue**, not a certificate-generation problem.

---

## Commands from your setup

### Verify chain

```bash
openssl verify -CAfile root.crt -untrusted sub.crt server.crt
```

### Inspect TLS chain

```bash
openssl s_client -connect localhost:443 -servername www.mistofvon.in -showcerts
```

### Check Apache vhosts

```bash
sudo apachectl -S
```

### Check SSL settings

```bash
grep -i SSL /etc/apache2/sites-available/*.conf
```

### Import Root CA into Firefox profile

```bash
certutil -A -d sql:/home/ubuntu/snap/firefox/common/.mozilla/firefox/etfznv8f.default -n "rootca" -t "CT,C,C" -i /home/ubuntu/pkicert/root.crt
```

### Verify Firefox import

```bash
certutil -L -d sql:/home/ubuntu/snap/firefox/common/.mozilla/firefox/etfznv8f.default | grep rootca
```

### Restart Firefox

```bash
pkill firefox
sleep 2
firefox &
```

---

## Final answer

For your case, the PKI setup itself looks correct. The remaining problem is most likely **Firefox trust state or hostname/vhost mismatch**, not the certificate chain.
