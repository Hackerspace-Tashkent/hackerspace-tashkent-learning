#!/usr/bin/env bash
# Фикстура S1-02: база с отзывами и служебной таблицей, где лежит токен.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="$HERE/lab-work"
rm -rf "$WORK"
mkdir -p "$WORK"

python3 - "$WORK" <<'PY'
import sqlite3, sys, os
work = sys.argv[1]
db = os.path.join(work, "reviews.db")
if os.path.exists(db):
    os.remove(db)
c = sqlite3.connect(db)
c.executescript("""
CREATE TABLE reviews (
    id INTEGER PRIMARY KEY,
    author TEXT,
    body TEXT
);
CREATE TABLE admin (
    id INTEGER PRIMARY KEY,
    name TEXT,
    token TEXT
);
INSERT INTO reviews (author, body) VALUES
 ('Ali','Отличный курс, всё понятно.'),
 ('Dilnoza','Спасибо, второй раз прохожу.'),
 ('Javokir','А есть практика по сетям?');
INSERT INTO admin (name, token) VALUES
 ('hackerspace','session-7f3a9c2e-mint-2026');
""")
c.commit()
c.close()
print("создана база: lab-work/reviews.db")
PY

echo
echo "Что дальше: прочитай урок и напиши srv.py."
