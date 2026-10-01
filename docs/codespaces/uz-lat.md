# Amaliyotni Codespace'da qanday bajarish kerak

Codespace — brauzerdagi Linux mashinasi. Hech narsa o'rnatish yoki buzish shart emas.

## Boshlash

1. GitHub'da repositoryni `main` tarmog'ida oching — amaliyotlar `labs/` da.
2. Yashil **Code** tugmasini, keyin **Codespaces** tabini bosing.
3. Mashina hajmini tanlang: **2 yadra, 4 GB** bu trekdagi barcha amaliyotlarga yetadi.
4. **Create codespace** ni bosing va taxminan bir daqiqa kuting.

## Tekshiruvni ishga tushirish

```bash
cd labs/level-0/01-terminal
./check.sh
CHECK_LANG=en ./check.sh
```

Har bir qator vazifa bajarilganini ko'rsatadi. Barchasi tugaganda skript 0 kodi bilan chiqadi.

## Xarajatlarni kam ushlash

Codespace soatiga to'lanadi va bo'sh turganlari kvotani yeyveradi. Repository buni oldini olish uchun sozlandi.

- **Kichik mashina.** Devcontainer 2 yadra va 4 GB so'raydi — eng arzon mos o'lcham.
- **Ichida og'ir narsa yo'q.** Ish stoli yoki qurish vositalari kerak bo'lganda.
- **Yopganda to'xtaydi.** Devcontainer `shutdownAction: stopContainer` ni belgilagan:
  Codespaces oynasini yopsangiz, mashina o'z-o'zidan to'xtaydi.
- **Tashkilot cheklovlari sozlanmagan.** 30 daqiqa faolsizlikdan keyingi to'xtatish va 0 kundan
  keyin o'chirish hali belgilanmagan. Demak: faqat o'zingiz to'xtatishga tayaning.

> **Muhim.** Ishlamay turgan Codespace ham kvotadan hisoblanadi. Uni o'zingiz yoping:
> Codespaces menyusida *Stop codespace* ni tanlang. O'chirish bir necha soniya oladi.
> Limitga tegib qolsangiz, avval kerak emas mashinalarni yoping.

## Agar Codespace sekin ishlayotgan bo'lsa

Amaliyot ataylab kichik. Sekin internetda ortiqcha narsa o'rnatmang va vazifalarni ketma-ket bajaring — har biri oldingisiga bog'liq.
