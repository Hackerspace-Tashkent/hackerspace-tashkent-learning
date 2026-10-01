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

> **Note.** To run a script directly, it needs the execute bit: `chmod +x script.sh`.
