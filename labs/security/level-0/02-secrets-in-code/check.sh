#!/usr/bin/env bash
# Практика S0-02: секрет в коде.
# Работа только с собственным репозиторием внутри лабораторной папки.
set -u
cd "$(dirname "$0")"
[ -n "${CHECK_LANG:-}" ] || CHECK_LANG=ru
HERE="$(pwd)"
WORK="$HERE/lab-work"
R="$WORK/repo"
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
is_repo()    { git -C "$R" rev-parse --git-dir >/dev/null 2>&1; }
has_commits(){ [ "$(git -C "$R" rev-list --count HEAD 2>/dev/null || echo 0)" -ge 2 ]; }
has_ignore() { [ -f "$R/.gitignore" ]; }
notes_ok()   { [ -f "$WORK/notes.md" ]; }

# Ключ живёт только в истории. Проверка достаёт его сама.
history_key() {
  [ -d "$R" ] || return 1
  git -C "$R" log -p --all 2>/dev/null \
    | grep -oE 'vt-lark-tessera-[A-Za-z0-9]+' | head -1
}

proof_matches() {
  local key want got
  key="$(history_key)" || return 1
  [ -n "$key" ] || return 1
  [ -f "$WORK/proof.txt" ] || return 1
  want="$(printf '%s' "$key" | sha256sum | cut -c1-12)"
  got="$(tr -d ' \n' < "$WORK/proof.txt")"
  [ "$want" = "$got" ]
}

# Ключ не должен остаться в текущей версии файла.
clean_now() {
  [ -f "$R/app.py" ] || return 1
  ! grep -q 'vt-lark-tessera-' "$R/app.py" 2>/dev/null
}

echo "$(t 'S0-02: the secret in the code' 'S0-02: секрет в коде' \
         'S0-02: kod ichidagi sir' 'S0-02: коди ичидаги сир')"
echo

check "$(t 'repo lab-work/repo exists' 'репозиторий lab-work/repo существует' \
         'lab-work/repo repositoriyi mavjud' 'lab-work/repo репозиторийси мавжуд')" is_repo
check "$(t 'in it at least two commits' 'в нём не меньше двух коммитов' \
         'unda kamida ikkita kommit bor' 'унда камида иккита коммит бор')" has_commits
check "$(t 'the secret is still findable in history' \
         'секрет всё ещё находится в истории' \
         'sir tarixda topiladi' 'сир тарихда топилади')" history_key
check "$(t 'proof.txt holds the hash of the key you found' \
         'в proof.txt хеш найденного ключа' \
         'proof.txt da topilgan kalitning xeshi bor' \
         'proof.txt да топилган калитнинг хеши бор')" proof_matches
check "$(t 'the key is gone from the current app.py' \
         'ключа нет в текущем app.py' \
         'joriy app.py da kalit yoʻq' \
         'жорий app.py да калит йўқ')" clean_now
check "$(t 'file .gitignore exists' 'файл .gitignore существует' \
         '.gitignore fayli mavjud' '.gitignore файли мавжуд')" has_ignore
check "$(t 'file notes.md exists' 'файл notes.md существует' \
         'notes.md fayli mavjud' 'notes.md файли мавжуд')" notes_ok

echo
printf '%s/%s\n' "$PASS" "$TOTAL"
[ "$PASS" -eq "$TOTAL" ] && exit 0 || exit 1
