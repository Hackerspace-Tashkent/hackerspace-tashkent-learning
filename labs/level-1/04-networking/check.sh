#!/usr/bin/env bash
# Автопроверка: Lesson 8. Networking
#
#   ./check.sh            только проверить
#   ./check.sh --submit   проверить и опубликовать результат
#
# Язык вывода:  CHECK_LANG=ru|uz-lat|uz-cyr|en  ./check.sh
# Всё делается в ./lab-work рядом с этим скриптом.
set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$HERE/lab-work"
LESSON="04-networking"
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
check 'index.html exists' 'index.html существует' 'index.html mavjud' 'index.html мавжуд' '[ -f "$WORK/index.html" ]'
check 'serve.sh exists and is executable' 'serve.sh существует и исполняем' 'serve.sh mavjud va bajariladigan' 'serve.sh мавжуд ва бажариладиган' '[ -x "$WORK/serve.sh" ]'
check 'server.pid was saved' 'server.pid сохранён' 'server.pid saqlangan' 'server.pid сақланган' '[ -s "$WORK/server.pid" ] && grep -qE '\''^[0-9]+$'\'' "$WORK/server.pid"'
check 'status.txt records 200' 'status.txt содержит 200' 'status.txt 200 ni qayd etadi' 'status.txt 200 ни қайд этади' '[ -f "$WORK/status.txt" ] && grep -q 200 "$WORK/status.txt"'
check 'ports.txt mentions port 8000' 'ports.txt упоминает порт 8000' 'ports.txt 8000-portni eslatadi' 'ports.txt 8000-портни эслайди' '[ -f "$WORK/ports.txt" ] && grep -q 8000 "$WORK/ports.txt"'
check 'check_site.sh exists and is executable' 'check_site.sh существует и исполняем' 'check_site.sh mavjud va bajariladigan' 'check_site.sh мавжуд ва бажариладиган' '[ -x "$WORK/check_site.sh" ]'
check 'check_site.sh returns 1 on a wrong port' 'check_site.sh возвращает 1 на неверном порту' 'check_site.sh noto'\''g'\''ri portda 1 qaytaradi' 'check_site.sh нотўғри портда 1 қайтаради' '[ -x "$WORK/check_site.sh" ] && { ( cd "$WORK" && ./check_site.sh 9999 >/dev/null 2>&1 ); [ $? -eq 1 ]; }'
check 'check_site.sh returns 0 on a live server' 'check_site.sh возвращает 0 при живом сервере' 'check_site.sh tirik serverda 0 qaytaradi' 'check_site.sh тирик серверда 0 қайтаради' '[ -x "$WORK/check_site.sh" ] && ( cd "$WORK" && { python3 -m http.server 8000 --bind 127.0.0.1 >/dev/null 2>&1 & sp=$!; sleep 2; ./check_site.sh >/dev/null 2>&1; rc=$?; kill $sp 2>/dev/null; exit $rc; } )'
check 'the server is stopped' 'Сервер остановлен' 'Server to'\''xtatilgan' 'Сервер тўхтатилган' '[ -s "$WORK/server.pid" ] && ! kill -0 "$(cat "$WORK/server.pid")" 2>/dev/null'

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
