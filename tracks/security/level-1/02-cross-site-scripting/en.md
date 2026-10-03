# How the browser executes what the server sent

## Why this matters

In the previous topic we pulled data out of a table by asking the server.
Here it is the other way round: we do not send a request, we **send
code**, and somebody else's browser runs it.

A page is treated as code, not as text. The browser receives a string and
asks the HTML parser: is this a tag? If it is a tag, it builds it. That
is what this attack is called: **XSS**, cross-site scripting.

## What the server does

A normal review page. Someone writes a review, the server saves it and
shows it **to everyone** who opens the page.

As long as the review passes through escaping, it is safe: `<` becomes
`&lt;` and the browser shows a character instead of building a tag.

```python
import html
safe = html.escape(user_input)   # <  →  &lt;
```

## Where it breaks

Any of these lines sends user input into HTML without escaping:

- the whole response body;
- `f"<p>{body}</p>"`;
- insertion into an attribute value;
- insertion inside `<script>`.

One such line and every visitor to the page runs someone else's code. Not
the administrator, not the developer: **the visitor**.

## The payload

A classic payload looks like this:

`<img src=x onerror=alert(1)>`

Read it as: an `img` tag with a broken `src` never loads, the browser
raises the error and runs `onerror`. No images, no network.

The text inside `alert` does not matter. What matters is the fact: **the
code executed**.

## What you will do

The server is yours to write. You will make it vulnerable, then remove
the hole, then explain what exactly the fix changes.

## Boundary

Your own machine, `localhost` only, synthetic data from the fixture. No
third-party sites.
