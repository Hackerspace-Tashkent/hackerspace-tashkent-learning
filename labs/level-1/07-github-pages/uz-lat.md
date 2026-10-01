# Laboratoriya: GitHub Pages

## Nima qilish kerak

Hamma narsa shu fayl yonidagi `lab-work/` da.

```bash
cd "$(dirname check.sh)"
mkdir -p lab-work
cd lab-work
```

### 1. Sahifa

`index.html` yarating. Tekshiriladigan eng kichik variant:

```html
<!DOCTYPE html>
<html lang="uz">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Mening birinchi sahifam</title>
</head>
<body>
  <h1>Salom</h1>
  <p>Repositoriyadan eʼlon qilindi.</p>
</body>
</html>
```

`lang` muhim: u boʻlmasa ekran oʻquvchisi matn qaysi tilda ekanini
tushunmaydi. `viewport` — telefonda buzilmasligi uchun.

### 2. Lokal tekshirish

```bash
python3 -m http.server 8000
```

`http://127.0.0.1:8000` ni oching. Ishlayapti — kod toʻgʻri, keyin
eʼlon qilgandan keyin ishlamasa, muammo Pages sozlamasida.

`Ctrl+C` bilan toʻxtating.

### 3. Eʼlon qilish

Fayl allaqachon `main` da. Endi **Settings → Pages → Source: Deploy from a
branch**, tarmoq `main`, papka `/ (root)`, saqlang.

Bir-uch daqiqadan keyin GitHub koʻrsatadigan manzilni oching. U
`https://sizning-login.github.io/repozitoriy-nomi/` koʻrinishida boʻladi.

### 4. Yozib qoʻyish

`PUBLISHED.md` — ishlaydigan manzil bilan bir qator. Aynan shu 200 ga javob
boʻlishi tekshiriladi.

`NOTES.md` — nima ishladi, nima ishlamadi, chiqish qancha vaqt oldi.

## Tekshiruv

```bash
./check.sh
```

Oʻnta mahalliy tekshiruv va, manzil berilgan boʻlsa va `curl` borsa,
oʻninchi — tirik soʻrov oʻzingizning saytingizga.

## Sayt ochilmasa

- **404** — fayl nomi `index.html` emas, yoki papka `/ (root)` emas
- **boʻsh sahifa** — fayl bor, lekin boʻsh yoki HTML buzilgan
- **bogʻlangan fayllarda 404** — CSS va JS sahifa izlagan joyda emas
- **uzun kutish** — eʼlon qilish baʼzan bir necha daqiqa oladi

## Laboratoriya nimani tekshirmaydi

U layoutni tekshirmaydi va chiroyli ekanini ham tekshirmaydi. Bu — did, va
avtomatik tekshiruv uni almashtirmaydi.
