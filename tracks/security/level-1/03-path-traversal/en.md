# Getting outside your own folder

## Why this matters

A server is often told: "serve the file `notes.txt`". The name comes
from the request. What happens if instead someone sends
`../../etc/passwd`?

The server joins the path: `public/` + `../../etc/passwd`. And it gets a
file it never meant to serve. This is **path traversal**.

## Why it works

The server thinks it is solving an easy problem: "which file was
asked for". In reality it is solving a different one: "can this name be
trusted".

The difference between `notes.txt` and `../../etc/passwd` is two dots.
A server that concatenates strings does not look at anything.

## What should come out

Only files from **your own folder** should be served. Three questions:

1. How does the name from the request get into the path?
2. What happens if it contains `..`?
3. What happens if it is an absolute path starting with `/`?

## How people close it

**Check after joining.** Build the full path and confirm it starts with
the folder you meant to serve -- not with something that merely looks
like it.

```python
full = os.path.realpath(os.path.join(ROOT, name))
if not full.startswith(os.path.realpath(ROOT) + os.sep):
    raise PermissionError("outside the folder")
```

**Refuse absolute paths.** A name like `/etc/passwd` must become a file
name, not a path.

**Reject bad names.** A list of forbidden pieces (`..`, `\0`) is a cheap
first line, but not the only one.

**Swap the identifier entirely.** The strongest option: never let a
request-supplied string into the path at all. Ask for a number and look
it up in your own list.

## What you will do

The server starts vulnerable. You walk past it, then close the hole and
explain why each measure works.

## Boundary

Your own machine, `localhost`, the fixture files only. No third-party
servers, no real `/etc/passwd`.
