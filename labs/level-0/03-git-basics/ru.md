# Урок 3. Git с нуля

Git хранит историю проекта: каждое изменение сохраняется, и можно вернуться к любому предыдущему состоянию.

## Первый репозиторий

```bash
mkdir my-project && cd my-project
git init
git status
```

`git init` создаёт репозиторий. `git status` показывает, что изменилось и что готово к сохранению.

```bash
echo 'Hello' > readme.md
git add readme.md
git status
```

## Сохранение изменений

Коммит — это сохранённая точка истории. У него есть короткое сообщение о том, что изменилось.

```bash
git commit -m 'Add readme'
git log --oneline
```

## Ветки

Ветка — отдельная линия работы. Экспериментируй свободно, потом сливай обратно.

```bash
git branch feature
git switch feature
echo 'More' >> readme.md
git add readme.md
git commit -m 'Extend readme'
git switch main
git merge feature
```

## Игнорирование файлов

Временные файлы не должны попадать в историю. Перечисли их в `.gitignore`.

```bash
echo '.lab-data/' > .gitignore
git add .gitignore
git commit -m 'Add gitignore'
```

> **Заметка.** Три состояния: рабочий каталог, индекс (`git add`), репозиторий (`git commit`).

## Практика

1. Создай `lab-work` и выполни там `git init`.
2. Создай `notes.md` и сделай минимум три коммита с понятными сообщениями.
3. Создай ветку `experiment`, добавь в ней файл `idea.md` и закоммить.
4. Слей `experiment` обратно в `main`.
5. Добавь `.gitignore`, игнорирующий `tmp/`.
6. Посмотри историю через `git log --oneline` — должно быть минимум четыре коммита.

```bash
cd labs/level-0/03-git-basics
./check.sh
```
