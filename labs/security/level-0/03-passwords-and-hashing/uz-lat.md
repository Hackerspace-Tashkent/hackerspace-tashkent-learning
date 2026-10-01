# Lab S0-03: parollar va xeshlar

| # | Talab | Tekshiriladi |
|---|---|---|
| 1 | `brute.py` fayli mavjud | ha |
| 2 | `crack.txt` da izlanayotgan xeshga mos parol bor | ha |
| 3 | `proof.txt` fayli mavjud | ha |
| 4 | `salted.py` pbkdf2 ishlatadi | ha |
| 5 | `salted.py` tuz ishlatadi | ha |
| 6 | `salted.py` da ikki xil tuz bor | ha |
| 7 | ishga tushirganda bir parol uchun **uch xil xesh** chiqadi | jonli tekshiruv |
| 8 | `notes.md` fayli mavjud | ha |

Yettinchi — fayl oʻqish emas. U sizning skriptingizni ishga tushiradi va
bir parol uchun uch xil qiymat talab qiladi: tuzsiz, birinchi tuz, ikkinchi
tuz. Bitta tuz yetarli emas, bu alohida tekshiriladi.

## Tartib

1. `bash setup.sh` — `hashes.txt` va `target.txt` yaratadi.
2. `brute.py` yoz, parolni top, `crack.txt` ga yoz.
3. Xeshni `proof.txt` ga yoz.
4. Uchta chiqish bilan `salted.py` yoz.
5. `notes.md` da javob ber: parol baribir tanlansa, tuzning nima keraği bor?

## Tekshirish

```bash
./check.sh
```
