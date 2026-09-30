# Lesson 1. Terminal and navigation

The terminal is the main tool on Linux. Almost everything in these lessons is done here.

Open a terminal and print the current directory:

```bash
pwd
```

List what is inside:

```bash
ls
ls -la
```

## Moving around

`cd` changes directory, `pwd` shows where you are. `~` is your home directory.

```bash
cd ~
cd /tmp
cd ..
pwd
```

`..` means one level up, `.` means the current directory.

## Creating and removing

```bash
mkdir my-project
cd my-project
touch readme.txt
ls
```

```bash
cp readme.txt readme.backup.txt
mv readme.backup.txt backup.txt
rm backup.txt
```

> **Note.** `rm` deletes without asking. There is no undo. Be careful.

## Reading files

```bash
cat readme.txt
head -5 readme.txt
tail -5 readme.txt
less readme.txt
```

## Chains and search

The pipe `|` passes the output of one command into the next one.

```bash
ls -la | less
cat readme.txt | wc -l
ls | grep txt
```

`find` searches for files by name, `grep` searches inside files.

```bash
find ~ -name '*.txt' 2>/dev/null
grep -r 'TODO' ~ 2>/dev/null | head
```

> **Note.** Press Tab to autocomplete a path. It saves a lot of typing.

## Practice

Do it in a Codespace, then run `./check.sh` — it tells you what is still missing.

1. Create the directory `lab-work`.
2. Go into it and create three files: `a.txt`, `b.txt`, `c.md`.
3. Write any text into `a.txt` and `b.txt`.
4. Copy `a.txt` to `backup.txt`, then rename the copy to `final.txt`.
5. Count how many lines are in `b.txt`.

```bash
cd labs/level-0/01-terminal
./check.sh
```
