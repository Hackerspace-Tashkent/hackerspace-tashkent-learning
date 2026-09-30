#!/usr/bin/env bash
# Автопроверка: Lesson 7. Processes and services
#
#   ./check.sh            только проверить
#   ./check.sh --submit   проверить и опубликовать результат
#
# Язык вывода:  CHECK_LANG=ru|uz-lat|uz-cyr|en  ./check.sh
# Всё делается в ./lab-work рядом с этим скриптом.
set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$HERE/lab-work"
LESSON="03-processes-and-services"
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
check 'worker.sh exists and is executable' 'worker.sh существует и исполняем' 'worker.sh mavjud va bajariladigan' 'worker.sh мавжуд ва бажариладиган' '[ -x "$WORK/worker.sh" ]'
check 'worker.sh handles TERM' 'worker.sh обрабатывает TERM' 'worker.sh TERM ni ushlaydi' 'worker.sh TERM ни ушлаб олади' 'grep -q "trap" "$WORK/worker.sh"'
check 'worker.pid was saved' 'worker.pid сохранён' 'worker.pid saqlangan' 'worker.pid сақланган' '[ -s "$WORK/worker.pid" ] && grep -qE '\''^[0-9]+$'\'' "$WORK/worker.pid"'
check 'worker.log has periodic lines' 'worker.log содержит периодические строки' 'worker.log davriy qatorlarni saqlaydi' 'worker.log даврий қаторларни сақлайди' '[ -f "$WORK/worker.log" ] && [ "$(wc -l < "$WORK/worker.log")" -ge 2 ]'
check 'worker.log ends with the cleanup line' 'worker.log заканчивается строкой уборки' 'worker.log tozalash qatori bilan tugaydi' 'worker.log тозалаш қатори билан тугайди' 'cd "$WORK" && [ -s worker.log ] && tail -n 3 worker.log | grep -qiE '\''clean|stop|exit|finish'\'''
check 'the process is no longer running' 'Процесс больше не работает' 'Jarayon endi ishlamaydi' 'Жараён энди ишламайди' '[ -s "$WORK/worker.pid" ] && ! kill -0 "$(cat "$WORK/worker.pid")" 2>/dev/null'
check 'worker.service exists' 'worker.service существует' 'worker.service mavjud' 'worker.service мавжуд' '[ -f "$WORK/worker.service" ]'
check 'unit has Unit, Service and Install sections' 'Юнит содержит секции Unit, Service и Install' 'Unitda Unit, Service va Install bo'\''limlari bor' 'Юнитда Unit, Service ва Install бўлимлари бор' 'cd "$WORK" && for s in Unit Service Install; do grep -q "^\[$s\]" worker.service || exit 1; done'
check 'ExecStart points at an absolute path' 'ExecStart указывает абсолютный путь' 'ExecStart absolyut yo'\''lni ko'\''rsatadi' 'ExecStart абсолют йўлни кўрсатади' 'cd "$WORK" && grep -qE "^ExecStart=/" worker.service'

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
