# Personal safety: online and in Uzbekistan

> **This is not legal advice.** Nothing here answers the question "what is legal".
> Where the answer depends on the law, links to official sources are given —
> check them there, not here. Rules and laws change; this page was written on
> **30 September 2026**.

## What was verified, and what was not

Links are at the bottom. Much of what the internet says about this topic is SEO
spam, and none of it was used. If a claim below is not backed by an official
link, treat it as practical advice, not as fact.

---

## 1. Online

### Passwords and two factors are the foundation

- Every account gets **its own** password. "One password for everything, and I
  will recover it" means one breach opens everything.
- A real password manager, not a notebook and not one note on your phone.
- **Two-factor authentication everywhere it exists.** An authenticator app or a
  hardware key is better than SMS: an SMS can be intercepted, and a SIM card can
  be re-registered in your name.
- Your email is the key to every other account. Anyone who gets into your inbox
  can reset everything else. So 2FA on email comes first.

### What you hand over

Worth being precise about:

| Action | What leaves |
|---|---|
| Pasting code into a free AI chat | The text goes to the service operator |
| Uploading a file to cloud storage | The file goes to the service owner |
| Paying with a card online | Card data and the transaction are visible to the bank and the payment system |
| Connecting to free café Wi-Fi | Your traffic is visible to whoever runs the hotspot |

**A free tier often means data may be used for model training.** Check your
account settings. Paid tiers usually state plainly that your data is not used.

### Phishing and phone fraud

The pattern is simple: you get a call or message from a bank, a government
service, your phone provider, or "support". Here is how to cut through it:

- **Urgency.** "Right now, within the hour" is pressure, not a reason.
- **They ask for a code from SMS.** Nobody legitimately needs it. Ever.
- **They ask you to transfer money or read out a code.** That is fraud by
  definition.
- **The link in the message goes somewhere else.** Hover over it and read the
  real address before you click.

**The simple rule: hang up first.** Call the number on the back of your card or
from the official website yourself, not the number in the message.

### Bank card

- Keep a separate card for online payments, with a limit. Then losing it online
  does not cost you all your money.
- Turn on SMS notifications — they do not protect you from fraud, but they let
  you notice a charge in the first minutes.
- Save your bank's support number **in your phone**, not in a note app: if the
  SIM is blocked you will not have it to hand.

### Services to check things yourself

No need to trust a blogger — you can measure:

- **OONI Explorer** (`ooni.org`) — measurements of whether sites and services are
  reachable, from specific countries and operators.
- **NetBlocks** (`netblocks.org`) — reports on network outages and restrictions.
- **Freedom House** (`freedomhouse.org`) — annual internet-freedom score by
  country. In its 2025 report Uzbekistan scored 29 out of 100 and was classified
  "Not Free".

### About VPNs — honestly

The legal position on VPNs in Uzbekistan is **unclear**, and the sources that
exist contradict each other: some say it is banned, some say it is not, and none
of them is official. I will not advise either way, because I cannot confirm it.

What is certain: restrictions on some platforms do exist here and are applied by
the operators. If this matters to you, check the current state through OONI and
NetBlocks, and check the legal side with a lawyer. We do not give legal advice
and we do not help people get around the law.

---

## 2. In Uzbekistan

### Housing

The most common way newcomers lose money here is **rental fraud**.

- Do not transfer a deposit before you have seen the flat in person.
- Ask the owner for the property document and check that the name matches.
- If you are given a "reservation" from another country, or asked to pay by
  transfer to a third party — stop. That is the standard scheme.
- Compare several listings. If the price is too good, it is too good.

### Money

- **ATMs:** use one inside a bank, not one on the street. On the street you get
  a sticker over the keypad, a helpful onlooker, and a camera. Cover the keypad
  with your hand.
- **Cash:** split it up. Do not keep everything in one place.
- **After withdrawing — look around.** The most dangerous moments are at the ATM
  and at the bazaar.

### Transport

- A night rate and "my own driver" costs less, but there is no accountability.
  Official apps record the trip: the record stays with you if something happens.
- Tell someone your route and the plate number if you are travelling alone and
  late.

### Meeting strangers

- **The first meeting is in public.** A café, a coworking space, a busy street.
- Do not get into a stranger's car, even if they are "just giving you a lift".
- Tell someone where you are going and with whom, and ask them to message when
  you left.

### Documents

- Copies of your passport and papers, kept separately from the originals, in a
  place not discussed in chat.
- Changing your phone: remember the number is tied to your documents at the
  operator's. A new number is not anonymity.

### Emergency numbers

The standard set, worth knowing by heart and **re-checking** against official
sources, because it can change:

| Service | Number |
|---|---|
| Single emergency number | **112** |
| Police | **101** |
| Ambulance | **102** |
| Fire | **103** |

Check [gov.uz](https://gov.uz) and your mobile operator for current details.

---

## 3. Personal data: the law that concerns you too

**Law of the Republic of Uzbekistan No. ZRU-547 of 02.07.2019 "On personal
data"** entered into force on 01.10.2019. It defines what personal data is, who
the operator is, what rights a person has, and what liability applies for
breaching it.

Why this matters beyond lawyers:

- A members list with phone numbers is a **personal data database**.
- Since 08.02.2020 there has been an administrative procedure for maintaining a
  state register of personal data databases (Cabinet of Ministers Resolution
  No. 71).
- If your project collects other people's data — registration, contact details,
  photos — you become a personal data operator, with obligations of your own.

Official text: [lex.uz/uz/docs/4396419](https://lex.uz/uz/docs/4396419).
Where there is no official interpretation of your exact case — ask a lawyer.

---

## 4. Sources

| What | Where |
|---|---|
| Personal data law | [lex.uz/uz/docs/4396419](https://lex.uz/uz/docs/4396419) |
| Register of personal data databases | [lex.uz/ru/docs/4729730](https://lex.uz/ru/docs/4729730) |
| Reachability measurements | [ooni.org](https://ooni.org) |
| Network outages and restrictions | [netblocks.org](https://netblocks.org) |
| Internet freedom by country | [freedomhouse.org](https://freedomhouse.org) |
| Government portals | [gov.uz](https://gov.uz) |
| Community code of conduct | [CODE_OF_CONDUCT.md](https://github.com/Hackerspace-Tashkent/hackerspace-tashkent/blob/main/CODE_OF_CONDUCT.md) |

## 5. Short list

1. Different passwords, a password manager, 2FA — email first.
2. Hang up first if someone calls claiming to be your bank.
3. A separate card for online payments, with a limit.
4. Never transfer a deposit for a flat you have not seen.
5. First meeting in public.
6. Do not paste secrets or personal data into web services.
7. Collecting other people's data — read Law No. ZRU-547.
