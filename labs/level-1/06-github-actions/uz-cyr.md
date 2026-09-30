# Лаборатория: GitHub Actions

## Нима қилиш керак

Ҳамма нарса шу файл ёнидаги `lab-work/` да. Папка йўқ — яратинг.

```bash
cd "$(dirname check.sh)"
mkdir -p lab-work/.github/workflows
cd lab-work
```

### 1. Ўз workflow-ингиз

`.github/workflows/ci.yml` яратинг:

```yaml
name: Менинг текширувларим

on:
  push:
  pull_request:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Кодни олиш
        uses: actions/checkout@v4

      - name: Скрипт синтаксиси
        run: bash -n labs/*/*/check.sh

      - name: Материалларни текшириш
        run: python3 tools/check_content.py
```

Бу ердан кўчириб, ўзингизча тўғриланг. Бу дарсдаги билан бир хил мисол.

### 2. Аввал нима текшириш

Фойдалилик бўйича:

1. `bash -n` — фақат синтаксис, ҳеч нарса бажарилмайди;
2. `tools/check_content.py` — ҳаволалар ва тиллар;
3. лабораторияларни бўш ҳолатда синовдан ўтказиш.

### 3. Ishga tushirish

```bash
git init -q -b main
git remote add origin https://github.com/сизнинг-логин/сизнинг-repo.git
git add .
git commit -m "Add a workflow that checks things"
git push -u origin main
```

Бир дақиқадан кейин репозиторияда **Actions** ўйини очинг. Иш яшил,
ёки қизил ва қайси қадамда тушганини кўрсатади.

Қизил бўлса — ўша қадам логини ўқинг, тахмин қилманг.

### 4. Ёзиш

`NOTES.md` — нимани тушундингиз, нима ҳайрат қилди, қаерда тўхтадингиз.
Уч қатор етчи.

## Текширув

```bash
./check.sh
```

Тўққизта маҳаллий текширув ва, агар `gh` бўлса, ўнинчи онлайн текширув.

## Эҳтиёт бўлинг

Workflow ичидаги скрипт бошқанинг машинасида, репозиторийга кириш
ҳуқуқи билан ишлайди. Махфий маълумотлар — фақат `secrets` орқали. Токенни
ҳеч қачон тўғридан-тўғри YAMLга ёзманг.
