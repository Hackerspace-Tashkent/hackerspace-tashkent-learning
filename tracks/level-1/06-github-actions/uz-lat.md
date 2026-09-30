# Dars 6. GitHub Actions

## Bu nima

GitHub Actions — sizning kodingizni sizning oʻrnigizga ishlatadigan kompyuter.
Repozitoriyga nima qilish kerakligini yozib qoʻyasiz, GitHub esa har bir
pushda buni oʻz kompyuteringizsiz bajaradi.

```
siz kod push qilasiz  →  GitHub sezadi  →  virtual mashina ishga tushadi
                      →  buyruqlarni bajaradi  →  natijani koʻrsatadi
```

Asosiy foyda: **tekshiruv kimning eslab qolishiga bogʻliq emas.** Kimdir
buzilgan kodni push qilsa — darim buziladi. Va hammada bir xil buziladi.

## Fayl qayerda boʻladi

`.github/workflows/nom.yml` repositoriya ildizida. Nom ixtiyoriy, kengaytma
`yml` yoki `yaml`. `.github/workflows/` ichidagi hammasi avtomatlashtirish
tavsifi deb hisoblanadi.

Bu **oddiy matn**, sir emas. Ochib, oʻqib, qoʻlda tuzatish mumkin.

## Minimal workflow

```yaml
name: Tekshiruv

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Kodni olish
        uses: actions/checkout@v4

      - name: Laboratoriyani tekshirish
        run: ./labs/level-0/01-terminal/check.sh
```

Qator qator koʻrib chiqamiz.

**`name`** — interfeysda ish nomi.

**`on:`** — qachon ishga tushsin. `push` — har bir pushda, `pull_request` —
PR ochilganda. Boʻsh `push:` «shu turdagi har bir hodisada» degani.

**`jobs:`** — vazifalar. Bir nechta boʻlishi mumkin, ular parallel ishlaydi.

**`runs-on:`** — qaysi mashinada. `ubuntu-latest` — standart Linux.
`windows-latest` va `macos-latest` ham bor, ular sekinroq va qimmatroq.

**`steps:`** — job ichidagi qadamlar, ketma-ket. Xato bir qadam butun jobni
toʻxtatadi.

**`uses:`** — tayyor amal, boshqar tomonidan yozilgan. `actions/checkout` kodi
mashinaga olib keladi; u boʻlmasa kod papkasi umuman boʻlmaydi.

**`run:`** — bajariladigan buyruq. Bitta qator yoki blok:

```yaml
      - name: Bir nechta buyruq
        run: |
          bash -n labs/*/*/check.sh
          python3 tools/check_content.py
```

YAML da `|` blok «koʻp qatorli qiymat» degani.

## Avval nima tekshiriladi

Foydalilik boʻyicha tartib, murakkablik boʻyicha emas:

1. **Skript sintaksisi.** `bash -n` hech narsani bajaradi, faqat xatolarni
   qidiradi. Eng arzon tekshiruv, koʻpini ushlaydi.
2. **Materiallar validatori.** Bizda `tools/check_content.py` bor — oʻlgan
   havolalar, til mosligining buzilishi, yoʻq fayllar.
3. **Laboratoriyalarning oʻzi.** Ularni toʻliq ishga tushirib boʻlmaydi:
   oʻquvchi fayllari kerak. Lekin boʻsh holat halol yiqilishini tekshirish mumkin.
4. **Koʻrinish.** Boʻshliqlar, tablar, satir oxiri. `*.sh` uchun LF majburiy:
   CRLF `$'\r': command not found` beradi.

## Maxfiy maʼlumotlar

Har qanday token, kalit va parol — `secrets` orqali, hech qachon faylda
matn sifatida emas:

```yaml
      - name: Kirish
        run: gh auth login --with-token <<< "$TOKEN"
        env:
          TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Repozitoriyda maxfiy fayl boʻlsa, uni darhol almashtirish kerak — kommitni
oʻchirsangiz ham. Git tarixni saqlaydi.

## Nosozlikni tuzatish

Ish yiqilsa — aynan shu qadam logini oʻqing. Koʻp uchraydigan sabablar:

- `actions/checkout` unutilgan, kod papkasi yoʻq;
- skript bajarilmaydi — `chmod +x` kerak yoki `bash` orqali ishga tushiring;
- skript ichida CRLF, LF emas;
- buyruq nolga teng boʻlmagan natija berdi, siz kutganingizdan farqli.

Xato qator qator koʻrinadi. Taxmin qilmang — logni oʻqing.

## Tushunish kerak boʻlgan cheklov

Ommaviy repositoriylar uchun bepul daqiqalar keng, shaxsiylar uchun
chegirilgan va hisob boʻyicha umumiy. Bizning oʻquv repositoriyimiz ommaviy,
shuning uchun cheklov amalda yoʻq. Actionsni doimiy ogʻir hisoblashka
rejalashtirmang.

## Keyingi

Laboratoriya yonma-yoʻnda: `labs/level-1/06-github-actions`. Oʻz
workflow-ingizni yozib, GitHub uni ishga tushirganini tekshirasiz.
