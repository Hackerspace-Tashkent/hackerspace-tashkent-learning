# Lab S0-04: HTTPS and certificates

| # | Requirement | Checked |
|---|---|---|
| 1 | file `cert.pem` exists | yes |
| 2 | file `key.pem` exists | yes |
| 3 | the certificate names `localhost` | yes |
| 4 | the certificate has a start and an end date | yes |
| 5 | `server.py` uses `ssl` | yes |
| 6 | `server.py` loads the certificate | yes |
| 7 | `proof.txt` holds the certificate fingerprint | recomputed |
| 8 | the client connects **with** the check | live check |
| 9 | the client connects **without** the check and says so | live check |
| 10 | file `notes.md` exists | yes |

Numbers 8 and 9 are not file reading: they **run your server** and
connect to it for real. Both outcomes are required: with the check and
without it. Only the second proves nothing, and only the first does not
show why the check is needed.

## Order

1. Issue the certificate with the command from the lesson.
2. Write `server.py` and `client.py`.
3. Write the fingerprint into `proof.txt`.
4. Answer in `notes.md`: why the check, if the encryption works anyway?

## Verify

```bash
./check.sh
```
