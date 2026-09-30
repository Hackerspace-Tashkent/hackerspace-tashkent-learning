# 3-дарс. Git дан бошлаш

Git лойиҳа тарихини сақлайди: ҳар бир ўзгариш сақланади ва кейинчалик аввалги ҳолатга қайтиш мумкин.

## Биринчи репозиторий

```bash
mkdir my-project && cd my-project
git init
git status
```

`git init` репозиторий йаратади. `git status` нимани ўзгаришини кўрсатади.

```bash
echo 'Hello' > readme.md
git add readme.md
git status
```

## Ўзгаришларни сақлаш

Commit — тарихдаги сақланган нуқта. Унга ўзгариш ҳақида қисқа хабар йозилади.

```bash
git commit -m 'Add readme'
git log --oneline
```

## Тармоқлар

Тармоқ — алоҳида иш йўли. Еркин тажриба қилинг, кейин бирлаштиринг.

```bash
git branch feature
git switch feature
echo 'More' >> readme.md
git add readme.md
git commit -m 'Extend readme'
git switch main
git merge feature
```

## Файлларни етиборсиз қолдириш

Вақтинчалик файллар тариҳга тушмаслиги керак. Уларни `.gitignore` га йозинг.

```bash
echo '.lab-data/' > .gitignore
git add .gitignore
git commit -m 'Add gitignore'
```

> **Изоҳ.** Учта ҳолат: иш каталоги, индекс (`git add`), репозиторий (`git commit`).
