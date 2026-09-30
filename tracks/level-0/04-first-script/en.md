# Lesson 4. Your first script

A script is a file of commands that runs as one program. Instead of typing the same commands again, you save them once and run them forever.

## Hello, script

The first line tells the system which interpreter to use. Then Python prints whatever is in the quotes.

```python
#!/usr/bin/env python3
print("Hello, Hackerspace!")
```

Save it as `hello.py` and run it. Make it executable so you can run it without `python3`.

```bash
chmod +x hello.py
./hello.py
```

## Variables and conditions

```python
name = input("Your name: ")
if name:
    print(f"Nice to meet you, {name}!")
else:
    print("Hello, stranger!")
```

## Loops

```python
for i in range(1, 6):
    print(f"{i} squared is {i ** 2}")
```

## Working with files

Scripts become useful when they handle files. A context manager closes the file for you, even if something fails.

```python
with open("notes.txt", "w", encoding="utf-8") as f:
    f.write("first line\n")
    f.write("second line\n")
```

Counting lines is a classic first task. This is also what the lab asks you to do.

```python
count = 0
with open("notes.txt", encoding="utf-8") as f:
    for line in f:
        count += 1
print("lines:", count)
```

> **Note.** Errors are normal. Read the last line of the traceback — it usually tells you exactly what went wrong.
