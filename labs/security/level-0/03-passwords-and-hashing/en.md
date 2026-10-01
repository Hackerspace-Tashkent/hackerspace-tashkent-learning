# Lab S0-03: passwords and hashes

| # | Requirement | Checked |
|---|---|---|
| 1 | file `brute.py` exists | yes |
| 2 | `crack.txt` holds the password behind the target hash | yes |
| 3 | file `proof.txt` exists | yes |
| 4 | `salted.py` uses pbkdf2 | yes |
| 5 | `salted.py` uses a salt | yes |
| 6 | `salted.py` uses two different salts | yes |
| 7 | running it gives **three different hashes** for one password | live check |
| 8 | file `notes.md` exists | yes |

Number seven is not file reading. It runs your script and requires three
different values for one password: no salt, salt A, salt B. A single salt
is not enough, and that is checked separately.

## Order

1. `bash setup.sh` — creates `hashes.txt` and `target.txt`.
2. Write `brute.py`, find the password, write it into `crack.txt`.
3. Write the hash into `proof.txt`.
4. Write `salted.py` with three outputs.
5. Answer in `notes.md`: why a salt, if the password is guessed anyway?

## Verify

```bash
./check.sh
```
