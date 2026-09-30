#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Проверка board.py на настоящих и враждебных входах."""
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "tools"))
import board  # noqa: E402

MARK = "<!-- hs:lesson=01-terminal;track=level-0;pass=8;total=8;lang=ru;user=Ann;ts=2026-09-30T10:00:00Z -->"

CASES = [
    ("нормальный маркер", MARK,
     dict(lesson="01-terminal", pass_=8)),
    ("маркер с переводом строк", "начало\n" + MARK + "\nсередина",
     dict(lesson="01-terminal", pass_=8)),
    ("лишние пробелы", "<!--  hs:lesson=02-files-and-permissions;pass=7;total=7;user=Bob  -->",
     dict(lesson="02-files-and-permissions", pass_=7)),
    ("обычный комментарий человека", "Отлично, я всё прошёл!",
     None),
    ("пустой комментарий", "", None),
    ("маркер без pass", "<!-- hs:lesson=01-terminal;user=Eve -->", None),
    ("подделка: pass больше total", "<!-- hs:lesson=01-terminal;pass=99;total=8;user=Mallory -->",
     None),
    ("подделка: total ноль", "<!-- hs:lesson=01-terminal;pass=0;total=0;user=Mallory -->",
     None),
    ("не число", "<!-- hs:lesson=01-terminal;pass=abc;total=8;user=Mallory -->", None),
    ("чужой HTML-комментарий", "<!-- nothing to see -->", None),
]

print("%-38s %s" % ("случай", "результат"))
print("-" * 62)
bad = 0
for name, body, expect in CASES:
    rec = board.parse_marker(body)
    if expect is None:
        ok = rec is None
        got = "отклонено" if rec is None else "ПРИНЯТО: %s" % rec
    else:
        ok = (rec is not None and rec["lesson"] == expect["lesson"]
              and rec["pass"] == expect["pass_"])
        got = "принято %s %d/%s" % (rec["lesson"], rec["pass"], rec["total"]) if rec else "отклонено"
    if not ok:
        bad += 1
    print("%-38s %s  %s" % (name, got, "OK" if ok else "СБОЙ"))

print()
print("сбоев: %d" % bad)
sys.exit(1 if bad else 0)
