# Lesson 5. Working on GitHub

## What this lesson gives you

In the previous lesson you worked with git locally: made a commit, created a
branch, merged it back. That history went nowhere — it lived in a folder on
your machine.

GitHub adds three things git does not have:

1. **shared access** — others see the history;
2. **discussion** — you can ask and answer next to the code;
3. **checks** — automatic code can say "it broke".

Without GitHub git stays a private diary. With it, it becomes a way of working
together.

## Fork and clone: the difference

A **fork** is a copy of someone else's repository in your GitHub account. You got
it with one button; nothing was physically copied — it is a record on GitHub's
servers.

A **clone** is a copy on your machine, downloaded with `git clone`.

The order is always:

```
someone's repo  →  your fork  →  clone on your machine
```

You can clone the original directly, but then you cannot push: you have no
rights to someone else's repository. The fork exists precisely for that.

```bash
git clone https://github.com/<your-username>/hackerspace-tashkent-learning.git
```

Look at the address — **your username**, not `Hackerspace-Tashkent`. If
`git remote -v` shows the original, you did not fork, or cloned the wrong thing.

## remote: where push goes

```bash
git remote -v
origin  https://github.com/<your-username>/... (fetch)
origin  https://github.com/<your-username>/... (push)
```

A `remote` is just a name for an address. There can be any number of them:

```bash
git remote add upstream https://github.com/Hackerspace-Tashkent/hackerspace-tashkent-learning.git
```

`origin` is your fork, where you push. `upstream` is the original, where other
people's changes come from. In `push` you use `origin`:

```bash
git push origin my-branch
```

## Branches and staying in sync with the original

You always work in a branch and never touch `main`:

```bash
git switch -c add-my-note
```

While the original moves on, your fork falls behind. Take the changes:

```bash
git fetch upstream
git switch main
git merge upstream/main
git switch add-my-note
git merge main
```

The last two commands merge `main` into your branch so they do not drift apart.
If your branch changed the same lines, Git shows a conflict. That is not a
breakage — it is a request to decide by hand what stays.

## Pull request

A **pull request (PR)** is the proposal "here are my changes, look and merge".

Formally a PR is not a "merge request" but a **request for review**. The merge
may never happen: a person may ask for changes. That is why the description
matters more than the Merge button.

The description is addressed to a human. Minimum:

```markdown
## What changed
## How to check
## What I checked myself
```

The third point is not required by the format but is worth more than the others.
It shows the author did not just press a button.

Through the browser: push → GitHub shows a Compare & pull request button.
From the terminal, if you have `gh`:

```bash
gh pr create --fill
gh pr status
```

## Issue: a conversation without code

An issue is a report, a question or an idea. It may contain no code at all.

Issues and PRs are different things, though both live on GitHub:

| | Issue | Pull request |
|---|---|---|
| About | a question, an idea, a bug | specific changes to code |
| Has code | not necessarily | necessarily |
| Who closes | the author or a maintainer | a maintainer after review |

A bug without a ready fix gets an issue. A ready fix gets a PR, and its
description links to the issue where it was discussed.

A good issue states: what you expected, what you got, how to reproduce.

## Review

A review is reading someone else's change and answering. It is not a style hunt;
it is checking "was this done right".

A useful review answers three questions:

- **is it clear what changed and why** (from the description, not the code);
- **is it actually correct** (is there a way to check);
- **what was not considered** (what breaks for others).

Phrases that do not help: "fix it", "bad", "disagree". Phrases that do: "this
case fails because…", "an empty value is not handled here, here is an example".

We do not demand formal rules. We demand one thing: **a comment must explain
what is wrong and what would be better.** Disagreement is fine as long as you
wrote why.

## Settings worth doing immediately

Do these two things at once, or be surprised later:

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email"
```

Without these, commits get signed as `root` or refuse to be created at all in
Codespaces.

Second is `.gitignore`. It holds everything that must not enter history:
`lab-work/`, keys, `.env`, temporary files. It is already configured in our
repository, but check in your own fork that the list fits.

## Check yourself

- [ ] `git remote -v` shows your fork, not the original
- [ ] the branch is not called `main`
- [ ] the PR description has "what changed" and "how to check"
- [ ] `git status` is clean before committing

## What comes next

The lab is next door: `labs/level-1/05-github-workflow`. You need to make a fork,
a branch, a commit, write a PR description and a checklist. Nine checks locally
and, if you have `gh`, a tenth one online.

## Honestly, what we do not check

The lab does not decide whether your PR is good. A person reads that, and the
person decides. Everything automatic is about files being in place and submitted
correctly.
