# Dastur: oʻz papkangizdan tashqariga chiqish

## Nimaga berilgan

`lab-work/` da fikstura yaratdi:

- `public/` -- papka, undagi fayllar **berilishi kerak**:
  `index.html` va `notes.txt`;
- `secret.txt` -- xizmat fayli `public/` **yonida**, lekin ichida emas.
  U tashqariga chiqmasligi kerak.

## Qadamlar

1. Fikstura tayyorlang:

```bash
bash setup.sh
```

2. Nima paydo boʻlganini koʻring:

```bash
ls -R lab-work
```

3. `srv.py` yozing:

- `GET /` -- `public/index.html` ni beradi;
- `GET /<ism>` -- soʻrovdagi ism boʻyicha `public/` dan fayl beradi;
- `python3 srv.py <port> [--unsafe]` -- port raqamini argument oladi,
  qoʻshimcha `--unsafe` belgisi bilan;
- **belgisiz** server xavfsiz ishlaydi va `public/` dan tashqarida
  hech narsani chiqarmaydi;
- **`--unsafe` bilan** ismni `public/` ga tekshiruvsiz qoʻshadi --
  teshik shunda koʻrinadi.

Qoʻshish shunday koʻrinadi:

```python
path = os.path.join(ROOT, name)
```

4. Ishga tushiring va oddiy fayl berilishini tekshiring:

```bash
cd lab-work
python3 srv.py 8103
```

Boshqa terminalda:

```bash
curl http://127.0.0.1:8103/notes.txt
```

5. ** `--unsafe` bilan ishga tushirilgan** serverni aylanib oʻting:

```bash
cd lab-work
python3 srv.py 8103 --unsafe
```

Boshqa terminalda yuboring:

```
curl --path-as-is http://127.0.0.1:8103/../secret.txt
```

`--path-as-is` kerak, aks holda `curl` yoʻlni oʻzi qisqartiradi. Javobda
`secret.txt` mazmuni kelsa -- teshik topildi.

6. **`secret.txt` ni oʻchirmang.** Faylni oʻchirish yechim emas, u
faqat shuning uchun tekshiruvdan oʻtadi. Tekshiruv buni alohida
kuzatadi.

7. Endi teshikni yoping. `os.path.realpath` orqali toʻliq yoʻlni quring
va u `public/` bilan boshlanishini tekshiring. Ikkalasini ham sinab
koʻring: `/../secret.txt` va `/../../etc/passwd`.

8. Serverni qayta ishga tushiring: oddiy fayl qaytadi, chetlab oʻtish
esa ishlamaydi.

## Tekshiriladigan

| | |
|---|---|
| 1 | `srv.py` fayli mavjud |
| 2 | server HTTP orqali javob beradi |
| 3 | oddiy fayl beriladi |
| 4 | yoʻlni chetlab oʻtish `secret.txt` ga yetadi |
| 5 | yopilgandan keyin chetlab oʻtish ishlamaydi |
| 6 | `secret.txt` oʻchirilmagan |

5 va 6 bitta narsani tekshiradi: server bir vaqtda ham faylni bera
olmaydi, ham bermay olmaydi. Shuning uchun u ikki rejimda ishlaydi va
tekshiruv uni ikki marta ishga tushiradi: avval `--unsafe` bilan, keyin
flag siz.

## G chegarasiga yetish

Nega faqat `..` yoʻqligini tekshirish yetarli emas:

- `....//` va `%2e%2e%2f` -- bu xuddi shu `../`, boshqacha yozilgan;
- ism `/` bilan boshlanib absolyut yoʻl boʻlib chiqishi mumkin;
- `public/` ichidagi simvolik havolaning oʻzi tashqariga koʻrsatadi;
- registr va kodlash ham muhim.

Ishonchli natija soʻrovdan kelgan satrga umuman ishonish toʻxtaganda
paydo boʻladi.
