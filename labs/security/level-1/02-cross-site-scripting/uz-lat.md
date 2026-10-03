# Dastur: brauzer orqali tokenni olish

## Nimaga berilgan

`lab-work/` ichida allaqachon `reviews.db` bazasi bor: uchta izoh va `admin`
jadvali, unda token turadi. **Token sahifada yo'q** -- u `admin.token` da
qoladi, izohlar sahifasi esa faqat izohlarni ko'rsatadi.

## Qadamlar

1. Fikstura tayyorlang:

```bash
bash setup.sh
```

2. Bazada nima borligini ko'ring. Codespaces da `sqlite3` mijozi yo'q,
   shuning uchun Python orqali oching -- u har doim mavjud:

```bash
python3 -c "
import sqlite3
c = sqlite3.connect('lab-work/reviews.db')
print([r[0] for r in c.execute(
    "SELECT name FROM sqlite_master WHERE type='table'")])
print(list(c.execute('SELECT author, body FROM reviews')))
"
```

Token `admin` jadvalida. U senga faqat **tekshirish uchun** kerak, sahifaga
u kirib kelmaydi.

3. `srv.py` yozing:

- `GET /` -- barcha izohlar sahifasi;
- `POST /review` -- `author` va `body` qabul qiladi, izohni saqlaydi va
  sahifani qayta ko'rsatadi;
- `python3 srv.py <port>` -- port raqamini argument sifatida oladi;
- `author` va `body` ni **ekranlamasdan** HTML ichiga joylashtiring --
  shunda yuklama sahifaga yetib boradi.

4. Serverni ishga tushiring:

```bash
cd lab-work
python3 srv.py 8102
```

5. Brauzerda `http://127.0.0.1:8102/` ni oching, izoh yuboring:
   `<img src=x onerror=alert(1)>`. Sahifa manbasida tirnoq paydo bo'ladimi?

6. Endi tokenni oling. U `admin` jadvalida, sahifa esa faqat `reviews`
   ko'rsatadi. Demak **server o'zi** boshqa jadvalni qaytarishi kerak.

   Eslab qol: sahifani brauzer ochadi va server yuborgan narsani
   bajaradi. Shuning uchun `admin` ga so'rov **server tomonida**
   bo'lishi kerak, javob esa sahifa tanasiga kelishi kerak.

7. Token sha256 ning dastlabki 12 belgisini `lab-work/proof.txt` ga yozing:

```bash
python3 -c "
import sqlite3, hashlib
t = sqlite3.connect('lab-work/reviews.db').execute(
    'SELECT token FROM admin LIMIT 1').fetchone()[0]
print(hashlib.sha256(t.encode()).hexdigest()[:12])
" > lab-work/proof.txt
```

8. Endi teshikni yoping: chiqarmasdan oldin `author` va `body` ni
   ekranlang. Yuklama endi matn sifatida kelishi kerak, teg emas.

## Tekshiriladigan

| | |
|---|---|
| 1 | `reviews.db` bazasi tayyorlandi |
| 2 | `srv.py` fayli mavjud |
| 3 | server HTTP orqali javob beradi |
| 4 | izoh kiritmasi yana sahifaga qaytadi |
| 5 | yuklama matn emas, teg sifatida keladi |
| 6 | `proof.txt` da chiqargan tokening xeshi bor |

4 va 5-tekshiruvlar **sening** serveringda o'tadi: tekshiruv yuklama
yuboradi va javobga qaraydi. Boshqa processni qabul qilmaydi.

## G chegarasiga yetish

HTML ekranlash -- bu «`escape` qo'sh» emas. Bu qaror:

- chiqarish HTML ga aynan qayerda bo'ladi;
- foydalanuvchi kiritmasining hammasi ekranlanadimi;
- bir marta ko'p ekranlanadimi (matr noto'g'ri chiqadi);
- kiritma atributga yoki `<script>` ichiga tushadimi -- u yerda
  `html.escape` yetarli emas.
