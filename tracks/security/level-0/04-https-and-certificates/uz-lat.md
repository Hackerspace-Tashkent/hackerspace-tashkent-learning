# HTTPS va sertifikatlar

## Buuni nega bilish kerak

Sen saytni ochib, manzil qatorida qulfa belgisini koʻrasiz.
Brauzer qanday bildiki, bu bogʻlanish haqiqatan oʻsha sayt bilan va
oʻrtada kimdir turmayapti?

«Qulfa chizilgani uchun» emas. Qulfa ikki holatda ham bir xil
chiziladi: hammasi joyida boʻlganda ham, **va** kimdir kanalni tutganda
ham. Farqi koʻzga koʻrinmaydi. Farqi shundaki, brauzer **tekshiruvni**
bajaradi.

## Tekshiruv nimadan iborat

**Sertifikat** — ochiq kalit kimga tegishli ekanini yozuvchi hujjat.
Ichida nom bor (`CN`, zamonaviy sertifikatlarda esa `SAN`) va amaldagi
muddat.

**Ishonch zanjiri.** Yakka sertifikatning oʻzi hech narsani anglamaydi:
sertifikatni kim xohlasa chiqara oladi. Kerak boʻlgani — siz ishonadigan
kimsa, yaʼni **sertifikat markazi**. U sertifikatga imzo qoʻyadi,
sizning uning ochiq kalitingiz allaqachon bor, demak imzoni tekshirish
mumkin.

**Iz.** Sertifikatda xesh bor — qiska iz. U siz kutilgan narsa bilan
taqqoslanadi.

## Oʻz-oʻzidan imzolangan sertifikat

Sertifikatni oʻzingiz chiqarishingiz mumkin — `openssl` uni qila oladi.
Va u ishlaydi. Ammo brauzer unga **ishonmaydi**, chunki uni maʼlum
markazlardan hech kim imzolamagan. Oʻzini markaz deb hisoblay olmaydi:
aks holda har kim oʻziga hujjat imzolab, har kim boʻlib chiqishi mumkin
boʻlardi.

Bu mashqda muammo yoʻq: ochiq kalit kimga ishonsh kerakligini oʻzingiz
hal qilasiz — oʻz sertifikatingizni ishonchli qilib koʻrsatasiz.

## Eng muhim qism

Pythonʼda tekshiruvni bitta qator bilan oʻchirish mumkin:

```python
ctx = ssl._create_unverified_context()
```

Shundan keyin **har qanday** sertifikatga, soxta boʻlsa ham, ulanish
jimgina oʻtadi. Shifrlash oʻrnida turadi, lekin u tomda kim borligi
maʼlum emas. Bu — eshikni mahkamlab, teshikdan qaramay qoldirish.

## Server qismi

Serverni sen yozmaysiz — u allaqachon tushuntirilgan. Muhim boʻlgan uch
qator belgilangan, qolgani 08-darsdagi oddiy HTTP server.

```python
#!/usr/bin/env python3
"""Oʻquvchilar uchun oʻzi imzolagan sertifikatli HTTPS server."""
import http.server
import json
import ssl

PORT = 8443


class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        body = json.dumps({"ok": True, "who": "localhost"}).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *a):
        pass


# Uchta qator -- shu uchun butun mashgʻulot boshlangan.
ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)   # 1. TLS server tomoni
ctx.load_cert_chain("cert.pem", "key.pem")     # 2. sertifikatni taqdim etish
srv = http.server.HTTPServer(("127.0.0.1", PORT), H)
srv.socket = ctx.wrap_socket(srv.socket, server_side=True)  # 3. TLS kiyish
srv.serve_forever()
```

**Bu erda muhimi.** 1-qator TLS tomonini tanlaydi. 2-qator aytadi:
«mening sertifikatim va yopiq kalitim shu» — va server uni har
ulgan odamga koʻrsatadi. 3-qator soketni oʻradi, shundan keyin maʼlumot
shifrlangan holda uchishi.

Eslatma: server sertifikatini koʻrsatishdan oldin **hech kimdan sabab
soʻramaydi**. Sertifikatni koʻrsatish — ruxsat emas. Ruxsatni
klient beradi, va darsning ikkinchi qismi aynan shu haqida.

## Sen nima qilasan

1. `localhost` uchun oʻz-oʻzidan imzolangan sertifikat chiqar.
2. Bu boʻlimdagi `server.py` ni `lab-work/` ga koʻchir.
3. `client.py` yoz: **tekshiruv bilan** va tekshiruvsiz ulanadi.
4. `proof.txt` ga sertifikat SHA-256 izining birinchi 16 belgisini yoz.
5. `notes.md` da javob ber: **shifrlash ishlayapti boʻlsa,
   tekshiruvsiz sertifikatda nimasi notoʻgʻri?**

## Buyruq

Avval ish papkasini yaratib, unga oʻting. **Tekshiruv fayllarni aynan
u erda izlaydi.**

```bash
mkdir -p lab-work
cd lab-work
```

Qolgan hammasi shu papkada yaratiladi:

```bash
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem \
  -days 1 -nodes -subj "/CN=localhost"
```

Bir kun — ataylab: oʻquv sertifikat abadiy yashamasligi kerak.

## Sertifikatni koʻrish

```bash
openssl x509 -in cert.pem -noout -text
openssl x509 -in cert.pem -noout -fingerprint -sha256
```

## Vazifa chegarasi

Hamma narsa `127.0.0.1` da, sizning kompʼyuteringizda, sizning
sertifikatingiz bilan boʻladi. Boshqalarning saytlari tekshirilmaydi
va skanlanmaydi. Boshqa odamning sertifikatlarini tekshirish — bu
mavzuning oʻquv maqsadi emas.
