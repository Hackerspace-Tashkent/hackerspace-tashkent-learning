# Track Level 1 — confident user

You can run commands. Now you make the machine work for you: scripts, schedules, services and the network.

- [Lesson 5. Bash scripts](01-bash-scripts/en.md) — variables, conditions, loops, functions, arguments, exit codes
- [Lesson 6. Automation and logs](02-automation-and-logs/en.md) — streams, log files, cron
- [Lesson 7. Processes and services](03-processes-and-services/en.md) — background, signals, `trap`, systemd units
- [Lesson 8. Networking](04-networking/en.md) — addresses, ports, `ss`, `curl`, hosts

## Before you start

Level 0 is assumed. If `check.sh` in the last Level 0 lesson still fails, go back first.

> **Note.** Lesson 7 has no running service to start: a Codespace is a container and `systemd` is not PID 1 there. The practice checks that your unit file is right; running it is the part you do on a real machine.

```bash
cd labs/level-1/01-bash-scripts
./check.sh
```
