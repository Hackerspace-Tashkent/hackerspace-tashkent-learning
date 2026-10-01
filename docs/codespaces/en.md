# How to run the practice in a Codespace

A Codespace is a Linux machine in the browser. Nothing to install, nothing to break.

## Start

1. Open the repository on GitHub on the `main` branch — the labs are in `labs/`.
2. Click the green **Code** button, then the **Codespaces** tab.
3. Choose a machine size: **2 cores, 4 GB** is enough for every practice in this track.
4. Click **Create codespace** and wait about a minute.

## Run the check

```bash
cd labs/level-0/01-terminal
./check.sh
CHECK_LANG=en ./check.sh
```

Each line shows whether a task is done. The script exits with code 0 when everything is finished.

## Keeping costs low

Codespaces bill by the hour and idle ones keep burning quota. The repository is configured to avoid that.

- **Small machine.** The devcontainer requests 2 cores and 4 GB, the cheapest size that works.
- **Nothing heavy inside.** No desktop, no build tools unless the lesson needs them.
- **Stops when you close it.** The devcontainer sets `shutdownAction: stopContainer`:
  close the Codespaces window and the machine stops on its own.
- **Organization limits are not configured.** The 30-minute idle stop and the 0-day retention
  are not set. That means: rely on stopping it yourself.

> **Important.** An idle codespace still counts against your quota. Close it yourself:
> in the Codespaces menu choose *Stop codespace*. Deleting takes a few seconds.
> If you hit the limit, close the machines you are not using first.

## If the Codespace is too slow

The practice is small on purpose. On a slow connection, install nothing extra and do the tasks in the same order — each one depends on the previous.
