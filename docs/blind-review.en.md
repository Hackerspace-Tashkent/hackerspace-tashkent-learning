# Blind pass and quality review

Date: 2 October 2026
Method: a separate agent session on a different model, given only the
lesson and the practice text, forbidden from reading the reference
solution or the checker source.

## Why this is needed

Until now I reviewed my own work: I wrote the material, then walked it
myself, then ran tools that I also wrote. That is self-review, and it has
a blind spot. I check what I suspected.

A blind pass works differently. A fresh session does not know how the
lesson was written. It gets the lesson and the practice and is told: do
this, using only what is in front of you. It looks for a way forward and
gets stuck where a person gets stuck, not where I suspected a problem.

The model was not chosen at random: different weights and a different
provider, not a copy of the same one.

## What the pass showed

Eleven practices passed cleanly, with no sticking point anywhere:

| practice | result |
|---|---|
| level-0-01-terminal | 8/8 |
| level-0-02-files-and-permissions | 7/7 |
| level-0-03-git-basics | 6/6 |
| level-0-04-first-script | 7/7 |
| level-1-01-bash-scripts | 8/8 |
| level-1-02-automation-and-logs | 11/11 |
| level-1-03-processes-and-services | 10/10 |
| level-1-06-github-actions | 10/10 |
| level-1-08-http-api | 11/11 |
| security-03-passwords-and-hashing | 8/8 |
| security-01-sql-injection | 6/6 |
| security-02-secrets-in-code (separate run) | 5/5 |

That is a fact in our favour: I had assumed the holes were everywhere.

Four practices produced no result: three timeouts and one interruption.
The free models enforce a fair-share limit and do not survive parallel
runs. They need to run sequentially with pauses.

## Defects found and fixed

**`notes.md` had no path.** The lesson said "answer in notes.md", the
checker looked for `lab-work/notes.md`. A learner writes the file where
they are standing, which is one level deeper. Reproduced by hand: 4/5
instead of 5/5.

**`wc` was never explained.** The lesson shows `cat readme.txt | wc -l`
as a pipeline example and then explains `find` and `grep`. It says
nothing about `wc` or `less`, and the practice requires counting lines.

**A script with no contents.** The practice asks for `hello.sh` and
`chmod +x`. The lesson explains the execute bit, but `#!/bin/bash`
appeared zero times: nothing says what goes inside the file, or why the
system reads the first line rather than running it.

**My own tool missed all of it.** `cold_pass.py` checks that the lesson
mentions the required file. It does not check that the path it mentions
matches where the checker looks. "The word is there" is not "the word is
right".

## Quality review: three invented findings out of four

A separate request: not "will it pass", but "is this well written". The
model reported four specific gaps between theory and practice.

Three did not hold up. It claimed the practice requires `sys.argv` and
`os.listdir`/`glob`, which the lesson never teaches. Neither string
appears in the lesson **or** in the practice. It also said the lesson
does not teach writing scripts; `chmod +x` appears there twice.

In its report it admitted it had seen only the Russian files and guessed
the rest.

**The conclusion worth writing down:** a critic model produces confident
citations of text it never read. Every claim has to be verified by hand.
Without that step you get a confident report on invented defects, and the
real findings get lost in it.

## Two mistakes in the method itself

**The learner was given only the lesson.** On the first run, the
git-basics practice scored 2/6 with a report that the lesson did not
cover the `experiment` branch, `idea.md` or `tmp/`. I went to check, and
the mistake was mine: the practice contains all six steps including
those. I simply never told the learner to open the practice file. Running
it by hand gave 6/6, and the reworked harness confirmed that.

This is the second form of one mistake: earlier the harness measured a
state no person is ever in.

**The learner wrote into the live repository.** The GitHub Pages session
created `.github/workflows/pages.yml` — the workflow the practice asks
for — which `git add -A` swept into the index and which would have run on
every push to `main`. The token caught it: it is not allowed to touch
workflows, so the push was refused.

Learners now work in a separate copy of the repository. Cleaning up
afterwards did not help: the file reaches the index first.

## What this does not prove

Eleven green runs are eleven models, not people. Not one person has
walked a topic end to end. The check shows the instructions are written
well enough to reach the end. It says nothing about whether anyone
understood them.

Four of the seventeen practices have no blind-pass result yet.
