# Dars 7. GitHub Pages

## Bu nima

GitHub Pages — repositoriyadan toʻgʻridan-toʻgʻri statik sayt hostingi. Siz
ildizga `index.html` faylini qoʻyasiz, sozlamalarda Pages ni yoqasiz, bir daqiqa
dan keyin sayt manzilda ochiladi.

```
repositoriy  →  Pages ni yoqish  →  GitHub yigʻadi  →  sayt ishlaydi
```

Bizning saytimiz aynan shunday qurilgan:
`https://hackerspace-tashkent.github.io/Hackerspace-Tashkent-website/`.

## Asosiy cheklov

Pages faqat **statik fayllarni** beradi. Yaʼni `.html`, `.css`, `.js`, rasm va
shriftlar.

U nima **qila olmaydi**:
- serverda kod ishga tushirish — na PHP, na Python, na Node;
- bazani saqlash;
- tashqi servissiz shakl qabul qilish;
- maxfiy maʼlumotlarni yashirish — repositoriyadagi hamma narsa hammaga koʻrinadi.

Shundan qoida: **server mantig'i — bu VPS, statika — bu Pages.** Agar saytga
baza kerak boʻlsa, ikki yoʻl bor: tashqi servis (Supabase, Airtable) yoki
oʻz serveringiz. Pages da API kalitini yashirish umuman mumkin emas, maxfiy
kalit har doim sahifa manbasida koʻrinadi.

## Birinchi usul: tarmoqdan

Eng oddiy va koʻpincha yetarli.

1. `index.html` fayli `main` ning ildizida turadi.
2. **Settings → Pages → Source: Deploy from a branch**, tarmoq `main`, papka
   `/ (root)`.
3. Saqlang. Bir-uch daqiqadan keyin sayt javob beradi.

Muhim tafsilotlar:
- fayl **aniq `index.html`** deb nomlanishi kerak (`index.htm` emas, `Index.html`
  ham emas);
- sayt ichki papkada boʻlsa, manzilda `/papka-nomi/` koʻrinadi;
- bosh sahifa — `index.html`, qolgani fayl nomi bilan ochiladi.

## Ikkinchi usul: Actions orqali

Kerak, agar sayt yigʻiladi: statik sayt generatori, shablonlar, rasmlarni
qayta ishlash.

```yaml
name: Saytni eʼlon qilish

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v5
      - uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
    steps:
      - uses: actions/deploy-pages@v4
```

Bu yerda muhim va ochiq boʻlmagan narsa:

**`permissions:`** — Actions sahifalarni sukut boʻyicha eʼlon qila olmaydi. Bu
uch qatursiz deploy huquq xatosi bilan toʻxtaydi.

**Ikkita job, bittasi emas.** Yigʻish va eʼlon qilish ajratilgan: qayta yigʻish
ishlayotgan saytni buzmasin. `needs: build` «birinchisini kut» degani.

**`environment: github-pages`** — GitHub oʻzi yaratadigan maxsus muhit. Aynan u
deployni Pages ga bogʻlaydi.

**Artefakt** — oraliq natija. `upload-pages-artifact` papkani yigʻadi,
`deploy-pages` uni ochib joylaydi.

## Oʻz domeningiz

**Settings → Pages → Custom domain** ga domeningizni yozing, soʻng domeningiz
sozlamalarida `USER.github.io` ga CNAME yarating.

Ikki ogohlantirish:
- domen darhol ishga tushmaydi; tekshiruv daqiqalardan bir kun gacha,
  baʼzan uzoqroq davom etadi;
- DNS sozlanmagan boʻlsa, sayt `DNS Check in Progress` holatida turib qoladi va
  ochilmaydi. Nimadan keyin kutishdan oldin domen umuman resolve boʻlishini
  tekshiring.

Biz shu yerga urildik: `hackerspace.uz` sozlanmagan va ochilmaydi. Ishlaydigan
manzil — Pages dagi.

## Eʼlon qilishdan oldin lokal tekshirish

Eʼlon qilib, keyin qorish — yomon sikl. Lokal tekshiring:

```bash
cd lab-work
python3 -m http.server 8000
```

Brauzerda `http://127.0.0.1:8000` ni oching. Lokal ishlaydi, Pages da ishlamasa —
muammo Pages sozlamasida, kodda emas.

Codespaces ham shunday: u yorda portga «Open in Browser» tugmasi bor.

## HTTPS

Pages sertifikatni avtomatik beradi. Majburiy HTTPS — sozlamadagi tugma. Oʻz
domeningizda «Enforce HTTPS» ni yoqishingiz mumkin, lekin avval domen ochilishini
ta’minlang — aks holda hech kimga koʻrinmaydigan sayt hosil boʻladi.

## Keyingi

Laboratoriya yonma-yoʻnda: `labs/level-1/07-github-pages`. Sahifa yigʻish,
lokal tekshirish, eʼlon qilish va manzilni yozib qoʻyish kerak.
