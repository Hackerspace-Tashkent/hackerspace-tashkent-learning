# Practice: a command the user wrote

## What you are given

The fixture created in `lab-work/`:

- `flag.txt` -- a file containing `flag{ne_privet_iz_komandy}`;
- `hosts.txt` -- the list of hosts the server will probe.

## Steps

1. Set up the fixture:

```bash
bash setup.sh
```

2. Look at what appeared:

```bash
ls lab-work
cat lab-work/hosts.txt
```

3. Write `srv.py`:

- route `GET /ping` takes a `host` parameter;
- the server runs a reachability check and returns the output;
- `python3 srv.py <port> [--unsafe]` -- the port as an argument plus an
  optional flag;
- **without the flag** the command is built as a list of arguments, no
  shell involved;
- **with `--unsafe`** you build a string with an f-string and run it
  with `shell=True` -- that is the hole.

The vulnerable version:

```python
cmd = f"ping -c 1 {host}"
out = subprocess.run(cmd, shell=True, capture_output=True, text=True)
```

4. Start the vulnerable server:

```bash
cd lab-work
python3 srv.py 8104 --unsafe
```

5. A normal request:

```bash
curl -G --data-urlencode 'host=localhost' \
  http://127.0.0.1:8104/ping
```

6. Now the injection. Append a command to the host name:

```
curl -G --data-urlencode 'host=; cat flag.txt' \
  http://127.0.0.1:8104/ping
```

If `flag{...}` came back, the hole is there. Try `&& cat flag.txt` and
`$(cat flag.txt)` too: they work for different reasons.

7. **Do not delete `flag.txt`.** The checker watches for that separately.

8. Now close the hole. Drop the f-string and `shell=True`, pass a list:

```python
out = subprocess.run(["ping", "-c", "1", host],
                     capture_output=True, text=True)
```

9. Restart without the flag and run both payloads again: each must come
back as an ordinary failure, not as the file contents.

## What is checked

| | |
|---|---|
| 1 | the file `srv.py` exists |
| 2 | the server answers over HTTP |
| 3 | a normal host is answered |
| 4 | the injected command reads `flag.txt` |
| 5 | after the fix the injection no longer works |
| 6 | `flag.txt` was not deleted to pass the check |

Checks 4 and 5 look at two modes of the same server: first with
`--unsafe`, then without the flag.

## The answer you should reach

Checking "there is no `;` in the string" feels sufficient right up to
the first test case that walks around it. A list of arguments cannot be
walked around: there is no room to append a command. So the question is
not "which characters do I forbid" but "where does a string from the
request turn into a program".
