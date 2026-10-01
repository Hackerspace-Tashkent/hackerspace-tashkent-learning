# Lab S0-02: the secret in the code

| # | Requirement | Checked |
|---|---|---|
| 1 | the repository `lab-work/repo` exists | yes |
| 2 | it has at least two commits | yes |
| 3 | the secret is still findable in the history | yes |
| 4 | `proof.txt` holds the hash of the key you found | yes |
| 5 | the key is gone from the current `app.py` | yes |
| 6 | a `.gitignore` file exists | yes |
| 7 | a `notes.md` file exists | yes |

Numbers three and four are the point of the topic. The key is taken
**from the repository history**, not from the file in front of you.

## Order

1. `bash setup-repo.sh` — builds the repository with history.
2. Find the key in the history using the lesson's commands.
3. Confirm it is not in the current version.
4. Write the hash into `proof.txt`.
5. Answer in `notes.md`: what is needed to really remove the key?

## Verify

```bash
./check.sh
```
