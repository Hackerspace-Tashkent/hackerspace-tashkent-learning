# Obundan qanday foydalanish kerak

AI vositalari ishni tezlashtiradi. Ular siz nimani qilayotganingizni tushunishni
almashmaydi. «Tushundim» va «javobni oldim» orasidagi farq — bilish va bilmaslik
orasidagi farq.

Bu maqola to'rtta savolga javob beradi: AI qayerda haqiqatan yordam beradi,
qayerda zarar keltiradi, nima bepul ishlatiladi va qanday savol bersangiz foydali
javob olasiz.

---

## 1. AI qayerda haqiqatan yordam beradi

**Tushunmagan narsani tushuntirish.** Qo'llanma sen bergan savolga javob beradi.
AI boshqacha tomondan tushuntirishi, taqqoslash keltirishi va misol ko'rsatishi
mumkin. Bu eng ko'p uchraydigan va eng halol holat.

**Xatolikni o'qish.** Xatolik matnini to'liq, fayl nomi va qator raqami bilan
birga joylashtiring. Ko'pincha shuning o'zi yetarli. Xatoliklar odatda o'z
matnida nima noto'g'ri ekanini aytadi — faqat har doim birinchi o'qishda emas.

**Qiziq maydani yozish.** Faylni ochish, qatorma-qator o'qish, sanash, natijani
chiqarish — bu AI ishi, o'zing esa o'ylashni talab qiladigan qismni yozasan.

**Test misollarini o'ylash.** Yaxshi savol: «bu funksiyani nima buzadi?» Javob
shuni o'ylatadi — chegaralarni o'zing ham o'ylashga majbur qiladi.

**Uzun matnni siqish.** 40 sahifani besh abzasga. O'qishni almashtirmaydi,
lekin keraksizini saralaydi.

**Xom g'oyalar.** «Buni o'n usulda qil» — yomon. «Beshta yondashuv va
har birining afzallik-kamchiliklarini ber» — yaxshi. AI variantlarni sochadi,
qaror senik.

**Repetitsiya qilish.** O'z so'z bilan tushuntir, kod nima qilishini, ziddiyatlar
izohlasin. Ko'pincha shunda o'z mantiqingdagi tuynukni topsan.

## 2. AI qayerda zarar keltiradi

**Sizning tizimingiz haqidagi faktlar.** Model sizning serveringizni,
repository'yingizni yoki `.env` faylingizni ko'rmaydi. Qaysi versiyada ekanini,
qaysi portlar band ekanini, nima o'rnatilganini bilmaydi. Uning tizimingiz
haqidagi har bir maslahati taxminga asoslangan.

**Xato qimmatga tushadigan qarorlar.** Xavfsizlik, pul, huquq, sog'liq. Bu yerda
natijaga javob beradigan odam kerak.

**Tekshirolmagan holatlar.** Agar to'g'ri javobni ishonchli soxta javobdan
ajratolmasangiz, undan foydalana olmaysiz. Hali ajrata olmasangiz —
ishlatmang.

**Muhim moyilish.** AI optimistik. «Ijoatlar tekshir» degani, «sen rejalashtiruvchi
haqidagi taxmining noto'g'ri» deganidan ko'p uchraydi. To'g'ridan so'rab
ko'r: «men nimani noto'g'ri taxmin qilaman?»

## 3. Eng muhim qoida

**AI ishonchli noto'g'ri kodni, to'g'ri kod bilan bir xal ishonch bilan yozadi.**

«Men bilmayman» deydi sen ozroq, undan ko'p. Shuning uchun:

> Ko'chirilgan kod seniki emas — har bir qatorini o'qib, nima qilishini va
> aynan shuning uchun shunday yozilganini tushuntirib bolesang.

Bu bizga shior emas. Amaliyotni nusxa qilib topshargan odda predmetni tushunmagan
bo'ladi. `./check.sh` «vazifa bajarildi» deydi, lekin bilim paydo bo'lmagan.

Yana bir qoida, xavfsizlik darsi bilan bog'liq: **maxfiy ma'lumotlarni internet
xizmatlariga hech qachon tushma.** Na token, na `.env`, na kalitlar, na bazaga
ulashish satrlari. Erkin chatga kod joylashtirish — uni uchinchi tomonga berish.

## 4. Nimadan foydalanish bepul

Chegara vaqt o'zgaradi — bu erga tayanishdan oldin havola bo'yicha tekshiring.

| Vosita | Nima uchun | Bepul | Havola |
|---|---|---|---|
| **Perplexity** | Manbalar bilan qidiruv | Asosiy qidiruvlar amalda cheksiz, kuniga 3 ta Pro Search | [perplexity.ai](https://www.perplexity.ai) |
| **OpenRouter** | API orqali modellarga kirish | `:free` qo'shimchali 25+ model; kuniga 50 ta so'rov, yoki 10 kredit bir marta xarid qilsangiz 1000 | [openrouter.ai/pricing](https://openrouter.ai/pricing) |
| **Ollama + Qwen** | O'z mashinasizda model | Cheksiz, o'z temiringiz bilan cheklangan | [ollama.com/library/qwen](https://ollama.com/library/qwen) |
| **Google AI Studio** | Gemini modellari bilan ish | Kvota bilan bepul | [aistudio.google.com](https://aistudio.google.com) |
| **GitHub Copilot** | Redaktorda maslahat | Bepul tarif, talabalar uchun ko'proq | [github.com/features/copilot](https://github.com/features/copilot) |

**Perplexity** — bu ro'yxatda manbalarni ko'rsatadigan yagona vosita. Fakt kerak
bo'lganda, fikr emas, bu hal qiluvchi: manbani ochib, o'zing tekshira olasan.

**OpenRouter** ko'p modelga bitta kalit beradi. Bittasida kontekst tugasa qulay:
modelni almashtirib davom etasiz. Kamchilik: bepul modellar ko'pincha band, bir
xil savol ham ishlashi, ham `429` qaytarishi mumkin. Aniq model tanlang va
zaxira saqlang.

**Mahalliy model** — ma'lumot fizik ravishda mashinadan chiqmaydigan yagona
variant. Maxfiy kod va internetsiz ishlash uchun yaxshi. To'lov operativ xotira
va tezlik bilan.

## 5. Vazifaga qarab tanlash

| Vazifa | Nimadan foydalanish |
|---|---|
| Tekshirishni talab qiluvchi fakt topish | Perplexity — har doim manbasi bilan |
| Variantlar o'ylash | Har qanday model, hatto mahalliy |
| Noaniq sintaksisni tushuntirish | Har qanday; misol beruvchi yaxshiroq |
| Xatolikni tuzatish | To'liq xato matnini, muhit bilan birga joylashtiring |
| Ko'p bir xil kod yozish | Mahalliy model, agar kod maxfiy bo'lsa |
| O'z repository'yingiz bilan ishlash | Faylga kirish huquqi bor agent, brauzerdagi chat emas |
| O'z botingiz yoki avtomatlashtirish | API: OpenRouter yoki mahalliy model |

## 6. Namuna: bitta ishtirokchi buni qanday qurgan

Bu Arkadiyning shaxsiy sxemasi, hammaga uchun tavsiya emas — har kimning
vazifasi va temiri o'ziga xos.

- **Perplexity** — tekshirilishi muhim bo'lganda manba bilan qidiruv: narxlar,
  hujjatlar, taqqoslashlar.
- **Qwen mahalliy** — tashqariga chiqmasligi kerak bo'lgan kod bilan ish.
- **VPS'dagi Hermes** — avtomatlashtirish: botlar, monitoring, rejalashtirilgan
  vazifalar. Model OpenRouter orqali ulanadi va agent matn javob bermakdan
  tashqari, fayllar va brauzer bilan ishlaydi.

Mantiq oddiy: xato qanchalik qimmatga tushsa, hisoblash senik shunchalik yaqin
bo'lishi kerak. Ommaviy savol — internet xizmatiga. Maxfiy kod — o'z
mashinasiga. O'z infratuzilmang — umuman tashqi bog'liqliksiz.

## 7. Foydali javob olish uchun qanday so'rash kerak

**Kontekst ber.** «Ishlamayapti» — foydasiz. «2-darsda `check.sh` `FAIL:
readme.md 644` deydi, faylni nano'da yaratdim, mana `ls -l` chiqishi» — javoblanadigan
savol.

**Nima qilib ko'rganingni ayt.** Aks holda internettan dastlabki beshta maslahatni
 olasan.

**Tushuntirishni so'ra**, tayyor javobni emas. «Bu nega ishlaydi» tushuntirish
javob berishdan foydaliroq.

**Tanqidni so'ra.** «Mening yondashuvim shu, zaif joylarini top» — eng
baholanmagan so'rov.

**Faktni koddan alohida tekshir.** Kodni ishga tushirib tekshirasan. Manbasiz
fakt fakt emas.

## 8. Sizning mashinasidan nima chiqadi

Aniq bo'lishi lozim:

- brauzer chatiga qo'ygan matn xizmat egasinga boradi;
- bepul tariflar ko'pincha ma'lumot model o'qitishida ishlatilishi mumkinligini
  bildiradi — akkaunt sozlamalarini tekshir;
- mahalliy model hech narsani hech qayerga yubormaydi;
- faylga kirish huquqi bor agent aniq siz bergan miqdorda ko'radi.

## 9. Amaliyotda AI ishlatish mumkinmi

Bu jamoaning qarori, va u hali yo'q. Ochiq savollar:

- Kod AI tomonidan yozilgan bo'lsa, vazifa bajarilgan hisoblanadimi?
- Agar ha, bitta holatni ikkinchisidan qanday ajratiladi?
- Ommaviy tabloda «topshirdi» yoki «tushundi» ko'rsatiladimi?

Qoida yo'q paytda oqilona pozitsiya shu: **ha, lekin yashirmaslik.** Agar kod
AI yordamida yozilgan bo'lsa, PR yoki issue tavsifida aytib bering. Bu
yashirishdan ko'ra halol va foydaliroq.
