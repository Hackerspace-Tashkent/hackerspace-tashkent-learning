# Passwords and hashes

## Why this matters

A hash is **not encryption**. Encryption is reversible: with the key you
get the original text back. A hash cannot be reversed: from `a94f8f5` you
will not get `sable`.

That is good and bad at once. Good, because the password cannot be read
out. Bad, because **a forgotten password cannot be recovered at all**.
Only reset.

## How it breaks

For years passwords were stored like this:

```python
hashlib.sha256(password.encode()).hexdigest()
```

And here is what follows from it.

**Identical passwords produce identical hashes.** If two people have the
password `123456`, a leaked file holds two identical hashes. From the
hash alone you cannot even tell how many people use it.

**Guessing becomes a table lookup.** Somebody precomputed hashes of
billions of common passwords — that is called a rainbow table. After
that, a stolen file is not brute-forced, it is **searched in a ready-made
table**: match found, password known.

**Speed is unlimited.** sha256 runs billions of times per second. You can
try a billion candidates before anyone notices.

## What is done about it

**A salt.** A random string, unique per password. It is added to the
password before hashing. Two identical passwords now produce different
hashes, and the ready-made table is useless: every password needs its
own.

**Slow hashing.** Plain sha256 is fast on purpose — for speed, not for
protection. For passwords, functions that are **deliberately slow** are
used, and they are repeated tens of thousands of times.

Python's standard library has `hashlib.pbkdf2_hmac`:

```python
hashlib.pbkdf2_hmac("sha256", password.encode(), salt.encode(), 100000).hex()
```

`bcrypt` and `argon2` are better, but they are not in the standard
library — you install them separately. `pbkdf2_hmac` is what works with
nothing installed.

## What you will do

You get `hashes.txt` — "hash — word" pairs, invented words that do not
exist online. And `target.txt` — one hash.

1. Write `brute.py`: walk the words, find the match, write the word into
   `crack.txt`.
2. Write the first 12 characters of the sha256 of the password you found
   into `proof.txt`.
3. Write `salted.py`: for one and the same password show three hashes —
   no salt, salt A, salt B. They must differ.
4. Answer in `notes.md`: **why is a salt needed if the password has to be
   guessed anyway?**

## What it looks like

```python
import hashlib

# An example value. Put the word you actually found in crack.txt here.
PASSWORD = "brindle"


def pbkdf2(password, salt):
    return hashlib.pbkdf2_hmac("sha256", password.encode(),
                               salt.encode(), 100000).hex()


print("no salt  :", hashlib.sha256(PASSWORD.encode()).hexdigest())
print("salt A   :", pbkdf2(PASSWORD, "sable-4710"))
print("salt B   :", pbkdf2(PASSWORD, "vireo-9931"))
```

Same string, different hashes. That is exactly what the salt does.

## What is actually stored

The password is never stored. What is stored is the **hash, the salt and
the parameters** — because without salt and parameters the hash is
useless for verifying anything. The salt is not a secret: it sits next to
the hash and needs no hiding. What has to be hidden is the password
itself, which the system does not have.

## Important

The passwords here are invented and sit in your lab folder. Real
passwords are not guessed — they are either remembered or reset.
