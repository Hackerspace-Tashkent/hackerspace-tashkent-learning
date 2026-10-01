# Lesson 7. GitHub Pages

## What it is

GitHub Pages is free static hosting straight from a repository. You put an
`index.html` file in the root, switch Pages on in the settings, and in a minute
the site is open at an address.

```
repository  →  switch on Pages  →  GitHub builds  →  site works
```

Our own site is built exactly this way:
`https://hackerspace-tashkent.github.io/Hackerspace-Tashkent-website/`.

## The main limitation

Pages serves **only static files**: `.html`, `.css`, `.js`, images, fonts.

What it **cannot** do:
- run code on a server — no PHP, no Python, no Node;
- hold a database;
- handle forms without an external service;
- hide secrets — everything in the repository is visible to everyone.

Hence the rule: **server-side logic is a VPS, static is Pages.** If a site needs
a database it has two options: an external service (Supabase, Airtable) or your
own server. Hiding an API key on Pages is impossible in principle; the secret is
always visible in the page source.

## Method one: from a branch

The simplest, and often enough.

1. The file `index.html` sits in the root of `main`.
2. **Settings → Pages → Source: Deploy from a branch**, branch `main`, folder
   `/ (root)`.
3. Save. In a minute or three the site responds.

Details people trip over:
- the file must be named **exactly `index.html`** (not `index.htm`, not
  `Index.html`);
- if the site is in a subfolder, it appears in the address as `/folder-name/`;
- the front page is `index.html`; everything else is reachable by file name.

## Method two: through Actions

Needed when the site is built: a static site generator, templates, image
processing.

```yaml
name: Publish site

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v5
      - uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
    steps:
      - uses: actions/deploy-pages@v4
```

What matters here and is not obvious:

**`permissions:`** — Actions cannot publish pages by default. Without these three
lines the deploy fails with a permissions error.

**Two jobs, not one.** Building and publishing are separate: a rebuild should not
break a working site. `needs: build` means "wait for the first one".

**`environment: github-pages`** — a special environment GitHub creates itself.
It is what binds the deploy to Pages.

**The artifact** — the intermediate build result. `upload-pages-artifact`
packages the folder, `deploy-pages` unpacks and publishes it.

## A custom domain

Put your domain in **Settings → Pages → Custom domain**, then create a CNAME to
`USER.github.io` in your domain settings.

Two warnings:
- the domain does not start working instantly; checking takes minutes to a day,
  sometimes longer;
- if DNS is not configured the site sits at `DNS Check in Progress` and will not
  open. Check that the domain resolves at all before waiting for anything else.

We tripped on this: `hackerspace.uz` was never configured and does not open. The
working address is the Pages one.

## Check locally before publishing

Publishing and then looking is a bad loop. Check locally:

```bash
cd lab-work
python3 -m http.server 8000
```

Open `http://127.0.0.1:8000` in the browser. If it works locally but not on
Pages, the problem is the Pages setting, not the code.

Codespaces behaves the same: a port there has an "Open in Browser" button.

## HTTPS

Pages issues a certificate automatically. Enforced HTTPS is a toggle in the
settings. With your own domain you can turn on "Enforce HTTPS", but first make
sure the domain opens — otherwise you end up with a site nobody can reach.

## What comes next

The lab is next door: `labs/level-1/07-github-pages`. You build a page, check it
locally, publish it and write down the address.
