# Server nimani koʻradi

## Buni nega bilish kerak

Soʻrov yuborganda sen **oʻylagandan koʻra koʻp** narsa yuborasan.
Sen yozganingdan tashqarida u yerda brauzer nomi, versiya, baʼzan til,
baʼlan qayerdan kelgani maʼlumotlari bor.

Server bularning hammasini koʻradi. **Va ularga ishonadi.**

Bundan kelib chiqadigan narsa yangi boshlovchilarni chalgʻitadi:
**klientdan kelgan «men kim ekanim» haqidagi har qanday da'vo isbot
emas.**

## Soʻrovning uch qismi

```text
GET /readings HTTP/1.1
Host: 127.0.0.1:8000
X-Debug: 1
X-Access-Key: sable-marmalade
```

- **usul** — nimani qilmoqchisiz;
- **yoʻl** — nimaga;
- **sarlavhalar** — qolgan hammasi. Va ularni soxtalash oson.

Sarlavha — bu oddiy «ism: qiymat» juftligi. Oʻzgartirishni har qanday
`curl` bilan yozish mumkin, brauzer kerak emas.

## Nima qurasan

`127.0.0.1:8000` da shunday server:

- `/health` — har doim javob beradi, lekin **agar `X-Debug: 1`
  sarlavhasi yuborilsa, ichki kalitni berib yuboradi**. Haqiqiy tizim
  buni ataylab qilmasdi: bu xatolik — tuzatish ish yoqilganda boʻladi;
- `/readings` — maʼlumotni beradi, **lekin faqat toʻgʻri
  `X-Access-Key` bilan**;
- kalitsiz — `403`.

`lab-work/srv.py` yarating:

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


HTTPServer(("127.0.0.1", 8000), Handler).serve_forever()```

## Ish tartibi

1. Alohida terminalda `python3 srv.py` ishga tushiring.
2. Hech narsasiz soʻrang:

```bash
curl -s http://127.0.0.1:8000/health
```

3. Tuzatish sarlavhasi bilan soʻrang:

```bash
curl -s -H 'X-Debug: 1' http://127.0.0.1:8000/health
```

4. U yerdan qiymatni olib, maʼlumotni oching:

```bash
curl -s -H 'X-Access-Key: <qiymat>' http://127.0.0.1:8000/readings
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8000/readings
```

Kalitsiz `403` qaytadi.

5. `notes.md` da javob bering: **server nega umuman kalitni berdi?**

## Dalil, belgi emas

`proof.txt` da **topilgan kalitning xeshini** yozing: sha256 uning
birinchi 12 belgisidan, kichik harflarda.

```bash
printf '%s' 'kalit' | sha256sum | cut -c1-12 > proof.txt
```

Tekshiruv kalitni oʻzi oladi, xeshlaydi va solishtiradi. Koʻrib boʻladigan
narsa yoʻq: u na darsda, na `check.sh` da bor.

## Bu haqiqatan nimaga haqida

Sen **mavjud boʻlmagan** «himoyani» aylib oʻtding. Server `X-Debug`
sarlavhasini faqat oʻzi qoʻyadi deb oʻylagan. Lekin uni soʻrayotgan
qoʻyadi.

Kimlikni soxtalash, kirish nazoratidan oʻtish va koʻplab narsalar shu
tamoyilga qurilgan. Ostida bitta fikr bor: **klient ishonch manbai emas.**

## Muhim

Hammasi sizning mashinangizda, `127.0.0.1` da, oʻzingiz yozgan serverda
boʻldi. **Faqat shunday qilinishi mumkin.** Xuddi shu usulni begona
serverga qoʻllash — oʻrganish emas.
