# Practice: step outside your own folder

## What you are given

The fixture created in `lab-work/`:

- `public/` -- the folder whose files **should** be served: `index.html`
  and `notes.txt`;
- `secret.txt` -- a service file sitting **next to** `public/`, not
  inside it. It must not leave.

## Steps

1. Set up the fixture:

```bash
bash setup.sh
```

2. Look at what you got:

```bash
ls -R lab-work
```

3. Write `srv.py`:

- `GET /` serves `public/index.html`;
- `GET /<filename>` serves a file from `public/` by the name in the
  request;
- `python3 srv.py <port> [--unsafe]` -- the port as an argument,
  plus an optional flag;
- **without the flag** the server is safe and lets nothing out
  except files from `public/`;
- **with `--unsafe`** it joins the name to `public/` with no
  checks -- that is where the hole shows.

The join looks like this:

```python
path = os.path.join(ROOT, name)
```

4. Start it and confirm a normal file is served:

```bash
cd lab-work
python3 srv.py 8103
```

In another terminal:

```bash
curl http://127.0.0.1:8103/notes.txt
```

5. Walk past the server started **with the flag** `--unsafe`:

```bash
cd lab-work
python3 srv.py 8103 --unsafe
```

In another terminal, send:

```
curl --path-as-is http://127.0.0.1:8103/../secret.txt
```

`--path-as-is` stops curl from shortening the path itself. If the reply
carried the contents of `secret.txt`, the hole is there.

6. **Do not delete `secret.txt`.** Deleting the file is not a fix, it
only passes because the file is gone. The checker watches for that
separately.

7. Now close the hole. Build the full path with `os.path.realpath` and
confirm it starts with `public/`. Test both `GET /../secret.txt` and
`GET /../../etc/passwd`.

8. Restart the server: a normal file still comes back, the traversal
does not.

## What is checked

| | |
|---|---|
| 1 | the file `srv.py` exists |
| 2 | the server answers over HTTP |
| 3 | a normal file is served |
| 4 | the traversal reaches `secret.txt` |
| 5 | after the fix the traversal no longer works |
| 6 | `secret.txt` was not deleted to pass the check |

Look at 5 and 6: a server cannot hand the file out and refuse it at
the same time. So it has two modes, and the checker starts it
twice: first with `--unsafe`, then without the flag.

## The answer you should reach

Why checking "there is no `..` in the name" is not enough:

- `....//` and `%2e%2e%2f` are the same `../`, spelled differently;
- a name may start with `/` and turn out to be an absolute path;
- a symlink inside `public/` points outside on its own;
- case and encoding matter too.

Reliability arrives where the server stops trusting the request-supplied
string at all.
