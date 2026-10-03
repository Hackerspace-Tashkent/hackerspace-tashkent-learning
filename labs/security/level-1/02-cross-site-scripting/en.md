# Practice: pull the token out through the browser

## What you are given

`lab-work/` already has a `reviews.db` database: three reviews and a
service table `admin` holding a token. **The token is not in the page** —
it sits in `admin.token`, while the review page only shows reviews.

## Steps

1. Set up the fixture:

```bash
bash setup.sh
```

2. Look at the database to see what exists at all. There is no `sqlite3`
   client in Codespaces, so open it through Python, which is always
   there:

```bash
python3 -c "
import sqlite3
c = sqlite3.connect('lab-work/reviews.db')
print([r[0] for r in c.execute(
    \"SELECT name FROM sqlite_master WHERE type='table'\")])
print(list(c.execute('SELECT author, body FROM reviews')))
"
```

The token is in `admin`. You need it **only to verify**, it cannot reach
the page itself.

3. Write `srv.py`:

- one route `GET /` — the page with all reviews;
- one route `POST /review` — takes `author` and `body`, stores the review
  and shows the page again;
- `python3 srv.py <port>` — takes the port number as an argument;
- **insert `author` and `body` into HTML without escaping** — that is how
  the payload reaches the page.

4. Start the server:

```bash
cd lab-work
python3 srv.py 8102
```

5. Open `http://127.0.0.1:8102/` in a browser, submit a review with
   ``<img src=x onerror=alert(1)>`` and check whether a live tag appears in the page source.

6. Now pull the token. It is in the `admin` table while the page only
   shows `reviews`. So the **server itself** has to return the contents
   of another table.

   Remember: a browser opens the page and runs whatever the server sent.
   So the request for `admin` must happen **on the server side**, and the
   answer must come back inside the page body.

7. Write the first 12 characters of the sha256 of the token into
   `lab-work/proof.txt`:

```bash
python3 -c "
import sqlite3, hashlib
t = sqlite3.connect('lab-work/reviews.db').execute(
    'SELECT token FROM admin LIMIT 1').fetchone()[0]
print(hashlib.sha256(t.encode()).hexdigest()[:12])
" > lab-work/proof.txt
```

8. Now close the hole: escape `author` and `body` before printing them.
   Check that the payload now arrives as text rather than as a tag.

## What is checked

| | |
|---|---|
| 1 | the file `srv.py` exists |
| 2 | the server answers over HTTP |
| 3 | the review input comes back into the page |
| 4 | the payload arrives as a tag, not as text |
| 5 | proof.txt holds the hash of the token you pulled out |

Checks 3 and 4 run against **your** server: the checker sends a payload
and looks at what came back. It will not accept a different process on
the same port.

## The answer you should reach

Escaping HTML is not "just call escape". It is a decision:

- where exactly the output into HTML happens;
- whether everything from the user is escaped;
- whether something gets escaped twice (the text then looks wrong);
- whether input lands in an attribute or inside `<script>`, where
  `html.escape` is not enough.
