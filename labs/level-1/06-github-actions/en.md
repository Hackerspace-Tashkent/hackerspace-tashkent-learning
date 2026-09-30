# Lab: GitHub Actions

## What to do

Everything in `lab-work/` next to this file. It does not exist — create it.

```bash
cd "$(dirname check.sh)"
mkdir -p lab-work/.github/workflows
cd lab-work
```

### 1. Your own workflow

Create `.github/workflows/ci.yml`:

```yaml
name: My checks

on:
  push:
  pull_request:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Get the code
        uses: actions/checkout@v4

      - name: Script syntax
        run: bash -n labs/*/*/check.sh

      - name: Material check
        run: python3 tools/check_content.py
```

Copy from here and adjust. This is the same example as in the lesson.

### 2. What to check first

In order of usefulness:

1. `bash -n` — syntax only, executes nothing;
2. `tools/check_content.py` — links and languages;
3. a trial run of the labs on an empty state.

### 3. Run it

```bash
git init -q -b main
git remote add origin https://github.com/your-username/your-repo.git
git add .
git commit -m "Add a workflow that checks things"
git push -u origin main
```

In about a minute open the **Actions** tab in the repository. The run is
either green, or red with a failing step named.

If red, read that step's log instead of guessing.

### 4. Write it down

`NOTES.md` — what you understood, what surprised you, where you got stuck.
Three lines is enough.

## Checking

```bash
./check.sh
```

Nine local checks and, if you have `gh`, a tenth one online.

## Careful

A script in a workflow runs on someone else's machine with access to the
repository. Secrets go through `secrets`. Never put a token straight into YAML.
