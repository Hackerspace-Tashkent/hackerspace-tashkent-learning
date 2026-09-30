#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
lab_timing.py — прогон всех лабораторных с замером времени.

Нужен не для красоты, а потому что мы не знаем двух вещей:
  1. сколько реально занимает один урок;
  2. не сломалась ли лабораторная после правок.

Делает изолированную копию каждой практики в чистом временном каталоге,
запускает check.sh, засекает время и печатает таблицу. Файлы ученика не
трогает — всё происходит во временной папке.

Запуск:
    python3 tools/lab_timing.py            # таблица
    python3 tools/lab_timing.py --markdown # для вставки в отчёт
"""
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
COUNT_RE = re.compile(r"(\d+)\s*/\s*(\d+)")


def labs():
    out = []
    base = os.path.join(ROOT, "labs")
    for level in sorted(os.listdir(base)):
        ldir = os.path.join(base, level)
        if not os.path.isdir(ldir):
            continue
        for name in sorted(os.listdir(ldir)):
            chk = os.path.join(ldir, name, "check.sh")
            if os.path.isfile(chk):
                out.append((level, name, chk))
    return out


def run_one(level, name, chk):
    """Копирует практику в чистое место и запускает проверку на пустом ученике."""
    tmp = tempfile.mkdtemp(prefix="lab-%s-" % name)
    try:
        src_dir = os.path.dirname(chk)
        dst_dir = os.path.join(tmp, "lab")
        shutil.copytree(src_dir, dst_dir,
                        ignore=shutil.ignore_patterns(
                            "lab-work", ".git", "*.pyc", "__pycache__"))
        local_chk = os.path.join(dst_dir, "check.sh")

        env = dict(os.environ)
        env["LAB_LANG"] = env.get("LAB_LANG", "ru")
        env["HOME"] = tmp                    # чтобы ничего не тянулось из дома
        env["CHECK_LANG"] = env.get("CHECK_LANG", "ru")

        t0 = time.time()
        proc = subprocess.run(["bash", local_chk], cwd=dst_dir,
                              capture_output=True, text=True, timeout=600,
                              env=env)
        elapsed = time.time() - t0

        out = proc.stdout + proc.stderr
        m = COUNT_RE.search(out)
        got = int(m.group(1)) if m else -1
        total = int(m.group(2)) if m else -1

        # Пустое состояние обязано падать: иначе проверка ничего не проверяет.
        empty_ok = (proc.returncode != 0) and got == 0 and total > 0
        return {
            "level": level, "lab": name,
            "seconds": round(elapsed, 2),
            "passed": got, "total": total,
            "rc": proc.returncode,
            "empty_rejected": empty_ok,
            "tail": out.strip().split("\n")[-1] if out.strip() else "",
        }
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def main():
    results = [run_one(l, n, c) for l, n, c in labs()]
    as_md = "--markdown" in sys.argv

    total_time = sum(r["seconds"] for r in results)
    total_checks = sum(r["total"] for r in results if r["total"] > 0)
    bad = [r for r in results if not r["empty_rejected"]]

    if as_md:
        print("| Практика | Проверок | Пустое отвергнуто | Секунд |")
        print("|---|---|---|---|")
        for r in results:
            print("| %s/%s | %d | %s | %.1f |"
                  % (r["level"], r["lab"], r["total"],
                     "да" if r["empty_rejected"] else "**НЕТ**", r["seconds"]))
        print("| **всего** | **%d** | | **%.1f** |" % (total_checks, total_time))
        return 0

    print("=" * 74)
    print("ПРОГОН ЛАБОРАТОРНЫХ — замер и проверка, что пустое состояние отвергается")
    print("=" * 74)
    print("  %-28s %8s %10s %9s" % ("практика", "проверок", "отвергнуто", "секунд"))
    print("  " + "-" * 70)
    for r in results:
        print("  %-28s %8s %10s %9.1f"
              % (r["level"] + "/" + r["lab"],
                 "%d" % r["total"],
                 "да" if r["empty_rejected"] else "НЕТ!",
                 r["seconds"]))
    print("  " + "-" * 70)
    print("  %-28s %8d %10s %9.1f"
          % ("ИТОГО", total_checks,
             "%d/%d" % (len(results) - len(bad), len(results)), total_time))
    print("=" * 74)
    if bad:
        print("\n  ПРОБЛЕМА: пустое состояние прошло проверку —")
        print("  такая практика ничего не проверяет:")
        for r in bad:
            print("    %s/%s  rc=%d  %s"
                  % (r["level"], r["lab"], r["rc"], r["tail"][:60]))
        return 1
    print("\n  все практики отвергают пустое состояние.")
    print("  ВНИМАНИЕ: это проверка СКРИПТОВ, а не понятности материала.")
    print("  Понятность проверяется живым человеком, которого ещё не было.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
