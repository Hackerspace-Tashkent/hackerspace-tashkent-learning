# Lab S0-04: HTTPS va sertifikatlar

| # | Talab | Tekshiriladi |
|---|---|---|
| 1 | `cert.pem` fayli mavjud | ha |
| 2 | `key.pem` fayli mavjud | ha |
| 3 | sertifikat `localhost` nomlaydi | ha |
| 4 | sertifikatda boshlanish va tugash sanasi bor | ha |
| 4 | `server.py` `ssl` ishlatadi | ha |
| 6 | `server.py` sertifikatni yuklaydi | ha |
| 7 | `proof.txt` da sertifikat izi bor | qayta hisoblanadi |
| 8 | klient **tekshiruv bilan** ulanadi | jonli tekshiruv |
| 9 | klient tekshiruvsiz ulanadi va buni aytadi | jonli tekshiruv |
| 10 | `notes.md` fayli mavjud | ha |

8 va 9 — fayl oʻqish emas: ular **sizning serveringizni ishga
tushiradi** va unga haqiqatan ulanadi. Ikkala natija ham kerak:
tekshiruv bilan va uningsiz. Faqat ikkinchisi hech nimani isbotlamaydi,
faqat birinchisi tekshiruv nima uchun kerakligini koʻrsatmaydi.

## Tartib

1. Darsdagi buyruq bilan sertifikat chiqar.
2. `server.py` va `client.py` yoz.
3. Izni `proof.txt` ga yoz.
4. `notes.md` da javob ber: shifrlash ishlayapti boʻlsa, tekshiruv
   nima uchun kerak?

## Tekshirish

```bash
./check.sh
```
