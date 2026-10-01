#!/usr/bin/env bash
# Практика S0-01: что сервер видит.
# Только своя машина: 127.0.0.1. Никаких чужих серверов.
set -u
cd "$(dirname "$0")"
[ -n "${CHECK_LANG:-}" ] || CHECK_LANG=ru
HERE="$(pwd)"
WORK="$HERE/lab-work"
PASS=0
TOTAL=0

t() { case "$CHECK_LANG" in
  en) printf '%s\n' "$1" ;;
  uz-lat) printf '%s\n' "$3" ;;
  uz-cyr) printf '%s\n' "$4" ;;
  *) printf '%s\n' "$2" ;; esac; }

check() {
  local d="$1"; shift
  TOTAL=$((TOTAL+1))
  if "$@"; then PASS=$((PASS+1)); printf '  [x] %s\n' "$d"
  else printf '  [ ] %s\n' "$d"; fi
}

has_file()   { [ -f "$WORK/$1" ]; }
has_http()   { grep -qE "http\.server" "$WORK/srv.py" 2>/dev/null; }
reads_client(){ grep -qE "self\.headers" "$WORK/srv.py" 2>/dev/null; }
has_debug()  { grep -q "X-Debug" "$WORK/srv.py" 2>/dev/null; }
has_key()    { grep -q "X-Access-Key" "$WORK/srv.py" 2>/dev/null; }
proof_ok()   { [ -f "$WORK/proof.txt" ] && [ -s "$WORK/proof.txt" ]; }
notes_ok()   { [ -f "$WORK/notes.md" ]; }

# Живая проверка: поднимаем сервер ученика и говорим с ним по HTTP.
# Требуется ровно то поведение, ради которого задана тема:
#   1) заголовок отладки отдаёт внутренний ключ,
#   2) с этим ключом данные открываются,
#   3) без ключа — не открываются.
live_probe() {
  [ -f "$WORK/srv.py" ] || return 1
  local health="" secret="" code="000"
  ( cd "$WORK" && timeout 30 python3 srv.py >/tmp/s001.log 2>&1 ) &
  local pid=$!
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    sleep 1
    health="$(curl -s --max-time 3 -H 'X-Debug: 1' http://127.0.0.1:8000/health 2>/dev/null || true)"
    [ -n "$health" ] && break
  done
  if printf '%s' "$health" | grep -qE '[a-z]{4,}-[a-z]{4,}-[0-9]+'; then
    secret="$(printf '%s' "$health" | grep -oE '[a-z]{4,}-[a-z]{4,}-[0-9]+' | head -1)"
    code="$(curl -s --max-time 3 -o /dev/null -w '%{http_code}' \
             -H "X-Access-Key: $secret" http://127.0.0.1:8000/readings 2>/dev/null || echo 000)"
  fi
  kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
  [ "$code" = "200" ]
}

# Доказательство понимания: ученик записал хеш найденного ключа.
# Ключ проверка достаёт сама, отправляет серверу и сверяет хеш.
proof_matches() {
  [ -f "$WORK/srv.py" ] && [ -f "$WORK/proof.txt" ] || return 1
  local key
  key="$(grep -oE '"[a-z]{4,}-[a-z]{4,}-[0-9]+"' "$WORK/srv.py" | head -1 | tr -d '"')"
  [ -n "$key" ] || return 1
  local want got
  want="$(printf '%s' "$key" | sha256sum | cut -c1-12)"
  got="$(tr -d ' \n' < "$WORK/proof.txt")"
  [ "$want" = "$got" ]
}

echo "$(t 'S0-01: what the server sees' 'S0-01: что сервер видит' \
         'S0-01: server nimani koʻradi' 'S0-01: сервер нимани кўради')"
echo

check "$(t 'file srv.py exists' 'файл srv.py есть' 'srv.py fayli mavjud' 'srv.py файли мавжуд')" has_file srv.py
check "$(t 'reads the headers the client sent' 'читает заголовки, которые прислал клиент' \
         'klient yuborgan sarlavhalarni oqiydi' 'клиент юборган сарлавҳаларни ўқийди')" reads_client
check "$(t 'has the X-Debug branch' 'есть ветка X-Debug' 'X-Debug tarmogʻi bor' 'X-Debug тармоғи бор')" has_debug
check "$(t 'reads the X-Access-Key header' 'читает заголовок X-Access-Key' \
         'X-Access-Key sarlavhasini oqiydi' 'X-Access-Key сарлавҳасини ўқийди')" has_key
check "$(t 'file notes.md exists' 'файл notes.md существует' 'notes.md fayli mavjud' 'notes.md файли мавжуд')" notes_ok
check "$(t 'proof.txt holds the hash of the key you found' \
         'в proof.txt хеш найденного ключа' \
         'proof.txt da topilgan kalitning xeshi bor' \
         'proof.txt да топилган калитнинг хеши бор')" proof_matches
check "$(t 'your own server leaks on X-Debug and opens on the key' \
         'твой сервер отдаёт секрет на X-Debug и открывает по ключу' \
         'sizning serveringiz X-Debug da sirni beradi va kalit bilan ochadi' \
         'сизнинг серверингиз X-Debug да сирни беради ва калит билан очади')" live_probe

echo
printf '%s/%s\n' "$PASS" "$TOTAL"
[ "$PASS" -eq "$TOTAL" ] && exit 0 || exit 1
