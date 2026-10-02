# Lesson 2. Files and permissions

Linux has no separate folders for programs and documents. Everything is a file, and every file has permissions.

## Reading permissions

`ls -l` shows the owner, the group, and three permission triplets: `rwx` for owner, group and others. `r` is read, `w` is write, `x` is execute.

```bash
ls -l
-rw-r--r--  1 user user  2048 Sep 30 10:00 notes.txt
```

## Changing permissions

`chmod` changes permissions. Numbers are easier to remember: 4 read, 2 write, 1 execute.

```bash
chmod 644 notes.txt   # rw-r--r-- : ordinary file
chmod 755 script.sh  # rwxr-xr-x : script
chmod +x script.sh   # just make it executable
```

`chown` changes the owner. You can change the group of your own files with `chgrp`.

```bash
chgrp developers notes.txt
```

## Archives

```bash
tar -czf backup.tar.gz my-project/
tar -tzf backup.tar.gz
tar -xzf backup.tar.gz
```

## A tiny editor

`nano` is a terminal text editor. Ctrl+O saves, Ctrl+X exits.

```bash
nano notes.txt
```

## What a script is

A script is an ordinary text file holding commands. The `.sh` extension
does nothing by itself: Linux looks at the first line.

```bash
#!/bin/bash
echo "Hello, this is my first script"
```

That first line is the **shebang**. It tells the system which interpreter
to run. It is not executed itself — it is a hint.

Create `hello.sh`, put those two lines in it, then:

```bash
chmod +x hello.sh
./hello.sh
```

Without `chmod +x` you get "Permission denied": the system does not treat
the file as a program it may run.

> **Note.** To run a script directly, it needs the execute bit: `chmod +x script.sh`.
