#!/usr/bin/env bash
# Автопроверка: Lesson 2. Files and permissions
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

check 'Directory ~/permissions-lab exists' 'Каталог ~/permissions-lab создан' '~/permissions-lab katalogi mavjud' '~/permissions-lab каталоги мавжуд' '[ -d "$HOME/permissions-lab" ]'
check 'secret.txt has permissions 600' 'secret.txt имеет права 600' 'secret.txt ruxsati 600' 'secret.txt рухсати 600' '[ -f "$HOME/permissions-lab/secret.txt" ] && [ "$(stat -c %a "$HOME/permissions-lab/secret.txt")" = "600" ]'
check 'readme.md has permissions 644' 'readme.md имеет права 644' 'readme.md ruxsati 644' 'readme.md рухсати 644' '[ -f "$HOME/permissions-lab/readme.md" ] && [ "$(stat -c %a "$HOME/permissions-lab/readme.md")" = "644" ]'
check 'hello.sh exists' 'hello.sh существует' 'hello.sh mavjud' 'hello.sh мавжуд' '[ -f "$HOME/permissions-lab/hello.sh" ]'
check 'hello.sh is executable' 'hello.sh исполняемый' 'hello.sh bajariladigan' 'hello.sh бажариладиган' '[ -x "$HOME/permissions-lab/hello.sh" ]'
check 'hello.sh runs correctly' 'hello.sh работает' 'hello.sh ishlaydi' 'hello.sh ишлайди' 'cd "$HOME/permissions-lab" && ./hello.sh'
check 'Archive lab.tar.gz exists' 'Архив lab.tar.gz создан' 'lab.tar.gz arxivi mavjud' 'lab.tar.gz архиви мавжуд' '[ -f "$HOME/permissions-lab/lab.tar.gz" ]'

printf '\n'
if [ "$PASS" -eq "$TOTAL" ]; then
  printf '%s\n' "$(t "All tasks done: $PASS/$TOTAL" "Все задания выполнены: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL")"
  exit 0
else
  printf '%s\n' "$(t "Progress: $PASS/$TOTAL" "Готово: $PASS/$TOTAL" "Bajarildi: $PASS/$TOTAL" "Бажарилди: $PASS/$TOTAL")"
  exit 1
fi
