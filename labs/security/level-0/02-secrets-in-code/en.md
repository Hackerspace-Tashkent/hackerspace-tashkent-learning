# Lab S0-02: the secret in the code

| # | Requirement | What it means |
|---|---|---|
| 1 | `proof.txt` holds the hash of the key found in history | you really searched the history |
| 2 | `notes.md` has an answer, not an empty file | an empty file does not count |
| 3 | you committed your own work | the fixture leaves 2 commits, you will have 3 |
| 4 | `.gitignore` got an entry about secrets | not just a file, a meaningful entry |
| 5 | the history still holds the key — as it should | do **not** rewrite history |

Number five looks odd, and it is the point. The key was already removed
from the file in the second commit — and it is still in the history. If
you "fix" that by rewriting history, the lab will not count: that is not
what happens in real work. The key is treated as burned and a new one is
issued.

**Not one of these is credited to the fixture.** `setup-repo.sh` gets
you exactly zero out of five.

## Order

1. `bash setup-repo.sh` — creates `lab-work/repo` with a history of two
   commits. The key is in the first; the second no longer has it.
2. Find the key in history using the commands from the lesson.
3. Write its hash into `lab-work/proof.txt`.
4. Add a `.gitignore` entry about secrets — say `*.secret` and `.env` —
   and **commit it**. Without the commit, items 3 and 4 do not count.
5. Answer in `lab-work/notes.md`: what is needed for the key to really be gone?

## Verify

```bash
./check.sh
```
