#!/usr/bin/env bash
# Проверка S1-03: выход за пределы своей папки.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="$HERE/lab-work"
ROOT="$WORK/public"
SECRET="$WORK/secret.txt"
CHECK_LANG="${CHECK_LANG:-ru}"
PASS=0; FAIL=0
PORT=8103; SRV=""

t() { case "$CHECK_LANG" in
  en)
    case "$1" in
      srv)  echo "the file srv.py exists";;
      run)  echo "the server answers over HTTP";;
      ok)   echo "a normal file is served";;
      bad)  echo "the path traversal reaches secret.txt";;
      keep) echo "secret.txt was not deleted to pass the check";;
      close) echo "after the fix the traversal no longer works";;
      die)  echo "the server crashed, or the port is busy";;
    esac ;;
  uz-lat)
    case "$1" in
      srv)  echo "srv.py fayli mavjud";;
      run)  echo "server HTTP orqali javob beradi";;
      ok)   echo "oddiy fayl beriladi";;
      bad)  echo "yoʻlni chetlab oʻtish secret.txt ga yetadi";;
      keep) echo "secret.txt oʻchirilmagan";;
      close) echo "yopilgandan keyin chetlab oʻtish ishlamaydi";;
      die)  echo "server ishlamadi yoki port band";;
    esac ;;
  uz-cyr)
    case "$1" in
      srv)  echo "srv.py файли мавжуд";;
      run)  echo "сарвер HTTP орқали жавоб беради";;
      ok)   echo "оддий файл берилади";;
      bad)  echo "йўлни айланиб ўтиш secret.txt га етади";;
      keep) echo "secret.txt ўчирилмаган";;
      close) echo "ёпилгандан кейин айланиб ўтиш ишламайди";;
      die)  echo "сервер ишламади ёки порт банд";;
    esac ;;
  *)
    case "$1" in
      srv)  echo "файл srv.py существует";;
      run)  echo "сервер отвечает по HTTP";;
      ok)   echo "обычный файл отдаётся";;
      bad)  echo "обход пути достаёт secret.txt";;
      keep) echo "secret.txt не удалён, чтобы пройти проверку";;
      close) echo "после защиты обход больше не работает";;
      die)  echo "сервер упал или порт занят";;
    esac ;;
esac; }

report() { if [ "$1" = "1" ]; then PASS=$((PASS+1)); printf '  [x] %s\n' "$2";
           else FAIL=$((FAIL+1)); printf '  [ ] %s\n' "$2"; fi; }
check()  { [ "$1" -eq 0 ] && report 1 "$2" || report 0 "$2"; }

kill_srv() {
  [ -n "$SRV" ] || return 0
  pkill -P "$SRV" 2>/dev/null
  kill -TERM "$SRV" 2>/dev/null
  wait "$SRV" 2>/dev/null
  SRV=""
}
trap kill_srv EXIT

free_port() {
  local p=$1 i=0
  while [ $i -lt 40 ]; do
    if ! (exec 3<>"/dev/tcp/127.0.0.1/$p") 2>/dev/null; then echo "$p"; return; fi
    exec 3<&- 2>/dev/null || true
    p=$((p+1)); i=$((i+1))
  done
  echo "$1"
}

# Проверки фикстуры нет намеренно: её создаёт setup.sh, а не ученик.
# Все практики на пустом состоянии дают 0 -- так честнее.

# ── srv.py ──
[ -f "$WORK/srv.py" ]
check "$?" "$(t srv)"

if [ -f "$WORK/srv.py" ]; then
  # Задание двухэтапное: сначала дыра, потом защита. Одним запуском
  # это не проверить -- сервер не может одновременно отдавать файл
  # наружу и не отдавать. Поэтому у srv.py два режима:
  #   python3 srv.py <порт>            -- безопасный (по умолчанию)
  #   python3 srv.py <порт> --unsafe   -- с дырой, для проверки
  start_srv() {
    ( cd "$WORK" && exec python3 srv.py "$1" ${2:-} ) >/dev/null 2>&1 &
    SRV=$!
    local i=0
    while [ $i -lt 40 ]; do
      if (exec 3<>"/dev/tcp/127.0.0.1/$1") 2>/dev/null; then
        exec 3<&- 2>/dev/null; return 0
      fi
      kill -0 "$SRV" 2>/dev/null || return 1
      i=$((i+1)); sleep 0.25
    done
    return 1
  }

  PORT=$(free_port "$PORT")
  if start_srv "$PORT" --unsafe; then
    report 1 "$(t run)"

    OK=$(curl -s --max-time 5 "http://127.0.0.1:$PORT/notes.txt" 2>/dev/null)
    case "$OK" in *"публичной папки"*) report 1 "$(t ok)" ;; *) report 0 "$(t ok)" ;; esac

    OUT=$(curl -s --max-time 5 --path-as-is \
      "http://127.0.0.1:$PORT/../secret.txt" 2>/dev/null)
    case "$OUT" in *"не должен уходить"*) report 1 "$(t bad)" ;; *) report 0 "$(t bad)" ;; esac

    kill_srv
  else
    report 0 "$(t run)"
    echo "  (!) $(t die)"
    report 0 "$(t ok)"; report 0 "$(t bad)"
  fi

  # тот же сервер, но в безопасном режиме
  PORT=$(free_port "$PORT")
  if start_srv "$PORT"; then
    OUT2=$(curl -s --max-time 5 --path-as-is \
      "http://127.0.0.1:$PORT/../secret.txt" 2>/dev/null)
    case "$OUT2" in
      *"не должен уходить"*) report 0 "$(t close)" ;;
      *) report 1 "$(t close)" ;;
    esac
    kill_srv
  else
    report 0 "$(t close)"
  fi

  # файл на месте: его нельзя было удалить вместо защиты
  [ -f "$SECRET" ]
  check "$?" "$(t keep)"
else
  report 0 "$(t run)"; report 0 "$(t ok)"
  report 0 "$(t bad)"; report 0 "$(t close)"; report 0 "$(t keep)"
fi

TOTAL=$((PASS+FAIL))
echo
echo "Готово: $PASS/$TOTAL"

if [ "${1:-}" = "--submit" ]; then
  if [ "$PASS" = "$TOTAL" ]; then
    printf '[hackerspace-submit]\ntrack=security/level-1/03-path-traversal\n'
    exit 0
  fi
  exit 1
fi
[ "$PASS" = "$TOTAL" ] && exit 0 || exit 1
