# Nima dan boshlash kerak va nima uchun hammasi shu

Bu sahifa har birinchi marta terminal ochmaganlar uchun. Unda git, GitHub va
Codespace nima ekanligi, biz nima uchun aynan ularni tanlaganimiz tushuntirilgan.

Hech narsani o'rnatish shart emas. Kerak bo'lgan faqat brauzer va GitHub hisobi.

---

## Git nima

Git — bu dastur. U sizning fayllaringiz tarixini eslab qoladi. U sizning
o'z kompyuteringizda ishlaydi, internetsiz va ro'yxatdan o'tmasdan.

Kod yozganda git eskisini ustiga yozmaydi — u eslab qoladi: «shu vaqtda fayl
shunday ko'rinardi». Natijada qaytib borish mumkin bo'lgan tarix hosil bo'ladi.

Asosiy tushuncha — **commit**. Bu bitta saqlangan nuqta: «men shu bosqichni
tugatdim». Commit xabari esa nima o'zgarganini tushuntiradi.

Keyin **branch** keladi — bu sizning ishning nusxasi, unda tajriba qilib
tuzatishni o'z asl nushasiga tegmay turib sinab ko'rishingiz mumkin. Chiqdi,
yoqdi — asl nushaga qo'shdingiz. Chiqmadi — branchni tashlab yubordingiz, asl
nusha butunlay jarohatlanmagan.

Hammasi shu. Boshlash uchun zarur darajada butun git shu. Qolgani Level 0
trekining 3-darsida.

## GitHub nima

Git — dastur, GitHub — esa sizning repozitoriylaringiz turgan sayt. Farq muhim:

- git **mahalliy** ishlaydi, tarix sizning diskingizda yotadi;
- GitHub **internetdagi nusxani** saqlaydi, boshqalar ko'ra olishi uchun.

Saqlashdan tashqari, GitHub bizni rag'batlantirgan narsalar bor:

| Imkoniyat | Biz uchun nima uchun |
|---|---|
| **Repozitoriy** | Darslar, amaliyot va kod shu yerda. Bitta havola — butun kurs qo'lda. |
| **O'zgarishlar tarixi** | Kim nima o'zgartirgani ko'rinadi. Tasodifan buzilgani har doim qaytariladi. |
| **Issues** | Vazifa va savollar ro'yxati, hammaga ko'rinadi. Ochsangiz — kimdir allaqachon so'raganini ko'rasiz. |
| **Pull request** | O'zgarishlar avval ko'rsatiladi, keyin muhokama qilinadi, keyin qabul qilinadi. |
| **Codespaces** | Brauzerda to'liq Linux. Hech narsa o'rnatish shart emas. |
| **Ochiq kirish** | Hammasi ochiq. Kim istasa ko'radi, takrorlaydi va yaxshilaydi. |

## Nima uchun aynan GitHub

Qisqa va halol javob: chunki u **bepul, bir marta sozlanadi va o'quvchidan
faqat brauzer talab qiladi**.

Muhimroq shu — bu yerda aynan nima uchun muhim:

- **Boshlang'ich uchun nol xarajat.** O'z noutbukingiz, Linux o'rnatish yoki
  serverga to'lov kerak emas. Sahifani ochadigan kompyuter yetarli.
- **Zaif kompyuterda ishlaydi.** Codespace bulutda hisoblaydi. 4 GB operativkali
  eski noutbukda to'liq muhit ishlamaydi, lekin brauzer versiyasi ochiladi.
- **Ishni bir kishiga bog'lamaydi.** Materiallar chatda emas, kimningdir
  noutbukida emas, GitHub'da turadi. Bir yildan keyin ham u yerda bo'ladi,
  muallif ko'chsa ham.
- **Tekshirish jarayonga qo'shilgan.** Amaliyot natijasi ommaviy issue'dagi
  izoh. Kim o'tgani ko'rinadi va bu jim qilib tahrirlab bo'lmaydi.
- **To'rt til, bitta joy.** Har bir darsning to'rtta versiyasi yonma-yon turadi,
  to'rt xil joyda tarqalgan holda emas.

Biz qanday variantni **tanlamaganimiz** va nega:

- **O'z saytimiz, ro'yxatdan o'tish va shaxsiy kabinetlar bilan** — bu to'lanadigan,
  himoyalanadigan va boshqariladigan server. Qimmat, va uni boshqaradigan kishi
  yo'q.
- **Google Docs yoki Notion** — o'qish uchun qulay, lekin u yerda topshiriqni
  bajarib tekshirib bo'lmaydi.
- **Video darslar** — ko'rish oson, lekin tekshirilmaydi va ish izi qolmaydi.

## Codespace nima

Codespace — GitHubning bulutida yashaydigan, brauzerda ochiladigan Linux'li
virtual kompyuter. Tugmani bosding — haqiqiy buyruq qatori ochildi.

Bu nima beradi:

- Hammasi allaqachon o'rnatilgan: terminal, git, Python, muharrir. Hech narsa
  o'rnatmaysiz.
- Brauzer bo'lgan har qanday qurilmada ishlaydi. Kompyutarda boshladingiz —
  telefonda davom ettirdiz.
- Muhit sozlovi repozitoriyda turadi, miyangizda emas. Hammada bir xil.
- Muhit kichik: 2 yadro va 4 GB operativ xotira. Barcha darslarimiz uchun yetadi.
- Nimadir buzilsa, muhit o'chirilib, bir daqiqada qayta yaratiladi. Tajriba qilish
  arzon.

Halol aytish kerak bo'lgan cheklov: Codespace — bu Linux. Agar sizda Windows
bo'lsa va Windows'da o'rganmoqchi bo'lsangiz, amaliyotning bir qismini moslashtirish
kerak bo'ladi.

## Sizga nima kerak

Kerak:

- brauzer,
- GitHub hisobi,
- birinchi dars uchun taxminan ikki soat.

Kerak emas:

- Linux o'rnatish,
- o'z kompyuteringizga biror narsa o'rnatish,
- dastlabki besh dars uchun uskuna sotib olish,
- oldindan dasturlashni bilish,
- git ishlata bilish — buni 3-dars o'rgatadi.

## Birinchi topshiriqqa uch qadam

1. Agar GitHub hisobingiz yo'q bo'lsa, yarating.
2. O'rganish repozitoriyini oching va **Code → Codespaces → Create codespace
   on main** ni bosing. Bir daqiqada terminal ochiladi.
3. 1-darsni oching va buyruqlarni qo'lda bajaring. Oxirida tekshiruvni ishga
   tushiring.

Nimadir tushunarli bo'lmasa, issue oching yoki chatda so'rang. Qotib qolish
jim qolishdan foydaliroq: u aynan qayerda toxtaganingizni ko'rsatadi.
