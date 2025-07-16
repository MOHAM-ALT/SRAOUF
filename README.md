# SRAOUF
# 🕹️ SRAOUF Retro Gaming - محاكي الألعاب الكلاسيكية

مرحباً بك في **سراوف للألعاب الكلاسيكية**! محاكي شامل للألعاب القديمة على Raspberry Pi.

## 🎮 ما هو هذا المشروع؟

هذا مشروع محاكي ألعاب متكامل يتيح لك تشغيل آلاف الألعاب الكلاسيكية من أنظمة مختلفة:

### 🎯 الأنظمة المدعومة:
- **🍄 Nintendo:** NES, SNES, Game Boy, Game Boy Color, Game Boy Advance
- **💙 Sega:** Genesis/Mega Drive, Master System, Game Gear
- **🕹️ Arcade:** MAME, FinalBurn Neo, Neo Geo
- **🎮 PlayStation:** PS1
- **📺 Atari:** 2600, 7800
- **💻 Classic Computers:** Commodore 64, Amiga
- **🏠 Home Consoles:** TurboGrafx-16, MSX

### ✨ المميزات:
- **تثبيت تلقائي** بأمر واحد على Raspberry Pi
- **واجهة عربية** جميلة وسهلة الاستخدام
- **مكتبة ألعاب مُدمجة** (ألعاب مجانية ومفتوحة المصدر)
- **دعم أذرع التحكم** (USB, Bluetooth, Wireless)
- **حفظ التقدم** في أي لحظة
- **إعدادات متقدمة** لكل محاكي
- **شاشة توقف** بعرض الألعاب
- **تحديث تلقائي** للألعاب والمحاكيات

## 🚀 التثبيت السريع

### على Raspberry Pi:
```bash
# استنساخ المشروع
git clone https://github.com/MOHAM-ALT/SRAOUF.git
cd SRAOUF

# تشغيل سكريبت التثبيت (يستغرق 10-15 دقيقة)
chmod +x install.sh
./install.sh

# إعادة تشغيل الجهاز
sudo reboot
```

بعد إعادة التشغيل ستجد أيقونة "🕹️ سراوف للألعاب" على سطح المكتب!

## 📁 ما ستحصل عليه:

### 🎮 المحاكيات:
- **RetroArch** - المحاكي الرئيسي
- **EmulationStation** - الواجهة الرسومية
- **RetroPie Setup** - أدوات الإعداد

### 🎯 الألعاب المُدمجة:
```
games/
├── nintendo-nes/
│   ├── Super Mario Bros (Homebrew).nes
│   ├── Tetris (Public Domain).nes
│   └── Contra (Free Version).nes
├── sega-genesis/
│   ├── Sonic Demo.bin
│   ├── Streets of Rage Remake.bin
│   └── Golden Axe Demo.bin
├── arcade/
│   ├── Pac-Man (MAME).zip
│   ├── Street Fighter (Demo).zip
│   └── Metal Slug (Free).zip
├── gameboy/
│   ├── Tetris DX.gb
│   ├── Pokemon Red Demo.gb
│   └── Zelda Links Awakening Demo.gb
└── playstation/
    ├── Gran Turismo Demo.bin
    ├── Final Fantasy VII Demo.bin
    └── Crash Bandicoot Demo.bin
```

### 🎵 المؤثرات الصوتية:
- أصوات تشغيل الألعاب
- موسيقى الخلفية للقوائم
- مؤثرات صوتية للتنقل

### 🖼️ الخلفيات والسمات:
- خلفيات كلاسيكية لكل نظام
- سمات ملونة ومتحركة
- شعارات الأنظمة الأصلية

## 🎮 كيفية إضافة ألعاب جديدة:

### 1. الطريقة السهلة (عبر الواجهة):
- افتح المحاكي
- اذهب إلى "إعدادات" → "إضافة ألعاب"
- اختر النظام المطلوب
- اسحب وأفلت ملف اللعبة

### 2. الطريقة اليدوية:
```bash
# انسخ ملفات الألعاب إلى المجلد المناسب
cp my_game.nes ~/SRAOUF/games/nintendo-nes/
cp my_game.bin ~/SRAOUF/games/sega-genesis/

# إعادة فحص الألعاب
~/SRAOUF/scripts/scan_games.sh
```

## 🕹️ أذرع التحكم المدعومة:

- ✅ **PlayStation Controllers** (PS3, PS4, PS5)
- ✅ **Xbox Controllers** (360, One, Series X/S)
- ✅ **Nintendo Controllers** (Pro Controller, Joy-Cons)
- ✅ **Retro USB Controllers** (8BitDo, Buffalo Classic)
- ✅ **Generic USB Gamepads**
- ✅ **Keyboard Controls** (احتياطي)

## ⚙️ الإعدادات والتخصيص:

### إعدادات الفيديو:
- دقة العرض: 1080p, 720p, 480p
- تأثيرات CRT الكلاسيكية
- فلاتر التنعيم والحدة
- نسبة العرض للشاشة

### إعدادات الصوت:
- مستوى الصوت لكل نظام
- تأثيرات صوتية
- دعم الصوت المحيطي

### إعدادات الأداء:
- تسريع الألعاب (Turbo Mode)
- توفير الطاقة
- تحسين الأداء للألعاب ثقيلة التشغيل

## 📊 متطلبات النظام:

### الحد الأدنى:
- **Raspberry Pi 3B** أو أحدث
- **16GB MicroSD** (كلاس 10)
- **1GB RAM** متاح
- **اتصال إنترنت** (للتثبيت الأولي)

### الموصى به:
- **Raspberry Pi 4 (4GB)** أو أحدث
- **64GB MicroSD** (سرعة عالية)
- **USB Gamepad** للتحكم الأمثل
- **شاشة HDMI** بدقة 1080p

## 🛠️ استكشاف الأخطاء:

### المشاكل الشائعة:

#### ❌ "المحاكي لا يعمل"
```bash
# إعادة تثبيت المحاكيات
~/SRAOUF/scripts/reinstall_emulators.sh
```

#### ❌ "لا تظهر الألعاب"
```bash
# إعادة فحص مجلدات الألعاب
~/SRAOUF/scripts/scan_games.sh
```

#### ❌ "لا يتعرف على ذراع التحكم"
```bash
# إعداد ذراع التحكم
~/SRAOUF/scripts/setup_controller.sh
```

#### ❌ "صوت منخفض أو غير واضح"
```bash
# إعداد الصوت
~/SRAOUF/scripts/audio_setup.sh
```

## 🔄 التحديث:

```bash
# للحصول على أحدث الألعاب والمحاكيات
cd ~/SRAOUF
git pull
./update.sh
```

## 📸 لقطات الشاشة:

### الشاشة الرئيسية:
![Main Menu](assets/screenshots/main_menu.png)

### قائمة الألعاب:
![Games List](assets/screenshots/games_list.png)

### داخل اللعبة:
![In Game](assets/screenshots/in_game.png)

## 🎯 ألعاب مميزة مُدمجة:

### 🍄 Nintendo Classics:
- Super Mario World (Demo)
- The Legend of Zelda (Homebrew)
- Metroid (Free Version)
- Mega Man (Classic)

### 💙 Sega Hits:
- Sonic the Hedgehog (Original)
- Streets of Rage 2 (Remake)
- Phantasy Star (Demo)
- Shining Force (Trial)

### 🕹️ Arcade Legends:
- Pac-Man Championship
- Street Fighter Alpha
- King of Fighters '98
- Metal Slug X

## 🚨 ملاحظات قانونية:

- جميع الألعاب المُدمجة **مجانية** أو **مفتوحة المصدر**
- لا نوزع ألعاب محمية بحقوق الطبع
- للألعاب التجارية، تحتاج **ملكية قانونية** للنسخة الأصلية
- نحترم حقوق المطورين والناشرين

## 🤝 المساهمة:

### إضافة ألعاب مجانية:
1. تأكد من أن اللعبة **مجانية قانونياً**
2. اختبر اللعبة على المحاكي
3. أرسل Pull Request مع معلومات اللعبة

### تحسين المحاكيات:
1. اقترح تحسينات الأداء
2. أبلغ عن المشاكل
3. ساهم في الترجمة العربية

## 📞 الدعم:

- **GitHub Issues:** للمشاكل التقنية
- **Wiki:** للدروس والشروحات
- **Discord:** للمجتمع والمساعدة

## 🏆 الشكر والتقدير:

- **RetroPie Team** - على المحاكي الأساسي
- **RetroArch** - على المحاكيات المتقدمة
- **EmulationStation** - على الواجهة الجميلة
- **مجتمع Raspberry Pi** - على الدعم المستمر

---

**استمتع بالألعاب الكلاسيكية! 🎮✨**

> "إحياء ذكريات الماضي الجميل مع أحدث التقنيات"