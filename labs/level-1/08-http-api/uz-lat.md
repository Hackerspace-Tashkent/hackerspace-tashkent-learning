# Lab 08: o'z HTTP serveringiz

## Nima qilish kerak

Havo sensori koʻrsatkichlarini beruvchi kichik API yozing.

| # | Talab | Tekshiriladi |
|---|---|---|
| 1 | `lab-work/api.py` fayli mavjud | ha |
| 2 | `http.server` ishlatilgan | ha |
| 3 | soʻrov qaydovchisi belgilangan | ha |
| 4 | `GET` qaydovchisi bor | ha |
| 5 | maʼlumot fayldan oʻqiladi | ha |
| 6 | `application/json` kontent turi qoʻyilgan | ha |
| 7 | `/health` yoʻli bor | ha |
| 8 | nomaʼlum yoʻllar `404` beradi | ha |
| 9 | server `127.0.0.1` da eshitadi | ha |
| 10 | `lab-work/NOTES.md` fayli mavjud | ha |
| 11 | server `/health` ga **haqiqatan** javob beradi | jonli tekshiruv |

11-tekishiruv fayl oʻqish emas: tekshiruv sizning serveringizni ishga
tushiradi va mijoz bilan soʻraydi. Javob bermasa, server chiqishini
koʻrsatadi — sabab u yerda.

## Tartib

1. Darsdagi kodni `lab-work/api.py` ga koʻchiring.
2. `lab-work/data.json` yarating, misol koʻrsatkichlar bilan.
3. Alohida terminalda `python3 api.py` ishga tushiring.
4. Uchta yoʻl boʻyicha `curl` bilan tekshiring.
5. `NOTES.md` da yozib javob bering:

**Misolda nega `/health` `/readings` dan oldin turadi?**

Maslahat: ularning oʻrni almashsa nima boʻlishini oʻylab koʻring.

## Tekshirish

```bash
./check.sh
```
