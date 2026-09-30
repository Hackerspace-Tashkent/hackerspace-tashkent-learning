# 7-dars. Жараёнлар ва хизматлар

Ҳар бир ишлаётган дастур — рақамли жараён. Уларни кўриш, фонга ўтказиш ва одоблик тўхтатиш — ишлаётган машина ва тушуmsiz машина ўртасидаги фарқ.

## Жараёнларни кўриш

```bash
ps                  # процессы текущего терминала
ps aux               # все процессы всех пользователей
ps -ef               # то же, другой формат
top                  # обновляется live, q — выход
pgrep -f "python"    # найти по имени
```

Ҳар бир жараённинг `/proc` да шу рақамда каталоги бор. Бу дастур ўзи ҳақида нима деганини кўришнинг ҳалол йўли.

## Фон ва тўхтатиш

```bash
sleep 300 &        # запустить в фоне
jobs                # что запущено из этого терминала
nohup ./long.sh &   # пережить закрытие терминала
disown -a           # забыть о фоновых процессах

kill 12345          # попросить завершиться (SIGTERM)
kill -9 12345       # убить немедленно (SIGKILL)
```

> **Izoh.** K harfi katta emas `kill` — hazil emas: oddiy `kill` yaxshilab so'raydi. `-9` ushlanmaydi, dastur tozalashga ulgurmaydi.

## Сигнални ушлаб олиш

`trap` skriptga to'xtatilganda o'z tozalashini bajarishga imkon beradi. Aks holda yarim yozilgan fayl yarim qoladi.

```bash
#!/usr/bin/env bash
tmp="work.tmp"

cleanup() {
  echo "cleaning up..."
  rm -f "$tmp"
}
trap cleanup EXIT TERM

echo "working" > "$tmp"
sleep 30
```

> **Izoh.** Faqat logga yozib qaytadigan trap yetarli emas: sikl davom etaveradi va jarayon tugamaydi. Yozing va handler ichida `exit 0` qiling. Yana eslab qoling: bash trapni joriy buyruq tugagandan keyin bajaradi — `sleep 300` ichidagi skript `kill` ni besh daqiqaga e'tiborsiz qoldiradi. Shuning uchun amaliyotda qisqa pauzalar ishlatiladi.

## systemd ва хизматлар

Haqiqiy Linux mashinasida `systemd` dasturlarni yuklanganda ishga tushiradi, qulangandan keyin qayta ishga tushiradi va ularning chiqimini yig'adi. Xizmat unit fayli bilan tasvirlanadi.

```ini
[Unit]
Description=My report service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/report.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Yuklash — `systemctl daemon-reload`, ishga tushirish — `systemctl start report`, kuzatish — `journalctl -u report -f`.

> **Izoh.** Codespace — konteyner, u yerda `systemd` PID 1 emas va `systemctl status` ishlamaydi. Shuning uchun amaliyot xizmat yurishini emas, unit faylining to'g'riligini tekshiradi.
