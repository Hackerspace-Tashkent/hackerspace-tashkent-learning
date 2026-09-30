# 1-dars. Terminal va navigatsiya

Terminal — Linuxdagi asosiy vosita. Bu darslarda degan ko'p narsa shu yerda bajariladi.

Terminalni oching va joriy katalogni ko'ring:

```bash
pwd
```

Ichidagilarni ko'rsating:

```bash
ls
ls -la
```

## Ko'chish

`cd` katalogni o'zgartiradi, `pwd` joriy joyni ko'rsatadi. `~` — uy katalogingiz.

```bash
cd ~
cd /tmp
cd ..
pwd
```

`..` — bir qadam yuqoriga, `.` — joriy katalog.

## Yaratish va o'chirish

```bash
mkdir my-project
cd my-project
touch readme.txt
ls
```

```bash
cp readme.txt readme.backup.txt
mv readme.backup.txt backup.txt
rm backup.txt
```

> **Izoh.** `rm` savolsiz o'chiradi. Bekor qilish yo'q. Ehtiyot bo'ling.

## Fayllarni o'qish

```bash
cat readme.txt
head -5 readme.txt
tail -5 readme.txt
less readme.txt
```

## Zanjirlar va qidiruv

`|` belgisi bitta buyruq natijasini keyingisiga uzatadi.

```bash
ls -la | less
cat readme.txt | wc -l
ls | grep txt
```

`find` fayl nomi bo'yicha, `grep` ichki matn bo'yicha qidiradi.

```bash
find ~ -name '*.txt' 2>/dev/null
grep -r 'TODO' ~ 2>/dev/null | head
```

> **Izoh.** Yo'lni to'ldirish uchun Tab bosing. Ko'p yozishni tejaydi.

## Амалиёт

Codespace'da bajaring, keyin `./check.sh` — nimani qilish kerakligini aytadi.

1. `~/terminal-lab` katalogini yarating.
2. Unga kiring va uchta fayl yarating: `a.txt`, `b.txt`, `c.md`.
3. `a.txt` va `b.txt` ichiga ixtiyoriy matn yozing.
4. `a.txt` ni `backup.txt` ga nusxalang, keyin nusxani `final.txt` ga nomini o'zgartiring.
5. `b.txt` da necha qator borligini hisoblang.

```bash
cd labs/level-0/01-terminal
./check.sh
```
