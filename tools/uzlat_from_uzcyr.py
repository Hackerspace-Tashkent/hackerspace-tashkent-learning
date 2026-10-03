#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""uz-lat через транслитерацию из uz-cyr — не из головы.

Причина: я пишу «узбекскую латиницу» кириллическими гласными:
`qиладиган`, `sуровга`. Это не опечатка, а привычка. Три раза подряд
uz-lat выходил кириллицей и валидатор это ловил.

Корректная uz-cyr версия уже есть и написана хорошо. Из неё uz-lat
получается однозначно: правило перевода букв фиксировано.

Скрипт трогает ТОЛЬКО файлы, которые ввалидатор уже пометил, чтобы не
испортить те uz-lat, где латиница настоящая.
"""
import io
import re
import os
import sys

# Узбекская кириллица -> латиница. Порядок важен: двубуквенные сперва.
MAP = [
    ("ё", "yo"), ("Ё", "Yo"),
    ("ў", "oʻ"), ("Ў", "Oʻ"),
    ("ғ", "gʻ"), ("Ғ", "Gʻ"),
    ("қ", "q"), ("Қ", "Q"),
    ("ҳ", "h"), ("Ҳ", "H"),
    ("ҷ", "j"), ("Ҷ", "J"),
    ("ц", "ts"), ("Ц", "Ts"),
    ("ч", "ch"), ("Ч", "Ch"),
    ("ш", "sh"), ("Ш", "Sh"),
    ("щ", "shch"), ("Щ", "Shch"),
    ("ю", "yu"), ("Ю", "Yu"),
    ("я", "ya"), ("Я", "Ya"),
    ("ы", "y"), ("Ы", "Y"),
    ("э", "e"), ("Э", "E"),
    ("ъ", "ʼ"), ("ь", "ʼ"),
    ("а", "a"), ("А", "A"),
    ("б", "b"), ("Б", "B"),
    ("в", "v"), ("В", "V"),
    ("г", "g"), ("Г", "G"),
    ("д", "d"), ("Д", "D"),
    ("е", "e"), ("Е", "E"),
    ("ж", "j"), ("Ж", "J"),
    ("з", "z"), ("З", "Z"),
    ("и", "i"), ("И", "I"),
    ("й", "y"), ("Й", "Y"),
    ("к", "k"), ("К", "K"),
    ("л", "l"), ("Л", "L"),
    ("м", "m"), ("М", "M"),
    ("н", "n"), ("Н", "N"),
    ("о", "o"), ("О", "O"),
    ("п", "p"), ("П", "P"),
    ("р", "r"), ("Р", "R"),
    ("с", "s"), ("С", "S"),
    ("т", "t"), ("Т", "T"),
    ("у", "u"), ("У", "U"),
    ("ф", "f"), ("Ф", "F"),
    ("х", "x"), ("Х", "X"),
]

PROTECT = "`"          # содержимое кодовых блоков не трогаем


def split_comment(line):
    """Делит строку на (код, комментарий) по первому # вне кавычек."""
    q = None
    for i, ch in enumerate(line):
        if q:
            if ch == q:
                q = None
        elif ch in "\"'":
            q = ch
        elif ch == "#":
            return line[:i], line[i:]
    return line, ""


def translit_code_line(line):
    """Переводит комментарий и докстроку, код оставляет как есть."""
    code, comment = split_comment(line)
    comment = "".join(dict(MAP).get(c, c) for c in comment)

    stripped = code.strip()
    if stripped.startswith('"""') or stripped.startswith("'''"):
        # целиком докстрока -- переводим всё
        return "".join(dict(MAP).get(c, c) for c in code)

    # плейсхолдеры вида <қиймат> -- тоже проза, а не код
    code = re.sub(r"<[^<>]*>",
                  lambda m: "".join(dict(MAP).get(c, c) for c in m.group(0)),
                  code)
    return code + comment


def translit(text):
    out = []
    in_code = False
    for line in text.split("\n"):
        if line.startswith("```"):
            in_code = not in_code
            out.append(line)
            continue
        if in_code:
            out.append(translit_code_line(line))
            continue
        buf = []
        for ch in line:
            for a, b in MAP:
                if ch == a:
                    buf.append(b)
                    break
            else:
                buf.append(ch)
        out.append("".join(buf))
    return "\n".join(out)


def cyr_count(s):
    return sum(1 for c in s if "Ѐ" <= c <= "ӿ")


def main(targets):
    for path in targets:
        dirn, name = os.path.split(path)
        stem = name.replace("uz-lat", "uz-cyr")
        src = os.path.join(dirn, stem)
        if not os.path.isfile(src):
            print("!! нет uz-cyr рядом:", path)
            continue
        before = io.open(path, encoding="utf-8").read()
        s = io.open(src, encoding="utf-8").read()
        new = translit(s)
        if cyr_count(new) > 0:
            print("!! после перевода осталась кириллица:", path,
                  cyr_count(new))
            continue
        io.open(path, "w", encoding="utf-8").write(new)
        print("%-52s кириллица %d → 0"
              % (os.path.relpath(path, "/opt/data/learning-repo"),
                 cyr_count(before)))


if __name__ == "__main__":
    main(sys.argv[1:])