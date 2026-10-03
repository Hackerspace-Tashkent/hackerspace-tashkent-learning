# Brauzer server yuborgan nimani bajaradi

## Nima uchun bilish kerak

Oldingi mavzuda biz serverga so'rov yuborib, jadvaldagi ma'lumotni oldik.
Bu yerda teskari: so'rov yubormaymiz, biz **kod** yuboramiz, va
boshqaning brauzeri uni bajaradi.

Sahifa matn emas, kod hisoblanadi. Brauzer satrni oladi va HTML
parser'ga so'raydi: bu teg'mi? Agar teg bo'lsa — u yig'iladi. Shu
hujum **XSS** deyiladi.

## Nima qiladi server

Oddiy izohlar sahifasi. Kimdir izoh yozadi, server saqlaydi va
**hammaga** ko'rsatadi.

Ekranslash o'tsa, xavfsiz: `<` `&lt;` ga aylanadi va brauzer belgini
ko'rsatadi, teg qurmaydi.

```python
import html
safe = html.escape(user_input)   # <  →  &lt;
```

## Qayerda buziladi

Foydalanuvchi kiritmasini ekranlamasdan HTML ga chiqaruvchi qatorlar:

- butun javob tanasi;
- `f"<p>{body}</p>"`;
- atribut qiymatiga kiritish;
- `<script>` ichiga kiritish.

Bitta shunday qator — sahifaga kelgan har bir mehmon boshqaning kodini
bajaradi. Administrator emas, muhandis emas: **mehmon**.

## Yuklama

`<img src=x onerror=alert(1)>`

O'qish: `img` tegini buzilgan `src` bilan hech qachon yuklanmaydi,
brauzer xato beradi va `onerror` ni bajaradi. Rasm ham, internet ham
kerak emas.

`alert` ichidagi matn muhim emas. Muhim holat shu: **kod bajarildi**.

## Sen nimaga qilasan

Serverni o'zing yozadigan bo'ladi. Uni ochiq qilib, keyin teshikni
yopadigan bo'ladi va himoya nimaga aniq farq qilishini tushuntiradigan.

## Chegara

Faqat o'z kompyuteringiz, faqat `localhost`, faqat fikstura ma'lumotlari.
