# Lesson 6. GitHub Actions

## What it is

GitHub Actions is a computer that runs your code for you. You leave a file in
the repository describing what to do, and GitHub runs it on every push, without
your computer.

```
you push code  →  GitHub notices  →  starts a virtual machine
                →  runs commands  →  shows the result
```

The main benefit: **checking does not depend on someone remembering to run it.**
Somebody pushes broken code and it fails immediately. And it fails the same way
for everyone.

## Where the file lives

`.github/workflows/name.yml` at the repository root. The name is anything, the
extension `yml` or `yaml`. Everything in `.github/workflows/` GitHub treats as
a description of automation.

This is **plain text**, not magic. You can open it, read it, fix it by hand.

## A minimal workflow

```yaml
name: Check

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Get the code
        uses: actions/checkout@v4

      - name: Check the lab
        run: ./labs/level-0/01-terminal/check.sh
```

Line by line.

**`name`** — how the run appears in the interface.

**`on:`** — when to run. `push` — on any push, `pull_request` — when a PR is
opened. An empty `push:` means "on every event of this type".

**`jobs:`** — the tasks. There can be several; they run in parallel.

**`runs-on:`** — which machine to run on. `ubuntu-latest` is standard Linux.
`windows-latest` and `macos-latest` exist too; they are slower and costlier.

**`steps:`** — steps inside a job, in order. A failure stops the whole job.

**`uses:`** — a ready-made action someone else wrote. `actions/checkout` fetches
the code onto the machine; without it there simply is no code folder.

**`run:`** — a command to execute. A single line or a block:

```yaml
      - name: Several commands
        run: |
          bash -n labs/*/*/check.sh
          python3 tools/check_content.py
```

A `|` block in YAML means "a multi-line value".

## What is worth checking first

Ordered by usefulness, not difficulty:

1. **Script syntax.** `bash -n` executes nothing, it only looks for typos. The
   cheapest check there is, and it catches a lot.
2. **The material validator.** We have `tools/check_content.py` — broken links,
   language drift, missing files.
3. **The labs themselves.** They cannot be run whole: they need student files.
   But you can check that an empty state fails honestly.
4. **Formatting.** Spaces, tabs, line endings. For `*.sh`, LF is mandatory:
   CRLF gives `$'\r': command not found`.

## Secrets

Any token, key or password goes through `secrets`, never as text in the file:

```yaml
      - name: Log in
        run: gh auth login --with-token <<< "$TOKEN"
        env:
          TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

A secret file in a repository means you must rotate the secret immediately, even
if you delete the commit. Git keeps history.

## Debugging

When a run fails, read the log of the specific step. Common causes:

- `actions/checkout` forgotten, so the code folder is missing;
- the script is not executable — needs `chmod +x`, or run it through `bash`;
- CRLF instead of LF inside the script;
- the command returned non-zero and you did not expect that.

Errors appear line by line. Do not guess — read the log.

## A limitation worth understanding

Free minutes are generous for public repositories and limited for private ones,
shared across the account. Our learning repository is public, so limits barely
apply. Do not plan on Actions as permanent heavy computation.

## What comes next

The lab is next door: `labs/level-1/06-github-actions`. You write your own
workflow and check that GitHub ran it.
