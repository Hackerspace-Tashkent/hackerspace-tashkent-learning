#!/usr/bin/env bash
# Готовит sqlite-базу. Ключ лежит в ней одной: отдельного файла с ним нет,
# поэтому «просто открыть базу» не заменяет инъекцию.
set -eu
cd "$(dirname "$0")"
W="$PWD/lab-work"
rm -rf "$W"
mkdir -p "$W"

python3 - <<'PY'
import hashlib
import sqlite3

# Выдуманное имя: в интернете его нет, ключ нельзя загуглить.
KEY = "vt-glaive-rondel-8M4T"
PEOPLE = [
    ("marram", 0.11),
    ("scree", 0.42),
    ("slype", 0.07),
    ("crake", 0.93),
    ("bothy", 0.28),
    ("fen", 0.55),
]

db = sqlite3.connect("lab-work/data.db")
db.execute("CREATE TABLE people (name TEXT, score REAL)")
db.execute("CREATE TABLE vault (code TEXT, note TEXT)")
db.execute("INSERT INTO vault (code, note) VALUES (?, ?)",
           (KEY, "учебный ключ, не настоящий"))
db.executemany("INSERT INTO people VALUES (?, ?)", PEOPLE)
db.commit()
db.close()

print("Готова база: lab-work/data.db")
print("В таблице people шесть имён, в таблице vault — одна строка.")
print("Сервера ещё нет: его напишешь сам.")
PY
