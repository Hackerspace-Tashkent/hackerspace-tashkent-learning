# 3-dars. Git dan boshlash

Git loyiha tarixini saqlaydi: har bir o'zgarish saqlanadi va keyinchalik avvalgi holatga qaytish mumkin.

## Birinchi repository

```bash
mkdir my-project && cd my-project
git init
git status
```

`git init` repository yaratadi. `git status` nimani o'zgarishini ko'rsatadi.

```bash
echo 'Hello' > readme.md
git add readme.md
git status
```

## O'zgarishlarni saqlash

Commit — tarixdagi saqlangan nuqta. Unga o'zgarish haqida qisqa xabar yoziladi.

```bash
git commit -m 'Add readme'
git log --oneline
```

## Tarmoqlar

Tarmoq — alohida ish yo'li. Erkin tajriba qiling, keyin birlashtiring.

```bash
git branch feature
git switch feature
echo 'More' >> readme.md
git add readme.md
git commit -m 'Extend readme'
git switch main
git merge feature
```

## Fayllarni e'tiborsiz qoldirish

Vaqtinchalik fayllar tarihga tushmasligi kerak. Ularni `.gitignore` ga yozing.

```bash
echo '.lab-data/' > .gitignore
git add .gitignore
git commit -m 'Add gitignore'
```

> **Izoh.** Uchta holat: ish katalogi, indeks (`git add`), repository (`git commit`).

## Амалиёт

1. `lab-work` yarating va u yerda `git init` bajariring.
2. `notes.md` yarating va kamida uchta commit qiling, har biriga ma'nomli xabar yozing.
3. `experiment` tarmog'ini yarating, unga `idea.md` faylini qo'shing va commit qiling.
4. `experiment` tarmog'ini `main` ga qaytaring (merge).
5. `tmp/` ni ignore qiladigan `.gitignore` qo'shing.
6. `git log --oneline` bilan tarixni ko'ring — kamida to'rtta commit bo'lishi kerak.

```bash
cd labs/level-0/03-git-basics
./check.sh
```
