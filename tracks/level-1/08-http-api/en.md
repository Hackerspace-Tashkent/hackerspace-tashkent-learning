# HTTP API: your own server and a client for it

## What an API is

A program you can ask for data from **without reading its code**.

An air sensor writes numbers into a file. An application asks "what is it
now" and gets JSON back. The application does not care where the numbers
came from: a file, a sensor, a database. That is what an API is: an
agreement of "ask this way, answer that way".

## Anatomy of a request

A request is a method, a path, headers, and sometimes a body.

| Method | Means |
|---|---|
| `GET` | ask, change nothing |
| `POST` | send something new |
| `PUT` | replace entirely |
| `DELETE` | remove |

```bash
curl http://127.0.0.1:8000/readings
curl -X POST -H "Content-Type: application/json" \
     -d '{"pm25": 42.3}' http://127.0.0.1:8000/readings
```

## The response code is what a human actually reads

| Code | Means | Whose bug |
|---|---|---|
| `200` | all good | — |
| `201` | created | — |
| `400` | malformed request | client |
| `401` | not allowed | client |
| `404` | not found | client |
| `500` | server broke | **server** |

**The rule that saves hours: a 500 is a server bug.** Fixing the client is
pointless while the server is down. Server output first, client second.

## JSON

The usual format for such answers:

```json
{"time": "2026-10-01T12:00:00", "pm25": 42.3}
```

There are numbers, strings, `true`/`false`, arrays and nested objects.
That is all.

## Your own server without frameworks

Codespaces has **neither flask nor requests**, and that is for the better:
you will see the protocol itself, not a framework's habits. Everything
needed is in the standard library.

Create `lab-work/api.py`:

```python
#!/usr/bin/env python3
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

DATA_FILE = "data.json"


def load():
    try:
        with open(DATA_FILE, encoding="utf-8") as f:
            return json.load(f)
    except (OSError, ValueError):
        return []


class Handler(BaseHTTPRequestHandler):
    def reply(self, code, payload):
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/health":
            return self.reply(200, {"ok": True})
        if self.path == "/readings":
            return self.reply(200, load())
        self.reply(404, {"error": "not found"})


HTTPServer(("127.0.0.1", 8000), Handler).serve_forever()
```

And a data file `lab-work/data.json`:

```json
[
  {"time": "2026-10-01T12:00:00", "pm25": 42.3},
  {"time": "2026-10-01T12:05:00", "pm25": 39.8}
]
```

Run it and ask it yourself:

```bash
cd lab-work
python3 api.py &
curl -s http://127.0.0.1:8000/health
curl -s http://127.0.0.1:8000/readings
curl -s -i http://127.0.0.1:8000/nope
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8000/nope
```

Stop it with `Ctrl+C`.

## Why `127.0.0.1` and not `0.0.0.0`

`0.0.0.0` means "listen on every interface", which makes the server visible
to other machines on the network. For a learning task that is unnecessary
and unsafe. `127.0.0.1` is your machine only. Publish outward deliberately.

## Why data lives in a file and not in the code

So you can **test the server without restarting it**. Change `data.json`
and the answer changes immediately. With everything hardcoded, every test
needs a restart, and within five minutes you stop testing.

## Keys: why not in the code

**A key in client-side code is a published key.** Especially on Pages: anyone
who opens the page source sees it. Secrets live on the server, not in what
the user downloads.

## What to do on a 500

1. Open the server output — the truth is there, not in the client's message.
2. A frequent cause: invalid JSON in the request body.
3. Second frequent cause: a path the server does not handle, while the
   client expects a 200.

## Summary

A server is a program that listens on a port and speaks HTTP. `curl` is the
simplest client, and it is enough to verify things. The key skill is
**reading the response code**, not guessing.
