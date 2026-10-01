# HTTP API: o'z serveringiz va unga mijoz

## API nima

**Kodini oʻqimasdan** maʼlumot soʻraysaniz boʻlgan dastur.

Havo sensori sonralarni faylga yozadi. Dastur soʻraydi: «hozir qancha?» —
va JSON oladi. Dasturga sonralar qayerdan kelgani muhim emas: fayldan,
sensorsan, bazadan. Mana shu API: «shunday soʻra, shunday javob ber»
kelishuvi.

## Soʻrovning anatomiyasi

Soʻrov — bu usul, yoʻl, sarlavhalar va baʼzan tana.

| Usul | Nimani anglatadi |
|---|---|
| `GET` | soʻrash, hech narsani oʻzgartirmasdan |
| `POST` | yangisini yuborish |
| `PUT` | butunlay almashtirish |
| `DELETE` | oʻchirish |

```bash
curl http://127.0.0.1:8000/readings
curl -X POST -H "Content-Type: application/json" \
     -d '{"pm25": 42.3}' http://127.0.0.1:8000/readings
```

## Javob kodi — inson asosan oʻshuni oʻqiydi

| Kod | Nimani anglatadi | Kimning xatosi |
|---|---|---|
| `200` | hammasi joyida | — |
| `201` | yaratildi | — |
| `400` | soʻrov notoʻgʻri | mijoz |
| `401` | huquq yoʻq | mijoz |
| `404` | topilmadi | mijoz |
| `500` | server buzildi | **server** |

**Soatlar tejaydigan qoida: 500 — server xatosi.** Server yiqilib turib
turgan holda mijozni tuzatish behuda. Avval server chiqishi, keyin mijoz.

## JSON

Bunday javoblar uchun odatki format:

```json
{"time": "2026-10-01T12:00:00", "pm25": 42.3}
```

Sonralar, satrlar, `true`/`false`, massivlar va ichki obyektlar bor. Hammasi shu.

## Faymwornsiz oʻz serveringiz

Codespaces da **flask ham, requests ham yoʻq**, va bu yaxshiroq: protokolni
oʻzingiz koʻrasiz, freymvork odatlarini emas. Kerakli hammasi standart
kutubxonada bor.

`lab-work/api.py` yarating:

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

Va maʼlumot fayli `lab-work/data.json`:

```json
[
  {"time": "2026-10-01T12:00:00", "pm25": 42.3},
  {"time": "2026-10-01T12:05:00", "pm25": 39.8}
]
```

Ishga tushiring va oʻzingizdan soʻrang:

```bash
cd lab-work
python3 api.py &
curl -s http://127.0.0.1:8000/health
curl -s http://127.0.0.1:8000/readings
curl -s -i http://127.0.0.1:8000/nope
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8000/nope
```

Toʻxtatish: `Ctrl+C`.

## Nega `127.0.0.1` va `0.0.0.0` emas

`0.0.0.0` — «barcha interfeyslarda eshit» degani, yaʼni server tarmoqdagi
boshqa mashinalarga koʻrinadi. Oʻquv vazifasi uchun bu keraksiz va xavfsiz
emas. `127.0.0.1` — faqat sizning mashinangiz. Tashqariga chiqarish —
qasddan.

## Nega maʼlumot kodda emas, faylda

**Serverni toʻxtatmay sinab koʻrish** uchun. `data.json` ni oʻzgartirdingiz
— javob darhol oʻzgardi. Hammasi kodda boʻlsa, har bir sinov uchun
qayta ishga tushirish kerak, va besh daqiqadan keyin sinashni tashlaysiz.

## Kalitlar: nega kodda emas

**Mijoz kodidagi kalit — eʼlon qilingan kalit.** Ayniqsa Pages da:
sahifa manzilini kim ochsa, uni koʻradi. Maxfiy narsalar serverda turadi,
foydalanuvchi yuklab oladigan narsada emas.

## 500 chiqsa nima qilish kerak

1. Server chiqishini oching — haqiqat u yerda, mijoz xabarida emas.
2. Koʻp uchraydigan sabab: soʻrov tanasida notoʻgʻri JSON.
3. Ikkinchi sabab: server qoʻllaydigan yoʻl, lekin mijoz 200 kutmoqda.

## Xulosa

Server — bu portda eshitadigan va HTTP bilan gaplashadigan dastur.
`curl` — eng sodda mijoz, va tekshirish uchun yetarli. Asosiy koʻnikma —
**javob kodini oʻqish**, taxmin qilish emas.
