#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_gh.py — одноразовый генератор материалов по GitHub Actions и Pages.

Как и раньше: кодовые примеры общие для всех языков, текст переводится.
В репозиторий генератор не попадает.
"""
import os
import re

ROOT = os.path.dirname(os.path.abspath(__file__))

LANGS = ["en", "ru", "uz-lat", "uz-cyr"]
EXT = {"en": "en.md", "ru": "ru.md", "uz-lat": "uz-lat.md", "uz-cyr": "uz-cyr.md"}
# полное имя языка → суффикс ключа в словарях
FULL = {"en": "en", "ru": "ru", "uz-lat": "uz_lat", "uz-cyr": "uz_cyr"}

# Защищаем от перевода: код, команды, пути, URL, имена файлов.
CODE_RE = re.compile(
    r"(```.*?```|`[^`\n]+`|https?://\S+|\$\{?[A-Za-z_][A-Za-z0-9_]*\}?|"
    r"\bgh\s+[a-z]+|\bfetch-depth\b|\btrue\b|\bfalse\b)")

GLOSSARY = [
    # (латиница, uz-lat, uz-cyr)
    ("workflow", "workflow", "workflow"),
    ("workflows", "workflow'lar", "workflow'лар"),
    ("runner", "runner", "runner"),
    ("job", "job", "job"),
    ("step", "qadam", "қадам"),
    ("artifact", "artifact", "artifact"),
    ("badge", "nishon", "нишон"),
    ("deployment", "deploy", "deploy"),
    ("repository", "repository", "repository"),
    ("repositories", "repository'lar", "repository'лар"),
    ("commit", "commit", "commit"),
    ("branch", "branch", "branch"),
    ("matrix", "matrix", "matrix"),
    ("cache", "kesh", "кеш"),
    ("secret", "maxfiy", "махфий"),
    ("secrets", "maxfiylar", "махфийлар"),
    ("token", "token", "token"),
    ("trigger", "trigger", "trigger"),
    ("environment", "muhit", "муҳит"),
    ("script", "skript", "скрипт"),
    ("scripts", "skriptlar", "скриптлар"),
    ("check", "tekshiruv", "текширув"),
    ("checks", "tekshiruvlar", "текширувлар"),
    ("public", "ommaviy", "оммавий"),
    ("private", "maxfiy", "махфий"),
    ("static", "statik", "статик"),
    ("status", "holat", "ҳолат"),
    ("log", "log", "log"),
    ("logs", "loglar", "логлар"),
    ("file", "fayl", "файл"),
    ("files", "fayllar", "файллар"),
    ("page", "sahifa", "саҳифа"),
    ("pages", "sahifalar", "саҳифалар"),
    ("site", "sayt", "сайт"),
    ("directory", "katalog", "каталог"),
    ("content", "kontent", "контент"),
    ("source", "manba", "манба"),
    ("release", "nazorat", "назорат"),
    ("version", "versiya", "версия"),
    ("default", "asosiy", "асосий"),
    ("settings", "sozlamalar", "созламалар"),
    ("limit", "chegara", "чегара"),
    ("result", "natija", "натижа"),
    ("code", "kod", "код"),
    ("time", "vaqt", "вақт"),
    ("free", "bepul", "бепул"),
    ("minutes", "daqiqa", "дақиқа"),
    ("hours", "soat", "соат"),
    ("days", "kun", "кун"),
]

COMBINATIONS = [
    ("oʻ", "oʻ", "ў"), ("gʻ", "gʻ", "ғ"),
    ("yoʻ", "yoʻ", "ё"), ("ts", "ts", "ц"),
    ("sh", "sh", "ш"), ("ch", "ch", "ч"),
]


def protect(text):
    """Разбивает текст на защищённые и открытые части."""
    parts, last, out = [], 0, []
    for m in CODE_RE.finditer(text):
        if m.start() > last:
            out.append((False, text[last:m.start()]))
        out.append((True, m.group(0)))
        last = m.end()
    if last < len(text):
        out.append((False, text[last:]))
    return out


def translit_word(w, to_lang):
    low = w.lower()
    for src, lat, cyr in GLOSSARY:
        if low == src:
            cap = w[0].isupper()
            out = lat if to_lang == "uz-lat" else cyr
            return out[0].upper() + out[1:] if cap and out else out
    for src, lat, cyr in COMBINATIONS:
        if src in low:
            out = lat if to_lang == "uz-lat" else cyr
            idx = low.index(src)
            pre, post = w[:idx], w[idx + len(src):]
            if to_lang == "uz-cyr":
                pre = "ў" if src == "oʻ" else pre
            if to_lang == "uz-cyr" and src == "yoʻ":
                pre = w[:idx] + "ё"
                post = post
            return pre + out + post
    if to_lang == "uz-cyr":
        m = re.match(r"^([a-zA-Z]*)(o|g)(ʻ?)", w)
        if m and m.group(3) == "ʻ":
            letter = {"o": "ў", "g": "ғ"}[m.group(2)]
            return m.group(1) + letter + "ʻ" + w[m.end():]
    return w


def translate(text, to_lang):
    if to_lang == "en":
        return text
    words = text.split(" ")
    out = []
    for w in words:
        if CODE_RE.fullmatch(w):
            out.append(w)
            continue
        core = w
        prefix = suffix = ""
        m = re.match(r"^([^\wʻ]*)(.*?)([^\wʻ]*)$", w, re.S)
        if m:
            prefix, core, suffix = m.group(1), m.group(2), m.group(3)
        if not core:
            out.append(w)
            continue
        out.append(prefix + translit_word(core, to_lang) + suffix)
    return " ".join(out)


def render(blocks):
    """Собирает markdown-страницу на четырёх языках из общих блоков."""
    pages = {lang: [] for lang in LANGS}

    def emit(key, template, text=None):
        for lang in LANGS:
            val = None
            if isinstance(key, dict):
                for full, sub in FULL.items():
                    if full in key and isinstance(key[full], dict):
                        val = key[full].get(sub)
                    if val is not None:
                        break
            if val is None:
                raise KeyError("нет перевода %r" % (key,))
            for is_code, chunk in protect(val):
                pages[lang].append(chunk if is_code else template(
                    chunk, lang))
            pages[lang].append("\n\n")

    for b in blocks:
        kind = b["t"]

        if kind == "code":
            for lang in LANGS:
                pages[lang].append("```%s\n%s\n```\n\n" % (b.get("lang", "bash"), b["c"]))
            continue

        if kind == "quote":
            emit(b["x"], lambda t, l: "> " + t)
            continue

        if kind == "note":
            emit(b["x"], lambda t, l: "> **Заметка.** " + t if l == "ru" else
                 ("> **Note.** " + t if l == "en" else
                  ("> **Izoh.** " + t if l == "uz-lat" else "> **Изоҳ.** " + t)))
            continue

        if kind == "h1":
            emit(b["x"], lambda t, l: "# " + t); continue
        if kind == "h2":
            emit(b["x"], lambda t, l: "## " + t); continue
        if kind == "h3":
            emit(b["x"], lambda t, l: "### " + t); continue

        if kind == "p":
            emit(b["x"], lambda t, l: t); continue

        if kind == "li":
            emit(b["x"], lambda t, l: "- " + t); continue

        if kind == "numbered":
            for lang in LANGS:
                for i, item in enumerate(b["x"][FULL[lang]], 1):
                    for is_code, chunk in protect(item):
                        pages[lang].append(chunk if is_code else (
                            ("%d. " % i) + chunk if is_code is False and i == 1 else chunk))
                    pages[lang].append("\n")
                pages[lang].append("\n")
            continue

        if kind == "table":
            for lang in LANGS:
                cols = b["x"][FULL[lang]]
                pages[lang].append("| " + " | ".join(cols[0]) + " |\n")
                pages[lang].append("|" + "|".join(["---"] * len(cols[0])) + "|\n")
                for row in cols[1:]:
                    pages[lang].append("| " + " | ".join(row) + " |\n")
                pages[lang].append("\n")
            continue

        raise ValueError("неизвестный блок: %r" % kind)

    return {lang: "".join(pages[lang]).rstrip() + "\n" for lang in LANGS}


def write(path, content, created):
    full = os.path.join(ROOT, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "w", encoding="utf-8") as f:
        f.write(content)
    created.append(path)
