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

`wc` считает: `wc -l` — строки, `wc -w` — слова, `wc -c` — символы.
`less` показывает длинный вывод постранично, `q` — выход.

Строка `cat readme.txt | wc -l` читает файл и считает в нём строки.
`grep txt` в конце находит в выводе `ls` всё, где есть «txt».

```bash
find ~ -name '*.txt' 2>/dev/null
grep -r 'TODO' ~ 2>/dev/null | head
```

> **Заметка.** Нажимай Tab для автодополнения пути. Экономит кучу набора.
