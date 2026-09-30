# Progress board

This issue collects practice results. Students do not fill it in manually —
`check.sh --submit` inside a Codespace posts a comment here, and a workflow
appends it to the board below and to `board/data.json`.

**Nothing here is written by hand.** If a comment looks like a result but was
typed by a person, the workflow ignores it — only the machine marker counts.

## How it works

```
cd labs/level-0/01-terminal
./check.sh           # check only
./check.sh --submit  # check and publish the result
```

All work happens in `./lab-work` next to the script, so nothing is written to
your home directory. The result marker is invisible in the rendered comment: a
GitHub Action reads it, stores one line per student per lesson in
`board/data.json`, and regenerates the table below.

## What is honest about this

The marker is not a signature. Anyone who reads `check.sh` can post a
perfect score by hand. The board therefore measures **motivation and visible
progress, not certification**. Do not treat it as a diploma. If the score
matters later, it needs proctoring — a short review where the student explains
their work, which is what the final project already is.

## Privacy

A submission contains your GitHub handle, the lesson, the score, the interface
language and the timestamp. It is public and permanent. If you would rather stay
anonymous, do not use `--submit` — running `./check.sh` alone changes nothing
outside your Codespace.

## Re-running

A new attempt replaces the previous one for the same lesson, so the board always
shows the latest state. To go back, post a fresh result.
