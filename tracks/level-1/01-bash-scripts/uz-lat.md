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

## Chiqim kodlari

Har bir buyruq raqam bilan tugaydi: 0 — muvaffaqiyat, boshqasi — xato. `$?` oxirgi buyruq kodini saqlaydi.

```bash
set -e   # остановиться при первой ошибке
set -u   # считать ошибкой неопределённую переменную
set -o pipefail   # ошибка в пайпе, если кто-то в нём упал
```

> **Izoh.** `set -e` ning o'tkir burchaklari bor: `if` ichida, manfiy shartda va quvurning oxirgi buyrug'idan tashqarida ishlamaydi.

## Amaliyot

1. Bu papka ichida `lab-work` katalogini yarating.
2. `greet.sh` yozing: ismni birinchi argument sifatida oladi va salomlaydi. Argument bo'lmasa, stderr'ga ishlatish ko'rsatmasini chiqarib, 1 bilan chiqadi.
3. Uni bajarishga ruxsat bering va ikkala holatni tekshiring: ism bilan va ismsiz.
4. `count_lines.sh` yozing: faylni oladi va necha qator borligini chiqaradi.
5. `backup.sh` yozing: joriy katalogdagi barcha `.txt` fayllardan `backup-YYYYMMDD-HHMMSS.tar.gz` yaratadi.
6. Ikki marta ishga tushiring va ikkala arxiv ham borligini tekshiring.

```bash
cd labs/level-1/01-bash-scripts
./check.sh
```
