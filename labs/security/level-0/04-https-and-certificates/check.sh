#!/usr/bin/env bash
# Практика S0-04: сертификаты и кто кому доверяет.
# Всё локально: свой сервер, свой сертификат, 127.0.0.1.
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

has_file()  { [ -f "$WORK/$1" ]; }
not_empty() { [ -f "$WORK/$1" ] && [ -s "$WORK/$1" ]; }
has_ssl()   { grep -qE "ssl\.|SSLContext|wrap_socket" "$WORK/server.py" 2>/dev/null; }
has_load()  { grep -qE "load_cert_chain" "$WORK/server.py" 2>/dev/null; }

cert_text() { openssl x509 -in "$WORK/cert.pem" -noout -text 2>/dev/null; }

# Сертификат должен называть localhost, иначе проверка имени не пройдёт.
names_localhost() {
  cert_text | grep -qiE 'CN *= *localhost|DNS:localhost'
}

# Срок действия: учебный сертификат живёт недолго, но не должен быть
# бессрочным — иначе он не проверит ничего.
has_dates() {
  local a b
  a="$(openssl x509 -in "$WORK/cert.pem" -noout -startdate 2>/dev/null | cut -d= -f2)"
  b="$(openssl x509 -in "$WORK/cert.pem" -noout -enddate 2>/dev/null | cut -d= -f2)"
  [ -n "$a" ] && [ -n "$b" ] && [ "$a" != "$b" ]
}

# Доказательство: отпечаток сертификата, который ученик предъявил.
fingerprint_ok() {
  [ -f "$WORK/cert.pem" ] && [ -f "$WORK/proof.txt" ] || return 1
  local want got
  want="$(openssl x509 -in "$WORK/cert.pem" -noout -fingerprint -sha256 2>/dev/null \
          | cut -d= -f2 | tr -d ':' | tr 'A-Z' 'a-z' | cut -c1-16)"
  got="$(tr -d ' \n:' < "$WORK/proof.txt" | tr 'A-Z' 'a-z' | cut -c1-16)"
  [ -n "$want" ] && [ "$want" = "$got" ]
}

# Порт занят? Ждём освобождения. Если после ожидания всё ещё занят --
# отвечать будет не наш сервер, и засчитывать это нельзя.
port_busy() {
  python3 - <<'PY'
import socket
s = socket.socket()
s.settimeout(0.4)
try:
    s.connect(("127.0.0.1", 8443))
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

# Запуск в отдельной группе процессов: иначе kill не достаёт до python3,
# сервер остаётся жить и следующая проверка получает ответ от него.
start_server() {
  ( cd "$WORK" && exec setsid timeout 25 python3 server.py ) \
      >/tmp/s004.log 2>&1 &
  SRV_PID=$!
}

stop_server() {
  kill -- -"$SRV_PID" 2>/dev/null || kill "$SRV_PID" 2>/dev/null || true
  wait "$SRV_PID" 2>/dev/null || true
  wait_port_free >/dev/null 2>&1 || true
}

# Живая проверка 1: с проверкой сертификата соединение проходит.
live_verified() {
  [ -f "$WORK/server.py" ] && [ -f "$WORK/cert.pem" ] || return 1
  wait_port_free || return 1
  start_server
  local n out=""
  for n in 1 2 3 4 5 6 7 8; do
    sleep 1
    kill -0 "$SRV_PID" 2>/dev/null || return 1
    out="$( cd "$WORK" && timeout 10 python3 client.py 2>&1 || true )"
    printf '%s' "$out" | grep -qiE "verified" && break
  done
  stop_server
  printf '%s' "$out" | grep -qiE "verified"
}

# Живая проверка 2: БЕЗ проверки соединение проходит тоже.
# Это и есть смысл темы: без проверки "шифрование" ничего не значит.
live_unverified() {
  [ -f "$WORK/server.py" ] && [ -f "$WORK/cert.pem" ] || return 1
  wait_port_free || return 1
  start_server
  local n out=""
  for n in 1 2 3 4 5 6 7 8; do
    sleep 1
    kill -0 "$SRV_PID" 2>/dev/null || return 1
    out="$( cd "$WORK" && timeout 10 python3 client.py --no-verify 2>&1 || true )"
    printf '%s' "$out" | grep -qiE "unverified|no-verify" && break
  done
  stop_server
  printf '%s' "$out" | grep -qiE "unverified|no-verify"
}

echo "$(t 'S0-04: certificates' 'S0-04: сертификаты' \
         'S0-04: sertifikatlar' 'S0-04: сертификатлар')"
echo

check "$(t 'file cert.pem exists' 'файл cert.pem существует' 'cert.pem fayli mavjud' 'cert.pem файли мавжуд')" has_file cert.pem
check "$(t 'file key.pem exists' 'файл key.pem существует' 'key.pem fayli mavjud' 'key.pem файли мавжуд')" has_file key.pem
check "$(t 'the certificate names localhost' 'сертификат называет localhost' \
         'sertifikat localhost nomlaydi' 'сертификат localhost номлайди')" names_localhost
check "$(t 'the certificate has a start and an end date' \
         'у сертификата есть начало и конец срока' \
         'sertifikatda boshlanish va tugash sanasi bor' \
         'сертификатда бошланиш ва тугаш санаси бор')" has_dates
check "$(t 'server.py uses ssl' 'server.py использует ssl' 'server.py ssl ishlatadi' 'server.py ssl ишлатади')" has_ssl
check "$(t 'server.py loads the certificate' 'server.py загружает сертификат' \
         'server.py sertifikatni yuklaydi' 'server.py сертификатни юклайди')" has_load
check "$(t 'proof.txt holds the certificate fingerprint' \
         'в proof.txt отпечаток сертификата' \
         'proof.txt da sertifikatning izi bor' \
         'proof.txt да сертификатнинг изи бор')" fingerprint_ok
check "$(t 'client connects and verifies the certificate' \
         'клиент подключается и проверяет сертификат' \
         'klient ulanadi va sertifikatni tekshiradi' \
         'клиент уланади ва сертификатни текширади')" live_verified
check "$(t 'client can also connect without verifying — and says so' \
         'клиент может подключиться и без проверки — и говорит об этом' \
         'klient tekshirmasdan ham ulana oladi — va buni aytadi' \
         'клиент текширмасдан ҳам улана олади — ва буни айтади')" live_unverified
check "$(t 'file notes.md exists' 'файл notes.md существует' 'notes.md fayli mavjud' 'notes.md файли мавжуд')" has_file notes.md

echo
printf '%s/%s\n' "$PASS" "$TOTAL"
[ "$PASS" -eq "$TOTAL" ] && exit 0 || exit 1
