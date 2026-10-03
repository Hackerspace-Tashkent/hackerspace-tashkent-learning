#!/usr/bin/env bash
# Фикстура S1-03: публичная папка и служебный файл, который наружу
# отдавать нельзя.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="$HERE/lab-work"
rm -rf "$WORK"
mkdir -p "$WORK/public"

cat > "$WORK/public/index.html" <<'HTML'
<!doctype html>
<html lang="ru">
<head><meta charset="utf-8"><title>Файлы</title></head>
<body><h1>Доступные файлы</h1></body>
</html>
HTML

cat > "$WORK/public/notes.txt" <<'TXT'
Заметка из публичной папки. Её отдавать положено.
TXT

# Этот файл лежит РЯДОМ с public, но не внутри. Отдавать его нельзя.
cat > "$WORK/secret.txt" <<'TXT'
Служебный файл. Он не должен уходить наружу.
TXT

echo
echo "Что дальше: прочитай урок и напиши srv.py."
