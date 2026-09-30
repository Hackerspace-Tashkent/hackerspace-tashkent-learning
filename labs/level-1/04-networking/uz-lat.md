# 8-dars. Тармоқ

Server — bu shunchaki portda tinglayotgan dastur. Uni ishga tushirib, unga murojaat qila boshlaganingizda, tarmoq veryondan chiqadi.

## Манзиллар ва портлар

```bash
ip addr              # адреса всех интерфейсов
ip route             # куда идёт трафик
hostname -I          # свой адрес
ss -tlnp             # кто слушает порты
```

`127.0.0.1` — bu `localhost`, o'zingiz bilan gaplashish. Port — 1 dan 65535 gacha raqam, tinglovchilar orasidan bitta dasturni tanlaydi.

## Серверни ишга тушириш

```bash
python3 -m http.server 8000 --bind 127.0.0.1
```

1024 dan katta port tanlang — undan kichisi root talab qiladi. `--bind 127.0.0.1` serverini faqat shu mashinada ochib qoldiradi, bu xavfsiz standart.

## Серверга murojaat

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

## Манзиллар ўрнига номлар

Хост — manzilga ishora qiluvchi nom. `/etc/hosts` kichik mahalliy ro'yxat, DNS so'ralishidan oldin tekshiriladi.

```bash
echo "127.0.0.1  mysite.local" | sudo tee -a /etc/hosts
curl -I http://mysite.local:8000
```
