# Security track

Four levels. Built by the same rules as the main track: four languages,
nothing to install, a script for checking, practice only on your own
hardware and your own network.

## What makes this track different

An ordinary lab asks "did it work". That cannot work here: someone who
understood nothing would go green just by looking at the answer. So here
there is **proof of understanding**: what is required is not a tick but
a concrete value you can only get by working it out.

## The rule that is not up for discussion

Everything happens on your own equipment and on your own network. Your
own servers on `127.0.0.1`, your own files, your own stubs. Never someone
else's site or someone else's service — not even to "just check". This
is not a formality: poking at a stranger's server turns from learning
into a crime.

## Four levels

### S0. Beginner

What the server sees, and why it matters.

- [What the server sees](level-0/01-what-the-server-sees/en.md)
- [The secret in the code](level-0/02-secrets-in-code/en.md)
- [Passwords and hashes](level-0/03-passwords-and-hashing/en.md)

You send headers. The server believes them. So what you claim about
yourself proves nothing. This is the ground everything else stands on.

### S1. Continuing

Authentication, access control, secrets in code.

- passwords and tokens: where they belong and where they must never be
- access control: why "checked on my own page" is not "checked on yours"
- secrets in a repository and in the browser: why a key on a page is no
  longer yours
- taking the API from lesson 08 apart for vulnerabilities

### S2. Advanced

The classic web vulnerabilities, each one on its own local server.

- SQL injection
- XSS
- path traversal
- SSRF
- command injection

### S3. Specialist

- how binaries work and what a buffer overflow is
- reverse engineering
- cryptography basics: hashes, salt, what must not be reversible
- networking: how to watch traffic

## Why invented names

The exercises in this track use names and formats that **do not exist**:
headers, keys, data formats that are not real anywhere. This is on
purpose.

If a task can be found online or asked to an AI, it teaches nothing — it
teaches recall. With a name that does not exist, the only way to reach
the answer is to understand it.

## The order of work

1. The lesson explains the idea.
2. Inside it you build the thing you are going to break.
3. The lab starts your server and checks the result with a real request.
4. Instead of ticks, **proof** is required — a concrete value.

## What is not here yet

Written and verified: level S0, **three topics**.

Not written: S1, S2, S3. Not because it is hard, but because **not one
person has gone through even S0**. The first topic has to be shown to
work before the next floor goes up.
