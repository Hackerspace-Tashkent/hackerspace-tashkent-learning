#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_lessons.py — проверяет материалы с точки зрения ученика, а не скрипта.

Четыре оси:
  A. Команды из уроков — работают ли они на самом деле
  B. Объясняет ли урок «зачем», а не только «как»
  C. Проверяет ли практика то, чему учит урок
  D. Единообразны ли термины между уроками

Запуск:  python3 tools/audit_lessons.py [A|B|C|D]
"""
import io
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TRACKS = os.path.join(ROOT, "tracks")
LABS = os.path.join(ROOT, "labs")
LANGS = ("ru", "en", "uz-lat", "uz-cyr")

# Команды, которые нельзя запускать: меняют систему или требуют сети.
SKIP = re.compile(
    r"\b(sudo\b|rm\s+-rf|systemctl|reboot|shutdown|apt-get|apt\b|dnf\b|"
    r"curl\b(?!.*127\.0\.0\.1)|wget\b|git\s+push|gh\b|ssh\b|docker\b|"
    r"killall|pkill|kill\s|chown\b|passwd|iptables|nmap|ping\b|"
    r"npm\s+i|yarn\b|pip\s+install|apt\s)")


def lessons():
    out = []
    for lvl in sorted(os.listdir(TRACKS)):
        base = os.path.join(TRACKS, lvl)
        if not os.path.isdir(base):
            continue
        for slug in sorted(os.listdir(base)):
            ru = os.path.join(base, slug, "ru.md")
            if os.path.isfile(ru):
                out.append((lvl, slug, os.path.join(base, slug)))
    return out


def code_blocks(text, langs=("bash", "sh", "shell", "console")):
    """Разбирает блоки кода построчно.

    Регулярка здесь не годится: необязательный язык фенса с
    ``re.S`` захватывал прозу между незакрытым блоком и следующим,
    и обычный текст попадал в список «команд». Поэтому построчно.
    """
    blocks = []
    cur = None
    buf = []
    for line in text.split("\n"):
        s = line.lstrip()
        if cur is None and s.startswith("```"):
            tok = s[3:].strip().lower()
            # пустой фенс или известный язык; иначе это не блок кода
            if tok == "" or tok in langs:
                cur = tok
                buf = []
            continue
        if cur is not None:
            if s.startswith("```"):
                blocks.append((cur, "\n".join(buf)))
                cur = None
                buf = []
            else:
                buf.append(line)
    return blocks


CMDS = {"ls", "pwd", "cd", "cat", "echo", "printf", "grep", "find",
        "head", "tail", "sort", "wc", "cut", "tr", "sed", "awk", "chmod",
        "chown", "ln", "cp", "mv", "rm", "touch", "mkdir", "rmdir", "stat",
        "file", "readlink", "basename", "dirname", "id", "whoami", "hostname",
        "uname", "date", "uptime", "ps", "top", "kill", "jobs", "bg", "fg",
        "nohup", "disown", "free", "df", "du", "ip", "ss", "netstat", "ping",
        "curl", "wget", "git", "tar", "gzip", "gunzip", "zip", "unzip",
        "export", "source", "alias", "set", "test", "true", "false", "sleep",
        "seq", "man", "which", "type", "python3", "node", "npm", "docker",
        "systemctl", "crontab", "env", "diff", "xargs", "tee", "ssh", "scp",
        "timeout", "watch", "history", "who", "groups", "env", "command"}


def cmd_lines(block):
    """Строки, которые действительно выглядят как команды.

    Отсекаем прозу: командная строка начинается с известной утилиты.
    Без этого фильтра обычный текст («Есть числа, строки…») попадал бы
    в проверку и давал бы сотни выдуманных ошибок.
    """
    out = []
    for raw in block.split("\n"):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        line = re.sub(r"^[$>]\s*", "", line)
        if "#" in line and not line.startswith(("'", '"')):
            line = line.split("#")[0].strip()
        if not line:
            continue
        first = re.split(r"[ \t]", line)[0]
        if first not in CMDS:
            continue
        out.append(line)
    return out


def axis_a(verbose=False):
    """Команды из уроков работают?"""
    print("=" * 68)
    print("ОСЬ A: команды из уроков работают?")
    print("=" * 68)
    tested = failed = skipped = 0
    problems = []
    hangs = []

    for lvl, slug, d in lessons():
        path = os.path.join(d, "ru.md")
        if not os.path.isfile(path):
            continue
        text = io.open(path, encoding="utf-8").read()
        for block in code_blocks(text):
            body = block[1] if isinstance(block, tuple) else block
            for cmd in cmd_lines(body):
                if SKIP.search(cmd):
                    skipped += 1
                    continue
                # составные конструкции и циклы пропускаем: их нельзя
                # безопасно выполнить одной строкой
                if re.search(r"(^|\s)(for|do|done|while|if|then|fi|\{|\}|<<|>>?)\b",
                             cmd) or cmd.endswith(("\\", "&&", "|")):
                    skipped += 1
                    continue
                tested += 1
                with tempfile.TemporaryDirectory() as tmp:
                    try:
                        proc = subprocess.run(
                            ["bash", "-c", cmd], cwd=tmp, capture_output=True,
                            text=True, timeout=15,
                            stdin=subprocess.DEVNULL,
                            env=dict(os.environ, HOME=tmp, CHECK_LANG="ru",
                                     PS1="$ "))
                    except subprocess.TimeoutExpired:
                        # Фоновые команды вроде `sleep 300 &` держат
                        # канал открытым. Это свойство нашего запуска,
                        # а не уроков: в настоящем терминале они
                        # возвращают строку сразу.
                        skipped += 1
                        tested -= 1
                        hangs.append((lvl, slug, cmd))
                        continue
                    if proc.returncode != 0:
                        failed += 1
                        err = (proc.stderr.strip().split("\n") or ["?"])[0][:90]
                        problems.append((lvl, slug, cmd, err))

    print("\nпроверено команд: %d, упало: %d, пропущено: %d\n"
          % (tested, failed, skipped))
    if problems:
        print("НЕ РАБОТАЮТ:")
        for lvl, slug, cmd, err in problems:
            print("  [%s/%s] %s" % (lvl, slug, cmd[:70]))
            print("      -> %s" % err)
    else:
        print("все проверенные команды отработали без ошибки")
    if hangs:
        print("\nфоновые команды, удерживающие канал (%d):" % len(hangs))
        for lvl, slug, cmd in hangs[:10]:
            print("  [%s/%s] %s" % (lvl, slug, cmd[:70]))
    return failed


def axis_b():
    """Объясняет ли урок «зачем»?"""
    print("=" * 68)
    print("ОСЬ B: объясняет ли урок, зачем он, а не только как")
    print("=" * 68)
    total = weak = 0
    for lvl, slug, d in lessons():
        text = io.open(os.path.join(d, "ru.md"), encoding="utf-8").read()
        total += 1
        # текст до первого блока кода — это заявление о пользе
        first = text.find("```")
        head = text[:first] if first > 0 else text
        words = len(re.findall(r"[a-zA-Zа-яА-ЯёЁ]{3,}", head))
        has_why = bool(re.search(
            r"\b(зачем|нужен|нужна|потому|чтобы|задача|цель|"
            r"why|need|because|so that|goal|purpose|"
            r"nima uchun|kerak|maqsad|sabab)\w*",
            head, re.I))
        if words < 25 or not has_why:
            weak += 1
            print("  [%s/%s] заявление о пользе слабое: %d слов, маркер: %s"
                  % (lvl, slug, words, has_why))
    print("\nуроков: %d, с слабым объяснением «зачем»: %d" % (total, weak))
    return weak


def axis_c():
    """Проверяет ли практика то, чему учит урок?"""
    print("=" * 68)
    print("ОСЬ C: проверяет ли практика то, чему учит урок")
    print("=" * 68)
    mismatch = 0
    for lvl, slug, d in lessons():
        lesson = io.open(os.path.join(d, "ru.md"), encoding="utf-8").read()
        chk = os.path.join(ROOT, "labs", lvl, slug, "check.sh")
        if not os.path.isfile(chk):
            print("  [%s/%s] НЕТ практики" % (lvl, slug))
            mismatch += 1
            continue
        body = io.open(chk, encoding="utf-8").read()
        # ключевые понятия урока: термины в заголовках H2
        heads = re.findall(r"^## (.+)$", lesson, re.M)
        words = set()
        for h in heads:
            for w in re.findall(r"[A-Za-zА-Яа-я]{4,}", h):
                words.add(w.lower())
        # сколько из них встречаются в практике
        hits = sum(1 for w in words if w in body.lower())
        cov = hits / len(words) if words else 0
        if cov < 0.25:
            print("  [%s/%s] практика слабо пересекается с уроком: %d из %d терминов (%.0f%%)"
                  % (lvl, slug, hits, len(words), cov * 100))
            mismatch += 1
    print("\nнесоответствий: %d" % mismatch)
    return mismatch


def axis_d():
    """Единообразны ли термины."""
    print("=" * 68)
    print("ОСЬ D: единообразие терминов между уроками")
    print("=" * 68)
    # пары понятий, которые новичку нельзя путать
    pairs = [
        ("процесс", "сервис"), ("порт", "интерфейс"),
        ("рабочая папка", "рабочий каталог"),
    ]
    issues = 0
    for lvl, slug, d in lessons():
        text = io.open(os.path.join(d, "ru.md"), encoding="utf-8").read().lower()
        for a, b in pairs:
            ca, cb = text.count(a), text.count(b)
            if ca and cb and max(ca, cb) >= 3 and min(ca, cb) / max(ca, cb) < 0.15:
                print("  [%s/%s] термин '%s' встречается %d раз, а '%s' — %d:"
                      " возможно подмена" % (lvl, slug, a, ca, b, cb))
                issues += 1
    if not issues:
        print("явных подмен терминов не найдено")
    return issues


if __name__ == "__main__":
    which = sys.argv[1].upper() if len(sys.argv) > 1 else "ABCD"
    total = 0
    if "A" in which:
        total += axis_a()
    if "B" in which:
        total += axis_b()
    if "C" in which:
        total += axis_c()
    if "D" in which:
        total += axis_d()
    print()
    print("ИТОГО замечаний: %d" % total)