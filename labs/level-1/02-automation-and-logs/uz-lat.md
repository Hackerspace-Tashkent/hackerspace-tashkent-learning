# 6-dars. Avtomatlashtirish va jurnalar

O'zi bajaradigan vazifa — eslab turish kerak bo'lgan vazifadan ancha qimmatli. Bu dars rejimani yoqish va iz qoldirish haqida.

## Чиқим оқимлари

Ҳар бир буйруқнинг учта оқими бор: натижа учун стандарт чиқим, муаммолар учун хато чиқими ва кирим. `>` файл ёзади, `>>` қўшади, `2>` хатоларни йўналтиради.

```bash
ls > out.txt          # только stdout, очистит файл
ls >> out.txt         # добавит в конец
ls 2> err.txt         # только stderr
ls > all.txt 2>&1     # и то и другое в один файл
ls 2>&1 | grep txt    # ошибки тоже попадут в пайп
```

> **Izoh.** Журнал — бул файл, унга қўшиб борса, ҳеч қачон тозаланмайди. `>>` ishlatнг ва ҳар қаторнинг бошига сана қўйинг.

```bash
#!/usr/bin/env bash
log="run.log"
printf '%s started\n' "$(date '+%F %T')" >> "$log"
printf '%s finished with code %d\n' "$(date '+%F %T')" "$?" >> "$log"
```

## cron bilan reja

`cron` belgilangan vaqtda buyruqni ishga tushiradi. Qatorda beshta maydon bor: daqiqa, soat, oy kuni, oy, hafta kuni, so'ng buyruq.

```bash
# минута час день месяц день_недели  команда
*/5 *   *   *     *            /home/me/report.sh
0  9   *   *     1-5          /home/me/backup.sh
30 18  *   *     *            /home/me/clean.sh
```

cron'ga hech qachon pochta yubormaslik. Ikkala oqimni jurnal fayliga yo'naltiring.

```bash
*/10 * * * * /home/me/report.sh >> /home/me/report.log 2>&1
```

## Режани таҳрирлаш

```bash
crontab -l     # показать текущие задачи
crontab -e     # изменить
crontab -r     # удалить все (осторожно)
```

Crontab — bu shunchaki matn fayl, har satrda bitta vazifa. `crontab myfile` uni o'rnatadi, `crontab -l` o'rnatilganini ko'rsatadi. Rejani faylda saqlasangiz — ya'ni `crontab -e` ichida ko'z yopib tahrirlash o'rniga — uni git'da tutib, har qanday mashinaga ko'chirish mumkin.

> **Izoh.** Codespace'da `cron` daemonsi ishlamaydi, shuning uchun o'rnatilgan vazifalar o'z-o'zidan ishga tushmaydi. Amaliyot fayl bilan ishlaydi: rejani yozing va fayl to'g'riligini tekshiring.
