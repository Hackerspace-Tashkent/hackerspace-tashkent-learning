#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Холодный проход: можно ли пройти практику, читая только документ.

Обычные проверки отвечают на вопрос "работает ли скрипт". Этот
инструмент отвечает на другой: "достаточно ли написано, чтобы дойти
до конца". Три класса дефектов, которые он ловит, а остальные не ловят:

1. ПРЕДПОСЫЛКА. Проверка требует API или файла, которого нет ни в уроке,
   ни в практике. Так было в S0-04: load_cert_chain встречался в check.sh
   ноль раз в материале, и задание было невыполнимо.

2. МЕСТО. Урок не говорит, где создавать файлы. Так было в S0-04: файлы
   создавались в текущей папке, проверка искала в lab-work, результат 0/10.

3. НЕСООТВЕТСТВИЕ. Текст и проверка ждут разного: разное число символов
   хеша, разные имена файлов.

Запуск:  python3 tools/cold_pass.py
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def read(p):
    with open(os.path.join(ROOT, p), encoding="utf-8") as f:
        return f.read()


def walk(top):
    out = []
    for dp, _d, names in os.walk(os.path.join(ROOT, top)):
        for n in names:
            out.append(os.path.relpath(os.path.join(dp, n), ROOT))
    return sorted(out)


def pairs():
    """Все темы: практика + четыре языка урока."""
    out = []
    for chk in walk("labs"):
        if not chk.endswith("check.sh"):
            continue
        topic = os.path.dirname(chk)          # labs/<...>/<topic>
        rel = os.path.split(topic)[1]          # имя темы
        depth = topic.count(os.sep) - 1        # labs/... -> уровень вложенности
        # labs/level-0/01-x            -> tracks/level-0/01-x
        # labs/security/level-0/01-x   -> tracks/security/level-0/01-x
        parts = topic.split(os.sep)
        if parts[1] == "security":
            tdir = "tracks/security/" + parts[2] + "/" + parts[3]
        else:
            tdir = "tracks/" + parts[1] + "/" + parts[2]
        out.append((chk, tdir, rel))
    return out


def code_tokens_from_check(chk_text):
    """Что именно проверка требует найти в коде ученика."""
    toks = set()
    for m in re.finditer(r"grep -q\w*\s+\"([^\"]+)\"\s+\"\$WORK", chk_text):
        t = m.group(1)
        # отбрасываем регулярки-метасимволы, оставляем слово
        for w in re.findall(r"[A-Za-z_][A-Za-z0-9_]{3,}", t):
            toks.add(w)
    for m in re.finditer(r"grep -q\w*\s+'([^']+)'\s+\"\$WORK", chk_text):
        for w in re.findall(r"[A-Za-z_][A-Za-z0-9_]{3,}", m.group(1)):
            toks.add(w)
    return toks


def files_from_check(chk_text):
    out = set()
    for m in re.finditer(r'\[ -f "\$WORK/([\w.\-]+)"', chk_text):
        out.add(m.group(1))
    return out


def hash_len_from_check(chk_text):
    m = re.search(r"cut -c1-(\d+)", chk_text)
    return m.group(1) if m else None


def main():
    problems = []
    total_labs = 0

    for chk, tdir, rel in pairs():
        total_labs += 1
        chk_text = read(chk)
        lab_dir = os.path.dirname(chk)

        lessons = {}
        for lang in ("ru", "en", "uz-lat", "uz-cyr"):
            p = "%s/%s.md" % (tdir, lang)
            if os.path.isfile(os.path.join(ROOT, p)):
                lessons[lang] = read(p)
        labs = {}
        for lang in ("ru", "en", "uz-lat", "uz-cyr"):
            p = "%s/%s.md" % (lab_dir, lang)
            if os.path.isfile(os.path.join(ROOT, p)):
                labs[lang] = read(p)

        if not lessons:
            problems.append((rel, "нет ни одного языка урока: " + tdir))
            continue
        if not labs:
            problems.append((rel, "нет ни одного языка практики"))

        # ---- 1. ПРЕДПОСЫЛКА: токены из check.sh есть в уроке?
        toks = code_tokens_from_check(chk_text)
        for tok in sorted(toks):
            where = [lg for lg, t in lessons.items() if tok in t]
            if not where:
                problems.append((rel, "check требует `%s`, "
                                       "в уроке его нет ни на одном языке" % tok))
            elif "ru" not in where:
                problems.append((rel, "check требует `%s`, "
                                       "в русском уроке нет (есть в %s)"
                                       % (tok, ",".join(where))))

        # ---- 2. МЕСТО: сказано ли про lab-work / setup
        alltext = " ".join(list(lessons.values()) + list(labs.values()))
        has_setup = os.path.isfile(os.path.join(lab_dir, "setup.sh"))
        if has_setup and "setup" not in alltext:
            problems.append((rel, "есть setup.sh, но в тексте не упомянут"))
        if not has_setup and "lab-work" not in alltext:
            problems.append((rel, "нет setup.sh и lab-work не упомянут"))

        # ---- 3. ФАЙЛЫ: каждый требуемый файл назван в тексте
        for f in sorted(files_from_check(chk_text)):
            if f not in alltext:
                problems.append((rel, "check ждёт файл `%s`, "
                                       "в тексте его нет" % f))

        # ---- 4. ХЕШ: сколько символов говорит текст и сколько ждёт check
        want = hash_len_from_check(chk_text)
        if want and "proof.txt" in alltext:
            said = set(re.findall(r"(\d+)\s*(?:символ|знаков|characters|белги)",
                                  alltext))
            if not said:
                problems.append((rel, "proof.txt есть, но не сказано, "
                                       "сколько символов хеша (check ждёт %s)"
                                       % want))
            elif want not in said:
                problems.append((rel, "текст говорит %s, check ждёт %s"
                                       % (sorted(said), want)))

        # ---- 5. ПОРЯДОК: есть ли в уроке команда запуска сервера,
        #          если практика поднимает его вживую
        if "live" in chk_text or "http" in chk_text.lower():
            if not any(k in alltext for k in ("python3", "python ")):
                problems.append((rel, "проверка поднимает сервер, "
                                       "но в тексте нет команды запуска"))

    print("=" * 66)
    print("ХОЛОДНЫЙ ПРОХОД — достаточно ли написано, чтобы дойти до конца")
    print("=" * 66)
    print("тем проверено: %d" % total_labs)
    print()
    if not problems:
        print("  замечаний нет")
    by_topic = {}
    for rel, p in problems:
        by_topic.setdefault(rel, []).append(p)
    for rel in sorted(by_topic):
        for p in by_topic[rel]:
            print("  %-40s %s" % (rel, p))
    print()
    print("всего замечаний: %d" % len(problems))
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())