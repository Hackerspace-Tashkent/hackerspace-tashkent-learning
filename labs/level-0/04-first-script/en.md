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

## Practice

1. Create `lab-work` and go into it.
2. Write `greet.py`: it asks for a name and greets the user. Make it executable.
3. Write `count.py`: it takes a filename as an argument and prints how many lines that file has.
4. Create a text file `data.txt` with at least 5 lines.
5. Run `./count.py data.txt` and check the result.
6. Write `report.py` that reads all `.txt` files in the current directory and prints their total line count.

```bash
cd labs/level-0/04-first-script
./check.sh
```
