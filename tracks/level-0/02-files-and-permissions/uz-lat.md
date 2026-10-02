# 2-dars. Fayllar va ruxsatlar

Linuxda dasturlar va hujjatlar uchun alohida papkalar yo'q. Hammasi fayl, va har bir faylda ruxsat bor.

## Ruxsatlarni o'qish

`ls -l` egasi, guruhini va uchta ruxsat guruhini ko'rsatadi: `rwx` — egasi, guruh, boshqalar. `r` — o'qish, `w` — yozish, `x` — bajarish.

```bash
ls -l
-rw-r--r--  1 user user  2048 Sep 30 10:00 notes.txt
```

## Ruxsatlarni o'zgartirish

`chmod` ruxsatlarni o'zgartiradi. Raqamlarni yotirish oson: 4 — o'qish, 2 — yozish, 1 — bajarish.

```bash
chmod 644 notes.txt   # rw-r--r-- : oddiy fayl
chmod 755 script.sh  # rwxr-xr-x : skript
chmod +x script.sh   # shunchaki bajariladigan qilish
```

`chown` egasini o'zgartiradi. O'z fayllaringiz guruhini `chgrp` bilan o'zgartirasiz.

```bash
chgrp developers notes.txt
```

## Arxivlar

```bash
tar -czf backup.tar.gz my-project/
tar -tzf backup.tar.gz
tar -xzf backup.tar.gz
```

## Oddiy muharrir

`nano` — terminaldagi matn muharriri. Ctrl+O saqlaydi, Ctrl+X chiqadi.

```bash
nano notes.txt
```

## Skript nima

Skript — bu oddiy matn fayli, ichida buyruqlar. `.sh` kengaytmasi
o'z-o'zidan hech nima qilmaydi: Linux birinchi qatorga qaraydi.

```bash
#!/bin/bash
echo " Salom, bu mening birinchi skriptim"
```

Birinchi qator **shebang** deyiladi. U tizimga qaysi interpretatorni
ishga tushirish kerakligini aytadi. U o'zi bajarilmaydi — bu yo'nalish.

`hello.sh` yarat, ichiga shu ikki qatorni yoz, keyin:

```bash
chmod +x hello.sh
./hello.sh
```

`chmod +x` bo'lmasa «Permission denied» chiqadi: tizim faylni ishga
tushirish mumkin bo'lgan dastur deb hisoblamaydi.

> **Izoh.** Skriptni to'g'ridan-to'g'ri ishga tushirish uchun bajarish ruxsati kerak: `chmod +x script.sh`.
