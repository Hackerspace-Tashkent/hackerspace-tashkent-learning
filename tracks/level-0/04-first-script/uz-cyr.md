# 4-дарс. Биринчи скриптингиз

Скрипт — битта дастур сифатида бажариладиган буйруқлар файли. Бир хил нарсани ҳар сафар йозмасдан бир марта сақлаб, доим ишга туширасиз.

##  Салом, скрипт

Биринчи қатор қайси интерпретатор ишлатилишини айтади. Кейин Python қавс ичидагини чиқаради.

```python
#!/usr/bin/env python3
print("Hello, Hackerspace!")
```

`hello.py` деб сақланг ва ишга туширинг. Бажаришга рухсат беринг — енди `python3` йозмасдан ишга туширасиз.

```bash
chmod +x hello.py
./hello.py
```

## Ўзгарувчилар ва шартлар

```python
name = input("Your name: ")
if name:
    print(f"Nice to meet you, {name}!")
else:
    print("Hello, stranger!")
```

## Цикллар

```python
for i in range(1, 6):
    print(f"{i} squared is {i ** 2}")
```

## Файллар билан ишлаш

Скриптлар файллар билан ишлаганда фойдали бўлади. Контекст-менеджер файлни ўзи йопади, ҳатто хато бўлса ҳам.

```python
with open("notes.txt", "w", encoding="utf-8") as f:
    f.write("first line\n")
    f.write("second line\n")
```

Қаторларни санаш — биринчи классик вазифа. Амалийотда ҳам шу сўралади.

```python
count = 0
with open("notes.txt", encoding="utf-8") as f:
    for line in f:
        count += 1
print("lines:", count)
```

> **Изоҳ.** Хатолар нормал ҳолат. Трацебацкнинг охирги қаторини ўқинг — у одатда нимани хато еканини аниқ айтади.
