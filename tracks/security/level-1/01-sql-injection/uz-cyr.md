# SQL инъекцияси

## Бууни нега билиш керак

Сен сервер ёзасиз. У мижоздан келган исм бўйича одамни излайди.
Энг табиий ёзув шундай кўринади:

```python
sql = "SELECT name, score FROM people WHERE name = '" + name + "'"
```

Қатор ёпиштирилган. `name` — мижоз юборган нарса, у сўров матнига
**код сифатида** кириб кетган.

## Хужумчи нима қилади

Оддий сўров: `marram` ни излайди, битта қатор қайтади.

`' OR '1'='1` кириши сўровни шунга айлантиради:

```sql
SELECT name, score FROM people WHERE name = '' OR '1'='1'
```

Шарт доим тўғри бўлиб қолди, сервер эса **бутун жадвални** қайтарди.
Бу бузиш эмас, тахмин ҳам эмас — бошқача сўров матни, уни сервер
одатдагидек бажарди.

Кейин `UNION` келади. У биринчи сўров натижасига иккинчисини қўшади:

```sql
SELECT name, score FROM people WHERE name = ''
UNION SELECT code, note FROM vault--
```

Охиридаги икки чизиқ қолганини кесади. Энди жавобда `vault` жадвали
бор — сервер уни кўрсатмоқчи ҳам эмас эди.

## Бу қандай ишлайди

Сабаби шундаки, SQLite ёки Python аҳмоқ эмас. Сабаби шундаки,
**сервер маълумот билан кодни ажратмайди**. Мижоз киритиши маълумот
бўлиши керак эди. Бу ерда у ифоданинг бир қисмига айланди.

## Нима учун бу жиддий

Қатор ёпиштириш билан фақат ўқиб қолмайди. Жадвални ўчириш,
паролларни алмаштириш, маош маълумотини тортиш мумкин. Ҳақиқий
сайтларда бу энг кўп учрайдиган дастур даражасидаги тешиклардан бири.

## Тўғри йўли

Қийматни **параметр** сифатида бериш керак, матннинг бир қисми
сифатида эмас:

```python
rows = db.execute(
    "SELECT name, score FROM people WHERE name = ?", (name,)
)
```

Драйвер қийматни ўзи экранлайди, исм ичидаги тирноқлар тирноқ
қолади, код бўлмайди. Ёпиштириш ҳеч қачон мумкин эмас — ҳатто
"зарарсиз кўринадиган" сўров учун ҳам.

## Сенга нима керак

`sqlite3` — стандарт кутубхонадаги модул, базани бир қаторда очилади:

```python
import sqlite3

db = sqlite3.connect("data.db")
rows = db.execute("SELECT name, score FROM people").fetchall()
```

Сервер 08-дарсдагидек кўтарилади: `127.0.0.1:8000` да `HTTPServer` ва
`parse_qs` орқали `?name=...` ни ўқийдиган ишчи. Пастда тўлиқ
келтирилган, мавзунинг ўзи шу учта қаторда.

```python
#!/usr/bin/env python3
"""Уязвимый сервер. Запрос склеен из строки -- это и есть дыра."""
import json
import sqlite3
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse

PORT = 8000


def query(name):
    db = sqlite3.connect("data.db")
    # ДВАЖДЫ СПРОСИЛИ, КАК ЭТО ДЕЛАТЬ, И НИ РАЗУ НЕ СДЕЛАЛИ
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

Алоҳида терминалда, `data.db` турган папкадан ишга туширинг:

```bash
python3 srv.py
```

## Сен нима қиласан

Сенга `data.db` берилади: олтита исмли `people` жадвали ва битта
қаторли `vault` жадвали — ўқув калити.

1. `/lookup?name=...` билан `srv.py` ёз ва юқоридаги
   **ёпиштиришни** ишлат. Бу хато эмас, вазифа шу.
2. Ҳалол сўров юбор ва битта қаторни кўр.
3. `' OR '1'='1` юбор ва қаторларни сан.
4. `UNION` ни `vault` гача чўз ва калитни чиқар.
5. `proof.txt` га калитнинг SHA-256 биринчи 12 белгисини ёз.
6. `notes.md` да жавоб бер: **параметр билан ёпиштириш ўртасидаги
   фарқ аниқ нимада?**

## Вазифа чегараси

Базанинг ўз папкада, серверни ўзинг ёзасиз, манзил `127.0.0.1`.
Бошқаларнинг сайтлари текширилмайди. Рухсатсиз бошқа серверни
текшириш — бу мавзунинг ўқув мақсади эмас.
