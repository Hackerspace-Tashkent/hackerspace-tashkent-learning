#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
self_test.py — протокол собственного прохода.

Зачем это нужно. Мы прогоняли проверки сами, и это доказало только одно:
скрипты работают. Это НЕ говорит, что материал понятен человеку, который
никогда не открывал терминал. У нас нет ни одного такого измерения.

Этот скрипт проводит один практик за другим, засекает время и спрашивает,
где застрял. Ответы пишутся в отчёт — это и есть данные, которых у нас нет.

Запуск:
    python3 tools/self_test.py            # Level 0
    python3 tools/self_test.py --level 1  # Level 1
"""
import argparse
import io
import os
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Вопросы, которые нужно задавать, а не только фиксировать время.
QUESTIONS = [
    ("Где было непонятно?",
     "Не «было сложно», а конкретно непонятный абзац, команда или слово."),
    ("Что пришлось догадываться?",
     "Места, где ты понял только потому, что знал заранее. Это ловушка для новичка."),
    ("Что можно было убрать без потери смысла?",
     "Лишние абзацы, повторы, команды, которые всё равно не нужны."),
    ("Где ты бросил бы, если бы не знал, что это вообще возможно?",
     "Самое честное место. Именно там нужен другой текст."),
]


def labs(level):
    base = os.path.join(ROOT, "labs", "level-%d" % level)
    if not os.path.isdir(base):
        return []
    out = []
    for name in sorted(os.listdir(base)):
        chk = os.path.join(base, name, "check.sh")
        if os.path.isfile(chk):
            out.append((name, chk))
    return out


def run_level(level):
    items = labs(level)
    print("=" * 70)
    print("ПРОТОКОЛ СОБСТВЕННОГО ПРОХОДА — уровень %d, %d практик" % (level, len(items)))
    print("=" * 70)
    print()
    print("Правила прохода, иначе ничего не измерится:")
    print()
    print("  1. Не открывай check.sh до конца. Он показывает ответы.")
    print("  2. Не смотри в решение, даже если помнишь — это другой путь.")
    print("  3. Первый раз проходи как человек, который никогда не открывал")
    print("     терминал. Записывай, где тебе пришлось остановиться.")
    print("  4. Замеряй время от прочтения урока до зелёной проверки.")
    print()

    report = []
    for name, chk in items:
        d = os.path.dirname(chk)
        lesson = os.path.join(ROOT, "tracks", "level-%d" % level, name, "ru.md")
        print("-" * 70)
        print("ПРАКТИКА: %s" % name)
        print("урок: tracks/level-%d/%s/ru.md" % (level, name))
        print()

        for q, hint in QUESTIONS:
            print("  %s" % q)
            print("      (%s)" % hint)
            print("      > ", end="")
            sys.stdout.flush()
            answer = input()
            report.append({"lab": name, "question": q, "answer": answer})
            print()

        t0 = time.time()
        proc = subprocess.run(["bash", os.path.join(d, "check.sh")],
                              cwd=d, capture_output=True, text=True)
        elapsed = time.time() - t0
        out = proc.stdout + proc.stderr

        # Маркеры в практиках разные: старые печатают [FAIL]/[ok],
        # новые — [ ]/[x]. Неполагаемся на один формат.
        failed, passed = [], 0
        for line in out.split("\n"):
            s = line.strip()
            if s.startswith("[FAIL]") or s.startswith("[ ]"):
                failed.append(s)
            elif s.startswith("[ok]") or s.startswith("[x]"):
                passed += 1
        print("  время проверки: %.1f сек, код выхода %d, прошло %d, не прошло %d"
              % (elapsed, proc.returncode, passed, len(failed)))
        if failed:
            print("  не прошло:")
            for f in failed:
                print("    %s" % f)
        else:
            print("  все проверки прошли")
        report.append({"lab": name, "seconds": round(elapsed, 1),
                       "rc": proc.returncode, "passed": passed,
                       "failed": failed})
        print()

    return report


def save(report):
    out = os.path.join(ROOT, "SELF-TEST.md")
    lines = ["# Результат собственного прохода", "",
             "Заполнено автоматически скриптом `tools/self_test.py`.", "",
             "## Время и результат", "",
             "| Практика | Секунд | Код выхода | Не прошло |",
             "|---|---|---|---|"]
    for r in report:
        if "seconds" in r:
            lines.append("| %s | %s | %s | %d |"
                         % (r["lab"], r["seconds"], r["rc"], len(r["failed"])))
    lines += ["", "## Где застрял", ""]
    cur = None
    for r in report:
        if "question" not in r:
            continue
        if r["lab"] != cur:
            cur = r["lab"]
            lines.append("### %s" % cur)
            lines.append("")
        lines.append("**%s**" % r["question"])
        lines.append("")
        lines.append(r["answer"] if r["answer"].strip() else "_не записано_")
        lines.append("")
    io.open(out, "w", encoding="utf-8").write("\n".join(lines) + "\n")
    print("=" * 70)
    print("Отчёт записан: %s" % os.path.relpath(out, ROOT))
    print("=" * 70)
    print()
    print("Что теперь важно:")
    print()
    print("  Если таблица времени заполнена — у нас впервые есть измерение.")
    print("  Если в «где застрял» больше пустых строк, чем заполненных —")
    print("  проход не состоялся, и это тоже результат.")
    print()
    print("  Главное: не чини текст сам по ходу. Записывай, вернёшься после.")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--level", type=int, default=0)
    args = ap.parse_args()
    report = run_level(args.level)
    if report:
        save(report)
    return 0


if __name__ == "__main__":
    sys.exit(main())