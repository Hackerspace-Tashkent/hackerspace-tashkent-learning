# 1-дарс. Терминал ва навигацийа

Терминал — Linuxдаги асосий восита. Бу дарсларда деган кўп нарса шу йерда бажарилади.

Терминални очинг ва жорий каталогни кўринг:

```bash
pwd
```

Ичидагиларни кўрсатинг:

```bash
ls
ls -la
```

## Кўчиш

`cd` каталогни ўзгартиради, `pwd` жорий жойни кўрсатади. `~` — уй каталогингиз.

```bash
cd ~
cd /tmp
cd ..
pwd
```

`..` — бир қадам йуқорига, `.` — жорий каталог.

## Йаратиш ва ўчириш

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

> **Изоҳ.** `rm` саволсиз ўчиради. Бекор қилиш йўқ. Еҳтийот бўлинг.

## Файлларни ўқиш

```bash
cat readme.txt
head -5 readme.txt
tail -5 readme.txt
less readme.txt
```

## Занжирлар ва қидирув

`|` белгиси битта буйруқ натижасини кейингисига узатади.

```bash
ls -la | less
cat readme.txt | wc -l
ls | grep txt
```

`find` файл номи бўйича, `grep` ички матн бўйича қидиради.

```bash
find ~ -name '*.txt' 2>/dev/null
grep -r 'TODO' ~ 2>/dev/null | head
```

> **Изоҳ.** ЙЎлни тўлдириш учун Таб босинг. Кўп йозишни тежайди.

## Амалиёт

Codespaceda бажаринг, кейин `./check.sh` — нимани қилиш кераклигини айтади.

1. `lab-work` каталогини йаратинг.
2. Унга киринг ва учта файл йаратинг: `a.txt`, `b.txt`, `c.md`.
3. `a.txt` ва `b.txt` ичига ихтийорий матн йозинг.
4. `a.txt` ни `backup.txt` га нусхаланг, кейин нусхани `final.txt` га номини ўзгартиринг.
5. `b.txt` да неча қатор борлигини ҳисобланг.

```bash
cd labs/level-0/01-terminal
./check.sh
```
