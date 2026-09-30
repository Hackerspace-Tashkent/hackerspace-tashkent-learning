#!/usr/bin/env bash
# Автопроверка: Lesson 1. Terminal and navigation
# Запуск:  ./check.sh
# Язык вывода:  CHECK_LANG=ru|uz-lat|uz-cyr|en  ./check.sh
set -u

PASS=0
TOTAL=0

t() {
  case "${CHECK_LANG:-ru}" in
    en)      echo "$1" ;;
    uz-lat)  echo "$3" ;;
    uz-cyr)  echo "$4" ;;
    *)       echo "$2" ;;
  esac
}

ok() { PASS=$((PASS+1)); printf '  [ok]   %s\n' "$1"; }
no() { printf '  [FAIL] %s\n' "$1"; }

check() {
  # $1..$4 — описание (en|ru|uz-lat|uz-cyr), $5 — команда для проверки
  local label
  TOTAL=$((TOTAL+1))
  label=$(t "$1" "$2" "$3" "$4")
  if eval "$5" >/dev/null 2>&1; then ok "$label"; else no "$label"; fi
}

check 'Directory ~/terminal-lab exists' 'Каталог ~/terminal-lab создан' '~/terminal-lab katalogi mavjud' '~/terminal-lab каталоги мавжуд' '[ -d "$HOME/terminal-lab" ]'
check 'File a.txt exists' 'Файл a.txt создан' 'a.txt fayli mavjud' 'a.txt файли мавжуд' '[ -f "$HOME/terminal-lab/a.txt" ]'
check 'File b.txt exists' 'Файл b.txt создан' 'b.txt fayli mavjud' 'b.txt файли мавжуд' '[ -f "$HOME/terminal-lab/b.txt" ]'
check 'File c.md exists' 'Файл c.md создан' 'c.md fayli mavjud' 'c.md файли мавжуд' '[ -f "$HOME/terminal-lab/c.md" ]'
check 'a.txt is not empty' 'a.txt не пустой' 'a.txt bo'\''sh emas' 'a.txt бўш эмас' '[ -s "$HOME/terminal-lab/a.txt" ]'
check 'b.txt is not empty' 'b.txt не пустой' 'b.txt bo'\''sh emas' 'b.txt бўш эмас' '[ -s "$HOME/terminal-lab/b.txt" ]'
check 'File final.txt exists' 'Файл final.txt создан' 'final.txt fayli mavjud' 'final.txt файли мавжуд' '[ -f "$HOME/terminal-lab/final.txt" ]'
check 'backup.txt was removed' 'backup.txt удалён' 'backup.txt o'\''chirilgan' 'backup.txt ўчирилган' '[ -d "$HOME/terminal-lab" ] && [ ! -e "$HOME/terminal-lab/backup.txt" ]'

printf '\n'
if [ "$PASS" -eq "$TOTAL" ]; then
  printf '%s\n' "$(t "All tasks done: $PASS/$TOTAL" "Все задания выполнены: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL")"
  exit 0
else
  printf '%s\n' "$(t "Progress: $PASS/$TOTAL" "Готово: $PASS/$TOTAL" "Bajarildi: $PASS/$TOTAL" "Бажарилди: $PASS/$TOTAL")"
  exit 1
fi
