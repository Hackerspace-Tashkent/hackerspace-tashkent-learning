# SQL inyektsiyasi

## Buni nega bilish kerak

Sen server yozasan. U mijozdan kelgan ism boʻyicha odamni izlaydi.
Eng tabiiy yozuv shunday koʻrinadi:

```python
sql = "SELECT name, score FROM people WHERE name = '" + name + "'"
```

Qator yopishtirilgan. `name` — mijoz yuborgan narsa, u soʻrov matniga
**kod sifatida** kirib ketgan.

## Hujumchi nima qiladi

Oddiy soʻrov: `marram` ni izlaydi, bitta qator qaytadi.

`' OR '1'='1` kirishi soʻrovni shunga aylantiradi:

```sql
SELECT name, score FROM people WHERE name = '' OR '1'='1'
```

Shart doim toʻgʻri boʻlib qoldi, server esa **butun jadvalni** qaytardi.
Bu buzish emas, taxmin ham emas — boshqacha soʻrov matni, uni server
odatdagidek bajardi.

Keyin `UNION` keladi. U birinchi soʻrov natijasiga ikkinchisini qoʻshadi:

```sql
SELECT name, score FROM people WHERE name = ''
UNION SELECT code, note FROM vault--
```

Oxiridagi ikki chiziq qolganini kesib tashlaydi. Endi javobda `vault`
jadvali bor — server uni koʻrsatmoqchi ham emas edi.

## Bu qanday ishlaydi

Sababi shuki, SQLite yoki Python ahmoq emas. Sababi shuki, **server
maʼlumot bilan kodni ajratolmaydi**. Mijoz kiritishi maʼlumot boʻlishi
kerak edi. Bu yerda u ifodaning bir qismiga aylandi.

## Nima uchun bu jiddiy

Qator yopishtirish bilan faqat oʻqib qolmaydi. Jadvalni oʻchirish,
parollarni almashtirish, maosh maʼlumotini tortish mumkin. Haqiqiy
saytlarda bu eng koʻp uchraydigan dastur darajasidagi teshiklardan biri.

## Toʻgʻri yoʻli

Qiymatni **parametr** sifatida berish kerak, matnning bir qismi emas:

```python
rows = db.execute(
    "SELECT name, score FROM people WHERE name = ?", (name,)
)
```

Drayver qiymatni oʻzi ekranlaydi, ism ichidagi tirnoqlar tirnoq
qoladi, kod boʻlmaydi. Yopishtirish hech qachon mumkin emas — hatto
"zararsiz koʻrinadigan" soʻrov uchun ham.

## Sen nima qilasan

Senga `data.db` beriladi: oltita ismli `people` jadvali va bitta
qatorli `vault` jadvali — oʻquv kaliti.

1. `/lookup?name=...` endpointi bilan `srv.py` yoz va satrdagi
   **yopishtirishni** ishlat. Bu xato emas, vazifa shu.
2. Halol soʻrov yubor va bitta qatorni koʻr.
3. `' OR '1'='1` yubor va qatorlarni san.
4. `UNION` ni `vault` gacha choʻz va kalitni chiqar.
5. `proof.txt` ga kalitning SHA-256 birinchi 12 belgisini yoz.
6. `notes.md` da javob ber: **parametr bilan yopishtirish orasidagi
   farq nimada aynan?**

## Vazifa chegarasi

Bazaning oʻz papkada, serverni oʻzing yozasan, manzil `127.0.0.1`.
Boshqalarning saytlari tekshirilmaydi. Ruxsatsiz boshqa serverni
tekshirish — bu mavzuning oʻquv maqsadi emas.
