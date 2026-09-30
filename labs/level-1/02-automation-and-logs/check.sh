#!/usr/bin/env bash
# Автопроверка: Lesson 6. Automation and logs
#
#   ./check.sh            только проверить
#   ./check.sh --submit   проверить и опубликовать результат
#
# Язык вывода:  CHECK_LANG=ru|uz-lat|uz-cyr|en  ./check.sh
# Всё делается в ./lab-work рядом с этим скриптом.
set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$HERE/lab-work"
LESSON="02-automation-and-logs"
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
check 'report.sh exists and is executable' 'report.sh существует и исполняем' 'report.sh mavjud va bajariladigan' 'report.sh мавжуд ва бажариладиган' '[ -x "$WORK/report.sh" ]'
check 'run.log has at least 3 lines' 'run.log содержит минимум 3 строки' 'run.log kamida 3 qatorga ega' 'run.log kamida 3 qatorga ega' '[ -f "$WORK/run.log" ] && [ "$(wc -l < "$WORK/run.log")" -ge 3 ]'
check 'every run.log line starts with a date' 'Каждая строка run.log начинается с даты' 'run.log ning har bir qatori sanadan boshlanadi' 'run.log нинг ҳар бир қатори санадан бошланади' 'cd "$WORK" && [ -s run.log ] && ! grep -qvE '\''^[0-9]{4}-[0-9]{2}-[0-9]{2}'\'' run.log'
check 'task.sh exists and is executable' 'task.sh существует и исполняем' 'task.sh mavjud va bajariladigan' 'task.sh мавжуд ва бажариладиган' '[ -x "$WORK/task.sh" ]'
check 'task.sh always exits 0' 'task.sh всегда завершается с кодом 0' 'task.sh doimo 0 bilan chiqadi' 'task.sh доимо 0 билан чиқади' 'cd "$WORK" && ./task.sh >/dev/null 2>&1; [ $? -eq 0 ]'
check 'crontab.txt exists' 'Файл crontab.txt создан' 'crontab.txt fayli mavjud' 'crontab.txt файли мавжуд' '[ -f "$WORK/crontab.txt" ]'
check 'the crontab line has 5 time fields' 'В строке crontab пять полей времени' 'Crontab qatorida beshta vaqt maydoni bor' 'Crontab қаторида бешта вақт майдони бор' 'cd "$WORK" && grep -qE '\''^\s*(\S+\s+){5}'\'' crontab.txt'
check 'the entry runs task.sh with an absolute path' 'Запись запускает task.sh по абсолютному пути' 'Yozuv task.sh ni absolyut yo'\''l bilan ishga tushiradi' 'Ёзув task.sh ни абсолют йўл билан ишга туширади' 'cd "$WORK" && grep -E '\''^\s*(\S+\s+){5}'\'' crontab.txt | grep -qE "/task\.sh(\s|$)"'
check 'the entry redirects both streams to a log' 'Запись перенаправляет оба потока в журнал' 'Yozuv ikkala oqimni jurnalga yo'\''naltiradi' 'Ёзув иккала оқимни журналга йўналтиради' 'cd "$WORK" && grep -E '\''^\s*(\S+\s+){5}'\'' crontab.txt | grep -q ">>"'
check 'the entry runs every 10 minutes' 'Запись запускается каждые 10 минут' 'Yozuv har 10 daqiqada ishga tushadi' 'Ёзув ҳар 10 дақиқада ишга тушади' 'cd "$WORK" && grep -qE '\''^\s*\*/10\s+\*\s+\*\s+\*\s+\*\s+'\'' crontab.txt'

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
