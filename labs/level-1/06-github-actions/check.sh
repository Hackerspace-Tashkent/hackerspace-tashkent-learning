#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/lab-work"
LANG="${CHECK_LANG:-ru}"
case "$LANG" in ru|en|uz-lat|uz-cyr) : ;; *) LANG=ru ;; esac
case "$LANG" in
  ru)     T() { printf '%s\n' "$*"; } ;;
  uz-lat) T() { printf '%s\n' "$*"; } ;;
  uz-cyr) T() { printf '%s\n' "$*"; } ;;
  *)      T() { printf '%s\n' "$*"; } ;;
esac

yaml_ok() {
  [ -f "$WF" ] || return 1
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$WF" <<'PYEOF' >/dev/null 2>&1
import sys
try:
    import yaml
except ImportError:
    sys.exit(0)          # PyYAML нет — считаем успехом, структуру проверяем отдельно
try:
    yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
except Exception:
    sys.exit(1)
sys.exit(0)
PYEOF
    return $?
  fi
  return 0
}

slug() {
  git -C "$WORK" remote get-url origin 2>/dev/null \
    | sed 's#.*github.com[:/]##; s#\.git$##'
}

PASS=0; TOTAL=0
check() {
  local d="$1"; shift
  TOTAL=$((TOTAL + 1))
  if "$@"; then PASS=$((PASS+1)); printf '  [x] %s\n' "$d"
  else printf '  [ ] %s\n' "$d"; fi
}

WF="$WORK/.github/workflows/ci.yml"
echo "$(T 'Практика: GitHub Actions')"
echo
check "$(T 'Создана рабочая папка lab-work/')" [ -d "$WORK" ]
check "$(T 'Создана папка .github/workflows/')" [ -d "$WORK/.github/workflows" ]
check "$(T 'Есть файл workflow — ci.yml')" [ -f "$WF" ]
check "$(T 'В workflow есть on: — что запускает')" grep -qE '^on:' "$WF"
check "$(T 'Есть jobs:')" grep -qE '^jobs:' "$WF"
check "$(T 'В job есть runs-on:')" grep -qE 'runs-on:' "$WF"
check "$(T 'Есть steps:')" grep -qE '^\s+steps:' "$WF"
check "$(T 'В шаге есть uses: или run:')" grep -qE 'uses:|run:' "$WF"
check "$(T 'Валидация YAML (если доступен python)')" yaml_ok
check "$(T 'Написан NOTES.md — что понял')" [ -s "$WORK/NOTES.md" ]

echo
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  TOTAL=$((TOTAL+1))
  if gh run list --repo "$(slug)" --limit 1 2>/dev/null | grep -q .; then
    PASS=$((PASS+1)); printf '  [x] %s\n' "$(T 'Прогон workflow виден через gh')"
  else
    printf '  [ ] %s\n' "$(T 'Прогон ещё не случился — запусти push')"
  fi
else
  echo "$(T 'gh недоступен — онлайн-проверка пропущена')"
fi

echo
if [ "$PASS" -eq "$TOTAL" ]; then echo "$(T "Готово: $PASS/$TOTAL")"; exit 0
else echo "$(T "Готово: $PASS/$TOTAL")"; exit 1; fi
