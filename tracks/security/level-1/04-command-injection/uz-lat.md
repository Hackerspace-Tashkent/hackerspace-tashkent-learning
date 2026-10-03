# Shell ijro qiladigan narsani ishga tushirganda

## Nima uchun bilish kerak

Oldingi mavzularda zarar SQL va HTML orqali kelgan: maʼlumot soʻrovga
yoki sahifaga aylangan. Bu erda u hammasigacha shell ga etadi.

Server «xost javob beradimi» deb tekshirmoqchi. U buyruq yozib ishga
tushiradi. Agar xost nomi soʻrovdan kelib, satrga aynan qoʻyilsa,
foydalanuvchi oʻz buyrugʻini qoʻshib qoʻya oladi.

Bu **command injection**, buyruq inʼektsiyasi.

## Qaerda paydo boʻladi

Xavfli qator oddiy koʻrinadi va shubha uygʻotmaydi:

```python
out = subprocess.run(
    f"ping -c 1 {host}",
    shell=True, capture_output=True, text=True)
```

`host` soʻrovdan keldi. `shell=True` satrni interpretatorga beradi, u
esa uni boʻlaklarga ajratadi. Xost nomidagi `;` bir tekshiruvni ikki
buyruqqa aylanadi.

## Nima uchun bu kamdan-kam holat emas

«Bu erda `;` yoki `&&` yoʻqmi» degan tekshiruv ishlamaydi. Taqiqlangan
belgilar roʻyxati doim voqeadan qisqa:

- boʻluvchilar faqat `;` emas — `&&`, `||`, qator oxiri, `$( )` ham;
- boʻshliq xavfsiz argumentlarni oʻtkazib yuboradi;
- tiqiq va `$()` `;` siz ham ishlaydi;
- URL-kodlash va dastur darajasidagi yoʻllar yangi yoʻllar ochadi.

## Buning oʻrniga

**Buyruq satri yaratmang.** Argumentlarni roʻyxat qilib bering:

```python
out = subprocess.run(["ping", "-c", "1", host],
                     capture_output=True, text=True)
```

Bu erda `host` — bitta argument, dastur matni emas. U ichida
`; cat flag.txt` boʻlsa ham, `ping` shu xost nomi bilan ishga tushadi
va boshqa hech narsa emas.

**`shell=False` asosiy holat boʻlsin.** Aniq `shell=True` kamdan-kam
boʻlishi va «buni shellsiz qanday qilib boʻlmaydi?» savolini tugʻirishi
kerak.

**Agar shell kerak boʻlsa — oq roʻyxat.** Satrni yomon narsaning
yoʻqligi boʻyicha emas, ruxsat etilganlar roʻyxatida borligi boʻyicha
tekshiring.

## Sen nimaga qilasan

Server avval zaif boʻlib turadi. Buyruq inʼektsiya qilasan, keyin
teshikni yopasan va belgilarni tekshirish roʻyxatdan yomonroq ekanini
tushuntirasan.

## Chegara

Faqat oʻz kompʼyuteringiz, faqat `localhost`, faqat fikstura
fayllari.
