# How to use AI while learning

AI tools speed up your work. They do not replace understanding what you are doing.
The difference between "I understood it" and "I was handed the answer" is the
difference between knowing and not knowing.

This guide answers four questions: where AI genuinely helps, where it hurts, what
is free to use, and how to ask so that you get something useful.

---

## 1. Where AI genuinely helps

**Explaining what the manual did not.** A reference manual answers the question
you happened to ask. AI can explain it from a different angle, give an analogy,
and show an example. This is the most common and most honest use.

**Reading an error message.** Paste the whole error, including the filename and
line number. Often that is enough. Errors usually say what is wrong right in the
text — just not always on the first read.

**Writing the boring part.** Open a file, read line by line, count something,
print a result. That is AI work, while you write the part that requires actually
thinking.

**Generating test cases.** A good question: "which edge cases break this
function?" The answer is useful because it forces you to think about boundaries
yourself.

**Compressing something long.** Forty pages into five paragraphs. It does not
replace reading, but it filters out what you did not need.

**Raw brainstorming.** "Give me 10 ways to do this" is bad. "Give me 5 approaches
with the pros and cons of each" is good. AI scatters options; you choose.

**Rehearsing.** Explain in your own words what your code does and ask for
contradictions. Often you find a hole in your own logic this way.

## 2. Where AI hurts

**Facts about your system.** The model cannot see your server, your repository or
your `.env`. It does not know your version, which ports are taken, or what is
already installed. Any advice it gives about your environment is a guess.

**Decisions where the cost of being wrong is high.** Security, money, law, health.
That calls for a human who answers for the outcome.

**Situations where you cannot verify.** If you cannot tell a correct answer from
a confidently invented one, you cannot use the tool. While that is true, do not
use it.

**A useful bias to know about.** AI is optimistic. It is more likely to say
"check your permissions" than "your assumption about how the scheduler works is
wrong". Ask it directly: "what am I assuming that could be wrong?"

## 3. The rule that matters most

**AI writes plausible wrong code with exactly the same confidence as right code.**

It will not say "I don't know" any more often than you would. Therefore:

> Copied code is not yours until you have read every line and can explain what it
> does and why it is written that way.

For us that is not a slogan. Someone who passed a lab by pasting does not
understand the subject. `./check.sh` will say the task is done, but no knowledge
has been created.

One more rule, tied to the security lesson: **never paste secrets into web
services.** No tokens, no `.env`, no keys, no database connection strings.
Pasting code into a free chat hands it to a third party.

## 4. What to use for free

Limits change — check the link before you rely on any of this.

| Tool | What for | Free tier | Link |
|---|---|---|---|
| **Perplexity** | Search with sources | Basic searches are practically unlimited, 3 Pro Searches per day | [perplexity.ai](https://www.perplexity.ai) |
| **OpenRouter** | API access to many models | 25+ models with a `:free` suffix; 50 requests per day, or 1000 if you have ever bought 10 credits | [openrouter.ai/pricing](https://openrouter.ai/pricing) |
| **Ollama + Qwen** | A model on your own machine | No limits, bounded by your hardware | [ollama.com/library/qwen](https://ollama.com/library/qwen) |
| **DeepSeek** | Working from a phone | The app is free, no subscription | [chat.deepseek.com](https://chat.deepseek.com) |
| **Google AI Studio** | Working with Gemini models | Free quota tier | [aistudio.google.com](https://aistudio.google.com) |
| **GitHub Copilot** | Suggestions inside the editor | Free tier, more for students | [github.com/features/copilot](https://github.com/features/copilot) |

**Perplexity** is the only one on this list that shows you sources. When you need
a fact rather than an opinion, that settles it: you can open the source and check
it yourself.

**OpenRouter** gives you one key for many models. It is handy when you run out of
context in one: switch models and continue. The downside is that free models are
often busy, and the same question may work or return `429`. Pick a specific model
and keep a spare.

**A local model** is the only option where the data physically does not leave the
machine. Good for private code and for working offline. You pay in RAM and speed.

### If you work from a phone

You cannot run a local model on a phone — there is not enough memory, and the
battery will be gone within half an hour. A cloud chat is all that is left, and
the choice is narrower than on a computer.

**DeepSeek** is the most practical option from a phone. The official app is
free, with no subscription and no advertising, and works on Android and iOS.
Web search and file upload are included. Verified: the domains
`chat.deepseek.com` and `api.deepseek.com` are alive, and the model weights are
open on Hugging Face under the MIT licence — so you can run the model yourself.

Three things worth understanding about DeepSeek:

- **The app is free, the API is not.** They are different products. Chatting in
  the app costs nothing, while API calls are billed per token, from about $0.22
  per million input tokens outside peak hours. If you see "free DeepSeek" in a
  developer ad, it is almost certainly promotional credit, or not about the API
  at all.
- **Limits are not published.** Instead of a message counter you may get "Server
  Busy" during load. That is not a ban and not a closed account — just wait.
- **Requests are processed in China.** That is not a reason to avoid it: the same
  amount of data goes to any other cloud chat. But if something lands in the
  prompt that a stranger must not see, remember section 8.

**Why this matters for us specifically.** For many people in Tashkent the phone
is the only device with internet. DeepSeek gives a full AI without a computer,
without a subscription and without a card. That is the lowest entry point of all
the options there are.

Useful from a phone: a quick question during the day, working out an error
message from a photo of the screen, drafting a text, translation. Not worth
doing from a phone: work with private code, and with data that must not leave.

## 5. Choosing by task

| Task | What to use |
|---|---|
| Find a fact that needs checking | Perplexity — with sources, always |
| Generate options | Any model, even a local one |
| Explain unfamiliar syntax | Any; better with examples |
| Debug an error | Paste the full error text, including the environment |
| Write lots of repetitive code | A local model, if the code is private |
| Work on your own repository | An agent with file access, not a chat in a browser |
| Your own bot or automation | API: OpenRouter or a local model |

## 6. An example: how one member set this up

This is Arkadiy's personal setup, not a recommendation for everyone — each of us
has different tasks and different hardware.

- **Perplexity** — searching with sources where verifiability matters: prices,
  documentation, comparisons.
- **Qwen locally** — working with code that must not go outside.
- **Hermes on his own VPS** — automation: bots, monitoring, scheduled jobs. The
  model is connected through OpenRouter, and the agent works with files and a
  browser rather than just answering text.

The logic is simple: the more expensive a mistake is, the closer the computation
should be to you. A public question goes to a web service. Private code stays on
your own machine. Your own infrastructure depends on no one else at all.

## 7. How to ask so that you get something useful

**Give context.** "It does not work" is useless. "`check.sh` in lesson 2 says
`FAIL: readme.md has mode 644`, I created the file in nano, here is the `ls -l`
output" is a question that can be answered.

**Say what you already tried.** Otherwise you get the first five suggestions from
the internet.

**Ask for the explanation, not the finished answer.** "Explain why this works" is
more useful than "give me the command".

**Ask for criticism.** "Here is my approach, find the weak points" is the most
underused request there is.

**Check facts separately from code.** You will verify the code by running it. A
fact without a source is not a fact.

## 8. What actually leaves your machine

Worth being clear about:

- text you paste into a web chat goes to the service operator;
- free tiers often mean data may be used for model training — check your account
  settings;
- a local model sends nothing anywhere;
- an agent with file access sees exactly what access you gave it.

## 9. Is using AI allowed in the exercises

That is a community decision, and there is not one yet. Open questions:

- Does a task count as done if the code was written by AI?
- If so, how do you tell one case from the other?
- Should the public board show "passed" or "understood"?

Until there is a rule, the reasonable position is: **yes, but do not hide it.** If
code was written with AI help, say so in the PR or issue description. That is more
honest and more useful than pretending it was all written by hand.
