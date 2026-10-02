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

`wc` hisoblaydi: `wc -l` — satrlar, `wc -w` — so'zlar, `wc -c` — belgilar.
`less` uzun natijani sahifama-sahifa ko'rsatadi, `q` — chiqish.

`wc -l` ishlatilgan qator fayldagi satrlar sonini sanaydi.

```bash
find ~ -name '*.txt' 2>/dev/null
grep -r 'TODO' ~ 2>/dev/null | head
```

> **Izoh.** Yo'lni to'ldirish uchun Tab bosing. Ko'p yozishni tejaydi.
