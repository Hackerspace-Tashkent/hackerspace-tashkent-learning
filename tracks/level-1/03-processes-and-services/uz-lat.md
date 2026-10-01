# 7-dars. Jaraenlar va xizmatlar

Har bir ishlayotgan dastur — raqamli jarayon. Ularni koʻrish, fonga oʻtkazish va odatdagina toʻxtatish — ishlayotgan mashina va tushunmas mashina orasidagi farq.

## Jaraenlarni koʻrish

```bash
ps                  # joriy terminal jarayonlari
ps aux               # barcha foydalanuvchilarning jarayonlari
ps -ef               # xuddi shu, boshqa formatda
top                  # jonli yangilanadi, q — chiqish
pgrep -f "python"    # nomi boʻyicha qidirish
```

Har bir jarayonning `/proc` da shu raqamda katalogi bor. Bu dastur oʻzi haqida nima deganini koʻrishning halol yoʻli.

## Fon va toʻxtatish

```bash
sleep 300 &        # fonda ishga tushirish
jobs                # shu terminaldan nimalar ishga tushgan
nohup ./long.sh &   # terminal yopilgandan oʻtib ketish
disown -a           # fon jarayonlarini unutish

kill 12345          # tugashga soʻrash (SIGTERM)
kill -9 12345       # darhol tugatish (SIGKILL)
```

> **Izoh.** K harfi katta emas `kill` — hazil emas: oddiy `kill` yaxshilab so'raydi. `-9` ushlanmaydi, dastur tozalashga ulgurmaydi.

## Signalni ushlab olish

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

## systemd va xizmatlar

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

## Amaliyot

1. `lab-work` katalogini yarating.
2. `worker.sh` yozing: bir daqiqa siklda ishlaydi, har soniyada `worker.log` ga qator yozadi va TERM signalini trap orqali ushlab, yakuniy qator yozib, so'ng chiqadi.
3. Uni fonda ishga tushiring, PID ni `worker.pid` ga saqlang va jurnal o'sayotganini tasdiqlang.
4. Bir necha soniya kutib, `kill` bilan yaxshilab to'xtating. `worker.log` oxirida tozalash qatori borligini va jarayon qolmaganini tekshiring.
5. Jarayon yo'qligini `kill -0 <pid>` bilan tekshiring.
6. `Unit`, `Service` va `Install` bo'limlari bo'lgan `worker.service` systemd unitini yozing, ExecStart esa skriptingizning absolyut yo'lini ko'rsatsin.

```bash
cd labs/level-1/03-processes-and-services
./check.sh
```
