#!/usr/bin/env python3
"""Клиент: показывает разницу между проверкой и её отсутствием."""
import json
import ssl
import sys
import urllib.request

CA = "cert.pem"
URL = "https://localhost:8443/"


def get(verify):
    if verify:
        ctx = ssl.create_default_context(cafile=CA)
    else:
        ctx = ssl._create_unverified_context()
    with urllib.request.urlopen(URL, context=ctx, timeout=10) as r:
        return json.loads(r.read())


if "--no-verify" in sys.argv:
    print("unverified: ответ получен БЕЗ проверки сертификата:", get(False))
else:
    print("verified: сертификат проверен, ответ:", get(True))
