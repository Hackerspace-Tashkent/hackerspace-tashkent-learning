# 6-dars. Avtomatlashtirish va jurnalar

O'zi bajaradigan vazifa — eslab turish kerak bo'lgan vazifadan ancha qimmatli. Bu dars rejimani yoqish va iz qoldirish haqida.

## Chiqim oqimlari

Har bir buyruqning uchta oqimi bor: natija uchun standart chiqim, muammolar uchun xato chiqimi va kirim. `>` fayl yozadi, `>>` qoʻshadi, `2>` xatolarni yoʻnaltiradi.

```bash
ls > out.txt          # faqat stdout, faylni tozalaydi
ls >> out.txt         # oxiriga qoʻshadi
ls 2> err.txt         # faqat stderr
ls > all.txt 2>&1     # ikkalasi bitta faylga
ls 2>&1 | grep txt    # xatolar ham paipga tushadi
```

> **Izoh.** Jurnal — bu fayl, unga qoʻshib borsa, hech qachon tozalanmaydi. `>>` ishlatng va har qatorning boshiga sana qoʻying.

```bash
#!/usr/bin/env bash
log="run.log"
printf '%s started\n' "$(date '+%F %T')" >> "$log"
printf '%s finished with code %d\n' "$(date '+%F %T')" "$?" >> "$log"
```

## cron bilan reja

`cron` belgilangan vaqtda buyruqni ishga tushiradi. Qatorda beshta maydon bor: daqiqa, soat, oy kuni, oy, hafta kuni, so'ng buyruq.

```bash
# daqiqa soat kun oy hafta-kuni  buyruq
*/5 *   *   *     *            /home/me/report.sh
0  9   *   *     1-5          /home/me/backup.sh
30 18  *   *     *            /home/me/clean.sh
```

cron'ga hech qachon pochta yubormaslik. Ikkala oqimni jurnal fayliga yo'naltiring.

```bash
*/10 * * * * /home/me/report.sh >> /home/me/report.log 2>&1
```

## Rejani tahrirlash

```bash
crontab -l     # joriy vazifalarni koʻrsatish
crontab -e     # oʻzgartirish
crontab -r     # hammasini oʻchirish (ehtiyot boʻling)
```

Crontab — bu shunchaki matn fayl, har satrda bitta vazifa. `crontab myfile` uni o'rnatadi, `crontab -l` o'rnatilganini ko'rsatadi. Rejani faylda saqlasangiz — ya'ni `crontab -e` ichida ko'z yopib tahrirlash o'rniga — uni git'da tutib, har qanday mashinaga ko'chirish mumkin.

> **Izoh.** Codespace'da `cron` daemonsi ishlamaydi, shuning uchun o'rnatilgan vazifalar o'z-o'zidan ishga tushmaydi. Amaliyot fayl bilan ishlaydi: rejani yozing va fayl to'g'riligini tekshiring.
