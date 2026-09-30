#!/usr/bin/env bash
# Проверка практики: работа с GitHub — fork, ветка, pull request.
# Две части: локальная (всегда) и онлайн (если есть gh и есть сеть).

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$HERE/lab-work"
LANG="${CHECK_LANG:-ru}"

case "$LANG" in
  ru)     T() { printf '%s\n' "$*"; } ;;
  en)     T() { printf '%s\n' "$*"; } ;;
  uz-lat) T() { printf '%s\n' "$*"; } ;;
  uz-cyr) T() { printf '%s\n' "$*"; } ;;
  *)      LANG=ru; T() { printf '%s\n' "$*"; } ;;
esac

PASS=0
TOTAL=0

check() {
  local desc="$1"; shift
  TOTAL=$((TOTAL + 1))
  if "$@"; then
    PASS=$((PASS + 1)); printf '  [x] %s\n' "$desc"
  else
    printf '  [ ] %s\n' "$desc"
  fi
}

echo "$(T 'Практика: работа с GitHub')"
echo "$(T 'Рабочая папка: lab-work/ рядом с этим скриптом')"
echo

# ── локальная часть ────────────────────────────────────────────────────────
have_work()  { [ -d "$WORK" ]; }
have_remote() { [ -d "$WORK/.git" ] && git -C "$WORK" remote | grep -q .; }
remote_is_fork() { git -C "$WORK" remote get-url origin | grep -q .; }
have_branch() {
  [ -d "$WORK/.git" ] || return 1
  [ "$(git -C "$WORK" branch --show-current)" != "main" ]
}
branch_not_main() {
  [ -n "$(git -C "$WORK" branch --show-current)" ] &&
  [ "$(git -C "$WORK" branch --show-current)" != "main" ]
}
has_commits() {
  [ -d "$WORK/.git" ] || return 1
  [ "$(git -C "$WORK" rev-list --count HEAD 2>/dev/null || echo 0)" -ge 1 ]
}
commit_ahead() {
  # есть коммит, которого нет в main
  git -C "$WORK" rev-list --count main..HEAD 2>/dev/null | grep -qv '^0$'
}
has_pr_text() { [ -s "$WORK/PR.md" ]; }
pr_text_mentions() {
  grep -qi "$1" "$WORK/PR.md" 2>/dev/null
}
has_checklist() { [ -s "$WORK/CHECKLIST.md" ]; }

check "$(T 'Создана рабочая папка lab-work/')" have_work
check "$(T 'В lab-work/ есть git-репозиторий')" [ -d "$WORK/.git" ]
check "$(T 'Настроен remote (свой fork)')" remote_is_fork
check "$(T 'Работа идёт не в ветке main')" branch_not_main
check "$(T 'Есть хотя бы один коммит')" has_commits
check "$(T 'Ветка идёт вперёд main')" commit_ahead
check "$(T 'Написан файл PR.md с описанием')" has_pr_text
check "$(T 'В PR.md есть строка What / Что / Nima')" pr_text_mentions "what\|что\|nima"
check "$(T 'Есть CHECKLIST.md — что проверено')" has_checklist

# ── онлайн часть ───────────────────────────────────────────────────────────
echo
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  if gh pr list --repo "$(git -C "$WORK" remote get-url origin 2>/dev/null | sed 's#.*github.com[:/]##; s#\.git$##')" \
       --state all --limit 1 2>/dev/null | grep -q .; then
    TOTAL=$((TOTAL + 1)); PASS=$((PASS + 1))
    printf '  [x] %s\n' "$(T 'Pull request виден через gh')"
  else
    TOTAL=$((TOTAL + 1))
    printf '  [ ] %s\n' "$(T 'Pull request виден через gh (создай PR на GitHub)')"
  fi
else
  echo "$(T 'gh не установлен или не авторизован — онлайн-проверка пропущена')"
  echo "$(T 'Это нормально: локальная часть уже засчитана')"
fi

echo
if [ "$PASS" -eq "$TOTAL" ]; then
  echo "$(T "Готово: $PASS/$TOTAL")"; exit 0
else
  echo "$(T "Готово: $PASS/$TOTAL")"; exit 1
fi
