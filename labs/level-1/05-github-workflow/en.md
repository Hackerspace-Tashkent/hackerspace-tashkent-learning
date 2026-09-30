# Lab: working with GitHub

## What to do

Everything happens in `lab-work/` next to this file. The folder does not exist
at first — create it yourself.

```bash
cd "$(dirname check.sh)"
mkdir lab-work
cd lab-work
```

### 1. Your own fork

Fork the learning repository and clone **your fork**, not the original:

```bash
git clone https://github.com/<your-username>/hackerspace-tashkent-learning.git
cd hackerspace-tashkent-learning
git remote -v
```

`origin` in `git remote -v` must carry your username.

### 2. A branch that is not `main`

```bash
git switch -c my-first-change
```

Work only in it. Do not touch `main`.

### 3. A change and a commit

Add any file or change an existing one, then:

```bash
git add .
git commit -m "Add my note about level 1"
```

### 4. The pull request description

Create `PR.md` — what you would type into the PR description field. At least
three lines:

```markdown
## What changed

## How to check

## What I checked myself
```

The third heading is the most valuable one. Write honestly: what you ran and
what actually worked.

### 5. A checklist

Create `CHECKLIST.md` marking what you verified. At least:

```markdown
- [ ] check.sh passes
- [ ] I read what each script does
```

### 6. The pull request

Push the branch and open the PR:

```bash
git push -u origin my-first-change
```

Then either in the browser, or, if `gh` is installed:

```bash
gh pr create --fill
```

Without `gh`, open the site and GitHub will offer to create the PR.

## Checking

```bash
./check.sh
```

Nine local checks plus, if you have `gh`, a tenth one that goes online.
Without `gh` the score will be `9/9`: that is fine, the local part already
counts.

## What this lab does not check

It does not check whether your PR makes sense. A person reads that. That is why
the third heading in `PR.md` matters more than the others.