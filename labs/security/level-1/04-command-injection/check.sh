#!/usr/bin/env bash
# Проверка S1-04: внедрение команд.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="$HERE/lab-work"
FLAG="$WORK/flag.txt"
CHECK_LANG="${CHECK_LANG:-ru}"
PASS=0; FAIL=0
PORT=8104; SRV=""

t() { case "$CHECK_LANG" in
  en)
    case "$1" in
      srv)  echo "the file srv.py exists";;
      run)  echo "the server answers over HTTP";;
      ping) echo "a normal host is answered";;
      inj)  echo "the injected command reads flag.txt";;
      close) echo "after the fix the injection no longer works";;
      keep) echo "flag.txt was not deleted to pass the check";;
      die)  echo "the server crashed, or the port is busy";;
    esac ;;
  uz-lat)
    case "$1" in
      srv)  echo "srv.py fayli mavjud";;
      run)  echo "server HTTP orqali javob beradi";;
      ping) echo "oddiy hostga javob beriladi";;
      inj)  echo "yuklangan buyruq flag.txt ni oʻqiydi";;
      close) echo "yopilgandan keyin inyeksiya ishlamaydi";;
      keep) echo "flag.txt oʻchirilmagan";;
      die)  echo "server ishlamadi yoki port band";;
    esac ;;
  uz-cyr)
    case "$1" in
      srv)  echo "srv.py файли мавжуд";;
      run)  echo "сарвер HTTP орқали жавоб беради";;
      ping) echo "оддий хостга жавоб берилади";;
      inj)  echo "юкланган буйруқ flag.txt ни ўқийди";;
      close) echo "ёпилгандан кейин инъекция ишламайди";;
      keep) echo "flag.txt ўчирилмаган";;
      die)  echo "сервер ишламади ёки порт банд";;
    esac ;;
  *)
    case "$1" in
      srv)  echo "файл srv.py существует";;
      run)  echo "сервер отвечает по HTTP";;
      ping) echo "на обычный хост отвечает";;
      inj)  echo "внедрённая команда читает flag.txt";;
      close) echo "после защиты инъекция не работает";;
      keep) echo "flag.txt не удалён, чтобы пройти проверку";;
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

[ -f "$WORK/srv.py" ]
check "$?" "$(t srv)"

if [ -f "$WORK/srv.py" ]; then
  PORT=$(free_port "$PORT")

  # ── уязвимый режим: команда собирается строкой ──
  if start_srv "$PORT" --unsafe; then
    report 1 "$(t run)"
    case "$(curl -s --max-time 8 --get \
             --data-urlencode 'host=localhost' \
             "http://127.0.0.1:$PORT/ping" 2>/dev/null)" in
      *"localhost"*) report 1 "$(t ping)" ;;
      *) report 0 "$(t ping)" ;;
    esac
    case "$(curl -s --max-time 8 --get \
             --data-urlencode 'host=; cat flag.txt' \
             "http://127.0.0.1:$PORT/ping" 2>/dev/null)" in
      *"flag{"*) report 1 "$(t inj)" ;;
      *) report 0 "$(t inj)" ;;
    esac
    kill_srv
  else
    report 0 "$(t run)"
    echo "  (!) $(t die)"
    report 0 "$(t ping)"; report 0 "$(t inj)"
  fi

  # ── безопасный режим ──
  PORT=$(free_port "$PORT")
  if start_srv "$PORT"; then
    case "$(curl -s --max-time 8 --get \
             --data-urlencode 'host=; cat flag.txt' \
             "http://127.0.0.1:$PORT/ping" 2>/dev/null)" in
      *"flag{"*) report 0 "$(t close)" ;;
      *) report 1 "$(t close)" ;;
    esac
    kill_srv
  else
    report 0 "$(t close)"
  fi

  [ -f "$FLAG" ]
  check "$?" "$(t keep)"
else
  report 0 "$(t run)"; report 0 "$(t ping)"
  report 0 "$(t inj)"; report 0 "$(t close)"; report 0 "$(t keep)"
fi

TOTAL=$((PASS+FAIL))
echo
echo "Готово: $PASS/$TOTAL"

if [ "${1:-}" = "--submit" ]; then
  if [ "$PASS" = "$TOTAL" ]; then
    printf '[hackerspace-submit]\ntrack=security/level-1/04-command-injection\n'
    exit 0
  fi
  exit 1
fi
[ "$PASS" = "$TOTAL" ] && exit 0 || exit 1
