#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
check_content.py — проверка целостности учебных материалов.

Проверяет не работу ученика (это делает labs/*/check.sh), а целостность
наших собственных материалов: ссылки, языки, пары урок↔практика, синтаксис
скриптов и отсутствие известных регрессий.

Запуск:
    python3 tools/check_content.py            # быстро, без сети
    python3 tools/check_content.py --links    # плюс проверка внешних ссылок
"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

LANGS = ["en", "ru", "uz-lat", "uz-cyr"]
LEVELS = ["level-0", "level-1"]

# Известные регрессии: появлялись и уже исправлялись, ловятся повторно.
FORBIDDEN = [
    (r"~/terminal-lab", "старый путь вместо lab-work"),
    (r"~/permissions-lab", "старый путь вместо lab-work"),
    (r"~/git-lab", "старый путь вместо lab-work"),
    (r"~/script-lab", "старый путь вместо lab-work"),
    (r"tools/build\.py", "генератор удалён из репозитория"),
    (r"tools/content\.py", "генератор удалён из репозитория"),
    (r"tools/translit\.py", "генератор удалён из репозитория"),
    (r"hackerspace\.tashkent@gmail", "неверная почта"),
    (r"@hackerspace_admin", "несуществующий аккаунт"),
    (r"hackerspace\.uz", "домен не настроен, работает Pages URL"),
]

MD_RE = re.compile(r"\[[^\]]*\]\(([^)]+)\)")


class Report:
    def __init__(self):
        self.errors = []
        self.warnings = []
        self.checks = 0

    def ok(self, name):
        self.checks += 1

    def error(self, name, detail):
        self.errors.append((name, detail))

    def warn(self, name, detail):
        self.warnings.append((name, detail))

    def total(self):
        return self.checks + len(self.errors)

    def print(self):
        print("=" * 68)
        print("ПРОВЕРКА МАТЕРИАЛОВ")
        print("=" * 68)
        for n, d in self.errors:
            print("  ОШИБКА  %-34s %s" % (n, d))
        for n, d in self.warnings:
            print("  ВНИМАНИЕ %-33s %s" % (n, d))
        if not self.errors and not self.warnings:
            print("  всё чисто")
        print("-" * 68)
        print("  успешно: %d, ошибок: %d, предупреждений: %d"
              % (self.checks, len(self.errors), len(self.warnings)))
        return 1 if self.errors else 0


def walk(ext=None):
    for base, dirs, files in os.walk(ROOT):
        dirs[:] = [d for d in dirs if d not in (".git", ".github", "__pycache__")]
        for f in sorted(files):
            if ext and not f.endswith(ext):
                continue
            yield os.path.relpath(os.path.join(base, f), ROOT)


def check_languages(r):
    """Каждая группа документов должна быть на всех четырёх языках."""
    groups = {}
    for p in walk(".md"):
        m = re.match(r"(.*)/([a-z]{2}(?:-[a-z]{3,4})?)\.md$", p)
        if not m:
            continue
        stem, lang = m.group(1), m.group(2)
        if lang in LANGS:
            groups.setdefault(stem, set()).add(lang)
    for stem, langs in sorted(groups.items()):
        missing = set(LANGS) - langs
        name = "языки: " + stem
        if missing:
            r.error(name, "нет языков: %s" % ", ".join(sorted(missing)))
        else:
            r.ok(name)


def check_internal_links(r):
    for p in walk(".md"):
        text = open(os.path.join(ROOT, p), encoding="utf-8").read()
        for m in MD_RE.finditer(text):
            target = m.group(1)
            if target.startswith(("http://", "https://", "mailto:")):
                continue
            target = target.split("#")[0]
            if not target:
                continue
            full = os.path.normpath(os.path.join(os.path.dirname(p), target))
            name = "ссылка: " + p
            if not os.path.exists(os.path.join(ROOT, full)):
                r.error(name, "битая ссылка -> %s" % target)
            else:
                r.ok(name)


def check_readme_language(r):
    """Ссылка из README должна вести на файл того же языка."""
    for p in sorted(walk("README*.md")):
        if os.path.dirname(p) != ".":
            continue
        base = os.path.basename(p)
        lang = base[len("README"):-3].lstrip(".") or "en"
        text = open(os.path.join(ROOT, p), encoding="utf-8").read()
        for m in MD_RE.finditer(text):
            t = m.group(1)
            if t.startswith("http") or t == "LICENSE":
                continue
            if re.fullmatch(r"README(\.[a-z-]+)?\.md", t):
                continue          # переключатель языков
            if t.endswith(".md"):
                seg = t.rsplit("/", 1)[-1][:-3]
                if seg != lang:
                    r.error("язык ссылки: " + base, "%s ведёт на язык %s" % (t, seg))
                else:
                    r.ok("язык ссылки: " + base)


def check_lesson_lab_pairs(r):
    """Каждой практике должен соответствовать урок и наоборот."""
    for level in LEVELS:
        lab_dir = os.path.join(ROOT, "labs", level)
        trk_dir = os.path.join(ROOT, "tracks", level)
        if not os.path.isdir(lab_dir):
            continue
        for d in sorted(os.listdir(lab_dir)):
            lab = os.path.join(lab_dir, d)
            trk = os.path.join(trk_dir, d)
            name = "пара %s/%s" % (level, d)
            if not os.path.isdir(lab):
                continue
            if not os.path.isdir(trk):
                r.error(name, "нет урока tracks/%s/%s" % (level, d))
                continue
            if not os.path.isfile(os.path.join(lab, "check.sh")):
                r.error(name, "нет check.sh")
                continue
            r.ok(name)
            for lang in LANGS:
                for base in (lab, trk):
                    f = os.path.join(base, "%s.md" % lang)
                    if not os.path.isfile(f):
                        r.error(name, "нет %s.md в %s" % (lang, os.path.relpath(base, ROOT)))
                    else:
                        r.ok(name)


def check_scripts(r):
    """Синтаксис и обязательные части скриптов проверки."""
    for p in sorted(walk("check.sh")):
        full = os.path.join(ROOT, p)
        name = "скрипт: " + p
        proc = subprocess.run(["bash", "-n", full], capture_output=True, text=True)
        if proc.returncode != 0:
            r.error(name, "синтаксис: %s" % proc.stderr.strip().split("\n")[0])
            continue
        r.ok(name)
        text = open(full, encoding="utf-8").read()
        if "WORK=" not in text:
            r.error(name, "нет переменной WORK")
        if not re.search(r"\b[tT]\(\)\s*\{", text) and 't "' not in text:
            r.warn(name, "похоже, нет функции перевода")
        checks = len(re.findall(r"(?m)^check\b", text))
        if checks == 0:
            r.error(name, "нет ни одной проверки")
        elif checks < 4:
            r.warn(name, "мало проверок: %d" % checks)
        if not os.access(full, os.X_OK):
            r.warn(name, "файл не исполняемый")


def check_forbidden(r):
    for p in walk(".md"):
        text = open(os.path.join(ROOT, p), encoding="utf-8").read()
        for pattern, why in FORBIDDEN:
            if re.search(pattern, text):
                r.error("регрессия: " + p, "%s (%s)" % (pattern, why))
            else:
                r.ok("регрессия: " + p)


def check_encoding(r):
    for p in walk(".md"):
        raw = open(os.path.join(ROOT, p), "rb").read()
        name = "кодировка: " + p
        if b"\xef\xbf\xbd" in raw:
            r.error(name, "повреждённый символ U+FFFD")
            continue
        try:
            raw.decode("utf-8")
            r.ok(name)
        except UnicodeDecodeError as e:
            r.error(name, "не UTF-8: %s" % e)


def check_structure_alignment(r):
    """Один и тот же документ на разных языках должен иметь ту же структуру."""
    groups = {}
    for p in walk(".md"):
        m = re.match(r"(.*)/([a-z]{2}(?:-[a-z]{3,4})?)\.md$", p)
        if m and m.group(2) in LANGS:
            groups.setdefault(m.group(1), []).append(p)
    for stem, files in sorted(groups.items()):
        if len(files) != len(LANGS):
            continue
        shapes = {}
        for p in files:
            text = open(os.path.join(ROOT, p), encoding="utf-8").read()
            shapes[p] = (len(re.findall(r"^## ", text, re.M)),
                         len(re.findall(r"^```", text, re.M)) // 2,
                         len(re.findall(r"^\|---", text, re.M)))
        vals = set(shapes.values())
        name = "структура: " + stem
        if len(vals) > 1:
            r.error(name, "разная структура: %s" % shapes)
        else:
            r.ok(name)


# Локальные адреса из лабораторных: ученик поднимает сервер сам.
LOCAL_URL = re.compile(r"^(https?://)(127\.0\.0\.1|localhost|\[::1\]|mysite\.local)\b")

# Коды, которыми сервер отвечает «жив, но автоматический доступ запрещён».
BLOCKED_CODES = (401, 403, 405, 406, 409, 429, 503)


def check_external_links(r, limit=None):
    """Проверяет внешние ссылки.

    Различает три исхода, иначе валидатор приучает игнорировать себя:
      2xx/3xx  — ссылка живая;
      4xx/5xx из BLOCKED_CODES — сервер жив, но режет ботов (Cloudflare и т.п.);
      0 / NXDOMAIN — ссылка действительно мертва.
    """
    import socket
    import urllib.error
    import urllib.request

    urls = set()
    for p in walk(".md"):
        for m in re.finditer(r"https?://[^\s)\]]+",
                             open(os.path.join(ROOT, p), encoding="utf-8").read()):
            urls.add(m.group(0).rstrip(".,;:"))
    urls = {u for u in urls if not LOCAL_URL.match(u)}
    if limit:
        urls = sorted(urls)[:limit]
    print("\n  проверяю %d внешних ссылок (это медленно)..." % len(urls))

    for u in sorted(urls):
        name = "внешняя: " + u[:52]
        host = u.split("//", 1)[1].split("/")[0].split(":")[0]

        # 1. домен существует?
        try:
            socket.gethostbyname(host)
        except socket.gaierror:
            r.error(name, "домен не резолвится")
            continue

        # 2. отвечает ли сервер?
        code = 0
        for method in ("HEAD", "GET"):
            try:
                req = urllib.request.Request(
                    u, method=method, headers={"User-Agent": "Mozilla/5.0"})
                with urllib.request.urlopen(req, timeout=25) as resp:
                    code = resp.status
                break
            except urllib.error.HTTPError as e:
                code = e.code
                break
            except Exception:
                continue

        if code and code < 400:
            r.ok(name)
        elif code in BLOCKED_CODES:
            r.warn(name, "жив, но закрыт от ботов (HTTP %s)" % code)
        else:
            r.error(name, "HTTP %s" % (code or "нет ответа"))


def check_script_mixing(r):
    """В latin-версиях не должно оставаться кириллицы.

    Обратное не проверяем: в узбекской кириллице легитимно много
    латинских терминов (Codespaces, Git, check.sh), и такая проверка
    даёт только ложные срабатывания. Реальный режим ошибки один —
    русский или кириллический заголовок, забытый в latin-версии.
    """
    for p in walk("uz-lat.md"):
        text = open(os.path.join(ROOT, p), encoding="utf-8").read()
        name = "кириллица в latin-версии: " + p
        bad = []
        in_code = False
        for i, line in enumerate(text.split("\n"), 1):
            if line.startswith("```"):
                in_code = not in_code
                continue
            if in_code or "http" in line:
                continue
            if "](README" in line:
                continue          # переключатель языков: названия как есть
            if re.search(r"[Ѐ-ӿ]", line):
                bad.append(i)
        if bad:
            r.warn(name, "строки: %s" % bad[:8])
        else:
            r.ok(name)


def main():
    r = Report()
    check_encoding(r)
    check_languages(r)
    check_lesson_lab_pairs(r)
    check_readme_language(r)
    check_internal_links(r)
    check_structure_alignment(r)
    check_scripts(r)
    check_script_mixing(r)
    check_forbidden(r)

    if "--links" in sys.argv:
        check_external_links(r)

    return r.print()


if __name__ == "__main__":
    sys.exit(main())
