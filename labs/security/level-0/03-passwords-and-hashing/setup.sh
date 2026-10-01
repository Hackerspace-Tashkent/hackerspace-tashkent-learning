#!/usr/bin/env bash
# Готовит список хешей без соли — ровно так, как это делают в утечках.
set -eu
cd "$(dirname "$0")"
W="$PWD/lab-work"
rm -rf "$W"
mkdir -p "$W"

python3 - <<'PY'
import hashlib

# Выдуманные слова: в интернете их нет, словарь придётся составить самому.
WORDS = [
    "sable", "marmalade", "tessera", "lark", "kestrel", "vireo",
    "quillon", "brindle", "ochre", "fen", "thole", "cwtch", "scree",
    "marram", "grike", "bothy", "crake", "slype", "gaur",
]
TARGET = "marram"

with open("lab-work/hashes.txt", "w", encoding="utf-8") as f:
    for w in sorted(WORDS):
        h = hashlib.sha256(w.encode()).hexdigest()
        f.write("%s  %s\n" % (h, w))

with open("lab-work/target.txt", "w", encoding="utf-8") as f:
    f.write(hashlib.sha256(TARGET.encode()).hexdigest() + "\n")
PY

echo "Фикстура готова: lab-work/hashes.txt и lab-work/target.txt"
echo "В hashes.txt лежат пары хеш-слово. В target.txt — один хеш."
echo "Найди, какому слову соответствует target.txt."
