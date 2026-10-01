# Lab: GitHub Pages

## What to do

Everything in `lab-work/` next to this file.

```bash
cd "$(dirname check.sh)"
mkdir -p lab-work
cd lab-work
```

### 1. The page

Create `index.html`. The minimum that gets checked:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My first page</title>
</head>
<body>
  <h1>Hello</h1>
  <p>Published from a repository.</p>
</body>
</html>
```

`lang` matters: without it a screen reader cannot tell what language the text
is. `viewport` keeps the layout from breaking on a phone.

### 2. Check locally

```bash
python3 -m http.server 8000
```

Open `http://127.0.0.1:8000`. If it works, the code is fine and any later
failure is a Pages setting.

Stop it with `Ctrl+C`.

### 3. Publish

The file is already on `main`. Now **Settings → Pages → Source: Deploy from a
branch**, branch `main`, folder `/ (root)`, save.

In a minute or three open the address GitHub shows you. It looks like
`https://your-username.github.io/repository-name/`.

### 4. Write it down

`PUBLISHED.md` — one line with the working address. That is what gets checked
for a 200 response.

`NOTES.md` — what worked, what did not, how long it took to appear.

## Checking

```bash
./check.sh
```

Ten local checks and, if an address is given and `curl` exists, an eleventh: a
live request to your own site.

## If the site does not open

- **404** — the file is not named `index.html`, or the folder is not `/ (root)`
- **blank page** — the file exists but is empty or the HTML is broken
- **404 on linked files** — CSS and JS are not where the page looks for them
- **long wait** — publishing sometimes takes a few minutes

## What the lab does not check

It does not check layout and does not check whether it looks good. That is taste,
and no automatic check replaces it.
