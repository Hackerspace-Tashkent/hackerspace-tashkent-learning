# 8-dars. Tarmoq

Server — bu shunchaki portda tinglayotgan dastur. Uni ishga tushirib, unga murojaat qila boshlaganingizda, tarmoq veryondan chiqadi.

## Manzillar va portlar

```bash
ip addr              # адреса всех интерфейсов
ip route             # куда идёт трафик
hostname -I          # свой адрес
ss -tlnp             # кто слушает порты
```

`127.0.0.1` — bu `localhost`, o'zingiz bilan gaplashish. Port — 1 dan 65535 gacha raqam, tinglovchilar orasidan bitta dasturni tanlaydi.

## Serverni ishga tushirish

```bash
python3 -m http.server 8000 --bind 127.0.0.1
```

1024 dan katta port tanlang — undan kichisi root talab qiladi. `--bind 127.0.0.1` serverini faqat shu mashinada ochib qoldiradi, bu xavfsiz standart.

## Serverga murojaat

```bash
curl -I http://127.0.0.1:8000     # только заголовки
curl -s http://127.0.0.1:8000 | head    # первые строки
curl -o page.html http://127.0.0.1:8000 # сохранить в файл
echo $?                                # код: 0 — связь есть
```

- `200` OK
- `301` yoki `302` yo'naltirilgan
- `404` topilmadi
- `403` taqiqlangan
- `000` ulanish muvaffaqiyatsiz

## Manzillar oʻrniga nomlar

Host — manzilga ishora qiluvchi nom. `/etc/hosts` kichik mahalliy roʻyxat, DNS soʻralishidan oldin tekshiriladi.

```bash
echo "127.0.0.1  mysite.local" | sudo tee -a /etc/hosts
curl -I http://mysite.local:8000
```

## Amaliyot

1. `lab-work` katalogini yarating va unga ixtiyoriy matnli `index.html` faylini qo'ying.
2. `serve.sh` yozing: `python3 -m http.server` ni 8000-portda fonda ishga tushiradi va PID ni `server.pid` ga yozadi.
3. Uni ishga tushiring, keyin javob kodini `status.txt` ga saqlang: `curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8000 > status.txt`.
4. `ss -tlnp` (yoki `netstat -tlnp`) chiqishida port borligini tasdiqlang va shu qatorni `ports.txt` ga saqlang.
5. `check_site.sh` yozing: berilgan portni so'raydi va faqat holat 200 bo'lganda 0, aks holda 1 bilan chiqadi. Noto'g'ri portda 1 berishi kerak.
6. `server.pid` dagi PID bilan `kill` qilib serverni to'xtating va 8000-portda endi hech kim tinglamayotganini tekshiring.

```bash
cd labs/level-1/04-networking
./check.sh
```
