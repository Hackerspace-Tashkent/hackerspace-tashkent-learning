# Laboratoriya: GitHub bilan ishlash

## Nima qilish kerak

Hamma narsa shu fayl yonidagi `lab-work/` papkasida boʻladi. Papka dastlab
yoʻq — uni oʻzingiz yarating.

```bash
cd "$(dirname check.sh)"
mkdir lab-work
cd lab-work
```

### 1. Oʻz forkingiz

Oʻquv repositoriyani fork qiling va **oʻz forkingizni** klonlang, asl nusxani emas:

```bash
git clone https://github.com/<sizning-login>/hackerspace-tashkent-learning.git
cd hackerspace-tashkent-learning
git remote -v
```

`git remote -v` da `origin` sizning loginingizni koʻrsatishi kerak.

### 2. `main` boʻlmagan tarmoq

```bash
git switch -c my-first-change
```

Faqat uning ichida ishlang. `main` ga tegmang.

### 3. Oʻzgarish va kommit

Har qanday fayl qoʻshing yoki mavjudini oʻzgartiring, keyin:

```bash
git add .
git commit -m "Add my note about level 1"
```

### 4. Pull request tavsifi

`PR.md` yarating — PR tavsif maydoniga yozadigan narsa. Kamida uch qator:

```markdown
## Nima oʻzgartirildi

## Qanday tekshiriladi

## Men oʻzim nimani tekshirdim
```

Uchinchi sarlavha eng qimmatli. Halol yozing: nimani ishga tushirdingiz va
haqiqatan nima ishadi.

### 5. Roʻyxat

`CHECKLIST.md` yarating, nimani tekshirganingizni belgilang. Kamida:

```markdown
- [ ] check.sh oʻtadi
- [ ] har bir skript nima qilishini oʻqidim
```

### 6. Pull request

Tarmoqni push qiling va PR oching:

```bash
git push -u origin my-first-change
```

Keyin brauzerda yoki, `gh` oʻrnatilgan boʻlsa:

```bash
gh pr create --fill
```

`gh` yoʻq boʻlsa saytni oching, GitHub oʻzi PR yaratishni taklif qiladi.

## Tekshiruv

```bash
./check.sh
```

Oʻta lokal tekshiruv va, `gh` boʻlsa, oʻninchchi onlayn tekshiruv.
`gh` yoʻq boʻlsa hisob `9/9` boʻladi: bu normal, lokal qism hisobga olingan.

## Bu laboratoriya nimani tekshirmaydi

U sizning PR-ingiz maʼnoli yoki yoʻqligini tekshirmaydi. Uni odam oʻqiydi.
Shuning uchun `PR.md` dagi uchinchi sarlavha qolganlaridan muhimroq.