# 4-dars. Birinchi skriptingiz

Skript — bitta dastur sifatida bajariladigan buyruqlar fayli. Bir xil narsani har safar yozmasdan bir marta saqlab, doim ishga tushirasiz.

##  Salom, skript

Birinchi qator qaysi interpretator ishlatilishini aytadi. Keyin Python qavs ichidagini chiqaradi.

```python
#!/usr/bin/env python3
print("Hello, Hackerspace!")
```

`hello.py` deb saqlang va ishga tushiring. Bajarishga ruxsat bering — endi `python3` yozmasdan ishga tushirasiz.

```bash
chmod +x hello.py
./hello.py
```

## O'zgaruvchilar va shartlar

```python
name = input("Your name: ")
if name:
    print(f"Nice to meet you, {name}!")
else:
    print("Hello, stranger!")
```

## Tsikllar

```python
for i in range(1, 6):
    print(f"{i} squared is {i ** 2}")
```

## Fayllar bilan ishlash

Skriptlar fayllar bilan ishlaganda foydali bo'ladi. Kontekst-menedjer faylni o'zi yopadi, hatto xato bo'lsa ham.

```python
with open("notes.txt", "w", encoding="utf-8") as f:
    f.write("first line\n")
    f.write("second line\n")
```

Qatorlarni sanash — birinchi klassik vazifa. Amaliyotda ham shu so'raladi.

```python
count = 0
with open("notes.txt", encoding="utf-8") as f:
    for line in f:
        count += 1
print("lines:", count)
```

> **Izoh.** Xatolar normal holat. Traceback'ning oxirgi qatorini o'qing — u odatda nimani xato ekanini aniq aytadi.
