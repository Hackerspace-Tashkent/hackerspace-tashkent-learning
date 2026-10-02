#!/usr/bin/env bash
# Практика S0-02: секрет в коде.
# Только собственный репозиторий внутри лабораторной папки.
#
# Правило этой проверки: если что-то выполняет фикстура, это не проверка.
# Раньше пять из семи пунктов описывали состояние, которое создаёт
# setup-repo.sh, и пустое состояние давало 5/7. Теперь все пять пунктов
# требуют действия ученика, и пустое даёт 0/5.
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

# Ключ достаётся молча. Раньше эта функция печатала ключ прямо в вывод
# проверки, и ученик читал ответ, ни разу не заглянув в историю.
history_key() {
  git -C "$R" log -p --all 2>/dev/null \
    | grep -oE 'vt-lark-tessera-[A-Za-z0-9]+' | head -1
}

commits() { git -C "$R" rev-list --count HEAD 2>/dev/null || echo 0; }

# 1. Доказательство: хеш ключа, который ученик нашёл в истории.
proof_matches() {
  [ -d "$R" ] || return 1
  local key want got
  key="$(history_key)"
  [ -n "$key" ] || return 1
  [ -s "$WORK/proof.txt" ] || return 1
  want="$(printf '%s' "$key" | sha256sum | cut -c1-12)"
  got="$(tr -d ' \n' < "$WORK/proof.txt")"
  [ "$want" = "$got" ]
}

# 2. Ученик что-то записал: пустой файл засчитывать нельзя.
notes_written() {
  [ -s "$WORK/notes.md" ] || return 1
  [ "$(wc -c < "$WORK/notes.md")" -ge 30 ]
}

# 3. Ученик закоммитил свою работу. Фикстура оставляет ровно два коммита.
has_new_commit() {
  [ -d "$R" ] || return 1
  [ "$(commits)" -ge 3 ]
}

# 4. В .gitignore появилась новая запись. В фикстуре там только
# lab-work/repo/ и lab-work/*.log -- про файлы с секретами там ничего.
ignore_extended() {
  [ -f "$R/.gitignore" ] || return 1
  git -C "$R" ls-files --error-unmatch .gitignore >/dev/null 2>&1 || return 1
  grep -qE '\*\.secret|\.env|secret|token' "$R/.gitignore"
}

# 5. Главное: работа ученика сделана, а история не переписана. Если бы
# он переписал её, ключ перестал бы находиться -- и это было бы неверно.
history_intact() {
  [ "$(commits)" -ge 3 ] || return 1
  [ -n "$(history_key)" ]
}

echo "$(t 'S0-02: the secret in the code' 'S0-02: секрет в коде' \
         'S0-02: kod ichidagi sir' 'S0-02: коди ичидаги сир')"
echo

check "$(t 'proof.txt holds the hash of the key you found in history' \
         'в proof.txt хеш ключа, найденного в истории' \
         'proof.txt da tarixda topilgan kalitning xeshi bor' \
         'proof.txt да тарихда топилган калитнинг хеши бор')" proof_matches
check "$(t 'notes.md has an answer, not an empty file' \
         'в notes.md есть ответ, а не пустой файл' \
         'notes.md da javob bor, boʻsh fayl emas' \
         'notes.md да жавоб бор, бўш файл эмас')" notes_written
check "$(t 'you committed your own work' \
         'ты закоммитил свою работу' \
         'oʻzingizning ishingizni kommit qildingiz' \
         'ўзингизнинг ишингизни коммит қилдингиз')" has_new_commit
check "$(t '.gitignore got an entry about secrets' \
         'в .gitignore появилась запись про секреты' \
         '.gitignore ga sir haqida yozuv qoʻshildi' \
         '.gitignore га сир ҳақида ёзув қўшилди')" ignore_extended
check "$(t 'the history still holds the key -- as it should' \
         'история всё ещё хранит ключ — и это правильно' \
         'tarix kalitni saqlab turibdi — va bu toʻgʻri' \
         'тарих калитни сақлаб турибди — ва бу тўғри')" history_intact

echo
printf '%s/%s\n' "$PASS" "$TOTAL"
[ "$PASS" -eq "$TOTAL" ] && exit 0 || exit 1
