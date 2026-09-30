#!/usr/bin/env bash
# Автопроверка: Lesson 1. Terminal and navigation
#
#   ./check.sh            только проверить
#   ./check.sh --submit   проверить и опубликовать результат
#
# Язык вывода:  CHECK_LANG=ru|uz-lat|uz-cyr|en  ./check.sh
# Всё делается в ./lab-work рядом с этим скриптом — ничего не пишется в домашний каталог.
set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$HERE/lab-work"
LESSON="01-terminal"
TRACK="level-0"
BOARD_REPO="Hackerspace-Tashkent/hackerspace-tashkent-learning"
BOARD_ISSUE="2"
QUIET_SUBMIT="${QUIET_SUBMIT:-0}"

# lab-work НЕ создаётся автоматически: первая задача практики — создать его самому.

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

check 'Directory lab-work exists' 'Каталог lab-work создан' 'lab-work katalogi mavjud' 'lab-work каталоги мавжуд' '[ -d "$WORK" ]'
check 'File a.txt exists' 'Файл a.txt создан' 'a.txt fayli mavjud' 'a.txt файли мавжуд' '[ -f "$WORK/a.txt" ]'
check 'File b.txt exists' 'Файл b.txt создан' 'b.txt fayli mavjud' 'b.txt файли мавжуд' '[ -f "$WORK/b.txt" ]'
check 'File c.md exists' 'Файл c.md создан' 'c.md fayli mavjud' 'c.md файли мавжуд' '[ -f "$WORK/c.md" ]'
check 'a.txt is not empty' 'a.txt не пустой' 'a.txt bo'\''sh emas' 'a.txt бўш эмас' '[ -s "$WORK/a.txt" ]'
check 'b.txt is not empty' 'b.txt не пустой' 'b.txt bo'\''sh emas' 'b.txt бўш эмас' '[ -s "$WORK/b.txt" ]'
check 'File final.txt exists' 'Файл final.txt создан' 'final.txt fayli mavjud' 'final.txt файли мавжуд' '[ -f "$WORK/final.txt" ]'
check 'backup.txt was removed' 'backup.txt удалён' 'backup.txt o'\''chirilgan' 'backup.txt ўчирилган' '[ -d "$WORK" ] && [ ! -e "$WORK/backup.txt" ]'

printf '\n'
if [ "$PASS" -eq "$TOTAL" ]; then
  verdict=$(t "All tasks done: $PASS/$TOTAL" "Все задания выполнены: $PASS/$TOTAL" \
                 "Барча вазифалар бажарилди: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL")
else
  verdict=$(t "Progress: $PASS/$TOTAL" "Готово: $PASS/$TOTAL" \
                 "Bajarildi: $PASS/$TOTAL" "Бажарилди: $PASS/$TOTAL")
fi
printf '%s\n' "$verdict"

# --- Публикация результата ------------------------------------------------

whoami() {
  if command -v gh >/dev/null 2>&1; then
    gh api user --jq .login 2>/dev/null && return 0
  fi
  [ -n "${GITHUB_USER:-}" ] && { echo "$GITHUB_USER"; return 0; }
  git config user.email 2>/dev/null || true
}

submit() {
  local user marker body
  user="$(whoami)"
  [ -n "$user" ] || user="unknown"

  marker="<!-- hs:lesson=$LESSON;track=$TRACK;pass=$PASS;total=$TOTAL;lang=${CHECK_LANG:-ru};user=$user;ts=$(date -u +%Y-%m-%dT%H:%M:%SZ) -->"
  body="$marker"$'\n'
  body="$body$(t "**$LESSON** — $PASS/$TOTAL" "**$LESSON** — $PASS/$TOTAL" "**$LESSON** — $PASS/$TOTAL" "**$LESSON** — $PASS/$TOTAL")"
  body="$body"$'\n'"$user"

  if ! command -v gh >/dev/null 2>&1; then
    printf '%s\n' "$(t "gh CLI is not available, result not sent." "gh CLI недоступен, результат не отправлен." "gh CLI mavjud emas, natija yuborilmadi." "gh CLI мавжуд эмас, натижа юборилмади.")"
    return 1
  fi

  if ! gh issue comment "$BOARD_ISSUE" --repo "$BOARD_REPO" --body "$body" >/dev/null 2>&1; then
    printf '%s\n' "$(t "Could not post. Check that gh is signed in: gh auth status" "Не удалось отправить. Проверь вход: gh auth status" "Yuborib bo'lmadi. Kirishni tekshiring: gh auth status" "Юбориб бўлмади. Киришни текширинг: gh auth status")"
    return 1
  fi

  [ "$QUIET_SUBMIT" = "1" ] || printf '%s\n' "$(t "Result published." "Результат опубликован." "Natija e'lon qilindi." "Натижа эълон қилинди.")"
  return 0
}

if [ "${1:-}" = "--submit" ]; then
  submit
elif [ "$PASS" -eq "$TOTAL" ] && [ "$QUIET_SUBMIT" != "1" ]; then
  printf '%s\n' "$(t "To publish it: ./check.sh --submit" "Чтобы опубликовать: ./check.sh --submit" "E'lon qilish uchun: ./check.sh --submit" "Эълон қилиш учун: ./check.sh --submit")"
fi

[ "$PASS" -eq "$TOTAL" ] && exit 0 || exit 1
