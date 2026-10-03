# Oʻz papkangizdan tashqariga chiqish

## Nima uchun bilish kerak

Serverga koʻpincha aytiladi: «`notes.txt` faylini ber». Ism soʻrovdan
keladi. Agar oʻrniga `../../etc/passwd` yuborilsa nima boʻladi?

Server yoʻlni qoʻshadi: `public/` + `../../etc/passwd`. Va u berishni
nima qilmoqchi boʻlmagan faylni oladi. Bu **path traversal**.

## Nima uchun ishlaydi

Server oʻziga oson vazifani deb oʻylaydi: «qaysi fayl soʻraldi».
Aslida boshqa vazifani hal qilmoqda: «bu ismga ishonish kerakmi».

`notes.txt` va `../../etc/passwd` farqi -- ikki nuqta. Satrlarni
qoʻshadigan server hech narsani koʻrmaydi.

## Chiqishi kerak boʻlgani

**Faqat oʻz papkangizdan** fayllar berilishi kerak. Uchta savol:

1. Soʻrovdagi ism yoʻlga qanday kiradi?
2. Uning ichida `..` boʻlsa nima boʻladi?
3. `/` bilan boshlanuvchi absolyut yoʻl boʻlsa nima boʻladi?

## Qanday yopiladi

**Qoʻshgandan keyin tekshirish.** Toʻliq yoʻlni quring va u aynan
xizmat qilmoqchi boʻlgan papka bilan boshlanishini tekshiring.

```python
full = os.path.realpath(os.path.join(ROOT, name))
if not full.startswith(os.path.realpath(ROOT) + os.sep):
    raise PermissionError("papkadan tashqariga")
```

**Absolyut yoʻllarni qabul qilmaslik.** `/etc/passwd` kabi ism fayl
nomi boʻlib qolishi kerak, yoʻl emas.

**Yomon ismlarni rad etish.** Taqiqlangan qismalar roʻyxati (`..`,
`\0`) arzon birinchi chiziq, lekin yagona emas.

**Identifikatorni butunlay almashtirish.** Eng ishonchli yoʻl: soʻrov
satrini yoʻlga umuman kiritmaslik. Raqam soʻrang va oʻz roʻyxatingiz
dan qidiring.

## Sen nimaga qilasan

Server avval zaif boʻlib turadi. Uni aylanib oʻtasan, keyin teshikni
yopasan va har bir chora nima uchun ishlashini tushuntirasan.

## Chegara

Faqat oʻz kompyuteringiz, faqat `localhost`, faqat fikstura
fayllari. Begona serverlar va haqiqiy `/etc/passwd` yoʻq.
