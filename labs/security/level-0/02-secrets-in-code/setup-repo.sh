#!/usr/bin/env bash
# Создаёт репозиторий-фикстуру lab-work/repo, в истории которого спрятан
# ключ. Ключ выдуман и учеником не выбирается: его нужно найти самому.
set -eu
cd "$(dirname "$0")"
R="$PWD/lab-work/repo"
TMP="$PWD/.fixture"

rm -rf "$R" "$TMP"
mkdir -p "$TMP"
cd "$TMP"
git init -q .
git config user.email "fixture@example.invalid"
git config user.name "Fixture"

# Выдуманное имя сервиса: в интернете такого нет.
SECRET="vt-lark-tessera-5Q2fK"

cat > app.py <<'PY'
#!/usr/bin/env python3
"""Загрузка данных датчика в облако."""

API_TOKEN = "PLACEHOLDER"
API_URL = "https://telemetry.example.invalid/v1/ingest"


def send(payload):
    # настоящий код отправил бы токен в заголовке
    return {"url": API_URL, "token": API_TOKEN, "body": payload}
PY

sed -i "s/PLACEHOLDER/$SECRET/" app.py
printf 'lab-work/repo/\nlab-work/*.log\n' > .gitignore
git add -A && git commit -qm "add sensor uploader"

# Вторая версия: ключ убрали из файла и решили, что дело закрыто.
cat > app.py <<'PY'
#!/usr/bin/env python3
"""Загрузка данных датчика в облако.

Ключ перенесли в переменную окружения.
"""

import os

API_TOKEN = os.environ["TELEMETRY_TOKEN"]
API_URL = "https://telemetry.example.invalid/v1/ingest"


def send(payload):
    return {"url": API_URL, "token": API_TOKEN, "body": payload}
PY

git add -A && git commit -qm "move token to environment variable"

# Репозиторий переносим туда, где его ждёт практика.
cd ..
mkdir -p "$(dirname "$R")"
mv "$TMP" "$R"

echo "Фикстура готова: lab-work/repo"
echo "Найди ключ в истории этого репозитория."