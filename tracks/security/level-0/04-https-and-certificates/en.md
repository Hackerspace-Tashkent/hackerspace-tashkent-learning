# HTTPS and certificates

## Why this matters

You open a site and see a padlock in the address bar. How does the
browser know the connection is really that site, and not somebody in the
middle?

Not "because a padlock is drawn". The padlock is drawn in two cases
alike: when everything is fine **and** when someone intercepted the
channel. The difference is invisible to the eye. The difference is that
the browser performs a **check**.

## What the check consists of

**A certificate** is a document saying who owns the private key. Inside
there is a name (`CN`, and in modern certificates `SAN`) and validity
dates.

**A chain of trust.** A certificate on its own means nothing: anyone can
issue any certificate. What is needed is somebody you trust — a
**certificate authority**. It signs the certificate, you already know its
public key, and therefore the signature can be verified.

**A fingerprint.** A certificate has a hash — a short print. It is
compared with what you expected to see.

## The self-signed certificate

You can issue a certificate yourself — `openssl` can do it. And it will
work. But the browser does **not** trust it, because nobody known signed
it. It cannot treat itself as an authority: otherwise anyone could sign a
certificate and impersonate anybody.

In this exercise that is fine: you decide who to trust by pointing at your
own certificate as the trusted one.

## The most important part

In Python you can switch the check off with one line:

```python
ctx = ssl._create_unverified_context()
```

After that a connection to **any** certificate, including a forged one,
passes silently. The encryption is still there, but who is on the other
end is unknown. It is like locking the door and not looking through the
peephole.

## What you will do

1. Issue a self-signed certificate for `localhost`.
2. Write `server.py` serving HTTPS with that certificate.
3. Write `client.py` that connects **with** the check and without it.
4. Write the first 16 characters of the certificate's SHA-256
   fingerprint into `proof.txt`.
5. Answer in `notes.md`: **what is wrong with an unverified certificate
   if the encryption still works?**

## The command

```bash
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem \
  -days 1 -nodes -subj "/CN=localhost"
```

One day on purpose: a teaching certificate should not live forever.

## How to look at the certificate

```bash
openssl x509 -in cert.pem -noout -text
openssl x509 -in cert.pem -noout -fingerprint -sha256
```

## Boundaries

Everything happens on `127.0.0.1`, on your own machine, with your own
certificate. No third-party site is probed or scanned. Probing somebody
else's certificates is not what this topic teaches.
