# SQL injection

## Why this matters

You write a server. It looks a user up by the name that came from the
client. The most natural line looks like this:

```python
sql = "SELECT name, score FROM people WHERE name = '" + name + "'"
```

The string was glued. `name` is what the user sent, and it landed in the
query text **as code**.

## What the attacker does

An ordinary query: search for `marram`, one row comes back.

The input `' OR '1'='1` turns the query into:

```sql
SELECT name, score FROM people WHERE name = '' OR '1'='1'
```

The condition is now always true, and the server handed over **the whole
table**. No cracking, no guessing — just a different query text, which
the server ran as ordinary.

Next comes `UNION`. It appends the result of a second query to the
first:

```sql
SELECT name, score FROM people WHERE name = ''
UNION SELECT code, note FROM vault--
```

The two dashes cut off the rest. Now the response contains the `vault`
table, which the server never meant to show.

## Why it works

Not because SQLite or Python are stupid. Because the **server cannot
tell data from code**. User input is supposed to be data. Here it became
part of an expression.

## Why it matters in practice

By gluing strings you can do more than read. You can drop tables, reset
passwords, pull salary data. On real sites this is among the most
common application-level holes.

## The right way

Pass the value as a **parameter**, not as part of the text:

```python
rows = db.execute(
    "SELECT name, score FROM people WHERE name = ?", (name,)
)
```

The driver escapes the value itself, and quotes inside the name stay
quotes instead of becoming code. Never glue — not even a query that
"looks harmless".

## What you will do

You get a `data.db`: a `people` table with six names and a `vault`
table with one row — a teaching key.

1. Write `srv.py` with a `/lookup?name=...` endpoint and the **glued
   string** shown above. That is not a typo, it is the exercise.
2. Send an honest request and look at the single row.
3. Send `' OR '1'='1` and count the rows.
4. Stretch a `UNION` to `vault` and pull the key out.
5. Write the first 12 characters of the key's SHA-256 into `proof.txt`.
6. Answer in `notes.md`: **what exactly is the difference between a
   parameter and gluing?**

## Boundaries

The database sits in your own folder, you write the server yourself, the
address is `127.0.0.1`. No third-party site is tested. Probing somebody
else's server without permission is not what this topic teaches.
