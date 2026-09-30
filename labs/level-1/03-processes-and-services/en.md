# Lesson 7. Processes and services

Every running program is a process with a number. Knowing how to look at them, put them in the background and stop them politely is the difference between a working machine and a mysterious one.

## Looking at processes

```bash
ps                  # процессы текущего терминала
ps aux               # все процессы всех пользователей
ps -ef               # то же, другой формат
top                  # обновляется live, q — выход
pgrep -f "python"    # найти по имени
```

Every process also has a directory in `/proc` with the same number. It is the honest way to see what a program thinks about itself.

## Background and stopping

```bash
sleep 300 &        # запустить в фоне
jobs                # что запущено из этого терминала
nohup ./long.sh &   # пережить закрытие терминала
disown -a           # забыть о фоновых процессах

kill 12345          # попросить завершиться (SIGTERM)
kill -9 12345       # убить немедленно (SIGKILL)
```

> **Note.** `kill` without a capital K is not a joke: plain `kill` asks politely. `-9` cannot be caught, so a program has no chance to clean up. Try polite first.

## Catching a signal

`trap` lets a script run its own cleanup when it is asked to stop. Without it, a half-written file stays half-written.

```bash
#!/usr/bin/env bash
tmp="work.tmp"

cleanup() {
  echo "cleaning up..."
  rm -f "$tmp"
}
trap cleanup EXIT TERM

echo "working" > "$tmp"
sleep 30
```

> **Note.** A trap that only logs and returns is not enough: your loop keeps running and the process never ends. Log, then `exit 0` inside the handler. And remember that bash handles a trap only after the command that is currently running finishes — a script sitting in `sleep 300` will ignore your `kill` for up to five minutes. That is why the practice uses short sleeps.

## Services with systemd

On a real Linux machine, `systemd` starts programs at boot, restarts them when they crash and collects their output. A service is described by a unit file.

```ini
[Unit]
Description=My report service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/report.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Load it with `systemctl daemon-reload`, start with `systemctl start report`, watch with `journalctl -u report -f`.

> **Note.** A Codespace is a container, so `systemd` is not PID 1 and `systemctl status` will not work there. The practice therefore checks that your unit file is correct, not that a service is running. You will run it on a real machine.
