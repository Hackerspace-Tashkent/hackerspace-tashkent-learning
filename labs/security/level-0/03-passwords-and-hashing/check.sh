#!/usr/bin/env bash
# Практика S0-03: пароли и хеши.
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
uses_pbkdf2() { grep -qE "pbkdf2_hmac|pbkdf2" "$WORK/salted.py" 2>/dev/null; }
uses_salt() { grep -qiE "salt" "$WORK/salted.py" 2>/dev/null; }

# Правильный пароль ученик обязан положить в crack.txt.
# Проверка пересчитывает sha256 сама и сравнивает с target.txt.
crack_ok() {
  [ -f "$WORK/target.txt" ] && [ -f "$WORK/crack.txt" ] || return 1
  local want got
  want="$(tr -d ' \n' < "$WORK/target.txt")"
  got="$(python3 - "$WORK/crack.txt" <<'PY'
import hashlib, sys
word = open(sys.argv[1], encoding="utf-8").read().strip()
print(hashlib.sha256(word.encode()).hexdigest())
PY
)"
  [ -n "$want" ] && [ "$want" = "$got" ]
}

# Живая проверка: соль обязана менять хеш.
# Считать "два разных хеша" недостаточно: pbkdf2 и без соли даёт хеш,
# отличный от sha256, и такая проверка проходит на пустой соли.
# Поэтому требуем три разных значения для ОДНОГО пароля: без соли,
# с первой солью и со второй. Тогда соль доказана, а не заявлена.
salt_changes_hash() {
  [ -f "$WORK/salted.py" ] || return 1
  ( cd "$WORK" && timeout 25 python3 salted.py >/tmp/s003.log 2>&1 ) || return 1
  [ -s /tmp/s003.log ] || return 1
  local uniq
  uniq="$(grep -oiE '\b[0-9a-f]{32,}\b' /tmp/s003.log | sort -u | wc -l)"
  [ "$uniq" -ge 3 ]
}

# И две разные соли должны быть реально разными, а не одной строкой.
two_salts() {
  [ -f "$WORK/salted.py" ] || return 1
  local n
  n="$(grep -oiE 'pbkdf2\([^)]*"[^"]+"' "$WORK/salted.py" | grep -oE '"[^"]+"' | sort -u | wc -l)"
  [ "$n" -ge 2 ] || [ "$(grep -oiE '"[a-z0-9-]{4,}"' "$WORK/salted.py" | sort -u | wc -l)" -ge 2 ]
}

echo "$(t 'S0-03: passwords and hashes' 'S0-03: пароли и хеши' \
         'S0-03: parollar va xeshlar' 'S0-03: пароллар ва хешлар')"
echo

check "$(t 'file brute.py exists' 'файл brute.py существует' 'brute.py fayli mavjud' 'brute.py файли мавжуд')" has_file brute.py
check "$(t 'crack.txt holds the password behind the target hash' \
         'в crack.txt пароль, соответствующий искомому хешу' \
         'crack.txt da izlanayotgan xeshga mos parol bor' \
         'crack.txt да изланаётган хешга мос парол бор')" crack_ok
check "$(t 'file proof.txt exists' 'файл proof.txt существует' 'proof.txt fayli mavjud' 'proof.txt файли мавжуд')" not_empty proof.txt
check "$(t 'salted.py uses pbkdf2' 'salted.py использует pbkdf2' 'salted.py pbkdf2 ishlatadi' 'salted.py pbkdf2 ишлатади')" uses_pbkdf2
check "$(t 'salted.py mentions a salt' 'salted.py использует соль' 'salted.py tuz ishlatadi' 'salted.py туз ишлатади')" uses_salt
check "$(t 'salted.py uses two different salts' 'в salted.py две разные соли' \
         'salted.py da ikki xil tuz bor' 'salted.py да икки хил туз бор')" two_salts
check "$(t 'running salted.py shows three different hashes for one password' \
         'запуск salted.py показывает два разных хеша одного пароля' \
         'salted.py ni ishga tushirish bitta parol uchun ikki xil xeshi koʻrsatadi' \
         'salted.py ни ишга тушириш бир парол учун икки хил хеш кўрсатади')" salt_changes_hash
check "$(t 'file notes.md exists' 'файл notes.md существует' 'notes.md fayli mavjud' 'notes.md файли мавжуд')" has_file notes.md

echo
printf '%s/%s\n' "$PASS" "$TOTAL"
[ "$PASS" -eq "$TOTAL" ] && exit 0 || exit 1
