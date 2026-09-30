#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Живая проверка: ученик отправляет результат, workflow должен его принять."""
import json
import os
import time
import urllib.request

tok = os.environ["GH_PAT"]
REPO = "Hackerspace-Tashkent/hackerspace-tashkent-learning"
UA = "ArkadiyVoronov"


def api(path, data=None, method="GET"):
    req = urllib.request.Request(
        "https://api.github.com/repos/%s%s" % (REPO, path),
        data=None if data is None else json.dumps(data).encode(),
        headers={"Authorization": "token %s" % tok,
                 "Content-Type": "application/json"},
        method=method)
    with urllib.request.urlopen(req) as r:
        return json.load(r)


# 1. Комментарий с настоящим маркером — как его оставил бы check.sh --submit
marker = ("<!-- hs:lesson=01-terminal;track=level-0;pass=8;total=8;"
          "lang=ru;user=%s;ts=2026-09-30T12:00:00Z -->" % UA)
body = "%s\n**01-terminal** — 8/8\n%s" % (marker, UA)
c = api("/issues/2/comments", {"body": body}, "POST")
print("комментарий создан:", c["html_url"])

# 2. Комментарий, написанный человеком, — должен быть проигнорирован
h = api("/issues/2/comments", {"body": "Я прошёл все задания, 8 из 8!"}, "POST")
print("человеческий комментарий:", h["html_url"])

# 3. Ждём workflow
for i in range(30):
    time.sleep(10)
    runs = api("/actions/runs?branch=main&per_page=5")
    items = runs.get("workflow_runs", [])
    board = [r for r in items if r["name"] == "Board"]
    if board and board[0]["head_sha"] and board[0]["status"] != "":
        r = board[0]
        print("workflow: %s / %s" % (r["status"], r["conclusion"]))
        if r["status"] == "completed":
            break
else:
    print("workflow не завершился за 5 минут")
    raise SystemExit(1)

# 4. Что попало в data.json на main
raw = urllib.request.urlopen(
    "https://raw.githubusercontent.com/%s/main/board/data.json" % REPO)
data = json.load(raw)
print("записей на main:", len(data))
for r in data:
    print("  ", r["user"], r["lesson"], "%d/%d" % (r["pass"], r["total"]), r["lang"])
