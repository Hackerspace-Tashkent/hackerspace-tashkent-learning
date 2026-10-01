# Lab S0-01: what the server sees

| # | Requirement | Checked |
|---|---|---|
| 1 | file `lab-work/srv.py` exists | yes |
| 2 | the server reads the client's headers | yes |
| 3 | there is an `X-Debug` branch | yes |
| 4 | it reads the `X-Access-Key` header | yes |
| 5 | file `lab-work/notes.md` exists | yes |
| 6 | `proof.txt` holds the hash of the key you found | yes |
| 7 | **your own server** leaks the secret and opens on the key | live check |

Number seven is not file reading. The check starts your server, talks to
it over HTTP, and demands exactly the behaviour the topic is about.

## Order

1. Copy the server from the lesson into `lab-work/srv.py`.
2. Run `python3 srv.py` in a separate terminal.
3. Walk through the lesson's steps with `curl`.
4. Write the hash of the key into `proof.txt`.
5. Answer in `notes.md`: why did the server hand the key over?

## Verify

```bash
./check.sh
```
