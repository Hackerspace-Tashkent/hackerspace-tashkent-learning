#!/usr/bin/env bash
# Проверка S2-01: CSRF.
#
# Два режима: без флага -- сервер с токеном, с --unsafe -- без него.
# Иначе требовать уязвимость и защиту в одном прогоне невозможно.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="$HERE/lab-work"
STATE="$WORK/state.txt"
CHECK_LANG="${CHECK_LANG:-ru}"
PASS=0; FAIL=0
PORT=8111; SRV=""
JAR="$(mktemp /tmp/s201-jar-XXXXXX)"

t() { case "$CHECK_LANG" in
  en)
    case "$1" in
      srv)  echo "the file srv.py exists";;
      run)  echo "the server answers over HTTP";;
      cook) echo "the server sets a session cookie";;
      noTokF) echo "in vulnerable mode the form carries no token";;
      inj)  echo "in vulnerable mode a foreign POST goes through";;
      tokF) echo "in safe mode the form contains a token";;
      noTok) echo "without the token the action is refused";;
      yesTok) echo "with the right token the action goes through";;
      die)  echo "the server crashed, or the port is busy";;
    esac ;;
  uz-lat)
    case "$1" in
      srv)  echo "srv.py fayli mavjud";;
      run)  echo "server HTTP orqali javob beradi";;
      cook) echo "server sessiya cookie si qoʻyadi";;
      noTokF) echo "zaif rejimda forma tokensiz keladi";;
      inj)  echo "zaif rejimda begona soʻrov oʻtadi";;
      tokF) echo "xavfsiz rejimda forma tokenni oladi";;
      noTok) echo "tokensiz amal rad etiladi";;
      yesTok) echo "toʻgʻri token bilan amal bajariladi";;
      die)  echo "server ishlamadi yoki port band";;
    esac ;;
  uz-cyr)
    case "$1" in
      srv)  echo "srv.py файли мавжуд";;
      run)  echo "сарвер HTTP орқали жавоб беради";;
      cook) echo "сарвер сессия cookie қўяди";;
      noTokF) echo "заиф режимда форма токенсиз келади";;
      inj)  echo "заиф режимда бегона сўров ўтади";;
      tokF) echo "хавфсиз режимда форма токенни олади";;
      noTok) echo "токенсиз амал рад этилади";;
      yesTok) echo "тўғри токен билан амал бажарилади";;
      die)  echo "сервер ишламади ёки порт банд";;
    esac ;;
  *)
    case "$1" in
      srv)  echo "файл srv.py существует";;
      run)  echo "сервер отвечает по HTTP";;
      cook) echo "сервер ставит cookie сессии";;
      noTokF) echo "в уязвимом режиме форма идёт без токена";;
      inj)  echo "в уязвимом режиме чужой POST проходит";;
      tokF) echo "в безопасном режиме форма содержит токен";;
      noTok) echo "без токена действие отклоняется";;
      yesTok) echo "с правильным токеном действие проходит";;
      die)  echo "сервер упал или порт занят";;
    esac ;;
esac; }

report() { if [ "$1" = "1" ]; then PASS=$((PASS+1)); printf '  [x] %s\n' "$2";
           else FAIL=$((FAIL+1)); printf '  [ ] %s\n' "$2"; fi; }

kill_srv() {
  [ -n "$SRV" ] || return 0
  pkill -P "$SRV" 2>/dev/null
  kill -TERM "$SRV" 2>/dev/null
  wait "$SRV" 2>/dev/null
  SRV=""
}
trap 'kill_srv; rm -f "$JAR"' EXIT

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

# ── srv.py ──
if [ -f "$WORK/srv.py" ]; then report 1 "$(t srv)"; else report 0 "$(t srv)"; fi

if [ -f "$WORK/srv.py" ]; then
  # ── уязвимый режим: действия без токена ──
  PORT=$(free_port "$PORT")
  if start_srv "$PORT" --unsafe; then
    report 1 "$(t run)"
    rm -f "$JAR"

    # получаем сессию и форму
    FORM_V=$(curl -s -c "$JAR" --max-time 8 "http://127.0.0.1:$PORT/set" 2>/dev/null)
    FORM_V=$(curl -s -b "$JAR" --max-time 8 "http://127.0.0.1:$PORT/form" 2>/dev/null)

    if grep -q . "$JAR" 2>/dev/null; then report 1 "$(t cook)"
    else report 0 "$(t cook)"; fi

    # токена в форме нет
    printf '%s' "$FORM_V" | grep -qiE 'csrf|token' \
      && report 0 "$(t noTokF)" || report 1 "$(t noTokF)"

    # чужой POST без токена ПРОХОДИТ -- это и есть уязвимость
    R=$(curl -s -b "$JAR" --max-time 8 -X POST \
          --data-urlencode "email=attacker@example.com" \
          "http://127.0.0.1:$PORT/action" 2>/dev/null)
    case "$R" in
      *ok*|*changed*|*accepted*|*updated*) report 1 "$(t inj)" ;;
      *) report 0 "$(t inj)" ;;
    esac
    kill_srv
  else
    report 0 "$(t run)"
    echo "  (!) $(t die)"
    report 0 "$(t cook)"; report 0 "$(t noTokF)"; report 0 "$(t inj)"
  fi

  # ── безопасный режим ──
  PORT=$(free_port "$PORT")
  if start_srv "$PORT"; then
    rm -f "$JAR"
    curl -s -c "$JAR" --max-time 8 "http://127.0.0.1:$PORT/set" >/dev/null 2>&1
    FORM=$(curl -s -b "$JAR" --max-time 8 "http://127.0.0.1:$PORT/form" 2>/dev/null)
    # поле csrf может быть записано с кавычками и без них --
    # ученик напишет как сможет, и это не должно быть причиной провала
    TOKEN=$(printf '%s' "$FORM" \
            | grep -oiE "name=[\"']?csrf[\"']?[^>]*value=[\"']?[^\"' >]+" \
            | head -1 \
            | grep -oiE "value=[\"']?[^\"' >]+" \
            | head -1 \
            | sed -e 's/^value=//' -e 's/^["'"'"']//' -e 's/["'"'"']$//')

    if [ -n "$TOKEN" ]; then report 1 "$(t tokF)"; else report 0 "$(t tokF)"; fi

    if [ -n "$TOKEN" ]; then
      R=$(curl -s -b "$JAR" --max-time 8 -X POST \
            --data-urlencode "email=attacker@example.com" \
            "http://127.0.0.1:$PORT/action" 2>/dev/null)
      case "$R" in
        *ok*|*changed*|*accepted*|*updated*) report 0 "$(t noTok)" ;;
        *) report 1 "$(t noTok)" ;;
      esac
      R2=$(curl -s -b "$JAR" --max-time 8 -X POST \
             --data-urlencode "email=you2@example.com" \
             --data-urlencode "csrf=$TOKEN" \
             "http://127.0.0.1:$PORT/action" 2>/dev/null)
      case "$R2" in
        *ok*|*changed*|*accepted*|*updated*) report 1 "$(t yesTok)" ;;
        *) report 0 "$(t yesTok)" ;;
      esac
    else
      report 0 "$(t noTok)"; report 0 "$(t yesTok)"
    fi
    kill_srv
  else
    report 0 "$(t tokF)"; report 0 "$(t noTok)"; report 0 "$(t yesTok)"
  fi

else
  report 0 "$(t run)"; report 0 "$(t cook)"; report 0 "$(t noTokF)"
  report 0 "$(t inj)"; report 0 "$(t tokF)"; report 0 "$(t noTok)"
  report 0 "$(t yesTok)"
fi

TOTAL=$((PASS+FAIL))
echo
echo "Готово: $PASS/$TOTAL"

if [ "${1:-}" = "--submit" ]; then
  if [ "$PASS" = "$TOTAL" ]; then
    printf '[hackerspace-submit]\ntrack=security/level-2/01-csrf\n'
    exit 0
  fi
  exit 1
fi
[ "$PASS" = "$TOTAL" ] && exit 0 || exit 1