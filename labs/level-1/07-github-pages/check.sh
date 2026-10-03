#!/usr/bin/env bash
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$HERE/lab-work"
LANG="${CHECK_LANG:-ru}"
case "$LANG" in ru|en|uz-lat|uz-cyr) : ;; *) LANG=ru ;; esac
T() { printf '%s\n' "$*"; }

PASS=0; TOTAL=0
check() {
  local d="$1"; shift
  TOTAL=$((TOTAL + 1))
  if "$@"; then PASS=$((PASS+1)); printf '  [x] %s\n' "$d"
  else printf '  [ ] %s\n' "$d"; fi
}

IDX="$WORK/index.html"
echo "$(T 'Практика: GitHub Pages')"
echo

has_index()    { [ -f "$IDX" ]; }
has_title()    { grep -qi '<title>' "$IDX"; }
has_lang()     { grep -qiE '<html[^>]+lang=' "$IDX"; }
has_viewport() { grep -qi 'name="viewport"' "$IDX"; }
has_body()     { grep -qi '<body' "$IDX" && grep -qi '</html>' "$IDX"; }
big_enough()   { [ "$(wc -c < "$IDX" 2>/dev/null || echo 0)" -gt 200 ]; }
has_link()     { [ -s "$WORK/PUBLISHED.md" ]; }
link_has_url() { grep -qE 'https?://[^ ]+' "$WORK/PUBLISHED.md"; }
has_notes()    { [ -s "$WORK/NOTES.md" ]; }

check "$(T 'Создана рабочая папка lab-work/')" [ -d "$WORK" ]
check "$(T 'Есть index.html')" has_index
check "$(T 'Файл не пустой')" big_enough
check "$(T 'Закрыт тег </html>')" has_body
check "$(T 'Указан язык: <html lang="...">')" has_lang
check "$(T 'Есть <title>')" has_title
check "$(T 'Есть viewport для телефонов')" has_viewport
check "$(T 'Написан PUBLISHED.md со ссылкой')" has_link
check "$(T 'В PUBLISHED.md есть https-адрес')" link_has_url
check "$(T 'Написан NOTES.md')" has_notes

echo
# Живая проверка ответа. Необязательна: без GitHub-аккаунта опубликовать
# сайт нельзя, и требовать этого от того, кто начинает с нуля, нечестно.
# Если адрес недостижим -- печатаем подсказку и НЕ считаем его проверкой.
URL="$(grep -hoE '(https?|http)://[^ )]*' "$WORK/PUBLISHED.md" 2>/dev/null | head -1)"
SKIP=0
if [ -z "$URL" ]; then
  SKIP=1
  echo "$(T 'Адрес не указан')"
elif ! command -v curl >/dev/null 2>&1; then
  SKIP=1
  echo "$(T 'curl недоступен')"
elif ! printf '%s' "$URL" | grep -qE '^https?://(127\.0\.0\.1|localhost)(:[0-9]+)?/|^https://'; then
  SKIP=1
  echo "$(T 'Адрес не локальный и не https -- проверка пропущена')"
else
  TOTAL=$((TOTAL+1))
  code="$(curl -s -o /dev/null -w '%{http_code}' -L --max-time 15 "$URL" 2>/dev/null)"
  if [ "$code" = "200" ]; then
    PASS=$((PASS+1)); printf '  [x] %s\n' "$(T 'Страница отвечает 200')"
  else
    FAIL=$((FAIL+1))
    printf '  [ ] %s\n' "$(T "Страница отвечает $code -- проверь адрес и настройки")"
  fi
fi
[ "$SKIP" = "1" ] && echo "$(T 'Это не влияет на результат: остальное проверено')"


echo
if [ "$PASS" -eq "$TOTAL" ]; then echo "$(T "Готово: $PASS/$TOTAL")"; exit 0
else echo "$(T "Готово: $PASS/$TOTAL")"; exit 1; fi
