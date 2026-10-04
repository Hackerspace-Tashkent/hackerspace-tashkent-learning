# Soʻrovni siz yubormagansiz

## Nima uchun bilish kerak

Hozirgacha zarar soʻrov ichida kelgan: satrda SQL, tanida `<script>`,
xost nomida `;`. Bularning hammasini **siz oʻzi** yuborgansiz.

CSRF teskari ishlaydi. Zararli kod umuman yoʻq. Oddiy sahifa oddiy
soʻrov yuboradi — brauzer esa sessiya cookie ni oʻzi qoʻshadi, chunki ular
shu domenga tegishli.

Server koʻradi: soʻrov keldi, cookie keldi, foydalanuvchi vakolatli.
Amal bajariladi.

**CSRF** — cross-site request forgery, boshqa saytdan soʻrovni
sohtalash.

## Nima uchun cookie shuncha ochiq

Cookie **avtomatik** yuboriladi. Brauzer ham soʻramaydi, ham qaerga
maʼlumot ketganini koʻrsatmaydi. Bu qulaylik va bir vaqtda muammo
manbai: brauzer farq qilolmaydi

- soʻrovni tugma bosip **siz** yubordingiz;
- soʻrovni **begona sahifa** yubordirdi.

«Foydalanuvchi vakolatli» tekshiruvi ikkalasida ham bajariladi.

## Napadda qanday koʻrinadi

Begona sahifada shunday forma bor:

```html
<form action="http://127.0.0.1:8111/action" method="post">
  <input type="hidden" name="email" value="attacker@example.com">
</form>
```

Foydalanuvchi sahifani ochadi. U hech narsani bosmasligi ham mumkin —
avtomatik yuboradigan variantlar bor. Forma ketadi, cookie ham u bilan
birga ketadi, pochta oʻzgaradi.

Yashiruvlik hech narsa bermaydi: `hidden` maydonni ekranda yashiradi,
soʻrovda emas.

## Nima ishlaydi

**Begona sahifa bilmaydigan token.** Server formaga tasodifiy qiymat
qoʻyadi va uni sessiyada eslab qoldiradi. Soʻrov keldi — solishtiriladi.
Begona sahifa qiymatni bilmaydi, demak sohtalay olmaydi.

Bu xossla **double submit** deb ataladi, qatʼiy koʻrinishida
**synchronizer token**: token serverda saqlanadi.

**Manbani tekshirish.** `Origin` yoki `Referer` kutilayotgan bilan
moslishishi kerak. Yordam beradi, lekin faqat shuga tayanib boʻlmaydi:
sarlavha kelib ketmasligi mumkin.

**`SameSite` bilan cookie.** `SameSite=Lax` begona saytdan POST
kelganda cookie yubormaydi. Kuchli himoya, lekin koʻz nuqtasi bor: oʻsha
saytdan keluvchi napadga halol emas, eski brauzerlarni ham qutqarmaydi.

**Muhim amallarni tasdiqlash.** Pochta, parolʼ va toʻlov maʼlumotlarini
oʻzgartirishni yangidan tasdiqlash kerak.

## Sen nimaga qilasan

Server avval himoyasiz boʻladi. Begona sahifa pochtani oʻzgartarishini
koʻrsatasan, keyin token qoʻshasan va u aniq nimani toʻxtatishini
tushuntirasan.

## Chegara

Faqat oʻz kompʼyuteringiz, faqat `localhost`, mavjud boʻlmagan pochta
manzillari.
