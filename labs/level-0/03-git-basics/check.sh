#!/usr/bin/env bash
# Автопроверка: Lesson 3. Git from scratch
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

check 'Repository ~/git-lab exists' 'Репозиторий ~/git-lab создан' '~/git-lab repository mavjud' '~/git-lab репозиторий мавжуд' '[ -d "$HOME/git-lab/.git" ]'
check 'notes.md is tracked by git' 'notes.md отслеживается git' 'notes.md git tomonidan kuzatilmoqda' 'notes.txt git томонидан кузатилмоқда' 'cd "$HOME/git-lab" 2>/dev/null && git ls-files --error-unmatch notes.md'
check 'There are at least 3 commits' 'Есть минимум 3 коммита' 'Kamida 3 ta commit bor' 'Камида 3 та коммит бор' 'cd "$HOME/git-lab" 2>/dev/null && [ "$(git rev-list --count HEAD 2>/dev/null)" -ge 3 ]'
check 'Branch experiment was merged' 'Ветка experiment слита' 'experiment tarmog'\''i birlashtirilgan' 'experiment тармоғи бирлаштирилган' 'cd "$HOME/git-lab" 2>/dev/null && [ -f idea.md ]'
check 'File idea.md exists' 'Файл idea.md существует' 'idea.md fayli mavjud' 'idea.md файли мавжуд' '[ -f "$HOME/git-lab/idea.md" ]'
check '.gitignore ignores tmp/' '.gitignore игнорирует tmp/' '.gitignore tmp/ ni ignore qiladi' '.gitignore tmp/ ни игноре қилади' 'cd "$HOME/git-lab" 2>/dev/null && grep -q "tmp/" .gitignore'

printf '\n'
if [ "$PASS" -eq "$TOTAL" ]; then
  printf '%s\n' "$(t "All tasks done: $PASS/$TOTAL" "Все задания выполнены: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL")"
  exit 0
else
  printf '%s\n' "$(t "Progress: $PASS/$TOTAL" "Готово: $PASS/$TOTAL" "Bajarildi: $PASS/$TOTAL" "Бажарилди: $PASS/$TOTAL")"
  exit 1
fi
