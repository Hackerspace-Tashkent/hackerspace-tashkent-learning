# Dastur: begona sahifa pochtangizni oʻzgartiradi

## Nima berilgan

`lab-work/` da fikstura yaratdi:

- `evil.html` — serveringizga POST yuboradigan sahifa;
- `state.txt` — joriy holat: `email=you@example.com`.

## Qadamlar

1. Fiksturani tayyorlang:

```bash
bash setup.sh
```

2. Nima paydo boʻlganini koʻring:

```bash
ls lab-work
cat lab-work/evil.html
cat lab-work/state.txt
```

3. `srv.py` yozing:

- `GET /set` **sessiya cookie qoʻyadi**; uzilmasa, server sizni mehmon
  deb hisoblaydi;
- `GET /form` pochta oʻzgartirish formasini beradi;
- `POST /action` `email` ni oladi va `state.txt` ga yozadi;
- `python3 srv.py <port> [--unsafe]` — port va ixtiyoriy belgi.

Himoyasiz server shunday koʻrinadi:

```python
cookie = "sid=abc123"
if "sid=" in self.headers.get("Cookie", ""):
    email = form.get("email")
    open("state.txt", "w").write("email=" + email)
    self.reply("ok: changed")
```

4. **Zaif** serverni ishga tushiring:

```bash
cd lab-work
python3 srv.py 8111 --unsafe
```

5. Sessiyani oling va qoʻlda sinab koʻring:

```bash
curl -c jar.txt http://127.0.0.1:8111/set
curl -b jar.txt http://127.0.0.1:8111/form
curl -b jar.txt -X POST --data-urlencode 'email=you@example.com' \
  http://127.0.0.1:8111/action
cat state.txt
```

6. Endi asosiy narsa — **sizning tomoningizda umuman forma yoʻq
soʻrov**:

```bash
curl -b jar.txt -X POST --data-urlencode 'email=attacker@example.com' \
  http://127.0.0.1:8111/action
cat state.txt
```

Pochta oʻzgardi. Aynan shuni `evil.html` qiladi: brauzer shu soʻrovni oʻzi
yuborib, cookie ni oʻzi qoʻshib beradi.

7. Endi teshikni yoping. `GET /form` da tasodifiy token yarating:

```python
token = secrets.token_urlsafe(16)
sessions[sid] = token          # serverda saqlanadi
```

va uni shaklga `<input type="hidden" name="csrf" value="...">`
sifatida qoʻying. `POST /action` da yuborilgan qiymatni sessiyadagi
qiymat bilan solishtiring. Mos kelmasa — rad, pochta oʻzgarmaydi.

8. **Belgisiz** qayta ishga tushiring va ikkita urinishni ham yuboring:
tokensiz rad, formadagi token bilan oʻtadi.

## Tekshiriladi

| | |
|---|---|
| 1 | `srv.py` fayli mavjud |
| 2 | sarver HTTP orqali javob beradi |
| 3 | sarver sessiya cookie qoʻyadi |
| 4 | zaif rejimda forma tokensiz keladi |
| 5 | zaif rejimda begona soʻrov oʻtadi |
| 6 | xavfsiz rejimda forma tokenni oladi |
| 7 | tokensiz amal rad etiladi |
| 8 | toʻgʻri token bilan amal bajariladi |

## G chegarasiga etish

Token ishlashining sababi «CSRF dan himoya qiladi» emas, balki begona
sahifa uni oʻqiy olmasligi. Bu erdan muhim xulosalar chiqadi:

- qiymat oldindan boʻlmasligi kerak, «foydalanuvchi nomi va tuz» emas;
- token sessiyaga bogʻlanadi: boshqa sessiyaning cookie si mos kelmaydi;
- holatni oʻzgartiradigan hammasiga kerak: chiqish, pochta oʻzgartirish;
- `SameSite` va `Origin` tekshiruvi — ikkinchi qalam, tokenning oʻrnini
  bosmaydi.
