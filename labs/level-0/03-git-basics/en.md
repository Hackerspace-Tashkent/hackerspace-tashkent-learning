# Lesson 3. Git from scratch

Git keeps the history of your project: every change is stored, and you can go back to any earlier state.

## First repository

```bash
mkdir my-project && cd my-project
git init
git status
```

`git init` creates a repository. `git status` shows what changed and what is ready to be saved.

```bash
echo 'Hello' > readme.md
git add readme.md
git status
```

## Saving changes

A commit is a saved point in history. It needs a short message describing what changed.

```bash
git commit -m 'Add readme'
git log --oneline
```

## Branches

A branch is a separate line of work. Experiment freely, then merge it back.

```bash
git branch feature
git switch feature
echo 'More' >> readme.md
git add readme.md
git commit -m 'Extend readme'
git switch main
git merge feature
```

## Ignoring files

Temporary files should not enter the history. List them in `.gitignore`.

```bash
echo '.lab-data/' > .gitignore
git add .gitignore
git commit -m 'Add gitignore'
```

> **Note.** Three states to remember: working directory, staging area (`git add`), repository (`git commit`).

## Practice

1. Create `~/git-lab` and run `git init` there.
2. Create `notes.md` and make at least three commits, each with a meaningful message.
3. Create a branch `experiment`, add a file `idea.md` there, and commit it.
4. Merge `experiment` back into `main`.
5. Add a `.gitignore` that ignores `tmp/`.
6. Check the history with `git log --oneline` — there should be at least four commits.

```bash
cd labs/level-0/03-git-basics
./check.sh
```
