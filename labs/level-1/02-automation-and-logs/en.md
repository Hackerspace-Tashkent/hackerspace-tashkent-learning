# Lesson 6. Automation and logs

A task that runs by itself is worth far more than a task you remember to do. This lesson is about making things happen on a schedule and leaving a trace.

## Output streams

Every command has three streams: standard output for results, standard error for problems, and standard input for input. `>` writes a file, `>>` appends, `2>` redirects errors.

```bash
ls > out.txt          # только stdout, очистит файл
ls >> out.txt         # добавит в конец
ls 2> err.txt         # только stderr
ls > all.txt 2>&1     # и то и другое в один файл
ls 2>&1 | grep txt    # ошибки тоже попадут в пайп
```

> **Note.** A log is a file you append to and never truncate. Use `>>`, and put the date at the start of every line.

```bash
#!/usr/bin/env bash
log="run.log"
printf '%s started\n' "$(date '+%F %T')" >> "$log"
printf '%s finished with code %d\n' "$(date '+%F %T')" "$?" >> "$log"
```

## Scheduling with cron

`cron` runs a command at a given time. Each line has five fields: minute, hour, day of month, month, day of week, then the command.

```bash
# минута час день месяц день_недели  команда
*/5 *   *   *     *            /home/me/report.sh
0  9   *   *     1-5          /home/me/backup.sh
30 18  *   *     *            /home/me/clean.sh
```

Never let cron mail you. Redirect both streams to a log file instead.

```bash
*/10 * * * * /home/me/report.sh >> /home/me/report.log 2>&1
```

## Editing your schedule

```bash
crontab -l     # показать текущие задачи
crontab -e     # изменить
crontab -r     # удалить все (осторожно)
```

A crontab is just a text file with one job per line. `crontab myfile` installs it, `crontab -l` shows what is installed. Keeping your schedule in a file — instead of editing it blind inside `crontab -e` — means you can keep it in git and reuse it on any machine.

> **Note.** In a Codespace the `cron` daemon is not running, so jobs you install will not fire on their own. The practice therefore works with a file: write your schedule, and check that the file is right. Installing and watching it is the part you do on a real machine.
