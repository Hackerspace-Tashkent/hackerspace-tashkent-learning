# Lesson 5. Bash scripts

You have run commands by hand. A script saves a sequence of commands so you can run it again without retyping.

```bash
#!/usr/bin/env bash
# Описание: что делает скрипт
echo "Hello from a script"
```

## Variables

A variable is a name for a value. There are no types, and quotes decide whether a value stays one piece or splits into words.

```bash
name="Tashkent"
count=3
file="my notes.txt"

echo "$name"      # Tashkent
echo $name        # то же самое, но кавычки безопаснее
echo "$file"      # my notes.txt — один аргумент
echo $file        # my и notes.txt — два аргумента
```

> **Note.** Always quote variables: "$var". Unquoted values break on spaces and empty values disappear.

## Conditions

```bash
if [ -f /etc/hostname ]; then
  echo "file exists"
elif [ -d /etc ]; then
  echo "directory exists"
else
  echo "neither"
fi
```

- `-f` file exists
- `-d` directory exists
- `-e` anything exists
- `-s` file is not empty
- `-z` string is empty
- `-n` string is not empty
- `=` strings are equal
- `-gt` `-lt` greater / less

## Loops

```bash
for f in *.txt; do
  echo "found: $f"
done

n=0
while [ "$n" -lt 3 ]; do
  echo "round $n"
  n=$((n + 1))
done
```

## Functions and arguments

A script receives arguments in `$1`, `$2` and so on. `$#` is how many there are, `"$@"` is all of them, and `shift` drops the first one.

```bash
#!/usr/bin/env bash
if [ "$#" -lt 1 ]; then
  echo "usage: $0 <name> [age]" >&2
  exit 1
fi

name="$1"
age="${2:-unknown}"

echo "name=$name"
echo "age=$age"
```

## Exit codes

Every command ends with a number: 0 means success, anything else means failure. `$?` holds the code of the last command.

```bash
set -e   # остановиться при первой ошибке
set -u   # считать ошибкой неопределённую переменную
set -o pipefail   # ошибка в пайпе, если кто-то в нём упал
```

> **Note.** `set -e` has sharp edges: it does not trigger in `if`, in a negated condition, or in a pipeline except the last command. Use it in scripts, not blindly in an interactive shell.
