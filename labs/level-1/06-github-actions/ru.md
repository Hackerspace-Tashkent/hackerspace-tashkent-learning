# Практика: GitHub Actions

## Что делать

Всё в `lab-work/` рядом с этим файлом. Папки нет — создай.

```bash
cd "$(dirname check.sh)"
mkdir -p lab-work/.github/workflows
cd lab-work
```

### 1. Свой workflow

Создай `.github/workflows/ci.yml`:

```yaml
name: Мои проверки

on:
  push:
  pull_request:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Забрать код
        uses: actions/checkout@v4

      - name: Синтаксис скриптов
        run: bash -n labs/*/*/check.sh

      - name: Проверка материалов
        run: python3 tools/check_content.py
```

Скопируй отсюда и правь под себя. Это тот же пример, что в уроке.

### 2. Что проверить в первую очередь

Порядок полезности:

1. `bash -n` — только синтаксис, ничего не выполняет;
2. `tools/check_content.py` — ссылки и языки;
3. пробный запуск практик на пустом состоянии.

### 3. Запустить

```bash
git init -q -b main
git remote add origin https://github.com/твой-логин/твой-репозиторий.git
git add .
git commit -m "Add a workflow that checks things"
git push -u origin main
```

Через минуту открой вкладку **Actions** в репозитории. Прогон либо зелёный,
либо красный с указанием шага.

Если красный — читай лог этого шага, а не гадай.

### 4. Записать

`NOTES.md` — что понял, что удивило, где споткнулся. Три строки достаточно.

## Проверка

```bash
./check.sh
```

Девять локальных проверок и, если есть `gh`, десятая — онлайновая.

## Осторожно

Скрипт в workflow выполняется на чужой машине с доступом к репозиторию.
Секреты — только через `secrets`. Никогда не клади токен прямо в YAML.
