#!/usr/bin/env bash
# Автопроверка: Lesson 4. Your first script
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

check 'Directory ~/script-lab exists' 'Каталог ~/script-lab создан' '~/script-lab katalogi mavjud' '~/script-lab каталоги мавжуд' '[ -d "$HOME/script-lab" ]'
check 'greet.py exists' 'greet.py существует' 'greet.py mavjud' 'greet.py мавжуд' '[ -f "$HOME/script-lab/greet.py" ]'
check 'greet.py is executable' 'greet.py исполняемый' 'greet.py bajariladigan' 'greet.py бажариладиган' '[ -x "$HOME/script-lab/greet.py" ]'
check 'count.py exists' 'count.py существует' 'count.py mavjud' 'count.py мавжуд' '[ -f "$HOME/script-lab/count.py" ]'
check 'data.txt has at least 5 lines' 'data.txt содержит минимум 5 строк' 'data.txt kamida 5 qatorga ega' 'data.txt kamida 5 qatorga ega' '[ -f "$HOME/script-lab/data.txt" ] && [ "$(wc -l < "$HOME/script-lab/data.txt")" -ge 5 ]'
check 'count.py counts lines correctly' 'count.py правильно считает строки' 'count.py qatorlarni to'\''g'\''ri sanaydi' 'count.py қаторларни тўғри санайди' 'cd "$HOME/script-lab" && n=$(./count.py data.txt 2>/dev/null | grep -oE '\''[0-9]+'\'' | head -1); [ -n "${n:-}" ] && [ "${n:-0}" -ge 5 ]'
check 'report.py exists' 'report.py существует' 'report.py mavjud' 'report.py мавжуд' '[ -f "$HOME/script-lab/report.py" ]'

printf '\n'
if [ "$PASS" -eq "$TOTAL" ]; then
  printf '%s\n' "$(t "All tasks done: $PASS/$TOTAL" "Все задания выполнены: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL")"
  exit 0
else
  printf '%s\n' "$(t "Progress: $PASS/$TOTAL" "Готово: $PASS/$TOTAL" "Bajarildi: $PASS/$TOTAL" "Бажарилди: $PASS/$TOTAL")"
  exit 1
fi
