# Dars 5. GitHub da ishlash

## Bu dars nima beradi

Oldingi darsda sen git bilan mahalliy ishladigan: kommit qilding, tarmoq
yaratding, qaytarib merge qilding. Bu tarix hech qerga ketmagan — sening
mashinangdagi papkada yashagan.

GitHub uchta narsani qo'shadi, ular gitda yo'q:

1. **umumiy kirish** — tarixni boshqalar ko'radi;
2. **muhokama** — kod yonida savol berish va javob berish mumkin;
3. **tekshiruvlar** — avtomatik kod «buzildi» deb ayta oladi.

GitHub'siz git shaxsiy daftarda qoladi. Uni bilan birga — birga ishlash
usuli bo'ladi.

## Fork va clone: farqi

**Fork** — boshqaning repositoriyining sening GitHub hisobingdagi nusxasi. Uni
bir tugma bilan olding, kod jismonan ko'chirilmadi — bu GitHub serveridagi
yozuv.

**Clone** — sening mashinangdagi nusxa, `git clone` orqali yuklab olingan.

Tartib doim bir xil:

```
boshqa repo  →  sening forking  →  mashinaga clone
```

Asl repo'ni to'g'ridan-to'g'ri clone qilishing mumkin, lekin keyin push qila
olmaysan: boshqaning repositoriyiga huquqing yo'q. Fork aynan shuning uchun
kerak.

```bash
git clone https://github.com/<sizning-login>/hackerspace-tashkent-learning.git
```

Manzilga bo'r — **sizning logining**, `Hackerspace-Tashkent` emas. Agar
`git remote -v` da asl repo chiqsa, fork qilmading yoki noto'g'ri narsani
klonlagan.

## remote: push qayerga ketadi

```bash
git remote -v
origin  https://github.com/<sizning-login>/... (fetch)
origin  https://github.com/<sizning-login>/... (push)
```

`remote` — bu shunchaki manzil uchun nom. Ular qancha bo'lishi mumkin:

```bash
git remote add upstream https://github.com/Hackerspace-Tashkent/hackerspace-tashkent-learning.git
```

`origin` — sening forking, push shu yerga. `upstream` — asl repo, boshqalarning
o'zgarishlari shu yerdan keladi. `push` da `origin` ishlatiladi:

```bash
git push origin my-branch
```

## Tarmoq va asl repo bilan moslashish

Sen doim tarmoqda ishlaysan, `main` ga tegmaysan:

```bash
git switch -c add-my-note
```

Asl repo hayotda davom etsa, sening forking orqada qoladi. O'zgarishlarni ol:

```bash
git fetch upstream
git switch main
git merge upstream/main
git switch add-my-note
git merge main
```

Oxirgi ikki komanda `main` ni sening tarmog'ingga ulaydi, shunda ular ajralib
ketmaydi. Agar tarmog'ingizda aynan shu qatorlar o'zgargan bo'lsa — Git
konflikt ko'rsatadi. Bu buzilgan emas, bu «nima qoladi?» degan qo'lda qaror.

## Pull request

**Pull request (PR)** — «mening o'zgarishlarim, qarang va ulang» taklifasi.

Rasmiy ravishda PR «birlashtirish so'rovi» emas, balki **tekshirish so'rovi**.
Birlashtirish umuman bo'lmasligi mumkin: odam o'zgartirish so'raydi. Shuning
uchun Merge tugmasiдан ko'ra tavrif muhimroq.

Tavsif odamga murojaat qiladi. Kamida:

```markdown
## Nima o'zgartirildi
## Qanday tekshiriladi
## Men o'zim nimani tekshirdim
```

Uchinchi punkt shakl bo'yicha shart emas, lekin qolganlaridan qimmatliroq.
Muallif tugmani bosganini emas, tekshirganini ko'rsatadi.

Brauzer orqali: push → GitHub «Compare & pull request» tugmasini ko'rsatadi.
Terminal orqali, `gh` bo'lsa:

```bash
gh pr create --fill
gh pr status
```

## Issue: kodsiz suhbat

Issue — bu ariza, savol yoki g'oya. Unda kod umuman bo'lmasligi mumkin.

Issue va PR — turli narsalar, garchi ikkalasi GitHubda yashaydi:

| | Issue | Pull request |
|---|---|---|
| Nima haqida | savol, g'oya, xato | kodga aniq o'zgarishlar |
| Kodi bor | shart emas | shart |
| Kim yopadi | muallif yoki maintainer | review'dan keyin maintainer |

Tayyor tuzatilmagan xato — issue. Tayyor tuzatilgani — PR, uning tavsifida
muhokama qilingan issuega havola qilinadi.

Yaxshi issue: nima kutilgan, nima bo'lgan, qanday takrorlash mumkin.

## Review

Review — boshqaning o'zgarishini o'qib, javob berish. Bu stil tekshiruvi emas,
bu «buni to'g'ri qildimi?» tekshiruvi.

Foydali review uchta savolga javob beradi:

- **nima o'zgargani va nima uchun tushunarlimi** (koddan emas, tavsifdan);
- **haqiqatan to'g'ri ishlaydimi** (tekshirish yo'li bormi);
- **nima hisobga olinmagan** (boshqalarda nima buziladi).

Yordam bermaydigan iboralar: «tuzat», «yomon», «rozi emasman». Yordam beradi:
«bu holat yiqiladi, chunki…», «boʻsh qiymat bu yerda qayta ishlanmagan, mana
misol».

Biz rasmiy qoidalar talab qilmaymiz. Bitta narsani talab qilamiz:
**izoh nima noto'g'ri va nima yaxshi bo'lishini tushuntirishi kerak.** Kelishmovchilik
normal, agar sababi yozilgan bo'lsa.

## Hoziroq sozlanadigan ikki narsa

Bu ikkisini darhol qiling, keyin hayron bo'lmaslik uchun:

```bash
git config --global user.name "Sening Isming"
git config --global user.email "sening@pochta"
```

Bularsiz kommitlar `root` nomi bilan imzolanadi yoki Codespaces'da umuman
yaratilmaydi.

Ikkinchisi — `.gitignore`. Unga tarixga kirmasligi kerak bo'lgan hamma narsa
tushadi: `lab-work/`, kalitlar, `.env`, vaqtinchalik fayllar. Bizning
repositoriyda allaqachon sozlangan, lekin o'z forkingda roʻyxat mos kelishini
tekshir.

## O'zingiz tekshirish

- [ ] `git remote -v` sening forkingni ko'rsatadi, asl reponi emas
- [ ] tarmoq `main` deb atalmagan
- [ ] PR tavsifida «nima o'zgartirildi» va «qanday tekshiriladi» bor
- [ ] commitdan oldin `git status` toza

## Keyingi

Laboratoriya yonma-yo'nda: `labs/level-1/05-github-workflow`. Unda fork, tarmoq,
kommit qilish, PR tavsifi va ro'yxat yozish kerak. To'qqizta mahalliy
tekshiruv va, `gh` bo'lsa, o'ninchchi onlayn tekshiruv.

## Nimani tekshirmaymiz haqida halol

Laboratoriya sizning PR-ningiz yaxshi yoki yomonini hal qilmaydi. Uni odam
o'qiydi, qaror ham odam qabul qiladi. Avtomatik tekshiriladigan yagona narsa —
fayllarning joyida va to'g'ri topshirilgani.
