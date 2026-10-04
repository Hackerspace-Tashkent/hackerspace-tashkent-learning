# Yo'nalish: xavfsizlik

To'rtta daraja. Boshqa trek bilan bir xil qoidalar: to'rt til, hech narsa
o'rnatmaydi, tekshiruv skripti, mashq faqat o'z qurilmangiz va o'z tarmog'ingizda.

## Bu trekning o'ziga xosligi

Oddiy laboratoriya «ishladi yoki yo'q» deb so'raydi. Bu yerda bunday
bo'lmaydi: hech narsani tushunmagan odam javotga qarab yashil oladi.
Shuning uchun bu yerda **tushunish dalili** talab qilinadi: belgi emas,
faqat tushunib chiqqandan keyin olsa bo'ladigan aniq qiymat.

## Muzokaralikka qabul qilinmaydigan qoida

Hamma narsa o'z qurilmangizda va o'z tarmog'ingizda bo'ladi. O'z
serverlaringiz `127.0.0.1` da, o'z fayllaringiz, o'z taqlidlaringiz.
Boshqalarning sayti yoki xizmati — «faqat ko'rib chiqish» uchun ham
yo'q. Bu shakliy emas: begona serverga qo'l uzatish o'rganishdan
jinoyatga aylanadi.

## To'rtta daraja

### S0. Boshlang'ich

Server nimani ko'radi va bu nega muhim.

- [Server nimani ko'radi](level-0/01-what-the-server-sees/uz-lat.md)

Sen sarlavhalar yuborasan. Server ularga ishonadi. Demak, o'zing
haqingda aytganing hech narsani tasdiqlamaydi. Qolgan hammasi shu
asos ustida turadi.

### S1. Davom etuvchi

Autentifikatsiya, kirish nazorati, kod ichidagi kalitlar.

- parol va tokenlar: ular qayerda bo'lishi va qayerda bo'lmasligi kerak
- kirish nazorati: nega «o'z sahifamda tekshirdim» «senning sahifangizda
  tekshirdim» degani emas
- repozitoriy va brauzerdagi kalitlar: nega sahifadagi kalit endi sizniki emas
- 08-darsdagi API ni zaifliklar bo'yicha bo'laklarga ajratish


**Yozilgan va tekshirilgan:**

- [SQL inyektsiyasi](level-1/01-sql-injection/uz-lat.md)
- [XSS: kod boshqa brauzerda bajariladi](level-1/02-cross-site-scripting/uz-lat.md)
- [Oʻz papkangizdan tashqariga chiqish](level-1/03-path-traversal/uz-lat.md)
- [Foydalanuvchi yozgan buyruq](level-1/04-command-injection/uz-lat.md)

## 2-daraja

- [Siz yubormagan soʻrov](level-2/01-csrf/uz-lat.md)

### S2. Ilg'or

Vebdagi klassik zaifliklar, har biri o'z lokal serverida.

- SQL inyektsiyasi
- XSS
- yo'lni aylanib o'tish (`path traversal`)
- SSRF
- buyruq inyektsiyasi

### S3. Mutaxassis

- binar fayllar qanday ishlaydi va bufer toshib ketish nima
- teskari ishlab chiqarish
- kriptografiya asoslari: xesh, tuz, nimani teskar qilib bo'lmaydi
- tarmoq: trafikni qanday kuzatish

## Nima uchun ishontirilgan nomlar

Bu trekdagi mashqlarda **mavjud bo'lmagan** nom va formatlar ishlatiladi:
sarlavhalar, kalitlar, maʼlumot formatlari. Bu ataylab qilingan.

Agar vazifa internetda topilsa yoki sun'iy intellektga so'ralsa, u
o'rgatmaydi — u eslatishni o'rgatadi. Mavjud bo'lmagan nom bilan
javobga faqat tushunib borish orqali yetish mumkin.

## Ish tartibi

1. Dars g'oyani tushuntiradi.
2. Uning ichida siz buzadigan narsani yassaysiz.
3. Laboratoriya sizning serveringizni ishga tushirib, natijani haqiqiy
   so'rov bilan tekshiradi.
4. Belgilar o'rniga **dalil** talab qilinadi — aniq qiymat.

## Hali yo'q bo'lganlar

Yozilgan va tekshirilgan: S0 darajasi — **toʻrtta mavzu**, S1 — **bitta**.

Yozilmagan: S1, S2, S3. Sabab qiyinlik emas, balki shuki **birorta odam
hatto S0 ni ham o'tmagan**. Birinchi mavzu ishlashini ko'rsatish kerak,
keyin keyingi qavat quriladi.
