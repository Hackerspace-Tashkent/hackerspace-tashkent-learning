# Parollar va xeshlar

## Buni nega bilish kerak

Xesh — bu **shifrlash emas**. Shifrlash qaytariladi: kalit bor, asl matn
qaytadi. Xesh qaytarilmaydi: `a94f8f5` dan `sable` ni olib boʻlmaydi.

Bu yaxshi ham, yomon ham. Yaxshi — chunki parolni oʻqib boʻlmaydi.
Yomon — chunki **eslab qolingan parolni tiklash umuman mumkin emas**,
faqat yangilash mumkin.

## Bu qanday buziladi

Yillar davomida parollar shunday saqlanardi:

```python
hashlib.sha256(password.encode()).hexdigest()
```

Mana bundan kelib chiqadigan natijalar.

**Bir xil parollar bir xil xeshlarni beradi.** Ikkita odamda `123456`
boʻlsa, oqib chiqqan faylda ikki xil xesh boʻladi. Xeshning oʻzidan
parolni nechta odam ishlatganini aytib ham boʻlmaydi.

**Tanlash jadval bilan muloqotga aylanadi.** Kimdir oldindan
milliardlab oddiy parollarning xeshlarini hisoblab qoʻyadi — buni
rangin jadval deyiladi. Keyin olingan faylni boshqarib tekshirilmaydi,
**tayyor jadvalda qidiriladi**: mos kelsa — parol maʼlum.

**Tezlik cheklanmagan.** sha256 sekunda milliard marta hisoblanadi.
Sen bir milliard variantni tekshirib tugamasa ham hech kim sezirmaydi.

## Buning echimi bor

**Tuz.** Tasodifiy satr, har bir parol uchun alohida. Xesh olishdan
oldin parolga qoʻshiladi. Endi bir xil parollar turli xesh beradi va
tayyor jadval beqaror boʻladi: har bir parol uchun oʻzinki kerak.

**Sekin xeshlash.** Odatiy sha256 tezda ishlaydi — bu tezlik uchun,
himoya uchun emas. Parollar uchun **ataylan sekin** funksiyalar
ishlatiladi, va ular oʻn ming marta takrorlanadi.

Python standart kutubxonasiida `hashlib.pbkdf2_hmac` bor:

```python
hashlib.pbkdf2_hmac("sha256", password.encode(), salt.encode(), 100000).hex()
```

`bcrypt` va `argon2` yaxshiroq, lekin ular standart kutubxonada yoʻq —
oʻrnatiladi. `pbkdf2_hmac` — oʻrnatishsiz ishlaydigan narsa.

## Sen nima qilasan

Senga `hashes.txt` — «xesh — soʻz» juftliklari, internetda yoʻq
ishontirilgan soʻzlar. Va `target.txt` — bitta xesh.

1. `brute.py` yoz: soʻzlarni kezib, maqsad bilan mosligini top, soʻzni
   `crack.txt` ga yoz.
2. Topilgan parolning sha256 ning birinchi 12 belgisini `proof.txt` ga yoz.
3. `salted.py` yoz: bir xil parol uchun uchta xesh koʻrsat — tuzsiz,
   birinchi tuz, ikkinchi tuz. Ular farq qilishi kerak.
4. `notes.md` da javob ber: **parol baribir tanlanadigan boʻlsa, tuzning
   nimaga keragi bor?**

## Qanday koʻrinadi

```python
import hashlib

# Bu -- misol uchun. Oʻzingiz topgan soʻzni shu yerga yozing.
PASSWORD = "brindle"


def pbkdf2(password, salt):
    return hashlib.pbkdf2_hmac("sha256", password.encode(),
                               salt.encode(), 100000).hex()


print("tuzsiz   :", hashlib.sha256(PASSWORD.encode()).hexdigest())
print("tuz A    :", pbkdf2(PASSWORD, "sable-4710"))
print("tuz B    :", pbkdf2(PASSWORD, "vireo-9931"))
```

Qator bir xil, xeshlar esa farq qiladi. Aynan shuni qiladi tuz.

## Aslida nima saqlanadi

Parol hech qachon saqlanmaydi. Saqlanadigani — **xesh, tuz va parametrlar**,
chunki tuzsiz va parametrsiz xesh tekshiruv uchun beqiy. Tuz sir emas: u
xesh yonida turadi va yashirilishi shart emas. Yashirilishi kerak
boʻlgani — parolning oʻzi, uni tizimda yoʻq.

## Muhim

Bu erdagi parollar ishontirilgan va laboratoriya papkasida turibdi.
Haqiqiy parollar tanlanmaydi — ular yoki eslab qoldiriladi, yoʻ yangilanadi.