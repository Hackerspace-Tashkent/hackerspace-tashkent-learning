# 5-dars. Bash skriptlari

Buyruqlarni qo'lda ishga tushirdingiz. Skript buyruqlar ketma-ketligini saqlaydi, shunda qayta yozmasdan yana ishga tushirasiz.

```bash
#!/usr/bin/env bash
# Описание: что делает скрипт
echo "Hello from a script"
```

## O'zgaruvchilar

O'zgaruvchi — qiymat uchun nom. Tiplar yo'q, qo'shtirnoqlar esa qiymat bitta bo'lak qoladimi yoki so'zlarga bo'linadimi.

```bash
name="Tashkent"
count=3
file="my notes.txt"

echo "$name"      # Tashkent
echo $name        # то же самое, но кавычки безопаснее
echo "$file"      # my notes.txt — один аргумент
echo $file        # my и notes.txt — два аргумента
```

> **Izoh.** O'zgaruvchilarni har doim qo'shtirnoq ichida oling: "$var". Aks holda bo'shliqlarda bo'linadi.

## Shartlar

```bash
if [ -f /etc/hostname ]; then
  echo "file exists"
elif [ -d /etc ]; then
  echo "directory exists"
else
  echo "neither"
fi
```

- `-f` fayl mavjud
- `-d` katalog mavjud
- `-e` umuman mavjud
- `-s` fayl bo'sh emas
- `-z` qator bo'sh
- `-n` qator bo'sh emas
- `=` qatorlar teng
- `-gt` `-lt` katta / kichik

## Tsikllar

```bash
for f in *.txt; do
  echo "found: $f"
done

n=0
while [ "$n" -lt 3 ]; do
  echo "round $n"
  n=$((n + 1))
done
```

## Funksiyalar va argumentlar

Skript argumentlarni `$1`, `$2` va hokozilarda oladi. `$#` — soni, `"$@"` — hammasi, `shift` — birinchisini olib tashlaydi.

```bash
#!/usr/bin/env bash
if [ "$#" -lt 1 ]; then
  echo "usage: $0 <name> [age]" >&2
  exit 1
fi

name="$1"
age="${2:-unknown}"

echo "name=$name"
echo "age=$age"
```

## Чиқим кодлари

Ҳар бир буйруқ рақам билан тугайди: 0 — муваффақият, бошқаси — хато. `$?` охирги буйруқ кодини сақлайди.

```bash
set -e   # остановиться при первой ошибке
set -u   # считать ошибкой неопределённую переменную
set -o pipefail   # ошибка в пайпе, если кто-то в нём упал
```

> **Izoh.** `set -e` ning o'tkir burchaklari bor: `if` ichida, manfiy shartda va quvurning oxirgi buyrug'idan tashqarida ishlamaydi.
