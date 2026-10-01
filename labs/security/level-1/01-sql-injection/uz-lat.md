# Lab S1-01: SQL inyektsiyasi

| # | Talab | Tekshiriladi |
|---|---|---|
| 1 | `srv.py` fayli mavjud | ha |
| 2 | `srv.py` sqlite3 ishlatadi | ha |
| 3 | kalit `srv.py` ga yozib qoʻyilmagan | ha |
| 4 | `proof.txt` da chiqarilgan kalitning xeshi bor | qayta hisoblanadi |
| 5 | inyektsiya ikkinchi jadvaldan kalitni chiqaradi | jonli tekshiruv |
| 6 | `notes.md` fayli mavjud | ha |

Kalit faqat **bazada** turibdi — alohida faylda yoʻq. Shuning uchun
`cat` uni olib kelmaydi: yagona yoʻl — inyektsiya.

5-tekshiruv qatorlarni sanamaydi: u `UNION` yuboradi va javobda
**oʻz bazangizdagi kalitni** izlaydi. Birinchi inyektsiya faqat
`people` ni boʻshatadi — `vault` gacha shu yoʻl bilan borilmaydi.

Eslatma: `srv.py` **zaif boʻlishi kerak**. Bu vazifa, xato emas.
Tozalasang, vazifa hisoblanmaydi.

## Tartib

1. `bash setup.sh` — `data.db` yaratadi.
2. Qator yopishtirish bilan `srv.py` yoz.
3. Halol soʻrov → bitta qator.
4. `' OR '1'='1` → `people` ning barcha qatorlari.
5. `vault` ga UNION → kalit.
6. Kalit xeshi → `proof.txt`.

## Tekshirish

```bash
./check.sh
```
