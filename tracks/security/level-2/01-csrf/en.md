# A request you did not send

## Why this matters

Until now the harm arrived inside a request: SQL in a string, `<script>`
in a body, `;` in a host name. All of it sent by **you**.

CSRF works the other way round. There is no malicious code at all. There
is an ordinary page sending an **ordinary** request -- and the browser
adds the session cookie by itself, because those cookies belong to this
domain.

The server sees: request arrived, cookie arrived, user is authorised.
The action runs.

**CSRF** is cross-site request forgery.

## Why cookies are so exposed

Cookies are sent **automatically**. The browser does not ask and does not
show where the data went. That is convenience and the source of the
problem at once: the browser cannot tell apart

- a request you made by pressing a button;
- a request a foreign page made you send.

The "user is authorised" check passes in both cases.

## What the attack looks like

The foreign page holds a form:

```html
<form action="http://127.0.0.1:8111/action" method="post">
  <input type="hidden" name="email" value="attacker@example.com">
</form>
```

The user opens the page. They may not even click anything -- there are
auto-submitting variants. The form goes out, the cookies go with it, the
email changes.

Hiding the field changes nothing: `hidden` hides it on screen, not in the
request.

## What works

**A token the foreign page does not know.** The server puts a random
value in the form and remembers it in the session. When the request
arrives it compares. The foreign page cannot know the value, so it cannot
forge.

The property is called **double submit** in the simple form and
**synchronizer token** in the strict one: the token lives on the server.

**Checking the source.** `Origin` or `Referer` must match what is
expected. It helps, but relying on it alone is unwise: the header may not
arrive at all.

**Cookies with `SameSite`.** `SameSite=Lax` does not send the cookie on a
cross-site POST. Strong protection, with a blind spot: it does not stop an
attack from the same site, and it does not save old browsers.

**Confirmation for important actions.** Changing an email, a password or
payment details deserves a fresh confirmation.

## What you will do

The server starts unprotected. You show that a foreign page changes the
email, then add the token and explain what exactly it stops.

## Boundary

Your own machine, `localhost`, synthetic email addresses only.
