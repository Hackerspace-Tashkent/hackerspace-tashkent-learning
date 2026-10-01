#!/usr/bin/env bash
# Практика S1-01: SQL-инъекция. Своя база, свой сервер, свой компьютер.
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
not_empty()  { [ -f "$WORK/$1" ] && [ -s "$WORK/$1" ]; }
uses_sqlite(){ grep -qE "sqlite3" "$WORK/srv.py" 2>/dev/null; }

# Ключ читает сама проверка из базы ученика. Ученику достаётся он
# только через инъекцию: отдельного файла с ключом не существует.
db_key() {
  [ -f "$WORK/data.db" ] || return 1
  python3 - "$WORK/data.db" <<'PY'
import sqlite3, sys
try:
    db = sqlite3.connect("file:%s?mode=ro" % sys.argv[1], uri=True)
    row = db.execute("SELECT code FROM vault").fetchone()
    if row and row[0]:
        print(row[0])
except Exception:
    pass
PY
}

# Ключ не должен быть зашит прямо в код сервера.
key_not_in_code() {
  [ -f "$WORK/srv.py" ] || return 1
  local key
  key="$(db_key)"
  [ -n "$key" ] || return 1
  ! grep -qF "$key" "$WORK/srv.py" 2>/dev/null
}

proof_matches() {
  local key want got
  key="$(db_key)" || return 1
  [ -n "$key" ] || return 1
  [ -s "$WORK/proof.txt" ] || return 1
  want="$(printf '%s' "$key" | sha256sum | cut -c1-12)"
  got="$(tr -d ' \n' < "$WORK/proof.txt")"
  [ "$want" = "$got" ]
}

# Живая проверка. Первой инъекцией сливается people -- до vault так не
# добраться. Настоящее задание -- дотянуть UNION до второй таблицы,
# поэтому проверка требует в ответе ИМЕННО ключ из базы, а не просто
# много строк. Этого нельзя добиться, не разобравшись в запросе.
PAYLOAD="' UNION SELECT code, note FROM vault--"

# Порт занят чужим или ещё не ушедшим процессом? Ждём освобождения.
# Если после ожидания всё ещё занято -- это не наш сервер, и отвечать
# на запрос будем не мы. Такой результат засчитывать нельзя.
port_busy() {
  python3 - <<'PY'
import socket, sys
s = socket.socket()
s.settimeout(0.4)
try:
    s.connect(("127.0.0.1", 8000))
    print("busy")
except OSError:
    print("free")
finally:
    s.close()
PY
}

wait_port_free() {
  local n
  for n in 1 2 3 4 5 6 7 8 9 10; do
    [ "$(port_busy)" = "free" ] && return 0
    sleep 1
  done
  return 1
}

live_injection() {
  [ -f "$WORK/srv.py" ] || return 1
  local key out
  key="$(db_key)"
  [ -n "$key" ] || return 1

  # Если порт занят -- ответ придёт не от нашего srv.py.
  wait_port_free || return 1

  # setsid даёт серверу собственную группу процессов: kill -- -pid гасит
  # и его самого, и потомков. Обычный kill оставлял python3 живым, и порт
  # продолжал отвечать за следующий прогон.
  ( cd "$WORK" && exec setsid timeout 30 python3 srv.py ) >/tmp/s101.log 2>&1 &
  local pid=$!
  for _ in $(seq 1 12); do
    sleep 1
    kill -0 "$pid" 2>/dev/null || return 1   # сервер умер -- честно fail
    out="$(curl -s --max-time 4 --get \
            --data-urlencode "name=$PAYLOAD" \
            http://127.0.0.1:8000/lookup 2>/dev/null || true)"
    [ -n "$out" ] && break
  done
  kill -- -"$pid" 2>/dev/null || kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
  [ -n "$out" ] || return 1
  printf '%s' "$out" | grep -qF "$key"
  local ok=$?
  wait_port_free >/dev/null 2>&1 || true
  return $ok
}

echo "$(t 'S1-01: SQL injection' 'S1-01: SQL-инъекция' \
         'S1-01: SQL inyektsiyasi' 'S1-01: SQL инъекцияси')"
echo

check "$(t 'file srv.py exists' 'файл srv.py существует' 'srv.py fayli mavjud' 'srv.py файли мавжуд')" has_file srv.py
check "$(t 'srv.py uses sqlite3' 'srv.py использует sqlite3' 'srv.py sqlite3 ishlatadi' 'srv.py sqlite3 ишлатади')" uses_sqlite
check "$(t 'the key is not hardcoded in srv.py' 'ключ не зашит в srv.py' \
         'kalit srv.py ga yozib qoʻyilmagan' \
         'калит srv.py га ёзиб қўйилмаган')" key_not_in_code
check "$(t 'proof.txt holds the hash of the key you pulled out' \
         'в proof.txt хеш ключа, который ты вытащил' \
         'proof.txt da chiqarib olgan kalitning xeshi bor' \
         'proof.txt да чиқариб олган калитнинг хеши бор')" proof_matches
check "$(t 'the injection pulls the key out of the second table over HTTP' \
         'инъекция вытаскивает ключ из второй таблицы по HTTP' \
         'inyektsiya ikkinchi jadvaldan kalitni HTTP orqali chiqaradi' \
         'инъекция иккинчи жадвалдан калитни HTTP орқали чиқаради')" live_injection
check "$(t 'file notes.md exists' 'файл notes.md существует' 'notes.md fayli mavjud' 'notes.md файли мавжуд')" has_file notes.md

echo
printf '%s/%s\n' "$PASS" "$TOTAL"
[ "$PASS" -eq "$TOTAL" ] && exit 0 || exit 1
