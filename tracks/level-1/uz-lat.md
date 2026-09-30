# 1-daraja — ishonchli foydalanuvchi

Siz buyruqlarni ishga tushira olasiz. Endi mashinani o'zingizga xizmat qildirasiz: skriptlar, reja, xizmatlar va tarmoq.

- [5-dars. Bash skriptlari](01-bash-scripts/uz-lat.md) — o'zgaruvchilar, shartlar, tsikllar, funksiyalar, argumentlar, chiqim kodlari
- [6-dars. Avtomatlashtirish va jurnalar](02-automation-and-logs/uz-lat.md) — oqimlar, jurnal fayllari, cron
- [7-dars. Jarayonlar va xizmatlar](03-processes-and-services/uz-lat.md) — fon, signallar, `trap`, systemd unitlari
- [8-dars. Tarmoq](04-networking/uz-lat.md) — manzillar, portlar, `ss`, `curl`, xostlar

## Boshlashdan oldin

0-daraja o'tgan deb hisoblanadi. Agar Level 0 ning oxirgi darsidagi `check.sh` hali ham ishlamasa, avval qayting.

> **Izoh.** 7-darsda ishlayotgan xizmat bo'lmaydi: Codespace — konteyner va `systemd` u yerda PID 1 emas. Amaliyot unit fayl to'g'riligini tekshiradi.

```bash
cd labs/level-1/01-bash-scripts
./check.sh
```
