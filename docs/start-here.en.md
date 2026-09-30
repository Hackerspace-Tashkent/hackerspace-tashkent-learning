# Where to start, and why all this

This page is for anyone who has never opened a terminal. It explains what git,
GitHub and Codespaces are, and why we chose them.

Nothing needs to be installed. You need a browser and a GitHub account.

---

## What git is

Git is a program that remembers the history of your files. It runs on your own
computer, with no internet and no registration.

When you write code, git does not overwrite the old version — it remembers that
at this moment the file looked like this. What you get is a history you can go
back to.

The key word is **commit**. One saved checkpoint: "I finished this step". The
commit message explains what changed.

Next comes a **branch** — a copy of your work where you can experiment without
fearing you will break the main version. Made it, liked it, merged it back. Did
not like it, threw the branch away, and the main version was never harmed.

That is all. That is the whole of git at the level you need to start. The rest
is in lesson 3 of the Level 0 track.

## What GitHub is

Git is the program; GitHub is the website that holds your repositories. The
difference matters:

- git works **locally**, the history sits on your disk;
- GitHub keeps **a copy on the internet**, so other people can see it.

Besides storage, GitHub has what we actually chose it for:

| Feature | Why we need it |
|---|---|
| **Repository** | Where lessons, practice and code live. One link gives you the whole course. |
| **Change history** | You can see who changed what. Anything broken by accident can be restored. |
| **Issues** | A visible list of tasks and questions. Open it and you see someone already asked. |
| **Pull requests** | Changes are shown first, discussed second, and only then accepted. |
| **Codespaces** | A full Linux in the browser. Nothing to install. |
| **Open access** | Everything is in the open. Anyone can read it, repeat it and improve it. |

## Why GitHub specifically

The short honest answer: because it is **free, set up once, and requires nothing
from a student except a browser**.

More importantly, here is why that matters in this case:

- **Zero cost to start.** No laptop of your own, no Linux installation, no money
  for a server. A computer that can open a web page is enough.
- **It works on a weak computer.** Codespace computes in the cloud. A full
  environment will not start on an old laptop with 4 GB of RAM, but the browser
  version will.
- **It does not tie the work to one person.** The material lives on GitHub, not
  in a chat log and not on somebody's laptop. In a year it will still be there,
  even if the author moves away.
- **Checking is part of the process.** A practice result is a comment in a
  public issue. Anyone can see who passed, and it cannot be quietly edited.
- **Four languages, one place.** All four versions of every lesson sit next to
  each other, not scattered across four different places.

What we did **not** choose, and why:

- **Our own website with registration and user accounts** — that is a server to
  pay for, protect and maintain. Expensive, and nobody is free to do it.
- **Google Docs or Notion** — nice to read, but you cannot run and verify an
  exercise in them.
- **Video lessons** — they look easy, but they cannot be checked and they leave
  no trace of work.

## What a Codespace is

A Codespace is a virtual computer with Linux that lives in GitHub's cloud and
opens in your browser. You press a button and a real command line appears.

What that gives you:

- Everything is already installed: terminal, git, Python, editor. You install
  nothing.
- It works from any device with a browser. You start on a laptop and continue on
  a phone.
- The environment setup lives in the repository, not in your head. Everyone has
  the same one.
- The environment is small: 2 cores and 4 GB of RAM. That is enough for all of
  our lessons.
- If something breaks, the environment is deleted and recreated in a minute.
  Experimenting is cheap.

One limitation worth knowing honestly: a Codespace is Linux. If you are on
Windows and want to learn on Windows, part of the practice has to be adapted.

## What you need

Required:

- a browser,
- a GitHub account,
- about two hours for the first lesson.

Not needed:

- installing Linux,
- installing anything on your own computer,
- buying hardware for the first five lessons,
- knowing anything about programming in advance,
- knowing how to use git — lesson 3 teaches that.

## Three steps to your first task

1. Create a GitHub account if you do not have one.
2. Open the learning repository and press **Code → Codespaces → Create codespace
   on main**. In a minute a terminal opens.
3. Open lesson 1 and run the commands by hand. At the end, run the check.

If anything is unclear, open an issue or ask in the chat. Being stuck is more
useful than silence: it shows exactly where you got to.
