# Lab S1-01: SQL injection

| # | Requirement | Checked |
|---|---|---|
| 1 | file `srv.py` exists | yes |
| 2 | `srv.py` uses `sqlite3` | yes |
| 3 | the key is not hardcoded in `srv.py` | yes |
| 4 | `proof.txt` holds the hash of the extracted key | recomputed |
| 5 | the injection pulls the key out of the second table | live check |
| 6 | file `notes.md` exists | yes |

The key lives **only** in the database — there is no separate file with
it. So `cat` will not get you there: injection is the only route.

Check 5 does not count rows: it sends the `UNION` and looks for **the
key from your own database** in the response. The first injection dumps
only `people` — `vault` is not reachable that way.

Note: `srv.py` is supposed to be **vulnerable**. That is the exercise,
not a mistake. Fix it and the lab will not count.

## Order

1. `bash setup.sh` — creates `data.db`.
2. Write `srv.py` with the glued string.
3. Honest request → one row.
4. `' OR '1'='1` → all rows of `people`.
5. `UNION` to `vault` → the key.
6. Key hash → `proof.txt`.

## Verify

```bash
./check.sh
```
