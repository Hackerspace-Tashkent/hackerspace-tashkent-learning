# Yoʻnalish: xavfsizlik

Toʻrtta daraja. Boshga trek bilan bir xil qoidalar: toʻrt til, hech narsa oʻrnatmaydi, tekshiruv skripti, mashq faqat oʻz qurilmangiz va oʻz tarmogʻingizda.

## Bu trekning oʻziga xosligi

Oddiy laboratoriya «ishladi yoki yoʻq» deb soʻraydi. Bu erda bunday
boʻlmaydi: hech narsani tushunmagan odam javotga qarab yashil oladi.
Shuning uchun bu erda **tushunish daloli** talab qilinadi: belgi emas,
faqat tushunib chiqqandan keyin olib boʻladigan aniq qiymat.

## Muzokaralikka qabul qilinmaydigan qoida

Hamma narsa oʻz qurilmangizda va oʻz tarmogʻingizda boʻladi. Oʻz
serverlaringiz `127.0.0.1` da, oʻz fayllaringiz, oʻz taqlidlaringiz.
Boshqalarning sayti yoki xizmati — «faqat koʻrib chiqish» uchun ham
yoʻq. Bu shakliy emas: begona serverga qoʻl uzatish oʻrganishdan
jinoyatga aylanadi.

## Toʻrtta daraja

### S0. Boshlangʻich

Server nimani koʻradi va bu nega muhim.

- [Server nimani koʻradi](level-0/01-what-the-server-sees/uz-cyr.md)
- [Kodi ichidagi sir](level-0/02-secrets-in-code/uz-cyr.md)
- [Parollar va xeshlar](level-0/03-passwords-and-hashing/uz-cyr.md)
- [HTTPS va sertifikatlar](level-0/04-https-and-certificates/uz-cyr.md)

Sen sarlavhalar yuborasiz. Server ularga ishonadi. Demak, oʻzingiz
haqingizda aytganing hech narsani tasdiqlamaydi. Qolgan hammasi shu
asos ustida turadi.

### S1. Davom etuvchi

Autentifikatsiya, kirish nazorati, kod ichidagi kalitlar.

- parol va tokenlar: ular qaerda boʻlishi va qaerda boʻlmasligi kerak
- kirish nazorati: nega «oʻz sahifamda tekshirdim» «senning sahifangizda
  tekshirdim» degani emas
- repozitoriy va brauzerdagi kalitlar: nega sahifadagi kalit endi sizniki emas
- 08-darsdagi API ni zaifliklar boʻyicha boʻlaklarga ajratish


**Yozilgan va tekshirilgan:**

- [SQL inʼektsiyasi](level-1/01-sql-injection/uz-cyr.md)
- [XSS: kod boshqa brauzerda bajariladi](level-1/02-cross-site-scripting/uz-cyr.md)
- [Oʻz papkasingizdan tashqariga chiqish](level-1/03-path-traversal/uz-cyr.md)
- [Foydalanuvchi yozgan buyruq](level-1/04-command-injection/uz-cyr.md)

## 2-daraja

- [Soʻrovni siz yubormagansiz](level-2/01-csrf/uz-cyr.md)

### S2. Ilgʻor

Vebdagi klassik zaifliklar, har biri oʻz lokal serverida.

- SQL inʼektsiyasi
- XSS
- yoʻlni aylanib oʻtish (`path traversal`)
- SSRF
- buyruq inʼektsiyasi

### S3. Mutaxassis

- binar fayllar qanday ishlaydi va bufer toʻshib ketish nima
- teskari ishlab chiqarish
- kriptografiya asoslari: xesh, tuz, nimani teskari qilib boʻlmaydi
- tarmoq: trafikni qanday kuzatish

## Nima uchun ishontirilgan nomlar

Bu trekdagi mashqlarda **mavjud boʻlmagan** nom va formatlar ishlatiladi:
sarlavhalar, kalitlar, maʼlumot formatlari. Bu ataylab qilingan.

Agar vazifa internetda topilsa yoki sunʼiy intellektga soʻralsa, u
oʻrgatmaydi — u eslatgani oʻrgatadi. Mavjud boʻlmagan nom bilan
javobga faqat tushunib borish orqali etish mumkin.

## Ish tartibi

1. Dars gʻoyani tushuntiradi.
2. Uning ichida siz buzadigan narsani yassaysiz.
3. Laboratoriya sizning serveringizni ishga tushirib, natijani haqiqiy
   soʻrov bilan tekshiradi.
4. Belgilar oʻrniga **dalol** talab qilinadi — aniq qiymat.

## Hali yoʻq boʻlganlar

Yozilgan va tekshirilgan: **toʻqqizta mavzu** — S0 toʻrtta, S1 toʻrtta,
S2 bitta.

Yozilmagan: JWT, kriptografiya, zaifliklarni tahlil qilish, bogʻliqliklar
xavfsizligi, audit, CI da maxfiy kalitlar. Sabab qiyinlik emas, balki
shuki **birta odam hatto S0 ni ham oʻtmagan**. Birinchi mavzu ishlashini
koʻrsatish kerak, keyin keyingi qavat quriladi.
