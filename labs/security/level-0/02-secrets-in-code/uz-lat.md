# Lab S0-02: kod ichidagi sir

| # | Talab | Nimani anglatadi |
|---|---|---|
| 1 | `proof.txt` da tarixda topilgan kalitning xeshi bor | sen haqiqatan tarixda izlagan |
| 2 | `lab-work/notes.md` da javob bor, boʻsh fayl emas | boʻsh fayl hisobga olinmaydi |
| 3 | oʻzingizning ishingizni kommit qildingiz | fixture 2 ta kommit qoʻyadi, sen 3 ta qilasan |
| 4 | `.gitignore` ga sir haqida yozuv qoʻshildi | shunchaki fayl emas, maʼnoli yozuv |
| 5 | tarix kalitni saqlab turibdi — va bu toʻgʻri | tarixni **qayta yozma** |

Beshinchi punqt gʻoyangi koʻrinadi, va asl shu. Kalit ikkinchi
kommitda allaqachon fayldan olib tashlangan — ammo u tarixda turibdi.
Agar buni tarixni qayta yozib «tuzatsang», vazifa hisoblanmaydi:
haqiqiy ishda bunday qilinmaydi. Kalit yoʻq deb hisoblanadi va yangisi
chiqariladi.

**Bularning birortasi fixture ga yozib qoʻyilmaydi.**
`setup-repo.sh` senga beshdan aniq noldan beradi.

## Tartib

1. `bash setup-repo.sh` — ikki kommitlik tarix bilan
   `lab-work/repo` ni yaratadi. Kalit birinchisida, ikkinchisida yoʻq.
2. Darsdagi buyruqlar bilan kalitni tarixda top.
3. Uning xeshini `lab-work/proof.txt` ga yoz.
4. `.gitignore` ga sir haqida yozuv qoʻsh — masalan, `*.secret` va
   `.env` — va **kommit qil**. Kommit qilmasang 3 va 4 hisoblanmaydi.
5. `lab-work/notes.md` da javob ber: kalit haqiqatan yoʻq boʻlishi uchun
   nima kerak?

## Tekshirish

```bash
./check.sh
```
