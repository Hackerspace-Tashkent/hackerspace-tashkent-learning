# What the server sees

## Why this matters

When you send a request, you send **more than you think**. Besides what
you typed there is the browser name, the version, sometimes a language,
sometimes where the request came from.

The server sees all of it. **And it believes it.**

From that follows the thing that confuses beginners: **any claim about who
you are, coming from the client, is not proof.**

## Three parts of a request

```text
GET /readings HTTP/1.1
Host: 127.0.0.1:8000
X-Debug: 1
X-Access-Key: sable-marmalade
```

- **method** — what you want to do;
- **path** — to what;
- **headers** — everything else. And those are easy to forge.

A header is just a "name: value" pair. You can write your own with
`curl`; no browser needed.

## What you will build

A server on `127.0.0.1:8000` that behaves like this:

- `/health` — always answers, but **if you send `X-Debug: 1` it hands
  over the internal key**. No real system would do that on purpose: it
  is what happens when debug is never switched off;
- `/readings` — serves the data, **but only with the right `X-Access-Key`**;
- without the key — `403`.

Create `lab-work/srv.py`:

```python
#!/usr/bin/env python3
"""Сервер-заглушка. Он доверяет заголовкам — это и есть проблема."""
import json
from http.server import BaseHTTPRequestHandler, HTTPServer

# Выдуманное имя: в интернете такого нет, ключ нельзя загуглить.
ACCESS_KEY = "sable-marmalade-4710"
DATA = [{"time": "12:00", "pm25": 42.3}, {"time": "12:05", "pm25": 39.8}]


class Handler(BaseHTTPRequestHandler):
    def reply(self, code, payload):
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        # Заголовок прислал клиент. Сервер ему верит.
        # В настоящей системе такого быть не должно.
        if self.headers.get("X-Debug") == "1":
            return self.reply(200, {"status": "ok", "debug_key": ACCESS_KEY})

        if self.path == "/readings":
            if self.headers.get("X-Access-Key") == ACCESS_KEY:
                return self.reply(200, {"readings": DATA})
            return self.reply(403, {"error": "key required"})

        self.reply(404, {"error": "not found"})


HTTPServer(("127.0.0.1", 8000), Handler).serve_forever()
```

## The work

1. Run `python3 srv.py` in a separate terminal.
2. Ask with nothing:

```bash
curl -s http://127.0.0.1:8000/health
```

3. Ask with the debug header:

```bash
curl -s -H 'X-Debug: 1' http://127.0.0.1:8000/health
```

4. Take the value from there and open the data:

```bash
curl -s -H 'X-Access-Key: <value>' http://127.0.0.1:8000/readings
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8000/readings
```

Without the key you get `403`.

5. In `notes.md` answer: **why did the server hand the key over at all?**

## Proof, not ticks

In `proof.txt` write the **hash of the key you found**: the first 12
characters of its sha256, lowercase.

```bash
printf '%s' 'the-key' | sha256sum | cut -c1-12 > proof.txt
```

The check extracts the key itself, recomputes the hash and compares.
There is nothing to look up: it is neither in the lesson nor in
`check.sh`.

## What this is really about

You just walked past a "protection" that **did not exist**. The server
thought only itself could set `X-Debug`. But the requester sets it.

Identity spoofing, access-control bypass and much else are built on the
same principle. One idea underneath: **the client is not a source of
truth**.

## Important

All of this happened on your own machine, on `127.0.0.1`, with a server
you wrote yourself. **That is the only way it is allowed.** The same
trick against someone else's server is not learning.
