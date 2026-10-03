# When the shell runs what the user sent

## Why this matters

In the earlier topics harm arrived through SQL and through HTML: data
turned into a query or into a page. Here it reaches the shell.

A server wants to "check whether a host answers". It writes a command
and runs it. If the host name came from the request and landed in the
command string as it was, a user can append their own command to it.

This is **command injection**.

## Where it happens

The dangerous line looks ordinary and raises no suspicion:

```python
out = subprocess.run(
    f"ping -c 1 {host}",
    shell=True, capture_output=True, text=True)
```

`host` comes from the request. `shell=True` hands the string to the
interpreter, and the interpreter splits it into parts. A `;` in the host
name turns one check into two commands.

## Why this is not a rare case

Checking "is there a `;` or `&&` here" does not work. The list of
forbidden characters is always shorter than reality:

- separators are not only `;` -- also `&&`, `||`, newline, `$( )`;
- a space lets you pass arguments that were never meant to be there;
- backticks and `$()` work without `;` at all;
- URL encoding and library-level tricks add new routes.

## What to do instead

**Never build a command string.** Pass the arguments as a list:

```python
out = subprocess.run(["ping", "-c", "1", host],
                     capture_output=True, text=True)
```

Here `host` is one argument, not a program. Even if it contains
`; cat flag.txt`, what runs is `ping` with such a host name and nothing
else.

**`shell=False` by default.** An explicit `shell=True` should be rare and
should raise the question "why can this not run without a shell?"

**An allow-list if you must use a shell.** Do not check a string for the
absence of something bad; check that it is on a list of allowed values.

## What you will do

The server starts vulnerable. You inject a command, then close the hole
and explain why checking characters is worse than a list of arguments.

## Boundary

Your own machine, `localhost`, the fixture files only.
