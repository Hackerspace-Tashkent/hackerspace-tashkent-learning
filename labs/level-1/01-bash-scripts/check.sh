#!/usr/bin/env bash
# Автопроверка: Lesson 5. Bash scripts
#
#   ./check.sh            только проверить
#   ./check.sh --submit   проверить и опубликовать результат
#
# Язык вывода:  CHECK_LANG=ru|uz-lat|uz-cyr|en  ./check.sh
# Всё делается в ./lab-work рядом с этим скриптом.
set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$HERE/lab-work"
LESSON="01-bash-scripts"
TRACK="level-1"
BOARD_REPO="Hackerspace-Tashkent/hackerspace-tashkent-learning"
BOARD_ISSUE="2"
QUIET_SUBMIT="${QUIET_SUBMIT:-0}"

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
  local label
  TOTAL=$((TOTAL+1))
  label=$(t "$1" "$2" "$3" "$4")
  if eval "$5" >/dev/null 2>&1; then ok "$label"; else no "$label"; fi
}

check 'Directory lab-work exists' 'Каталог lab-work создан' 'lab-work katalogi mavjud' 'lab-work каталоги мавжуд' '[ -d "$WORK" ]'
check 'greet.sh exists and is executable' 'greet.sh существует и исполняем' 'greet.sh mavjud va bajariladigan' 'greet.sh мавжуд ва бажариладиган' '[ -x "$WORK/greet.sh" ]'
check 'greet.sh greets the given name' 'greet.sh приветствует переданное имя' 'greet.sh berilgan ismni salomlaydi' 'greet.sh берилган исмни саломлайди' 'cd "$WORK" && ./greet.sh Ann | grep -qi ann'
check 'greet.sh fails without an argument' 'greet.sh падает без аргумента' 'greet.sh argumentsiz xato beradi' 'greet.sh аргументсиз хато беради' 'cd "$WORK" && ! ./greet.sh >/dev/null 2>&1'
check 'count_lines.sh exists and is executable' 'count_lines.sh существует и исполняем' 'count_lines.sh mavjud va bajariladigan' 'count_lines.sh мавжуд ва бажариладиган' '[ -x "$WORK/count_lines.sh" ]'
check 'count_lines.sh counts correctly' 'count_lines.sh считает верно' 'count_lines.sh to'\''g'\''ri sanaydi' 'count_lines.sh тўғри санайди' 'cd "$WORK" && printf "a\nb\nc\nd\n" > sample.txt && [ "$(./count_lines.sh sample.txt 2>/dev/null | grep -oE '\''[0-9]+'\'' | head -1)" = "4" ]'
check 'backup.sh exists and is executable' 'backup.sh существует и исполняем' 'backup.sh mavjud va bajariladigan' 'backup.sh мавжуд ва бажариладиган' '[ -x "$WORK/backup.sh" ]'
check 'backup.sh created at least 2 archives' 'backup.sh создал минимум 2 архива' 'backup.sh kamida 2 ta arxiv yaratdi' 'backup.sh камида 2 та архив яратди' '[ "$(ls "$WORK" 2>/dev/null | grep -c '\''^backup-.*\.tar\.gz$'\'')" -ge 2 ]'

printf '\n'
if [ "$PASS" -eq "$TOTAL" ]; then
  verdict=$(t "All tasks done: $PASS/$TOTAL" "Все задания выполнены: $PASS/$TOTAL" \
                 "Барча вазифалар бажарилди: $PASS/$TOTAL" "Барча вазифалар бажарилди: $PASS/$TOTAL")
else
  verdict=$(t "Progress: $PASS/$TOTAL" "Готово: $PASS/$TOTAL" \
                 "Bajarildi: $PASS/$TOTAL" "Бажарилди: $PASS/$TOTAL")
fi
printf '%s\n' "$verdict"

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
  body="$marker"$'\n'"**$LESSON** — $PASS/$TOTAL"$'\n'"$user"
  if ! command -v gh >/dev/null 2>&1; then
    printf '%s\n' "$(t "gh CLI is not available, result not sent." "gh CLI недоступен, результат не отправлен." "gh CLI mavjud emas, natija yuborilmadi." "gh CLI мавжуд эмас, натижа юборилмади.")"
    return 1
  fi
  if ! gh issue comment "$BOARD_ISSUE" --repo "$BOARD_REPO" --body "$body" >/dev/null 2>&1; then
    printf '%s\n' "$(t "Could not post. Check gh auth status" "Не удалось отправить. Проверь gh auth status" "Yuborib bo'lmadi. Tekshiring: gh auth status" "Юбориб бўлмади. Текширинг: gh auth status")"
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
