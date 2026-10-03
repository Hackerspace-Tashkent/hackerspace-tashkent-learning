#!/usr/bin/env bash
# Фикстура S1-04: служебный файл, который не должен попасть в вывод.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="$HERE/lab-work"
rm -rf "$WORK"
mkdir -p "$WORK"

cat > "$WORK/flag.txt" <<'TXT'
flag{ne_privet_iz_komandy}
TXT

cat > "$WORK/hosts.txt" <<'TXT'
127.0.0.1 localhost
127.0.0.1 shakerspace-check
TXT

echo
echo "Что дальше: прочитай урок и напиши srv.py."
