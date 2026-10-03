# Dastur: foydalanuvchi yozgan buyruq

## Nimaga berilgan

`lab-work/` da fikstura yaratdi:

- `flag.txt` -- `flag{ne_privet_iz_komandy}` mazmunli fayl;
- `hosts.txt` -- server tekshiradigan hostlar roʻyxati.

## Qadamlar

1. Fikstura tayyorlang:

```bash
bash setup.sh
```

2. Nima paydo boʻlganini koʻring:

```bash
ls lab-work
cat lab-work/hosts.txt
```

3. `srv.py` yozing:

- `GET /ping` yoʻli `host` parametrini oladi;
- server tekshiruvni ishga tushiradi va chiqishni qaytaradi;
- `python3 srv.py <port> [--unsafe]` -- port va ixtiyoriy belgi;
- **belgisiz** buyruq argumentlar roʻyxati qilib yigʻiladi, shell
  ishlatilmaydi;
- **`--unsafe` bilan** f-string bilan satr yigʻilib, `shell=True`
  bilan ishga tushiriladi -- shunda teshik chiqadi.

Zaif variant:

```python
cmd = f"ping -c 1 {host}"
out = subprocess.run(cmd, shell=True, capture_output=True, text=True)
```

4. Zaif serverni ishga tushiring:

```bash
cd lab-work
python3 srv.py 8104 --unsafe
```

5. Oddiy soʻrov:

```bash
curl -G --data-urlencode 'host=localhost' \
  http://127.0.0.1:8104/ping
```

6. Endi inyeksiya. Host nomiga buyruq qoʻshing:

```
curl -G --data-urlencode 'host=; cat flag.txt' \
  http://127.0.0.1:8104/ping
```

Javobda `flag{...}` chiqsa -- teshik topildi. `&& cat flag.txt` va
`$(cat flag.txt)` ni ham sinab koʻring: ular boshqa sabab bilan ishlaydi.

7. **`flag.txt` ni oʻchirmang.** Tekshiruv buni alohida kuzatadi.
8. Endi teshikni yoping. f-string va `shell=True` ni olib tashlang,
   roʻyxat bering:

```python
out = subprocess.run(["ping", "-c", "1", host],
                     capture_output=True, text=True)
```

9. Belgisiz qayta ishga tushiring va ikkala zararli yuklamani yana
   yuboring: ikkalasi ham oddiy muvaffaqiyatsizlik qaytarmoqchi.

## Tekshiriladigan

| | |
|---|---|
| 1 | `srv.py` fayli mavjud |
| 2 | server HTTP orqali javob beradi |
| 3 | oddiy hostga javob beriladi |
| 4 | yuklangan buyruq `flag.txt` ni oʻqiydi |
| 5 | yopilgandan keyin inyeksiya ishlamaydi |
| 6 | `flag.txt` oʻchirilmagan |

4 va 5 bir serverning ikki rejimini tekshiradi: avval `--unsafe` bilan,
keyin belgisiz.

## G chegarasiga yetish

«Satrda `;` yoʻq» tekshiruvi yetarli koʻrinadi ayniqsa birinchi uni
yuvib oʻtadigan test-kasegacha. Argumentlar roʻyxatini esa yuvib
boʻlmaydi: unga buyruq qoʻshishga joy yoʻq. Savol shuning uchun
«qaysi belgilarni taqiqlaymiz» emas, «soʻrovdan kelgan satr qayerda
dasturga aylanadi».
