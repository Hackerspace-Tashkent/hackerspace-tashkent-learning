#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Следит за Telegram-каналом и чатом хакерспейса.

Читает публичное превью Telegram. Ничего не отправляет, личные данные
не читает. Молчит, пока нечего сообщить.

Ориентир -- последний номер поста (data-post="Канал/12"), а не счётчик:
счётчик уменьшается, если пост удалить, и молчит, если что-то переименовали.

Запуск:
  python3 tools/tg_watch.py          молча, если изменений нет
  python3 tools/tg_watch.py --state  текущее состояние
  python3 tools/tg_watch.py --reset  начать отсчёт заново
"""
import html
import json
import os
import re
import sys
import urllib.request

STATE = "/opt/data/tg_watch_state.json"
CHANNEL = "hackerspace_tashkent"
CHAT = "hackerspace_tashkent_chat"
UA = {"User-Agent": "Mozilla/5.0 (compatible; hackerspace-watch/1.0)"}


def fetch(name):
    req = urllib.request.Request("https://t.me/s/" + name, headers=UA)
    with urllib.request.urlopen(req, timeout=25) as r:
        return r.read().decode("utf-8", "replace")


def clean(t):
    t = re.sub(r"<br\s*/?>", "\n", t)
    t = re.sub(r"<[^>]+>", "", t)
    return html.unescape(t).strip()


def channel_state():
    s = fetch(CHANNEL)
    # Каждое сообщение -- сегмент от data-post до следующего.
    parts = s.split('data-post="')[1:]
    posts = []
    for part in parts:
        pid = part.split('"')[0]
        m_t = re.search(r'class="tgme_widget_message_text[^"]*"[^>]*>'
                        r'(.*?)</div>', part, re.S)
        m_d = re.search(r'<time datetime="([^"]+)"', part)
        if not (m_t and m_d):
            continue
        num = int(pid.split("/")[-1]) if pid.split("/")[-1].isdigit() else 0
        posts.append({"n": num, "at": m_d.group(1),
                      "text": clean(m_t.group(1))[:400]})
    posts.sort(key=lambda p: p["n"])
    subs = re.findall(r'<div class="tgme_page_extra[^"]*">([^<]+)</div>', s)
    digits = re.sub(r"[^\d]", "", subs[0]) if subs else ""
    return {"posts": len(posts),
            "last_n": posts[-1]["n"] if posts else 0,
            "last": posts[-1] if posts else None,
            "subscribers": int(digits) if digits else None}


def chat_state():
    s = fetch(CHAT)
    subs = re.findall(r'<div class="tgme_page_extra[^"]*">([^<]+)</div>', s)
    digits = re.sub(r"[^\d]", "", subs[0]) if subs else ""
    return {"members": int(digits) if digits else None,
            "posts": len(re.findall(r"tgme_widget_message_text", s))}


def load():
    if os.path.isfile(STATE):
        try:
            with open(STATE, encoding="utf-8") as f:
                return json.load(f)
        except (ValueError, OSError):
            pass
    return None


def save(st):
    tmp = STATE + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(st, f, ensure_ascii=False, indent=2)
    os.replace(tmp, STATE)


def num(a, b):
    """Сравнить два числа, не выдумывая разницу, если одно из них None."""
    if a is None or b is None:
        return None
    return b - a if b != a else 0


def main():
    args = sys.argv[1:]
    try:
        now = {"channel": channel_state(), "chat": chat_state()}
    except Exception as e:                       # noqa: BLE001
        print("НЕ УДАЛОСЬ ПРОВЕРИТЬ: %s" % e)
        return 1

    if "--state" in args:
        print(json.dumps(now, ensure_ascii=False, indent=2))
        return 0
    if "--reset" in args:
        save(now)
        print("состояние сохранено как новое начало")
        return 0

    prev = load()
    if prev is None:
        save(now)
        print("ПЕРВЫЙ ЗАПУСК. Запомнил состояние, дальше пишу об изменениях.")
        print("  канал: постов %d, последний #%d, подписчиков %s"
              % (now["channel"]["posts"], now["channel"]["last_n"],
                 now["channel"]["subscribers"]))
        print("  чат:   участников %s" % now["chat"]["members"])
        return 0

    lines = []
    c0, c1 = prev.get("channel", {}), now["channel"]
    d_n = num(c0.get("last_n"), c1.get("last_n"))
    if d_n and d_n > 0:
        lines.append("Новых постов в канале: %d" % d_n)
        if c1.get("last"):
            lines.append("  последний (#%d, %s): %s"
                         % (c1["last"]["n"],
                            c1["last"]["at"][:16].replace("T", " "),
                            c1["last"]["text"][:300]))
    d_s = num(c0.get("subscribers"), c1.get("subscribers"))
    if d_s:
        lines.append("Подписчиков канала: %s → %s (+%d)"
                     % (c0.get("subscribers"), c1.get("subscribers"), d_s))
    h0, h1 = prev.get("chat", {}), now["chat"]
    d_m = num(h0.get("members"), h1.get("members"))
    if d_m:
        lines.append("Участников чата: %s → %s (%+d)"
                     % (h0.get("members"), h1.get("members"), d_m))

    if not lines:
        return 0

    save(now)
    print("Активность в телеграм хакерспейса\n")
    print("\n".join(lines))
    return 10


if __name__ == "__main__":
    sys.exit(main())