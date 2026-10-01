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

## Sen nima qilasan

1. `localhost` uchun oʻz-oʻzidan imzolangan sertifikat chiqar.
2. `server.py` yoz: shu sertifikat bilan HTTPS beradi.
3. `client.py` yoz: **tekshiruv bilan** va tekshiruvsiz ulanadi.
4. `proof.txt` ga sertifikat SHA-256 izining birinchi 16 belgisini yoz.
5. `notes.md` da javob ber: **shifrlash ishlayotgan boʻlsa,
   tekshiruvsiz sertifikatda nimasi notoʻgʻri?**

## Buyruq

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
