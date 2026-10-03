# SQL inʼektsiyasi

## Buuni nega bilish kerak

Sen server yozasiz. U mijozdan kelgan ism boʻyicha odamni izlaydi.
Eng tabiiy yozuv shunday koʻrinadi:

```python
sql = "SELECT name, score FROM people WHERE name = '" + name + "'"
```

Qator yopishtirilgan. `name` — mijoz yuborgan narsa, u soʻrov matniga
**kod sifatida** kirib ketgan.

## Xujumchi nima qiladi

Oddiy soʻrov: `marram` ni izlaydi, bitta qator qaytadi.

`' OR '1'='1` kirishi soʻrovni shunga aylantiradi:

```sql
SELECT name, score FROM people WHERE name = '' OR '1'='1'
```

Shart doim toʻgʻri boʻlib qoldi, server esa **butun jadvalni** qaytardi.
Bu buzish emas, taxmin ham emas — boshqacha soʻrov matni, uni server
odatdagidek bajardi.

Keyin `UNION` keladi. U birinchi soʻrov natijasiga ikkinchisini qoʻshadi:

```sql
SELECT name, score FROM people WHERE name = ''
UNION SELECT code, note FROM vault--
```

Oxiridagi ikki chiziq qolganini kesadi. Endi javobda `vault` jadvali
bor — server uni koʻrsatmoqchi ham emas edi.

## Bu qanday ishlaydi

Sababi shundaki, SQLite yoki Python ahmoq emas. Sababi shundaki,
**server maʼlumot bilan kodni ajratmaydi**. Mijoz kiritishi maʼlumot
boʻlishi kerak edi. Bu erda u ifodaning bir qismiga aylandi.

## Nima uchun bu jiddiy

Qator yopishtirish bilan faqat oʻqib qolmaydi. Jadvalni oʻchirish,
parollarni almashtirish, maosh maʼlumotini tortish mumkin. Haqiqiy
saytlarda bu eng koʻp uchraydigan dastur darajasidagi teshiklardan biri.

## Toʻgʻri yoʻli

Qiymatni **parametr** sifatida berish kerak, matnning bir qismi
sifatida emas:

```python
rows = db.execute(
    "SELECT name, score FROM people WHERE name = ?", (name,)
)
```

Drayver qiymatni oʻzi ekranlaydi, ism ichidagi tirnoqlar tirnoq
qoladi, kod boʻlmaydi. Yopishtirish hech qachon mumkin emas — hatto
"zararsiz koʻrinadigan" soʻrov uchun ham.

## Senga nima kerak

`sqlite3` — standart kutubxonadagi modul, bazani bir qatorda ochiladi:

```python
import sqlite3

db = sqlite3.connect("data.db")
rows = db.execute("SELECT name, score FROM people").fetchall()
```

Server 08-darsdagidek koʻtariladi: `127.0.0.1:8000` da `HTTPServer` va
`parse_qs` orqali `?name=...` ni oʻqiydigan ishchi. Pastda toʻliq
keltirilgan, mavzuning oʻzi shu uchta qatorda.

```python
#!/usr/bin/env python3
"""Zaif server. Soʻrov satrdan yigʻilgan -- shu ham teshik."""
import json
import sqlite3
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse

PORT = 8000


def query(name):
    db = sqlite3.connect("data.db")
    # IKKI MARTA SURADI, QANDAY QILIShNI, VA IKKILASIDA HAM QILINMADI
    sql = "SELECT name, score FROM people WHERE name = '" + name + "'"
    rows = db.execute(sql).fetchall()
    db.close()
    return sql, rows


class H(BaseHTTPRequestHandler):
    def do_GET(self):
        u = urlparse(self.path)
        if u.path != "/lookup":
            self.send_error(404)
            return
        name = parse_qs(u.query).get("name", [""])[0]
        sql, rows = query(name)
        body = json.dumps({"sql": sql, "rows": rows},
                          ensure_ascii=False).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *a):
        pass


HTTPServer(("127.0.0.1", PORT), H).serve_forever()
```

Alohida terminalda, `data.db` turgan papkadan ishga tushiring:

```bash
python3 srv.py
```

## Sen nima qilasan

Senga `data.db` beriladi: oltita ismli `people` jadvali va bitta
qatorli `vault` jadvali — oʻquv kaliti.

1. `/lookup?name=...` bilan `srv.py` yoz va yuqoridagi
   **yopishtirishni** ishlat. Bu xato emas, vazifa shu.
2. Halol soʻrov yubor va bitta qatorni koʻr.
3. `' OR '1'='1` yubor va qatorlarni san.
4. `UNION` ni `vault` gacha choʻz va kalitni chiqar.
5. `proof.txt` ga kalitning SHA-256 birinchi 12 belgisini yoz.
6. `notes.md` da javob ber: **parametr bilan yopishtirish oʻrtasidagi
   farq aniq nimada?**

## Vazifa chegarasi

Bazaning oʻz papkada, serverni oʻzing yozasiz, manzil `127.0.0.1`.
Boshqalarning saytlari tekshirilmaydi. Ruxsatsiz boshqa serverni
tekshirish — bu mavzuning oʻquv maqsadi emas.
