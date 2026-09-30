# Laboratoriya: GitHub Actions

## Nima qilish kerak

Hamma narsa shu fayl yonidagi `lab-work/` da. Papka yoʻq — yarating.

```bash
cd "$(dirname check.sh)"
mkdir -p lab-work/.github/workflows
cd lab-work
```

### 1. Oʻz workflow-ingiz

`.github/workflows/ci.yml` yarating:

```yaml
name: Mening tekshiruvlarim

on:
  push:
  pull_request:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Kodni olish
        uses: actions/checkout@v4

      - name: Skript sintaksisi
        run: bash -n labs/*/*/check.sh

      - name: Materiallarni tekshirish
        run: python3 tools/check_content.py
```

Bu yerdan koʻchirib, oʻzingizcha toʻgʻirlang. Bu darsdagi bilan bir xil
misol.

### 2. Avval nima tekshirish

Foydalilik boʻyicha:

1. `bash -n` — faqat sintaksis, hech narsa bajarilmaydi;
2. `tools/check_content.py` — havolalar va tillar;
3. laboratoriyalarni boʻsh holatda sinab koʻrish.

### 3. Ishga tushirish

```bash
git init -q -b main
git remote add origin https://github.com/sizning-login/sizning-repo.git
git add .
git commit -m "Add a workflow that checks things"
git push -u origin main
```

Bir daqiqadan keyin repositoriyada **Actions** oʻynini oching. Ish yashil,
yoki qizil boʻlsa, qaysi qadamda tushganini koʻrsatadi.

Qizil boʻlsa — oʻsha qadam logini oʻqing, taxmin qilmang.

### 4. Yozish

`NOTES.md` — nimani tushundingiz, nima qiziqarli bo'ldi, qayerda to'xtadingiz.
Uch qator yetchi.

## Tekshiruv

```bash
./check.sh
```

Toʻqqizta mahalliy tekshiruv va, `gh` boʻlsa, oʻninchi onlayn tekshiruv.

## Ehtiyot boʻling

Workflow ichidagi skript boshqaning mashinasida, repositoriyga kirish huquqi
bilan ishlaydi. Maxfiy maʼlumotlar — faqat `secrets` orqali. Tokenni hech
qachon toʻgʻridan-toʻgʻri YAMLga yozmang.
