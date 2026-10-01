#!/usr/bin/env bash
# Практика 08: HTTP API. Только стандартная библиотека.
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
  if "$@"; then
    PASS=$((PASS+1)); printf '  [x] %s\n' "$d"
  else
    printf '  [ ] %s\n' "$d"
  fi
}

has_file() { [ -f "$WORK/$1" ]; }
has_http_server() { grep -qE "http\.server" "$WORK/api.py" 2>/dev/null; }
has_handler_class() { grep -qE "BaseHTTPRequestHandler" "$WORK/api.py" 2>/dev/null; }
has_do_get() { grep -qE "def do_GET" "$WORK/api.py" 2>/dev/null; }
has_file_read() { grep -qE "open\(|json\.load" "$WORK/api.py" 2>/dev/null; }
has_json_type() { grep -qE "application/json" "$WORK/api.py" 2>/dev/null; }
has_health() { grep -qE "/health" "$WORK/api.py" 2>/dev/null; }
has_404() { grep -qE "404" "$WORK/api.py" 2>/dev/null; }
on_localhost() { grep -qE "127\.0\.0\.1" "$WORK/api.py" 2>/dev/null; }

# Настоящая проверка: поднимаем твой сервер и спрашиваем его клиентом.
live_health() {
  [ -f "$WORK/api.py" ] || return 1
  ( cd "$WORK" && timeout 25 python3 api.py >/tmp/lab08.log 2>&1 ) &
  local pid=$!
  local body=""
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    sleep 1
    body="$(curl -s --max-time 3 http://127.0.0.1:8000/health 2>/dev/null || true)"
    [ -n "$body" ] && break
  done
  kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
  printf '%s' "$body" | grep -q 'ok'
}

echo "$(t '--- lab 08: HTTP API ---' '--- лаб 08: HTTP API ---' '--- lab 08: HTTP API ---' '--- лаб 08: HTTP API ---')"
echo

check "$(t 'file api.py exists' 'файл api.py есть' 'api.py fayli mavjud' 'api.py файли мавжуд')" has_file api.py
check "$(t 'uses the http.server module' 'использует модуль http.server' 'http.server modulidan foydalanadi' 'http.server модулидан фойдаланади')" has_http_server
check "$(t 'defines a request handler' 'определяет обработчик запросов' "so'rov qaydovchisini belgilaydi" 'сўров қайдовчисини белгилайди')" has_handler_class
check "$(t 'there is a GET handler' 'есть обработчик GET' 'GET qaydovchisi bor' 'GET қайдовчиси бор')" has_do_get
check "$(t 'data is read from a file' 'данные читаются из файла' "ma'lumot fayldan o'qiladi" 'маълумот файлдан ўқилади')" has_file_read
check "$(t 'sets the JSON content type' 'задаёт тип содержимого application/json' "application/json kontent turini qo'yadi" 'application/json контент турини қўяди')" has_json_type
check "$(t 'has a /health path' 'есть путь /health' "/health yo'li bor" '/health йўли бор')" has_health
check "$(t 'unknown paths return 404' 'неизвестные пути дают 404' "noma'lum yo'llar 404 beradi" 'номаълум йўллар 404 беради')" has_404
check "$(t 'listens on 127.0.0.1, not on every interface' 'слушает 127.0.0.1, а не все интерфейсы' '127.0.0.1 da eshitadi, barcha interfeysda emas' '127.0.0.1 да эшитади, барча интерфейсда эмас')" on_localhost
check "$(t 'file NOTES.md exists' 'файл NOTES.md есть' 'NOTES.md fayli mavjud' 'NOTES.md файли мавжуд')" has_file NOTES.md
check "$(t 'the server really answers on /health' 'сервер действительно отвечает на /health' 'server /health ga haqiqatan javob beradi' 'сервер /health га ҳақиқатан жавоб беради')" live_health

echo
printf '%s/%s\n' "$PASS" "$TOTAL"

if [ "$PASS" -ne "$TOTAL" ] && [ -s /tmp/lab08.log ]; then
  echo
  echo "$(t 'server output:' 'вывод сервера:' 'server chiqishi:' 'сервер чиқиши:')"
  sed -n '1,5p' /tmp/lab08.log | sed 's/^/  /'
fi
rm -f /tmp/lab08.log

[ "$PASS" -eq "$TOTAL" ] && exit 0 || exit 1