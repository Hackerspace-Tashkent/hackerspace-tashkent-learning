# Practice: a foreign page changes your email

## What you are given

The fixture created in `lab-work/`:

- `evil.html` -- a page holding a form that posts to your server;
- `state.txt` -- current state: `email=you@example.com`.

## Steps

1. Set up the fixture:

```bash
bash setup.sh
```

2. Look at what appeared:

```bash
ls lab-work
cat lab-work/evil.html
cat lab-work/state.txt
```

3. Write `srv.py`:

- `GET /set` **sets the session cookie**; without it the server counts
  you as a guest;
- `GET /form` returns the email change form;
- `POST /action` takes `email` and writes it into `state.txt`;
- `python3 srv.py <port> [--unsafe]` -- the port and an optional flag.

The unprotected server looks like this:

```python
cookie = "sid=abc123"
if "sid=" in self.headers.get("Cookie", ""):
    email = form.get("email")
    open("state.txt", "w").write("email=" + email)
    self.reply("ok: changed")
```

4. Start the **vulnerable** server:

```bash
cd lab-work
python3 srv.py 8111 --unsafe
```

5. Take a session and try it by hand:

```bash
curl -c jar.txt http://127.0.0.1:8111/set
curl -b jar.txt http://127.0.0.1:8111/form
curl -b jar.txt -X POST --data-urlencode 'email=you@example.com' \
  http://127.0.0.1:8111/action
cat state.txt
```

6. Now the main point -- **a request with no form on your side at all**:

```bash
curl -b jar.txt -X POST --data-urlencode 'email=attacker@example.com' \
  http://127.0.0.1:8111/action
cat state.txt
```

The email changed. That is exactly what `evil.html` does: the browser
would send the same request and attach the cookie by itself.

7. Now close the hole. At `GET /form` generate a random token:

```python
token = secrets.token_urlsafe(16)
sessions[sid] = token          # remembered on the server
```

and put it into the form as `<input type="hidden" name="csrf" value="...">`.

At `POST /action` compare the submitted value with the one in the
session. No match means refusal, and the email does not change.

8. Restart **without the flag** and run both attempts: no token is
refused, the token from the form goes through.

## What is checked

| | |
|---|---|
| 1 | the file `srv.py` exists |
| 2 | the server answers over HTTP |
| 3 | the server sets a session cookie |
| 4 | in vulnerable mode the form carries no token |
| 5 | in vulnerable mode a foreign POST goes through |
| 6 | in safe mode the form contains a token |
| 7 | without the token the action is refused |
| 8 | with the right token the action goes through |

## The answer you should reach

A token works not because it "protects against CSRF" but because the
foreign page cannot read it. Important consequences follow:

- the value must be unpredictable, not "username plus salt";
- the token is bound to the session: another session's cookie will not do;
- everything that changes state needs it: logout, email change, delete;
- `SameSite` and the `Origin` check are a second layer, not a substitute.
