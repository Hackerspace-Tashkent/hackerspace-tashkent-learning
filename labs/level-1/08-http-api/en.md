# Lab 08: your own HTTP server

## What to do

Write a small API that serves air sensor readings.

| # | Requirement | Checked |
|---|---|---|
| 1 | file `lab-work/api.py` exists | yes |
| 2 | uses `http.server` | yes |
| 3 | a request handler is defined | yes |
| 4 | there is a `GET` handler | yes |
| 5 | data is read from a file | yes |
| 6 | content type `application/json` is set | yes |
| 7 | there is a `/health` path | yes |
| 8 | unknown paths return `404` | yes |
| 9 | the server listens on `127.0.0.1` | yes |
| 10 | file `lab-work/NOTES.md` exists | yes |
| 11 | the server **really** answers on `/health` | live check |

Number eleven is not file reading: the check starts your server and asks it
with a client. If it does not answer, it prints the server output, where
the reason is.

## Order

1. Copy the code from the lesson into `lab-work/api.py`.
2. Create `lab-work/data.json` with example readings.
3. Run `python3 api.py` in a separate terminal.
4. Check with `curl` on all three paths.
5. In `NOTES.md` answer in writing:

**Why does `/health` come before `/readings` in the example?**

Hint: think about what happens if you swap them.

## Verify

```bash
./check.sh
```
