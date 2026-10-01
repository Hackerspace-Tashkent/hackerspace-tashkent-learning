# HTTPS va sertifikatlar

## Buni nega bilish kerak

Sen saytni ochasan va manzil qatorida quffa belgisini koʻrasan.
Brauzer qanday bilsin ki bu bogʻlanish haqiqatan oʻsha sayt bilan,
va oʻrtada biror turgan emas?

«Quffa chizilganligi uchun» emas. Quffa ikki holatda ham bir xil
chiziladi: hamma joyida ham tartib, **va** biror kanalni ushlagan
odam boʻlganda ham. Farqi koʻzga koʻrinmaydi. Farqi shundaki, brauzer
**tekshiruvni** bajaradi.

## Tekshiruv nimalardan iborat

**Sertifikat** — ochiq kalit kimga tegishli ekanini yozuvchi hujjat.
Ichida nom bor (`CN`, zamonaviy sertifikatlarda esa `SAN`) va
amaldagi muddat.

**Ishonch zanjiri.** Yakka sertifikatning oʻzi hech nima anglamaydi:
sertifikatni kim xohlagan chiqarishi mumkin. Kerak boʻlgan — siz
ishonadigan kimsa, yaʼni **sertifikat markazi**. U sertifikatga imzo
qoʻyadi, sizning uning ochiq kalitingiz allaqachon bor, demak imzoni
tekshirish mumkin.

**Iz.** Sertifikatda xesh bor — qisqa iz. U siz kutilgan narsa bilan
taqqoslanadi.

## Oʻz-oʻzidan imzolangan sertifikat

Sertifikatni oʻzingiz chiqarishingiz mumkin — `openssl` buni qila
oladi. Va u ishlaydi. Ammo brauzer unga **ishonmaydi**, chunki uni
maʼlum markazlardan hech kim imzolamagan. Oʻzini markaz deb hisoblay
olmaydi: aks holda har kim oʻziga hujjat imzolab, har kim boʻlib
chiqishi mumkin boʻlardi.

Bu mashqda muammo yoʻq: ochiq kalit kimga ishonish kerakligini
oʻzingiz hal qilasiz — oʻz sertifikatizni ishonchli qilib koʻrsatasiz.

## Eng muhim qism

Pythonʼda tekshiruvni bitta qator bilan oʻchirish mumkin:

```python
ctx = ssl._create_unverified_context()
```

Shundan keyin **har qanday** sertifikatga, soxta boʻlsa ham, ulanish
jimgina oʻtadi. Shifrlash oʻrnida turibdi, lekin u tomonda kim borligi
maʼlum emas. Bu — eshikni mahkamlab, teshikdan qaramay qoldirish.

## Server qismi

Serverni sen yozmaysan — u allaqachin tushuntirilgan. Muhim boʻlgan uch
qator belgilangan, qolgani 08-darsdagi oddiy HTTP server.

```python
#!/usr/bin/env python3
"""HTTPS-сервер с учебным самоподписанным сертификатом."""
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


# Три строки, ради которых всё затевалось.
ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)   # 1. серверная сторона TLS
ctx.load_cert_chain("cert.pem", "key.pem")     # 2. предъявить сертификат
srv = http.server.HTTPServer(("127.0.0.1", PORT), H)
srv.socket = ctx.wrap_socket(srv.socket, server_side=True)  # 3. надеть TLS
srv.serve_forever()
```

**Bu yerda muhimi.** 1-qator TLS tomonini tanlaydi. 2-qator aytadi:
«mening sertifikatim va yopiq kalitim shu» — va server uni har
ulangan odamga koʻrsatadi. 3-qator soketni oʻraydi, shundan keyin maʼlumot
shifrlangan holda uchadi.

Eslatma: server sertifikatini koʻrsatishdan oldin **hech kimdan
sabam soʻramaydi**. Sertifikatni koʻrsatish — ruxsat emas. Ruxsatni
klient beradi, va darsning ikkinchi qismi aynan shu haqida.

## Sen nima qilasan

1. `localhost` uchun oʻz-oʻzidan imzolangan sertifikat chiqar.
2. Bu boʻlimdagi `server.py` ni `lab-work/` ga koʻchir.
3. `client.py` yoz: **tekshiruv bilan** va tekshiruvsiz ulanadi.
4. `proof.txt` ga sertifikat SHA-256 izining birinchi 16 belgisini yoz.
5. `notes.md` da javob ber: **shifrlash ishlayotgan boʻlsa,
   tekshiruvsiz sertifikatda nimasi notoʻgʻri?**

## Buyruq

Avval ish papkasini yaratib, unga oʻting. **Tekshiruv fayllarni aynan
u yerda izlaydi.**

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

Hamma narsa `127.0.0.1` da, sizning kompyuteringizda, sizning
sertifikatingiz bilan boʻladi. Boshqalarning saytlari tekshirilmaydi
va skanlanmaydi. Boshqa odamning sertifikatlarini tekshirish — bu
mavzuning oʻquv maqsadi emas.
