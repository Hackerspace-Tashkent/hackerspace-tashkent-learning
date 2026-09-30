# Урок 1. Терминал и навигация

Терминал — главный инструмент в Linux. Почти всё в этих уроках делается здесь.

Открой терминал и посмотри, где ты находишься:

```bash
pwd
```

Покажи содержимое:

```bash
ls
ls -la
```

## Перемещение

`cd` меняет каталог, `pwd` показывает текущий. `~` — твой домашний каталог.

```bash
cd ~
cd /tmp
cd ..
pwd
```

`..` — на уровень вверх, `.` — текущий каталог.

## Создание и удаление

```bash
mkdir my-project
cd my-project
touch readme.txt
ls
```

```bash
cp readme.txt readme.backup.txt
mv readme.backup.txt backup.txt
rm backup.txt
```

> **Заметка.** `rm` удаляет без вопроса. Отмены нет. Будь внимателен.

## Чтение файлов

```bash
cat readme.txt
head -5 readme.txt
tail -5 readme.txt
less readme.txt
```

## Цепочки и поиск

Символ `|` передаёт вывод одной команды в следующую.

```bash
ls -la | less
cat readme.txt | wc -l
ls | grep txt
```

`find` ищет файлы по имени, `grep` — по содержимому.

```bash
find ~ -name '*.txt' 2>/dev/null
grep -r 'TODO' ~ 2>/dev/null | head
```

> **Заметка.** Нажимай Tab для автодополнения пути. Экономит кучу набора.

## Практика

Выполни в Codespace, затем запусти `./check.sh` — он скажет, что ещё не сделано.

1. Создай каталог `lab-work`.
2. Перейди в него и создай три файла: `a.txt`, `b.txt`, `c.md`.
3. Запиши любой текст в `a.txt` и `b.txt`.
4. Скопируй `a.txt` в `backup.txt`, затем переименуй копию в `final.txt`.
5. Посчитай, сколько строк в `b.txt`.

```bash
cd labs/level-0/01-terminal
./check.sh
```
