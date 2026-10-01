# Kod ichidagi sir

## Buni nega bilish kerak

Deyarli barcha dasturchilar tushunadigan, ammo yangi boshlovchi
tushunmaydigan narsa bor. Mana ssenariy:

```text
kalit bilan kodni kommit qildi  →  kalitni fayldan olib tashladi  →  yana kommit qildi
```

Bu nuqtada odam kalit yoʻqligiga ishonadi. **U yoʻq emas.** U tarixda
qoladi, va repositoriy nusxasi bor har kim uni bitta buyruq bilan
chiqarib oladi.

Sir tarixga kirgan zahoti oskor hisoblanadi — olib tashlangan zahoti
emas.

## Amaliyot nimani beradi

Ikkita kommitli repositoriy:

- birinchisi — kalit toʻgʻri `app.py` ichida;
- ikkinchisi — kalit olib tashlanib, muhit oʻzgaruvchisiga koʻchirilgan.

Kalit `vt-lark-tessera-5Q2fK`. Bu **ishontirilgan** nom: bunday xizmat
yoʻq, kalitni internetdan topib boʻlmaydi. Va sen uni tanlagan emas —
demak, uni faqat tushunib olish yoʻli bor.

## Ish tartibi

1. Fiksturni tayyorla:

```bash
bash setup-repo.sh
```

2. Joriy holatni koʻr — kalit unda yoʻq:

```bash
cd lab-work/repo
cat app.py
```

3. Uni tarixda top:

```bash
git log --oneline
git log -p
git log -p | grep -i token
```

4. Boshqa yoʻllar bor, ularni ham sinab koʻr — bu ham malaka:

```bash
git log -S'vt-lark' --oneline
git rev-list --all | while read c; do git grep -l 'vt-lark' "$c"; done
```

5. Joriy versiyada kalit yoʻqligini tekshir:

```bash
grep -rn 'vt-lark' . || echo "joriy versiya toza"
```

6. `lab-work/proof.txt` da topilgan kalitning xeshini yoz — sha256 ning
   birinchi 12 belgisi:

```bash
printf '%s' 'vt-lark-tessera-5Q2fK' | sha256sum | cut -c1-12 > ../proof.txt
```

7. `notes.md` da javob ber: **kalit haqiqatan yoʻq boʻlishi uchun nima
   qilish kerak?**

## E'tib beriladigan javob

Joriy fayl toza — bu hech narsani oʻzgartirmaydi. Tarix **barcha**
versiyalarni saqlaydi, oʻchirilganlarini ham. Variantlar:

- **kalitni almashtirish** — yagona haqiqiy echim. Eskisi tarixda
  boʻlgani uchun oskor hisoblanadi;
- tarixni qayta yozish (`git filter-repo`, BFG) — izni repositoriy dan
  olib tashlamaydi, lekin kalit allaqachon biror joyga borib ketganini
  bekor qilmaydi;
- repositoriy allaqachon forklangan yoki klonlangan boʻlsa — iz
  boshqalarga ketgan, tarixni qayta yozish foyda bermaydi.

Shundan qoida: **sirlar repositoriyga umuman qoʻyilmaydi.**
`.gitignore` fayllarga yordam beradi, lekin e'tiborsizlikdan himoya
qilmaydi — bir `git add -f` erta ketadi.

## Sir qayerda boʻlishi kerak

| Qayerda | Mos keladimi |
|---|---|
| muhit oʻzgaruvchisi | ha |
| gitga kirmaydigan fayl | ehtiyot boʻling: yigʻimga tushishi mumkin |
| sirlar menejeri | ha |
| toʻgʻridan-toʻgʻri kodda | yoʻq |

SII haqidagi darsga eʼtibor ber: unda alohida aytilganki, sirli
kodni suhbatga qoʻyish mumkin emas. Bu ham shu holat.

## Muhim

Bu erdagi repositoriy sizniki, laboratoriya papkasida turibdi, kalit
ishontirilgan. Haqiqiy kalitlar bilan shunday qilinmaydi — ularni
odimga tushishi mumkin boʻlgan joyga qoʻymaydi.