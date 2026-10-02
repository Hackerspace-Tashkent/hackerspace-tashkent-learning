# SQL-инъекция

## Зачем это знать

Ты пишешь сервер. Он ищет пользователя по имени, которое пришло от
клиента. Самая естественная запись выглядит так:

```python
sql = "SELECT name, score FROM people WHERE name = '" + name + "'"
```

Строка склеена. `name` — то, что прислал пользователь, и оно попало
в текст запроса **как код**.

## Что делает атакующий

Обычный запрос: ищем `marram`, возвращается одна строка.

Запрос `' OR '1'='1` превращается в:

```sql
SELECT name, score FROM people WHERE name = '' OR '1'='1'
```

Условие стало всегда истинным, и сервер отдал **всю таблицу**. Не
взлом и не подбор — просто другой текст запроса, который сервер
выполнил как обычный.

Дальше — `UNION`. Он приклеивает результат второго запроса к первому:

```sql
SELECT name, score FROM people WHERE name = ''
UNION SELECT code, note FROM vault--
```

Две черты в конце отсекают остаток запроса. Теперь в ответе — таблица
`vault`, которую сервер и не собирался показывать.

## Почему это работает

Не потому, что SQLite или Python глупые. А потому, что **сервер не
различает данные и код**. Пользовательский ввод должен быть данными.
Здесь он стал частью выражения.

## Почему это серьёзно

Склеиванием строк можно не только читать. Можно удалять таблицы,
менять пароли, доставать данные о зарплатах. На реальных сайтах это
и есть самая частая дырка уровня приложения.

## Как правильно

Отдавать значение **параметром**, а не частью текста:

```python
rows = db.execute(
    "SELECT name, score FROM people WHERE name = ?", (name,)
)
```

Драйвер сам экранирует значение, и кавычки внутри имени останутся
кавычками, а не кодом. Склеивать нельзя **никогда** — даже «вроде
безобидный» запрос.

## Что тебе понадобится

`sqlite3` — модуль из стандартной библиотеки, файл базы открывается
одной строкой:

```python
import sqlite3

db = sqlite3.connect("data.db")
rows = db.execute("SELECT name, score FROM people").fetchall()
```

Сервер поднимается ровно так же, как в уроке 08: `HTTPServer` на
`127.0.0.1:8000` и обработчик, читающий `?name=...` через `parse_qs`.
Ниже он целиком — с тремя строками, ради которых затевалась тема.

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

Запускается в отдельном терминале, из папки с `data.db`:

```bash
python3 srv.py
```

## Что ты сделаешь

Тебе дадут базу `data.db`: таблица `people` с шестью именами и
таблица `vault` с одной строкой — учебным ключом.

1. Напиши `srv.py` с эндпоинтом `/lookup?name=...` и **склейкой строки**,
   как показано выше. Это не опечатка, а условие задачи.
2. Отправь честный запрос и посмотри на одну строку.
3. Отправь `' OR '1'='1` и посчитай строки.
4. Дотяни `UNION` до `vault` и вытащи ключ.
5. Запиши в `proof.txt` первые 12 символов SHA-256 ключа.
6. Ответь в `notes.md`: **чем именно отличается параметр от склейки?**

## Границы задачи

База лежит в твоей папке, сервер ты пишешь сам, адрес — `127.0.0.1`.
Никакие чужие сайты не проверяются. Проверять чужой сервер на
проникновение без разрешения — не то, чему здесь учат.
