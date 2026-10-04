#!/usr/bin/env bash
# Фикстура S2-01: страница-обманщик и состояние пользователя.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="$HERE/lab-work"
rm -rf "$WORK"
mkdir -p "$WORK"

# Страница злоумышленника. Она лежит рядом и откроется из того же
# origin, поэтому cookie уйдёт вместе с запросом -- в этом весь смысл.
cat > "$WORK/evil.html" <<'HTML'
<!doctype html>
<html lang="ru">
<head><meta charset="utf-8"><title>Скидка</title></head>
<body>
<form action="http://127.0.0.1:8111/action" method="post">
  <input type="hidden" name="email" value="attacker@example.com">
  <button>Получить скидку</button>
</form>
</body>
</html>
HTML

cat > "$WORK/state.txt" <<'TXT'
email=you@example.com
TXT

echo
echo "Что дальше: прочитай урок и напиши srv.py."