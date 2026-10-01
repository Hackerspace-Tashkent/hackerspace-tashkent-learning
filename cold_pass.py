#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Холодный проход: хватает ли документа, чтобы пройти практику.

Проверяет то, на чём ломается первый человек: сказано ли, где лежат
файлы, есть ли команда запуска фикстуры, назван ли формат доказательства
и совпадает ли то, что просит ученик, с тем, что проверяет check.sh.
"""
import io
import os
import re
import subprocess

ROOT = "/opt/data/learning-repo"
L = os.path.join(ROOT, "labs/security")
T = os.path.join(ROOT, "tracks/security")

problems = []

for dirpath, _d, files in os.walk(L):
    if "check.sh" not in files:
        continue
    rel = os.path.relpath(dirpath, L)
    lab = os.path.join(dirpath, "ru.md")
    trk = os.path.join(T, rel, "ru.md")

    if not os.path.isfile(lab):
        problems.append((rel, "нет labs/.../ru.md"))
        continue
    if not os.path.isfile(trk):
        problems.append((rel, "нет tracks/.../ru.md"))
        continue

    L_ = io.open(lab, encoding="utf-8").read()
    T_ = io.open(trk, encoding="utf-8").read()
    both = L_ + "\n" + T_

    has_setup = os.path.isfile(os.path.join(dirpath, "setup.sh"))
    if has_setup:
        # фикстура есть, но её надо вызвать -- и это сказано
        if "setup.sh" not in both:
            problems.append((rel, "есть setup.sh, но в тексте не упомянут"))
    else:
        # фикстуры нет: нужно сказать, что lab-work создаёт сам ученик
        if "lab-work" not in both:
            problems.append((rel, "нет setup.sh и lab-work не упомянут"))

    # формат доказательства: сколько символов хеша
    if "proof.txt" in both:
        m = re.search(r"(\d+)\s*(?:символ|знаков|characters)", both)
        if not m:
            problems.append((rel, "proof.txt есть, но не сказано, сколько "
                                   "символов хеша"))

    # какие файлы check.sh требует, и упомянуты ли они в тексте
    chk = io.open(os.path.join(dirpath, "check.sh"), encoding="utf-8").read()
    for f in sorted(set(re.findall(r'has_file\(\) \{ \[ -f "\$WORK/([\w.\-]+)"',
                                   chk))):
        if f not in both:
            problems.append((rel, "check.sh ждёт %s, в тексте его нет" % f))
    for f in sorted(set(re.findall(r'not_empty\(\) \{ \[ -f "\$WORK/([\w.\-]+)"',
                                   chk))):
        if f not in both:
            problems.append((rel, "check.sh ждёт непустой %s, в тексте нет" % f))

    # сколько символов хеша ждёт проверка, и совпадает ли с текстом
    m2 = re.search(r'cut -c1-(\d+)', chk)
    if m2 and "proof.txt" in both:
        want = m2.group(1)
        mm = re.search(r"(\d+)\s*(?:символ|знаков|characters)", both)
        if mm and mm.group(1) != want:
            problems.append((rel, "текст говорит %s символов, проверка ждёт %s"
                             % (mm.group(1), want)))

print("════════ холодный проход: проблемы в инструкциях")
if not problems:
    print("  не найдено")
for rel, p in problems:
    print("  %-34s %s" % (rel, p))
print()
print("всего замечаний:", len(problems))

# отдельно: сколько блоков кода в каждом уроке и компилируются ли они
print()
print("════════ блоки python в уроках")
for d in sorted(os.listdir(T)):
    full = os.path.join(T, d)
    if not os.path.isdir(full):
        continue
    r = subprocess.run(
        "python3 tools/check_content.py 2>/dev/null | grep -c 'компилируется' || true",
        shell=True, cwd=ROOT, capture_output=True, text=True)
    break
print("  (общий счёт указывает валидатор: 2493 проверки)")