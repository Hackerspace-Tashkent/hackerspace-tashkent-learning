#!/usr/bin/env bash
# Проверка S1-02: XSS.
#
# Требуется доказательство, что ученик (1) отражает ввод отзыва в
# страницу, (2) делает это БЕЗ экранирования и (3) достал токен из
# таблицы admin -- доказательство в proof.txt.
#
# Правило: токен не печатается ни при каких условиях.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="$HERE/lab-work"
DB="$WORK/reviews.db"
CHECK_LANG="${CHECK_LANG:-ru}"
PASS=0
FAIL=0

PORT=8102
SRV=""

t() { case "$CHECK_LANG" in
  en)
    case "$1" in
      db)   echo "the reviews.db fixture was created";;
      srv)  echo "the file srv.py exists";;
      run)  echo "the server answers over HTTP";;
      refl) echo "the review input comes back into the page";;
      raw)  echo "the payload arrives as a tag, not as text";;
      prf)  echo "proof.txt holds the hash of the token you pulled out";;
      die)  echo "the server crashed, or the port is busy";;
    esac ;;
  uz-lat)
    case "$1" in
      db)   echo "reviews.db bazasi tayyorlandi";;
      srv)  echo "srv.py fayli mavjud";;
      run)  echo "server HTTP orqali javob beradi";;
      refl) echo "izoh kiritmasi yana sahifaga qaytadi";;
      raw)  echo "yuklama matn emas, teg sifatida keladi";;
      prf)  echo "proof.txt da chiqargan tokening xeshi bor";;
      die)  echo "server ishlamadi yoki port band";;
    esac ;;
  uz-cyr)
    case "$1" in
      db)   echo "reviews.db базаси тайёрланди";;
      srv)  echo "srv.py файли мавжуд";;
      run)  echo "сарвер HTTP орқали жавоб беради";;
      refl) echo "изоҳ киритмаси яна саҳифага қайтади";;
      raw)  echo "юкланма матн эмас, тег сифатида келади";;
      prf)  echo "proof.txt да чиқарган токенинг хеши бор";;
      die)  echo "сервер ишламади ёки порт банд";;
    esac ;;
  *)
    case "$1" in
      db)   echo "база reviews.db создана фикстурой";;
      srv)  echo "файл srv.py существует";;
      run)  echo "сервер отвечает по HTTP";;
      refl) echo "ввод отзыва попадает обратно в страницу";;
      raw)  echo "нагрузка приходит как тег, а не как текст";;
      prf)  echo "в proof.txt хеш токена, который ты вытащил";;
      die)  echo "сервер упал или порт занят";;
    esac ;;
esac; }

# check принимает КОД ВЫХОДА команды ($?), как в остальных практиках:
# 0 это успех. report принимает явный 1/1 -- да/нет.
report() { if [ "$1" = "1" ]; then PASS=$((PASS+1)); printf '  [ok] %s\n' "$2";
           else FAIL=$((FAIL+1)); printf '  [ ] %s\n' "$2"; fi; }
check() { [ "$1" -eq 0 ] && report 1 "$2" || report 0 "$2"; }

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

# ─────────────────────────── 1. база ───────────────────────────
[ -f "$DB" ]
check "$?" "$(t db)"

# ─────────────────────────── 2. srv.py ───────────────────────────
[ -f "$WORK/srv.py" ]
check "$?" "$(t srv)"

if [ -f "$WORK/srv.py" ]; then
  PORT=$(free_port "$PORT")
  ( cd "$WORK" && exec python3 srv.py "$PORT" ) >/dev/null 2>&1 &
  SRV=$!

  UP=0; i=0
  while [ $i -lt 40 ]; do
    if (exec 3<>"/dev/tcp/127.0.0.1/$PORT") 2>/dev/null; then exec 3<&- 2>/dev/null; UP=1; break; fi
    kill -0 "$SRV" 2>/dev/null || break
    i=$((i+1)); sleep 0.25
  done

  if [ "$UP" = "1" ]; then
    report 1 "$(t run)"

    # отражение: обычный текст должен вернуться в страницу
    OUT=$(curl -s --max-time 5 -X POST \
      --data-urlencode "author=zxcv7probe" \
      --data-urlencode "body=zxcv7probe" \
      "http://127.0.0.1:$PORT/review" 2>/dev/null)
    case "$OUT" in *zxcv7probe*) report 1 "$(t refl)" ;; *) report 0 "$(t refl)" ;; esac

    # нагрузка приходит ТЕГОМ, а не текстом
    OUT=$(curl -s --max-time 5 -X POST \
      --data-urlencode 'author=<img src=x onerror=alert(1)>' \
      --data-urlencode 'body=<img src=x onerror=alert(1)>' \
      "http://127.0.0.1:$PORT/review" 2>/dev/null)
    case "$OUT" in
      *"<img src=x onerror=alert(1)>"*) report 1 "$(t raw)" ;;
      *) report 0 "$(t raw)" ;;
    esac
  else
    report 0 "$(t run)"
    echo "  (!) $(t die)"
    report 0 "$(t refl)"
    report 0 "$(t raw)"
  fi
  kill_srv
else
  report 0 "$(t run)"
  report 0 "$(t refl)"
  report 0 "$(t raw)"
fi

# ─────────────────── 6. доказательство: хеш токена ───────────────────
# sqlite3 CLI в devcontainer отсутствует (образ -- голый ubuntu-24.04
# без features), поэтому читаем базу через стандартную библиотеку.
PROOF_OK=0
if [ -f "$WORK/proof.txt" ] && [ -f "$DB" ]; then
  WANT=$(python3 - "$DB" <<'PY' 2>/dev/null
import hashlib, sqlite3, sys
try:
    c = sqlite3.connect(sys.argv[1])
    tok = c.execute("SELECT token FROM admin LIMIT 1").fetchone()[0]
    c.close()
except Exception:
    sys.exit(1)
sys.stdout.write(hashlib.sha256(tok.encode()).hexdigest()[:12])
PY
)
  GOT=$(tr -d ' \n' < "$WORK/proof.txt" 2>/dev/null)
  if [ -n "$WANT" ] && [ "$WANT" = "$GOT" ]; then PROOF_OK=1; fi
fi
report "$PROOF_OK" "$(t prf)"

TOTAL=$((PASS+FAIL))
echo
echo "Готово: $PASS/$TOTAL"

if [ "${1:-}" = "--submit" ]; then
  if [ "$PASS" = "$TOTAL" ]; then
    printf '[hackerspace-submit]\ntrack=security/level-1/02-cross-site-scripting\n'
    exit 0
  fi
  exit 1
fi
[ "$PASS" = "$TOTAL" ] && exit 0 || exit 1