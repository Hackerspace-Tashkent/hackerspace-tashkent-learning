# The secret in the code

## Why this matters

There is a thing almost every developer understands and almost no beginner
does. Here is the scenario:

```text
committed code with a key  →  removed the key from the file  →  committed again
```

At that point the person is sure the key is gone. **It is not gone.** It
stays in the history, and anyone with a copy of the repository pulls it
out with one command.

A secret counts as compromised from the moment it entered the history —
not from the moment it was removed.

## What the lab gives you

A repository with two commits:

- the first — the key sits directly in `app.py`;
- the second — the key was removed and moved to an environment variable.

The key is `vt-lark-tessera-5Q2fK`. That is an **invented** name: no such
service exists, so the key cannot be googled. And you did not choose it,
which means the only way to get it is to work it out.

## The work

1. Build the fixture:

```bash
bash setup-repo.sh
```

2. Look at the current state — the key is already gone from it:

```bash
cd lab-work/repo
cat app.py
```

3. Find it in the history:

```bash
git log --oneline
git log -p
git log -p | grep -i token
```

4. There are other ways, try them all, that is the skill:

```bash
git log -S'vt-lark' --oneline
git rev-list --all | while read c; do git grep -l 'vt-lark' "$c"; done
```

5. Confirm the current version has no key:

```bash
grep -rn 'vt-lark' . || echo "current version is clean"
```

6. In `lab-work/proof.txt` write the hash of the key you found, the
   first 12 characters of sha256:

```bash
printf '%s' 'vt-lark-tessera-5Q2fK' | sha256sum | cut -c1-12 > ../proof.txt
```

7. Answer in `notes.md`: **what has to happen for the key to really stop
   existing?**

## The answer worth reaching

The current file is clean, and that changes nothing. History holds **all**
versions, including deleted ones. Options:

- **rotate the key** — the only real fix. The old one counts as
  compromised, because it is in the history;
- rewrite the history (`git filter-repo`, BFG) — removes the trace from
  the repository, but does not undo that the key already went somewhere;
- if the repository was already forked or cloned — the trace went to other
  people, and rewriting history gains nothing.

Hence the rule: **secrets never go into a repository at all.** A
`.gitignore` helps with files, but does not save you from carelessness —
one `git add -f` is enough.

## Where a secret belongs

| Where | Suitable |
|---|---|
| environment variable | yes |
| a file not in git | carefully: it may end up in a build |
| a secrets manager | yes |
| directly in the code | no |

Note the AI lesson: it says separately that code with secrets must not
be pasted into a chat with an AI. That is the same case.

## Important

The repository here is your own, it sits in your lab folder, and the key
is invented. Nobody experiments with real keys — they are simply never
put where they can leak.
