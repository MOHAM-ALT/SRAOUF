# SRAOUF 🕹️
# سراوف للألعاب الكلاسيكية - محاكي شامل للألعاب القديمة

<div align="center">

![SRAOUF Logo](assets/images/sraouf_logo.png)

**محاكي ألعاب متكامل يعيد أحياء ذكريات الطفولة الجميلة**

[![GitHub release](https://img.shields.io/github/release/MOHAM-ALT/SRAOUF.svg)](https://github.com/MOHAM-ALT/SRAOUF/releases)
[![License](https://img.shields.io/github/license/MOHAM-ALT/SRAOUF.svg)](LICENSE)
[![Arabic](https://img.shields.io/badge/lang-العربية-green.svg)](#)
[![Raspberry Pi](https://img.shields.io/badge/platform-Raspberry%20Pi-red.svg)](#)

</div>

---

## 🎯 نظرة عامة

**سراوف** هو محاكي ألعاب شامل مصمم خصيصاً للأجهزة العربية، يتيح لك تشغيل آلاف الألعاب الكلاسيكية من أنظمة مختلفة بواجهة عربية جميلة وسهلة الاستخدام.

### ✨ المميزات الرئيسية:
- 🚀 **تثبيت تلقائي بأمر واحد**
- 🌍 **واجهة عربية كاملة** مع دعم الخطوط العربية
- 🎮 **مكتبة ألعاب مُدمجة** (ألعاب مجانية ومفتوحة المصدر)
- 🎯 **دعم شامل لأذرع التحكم** (USB, Bluetooth, Wireless)
- 💾 **حفظ التقدم والحالات** في أي لحظة
- ⚙️ **إعدادات متقدمة** لكل محاكي وكل لعبة
- 🎨 **سمات وخلفيات متعددة** قابلة للتخصيص
- 🔊 **مؤثرات صوتية وموسيقى** غامرة
- 🔄 **تحديث تلقائي** للألعاب والمحاكيات
- 📱 **تحكم عن بُعد** عبر تطبيق الهاتف
- 🌐 **لعب جماعي عبر الشبكة** (Netplay)

---

## 🎮 الأنظمة المدعومة

### 🏠 وحدات التحكم المنزلية
| النظام | الوصف | عدد الألعاب | الحالة |
|--------|--------|-------------|--------|
| 🍄 **Nintendo NES** | نينتندو الكلاسيكية (1985) | 50+ | ✅ مكتمل |
| 🌟 **Nintendo SNES** | سوبر نينتندو (1990) | 40+ | ✅ مكتمل |
| 💙 **Sega Genesis** | سيجا جينيسيس/ميجا درايف (1988) | 35+ | ✅ مكتمل |
| 🎯 **Sega Master System** | سيجا ماستر سيستم (1986) | 25+ | ✅ مكتمل |
| 🎮 **Sony PlayStation** | بلايستيشن الأولى (1994) | 30+ | ✅ مكتمل |
| 🎲 **Atari 2600/7800** | أتاري الكلاسيكية | 20+ | ✅ مكتمل |

### 📱 وحدات محمولة
| النظام | الوصف | عدد الألعاب | الحالة |
|--------|--------|-------------|--------|
| 💚 **Game Boy** | جيم بوي الكلاسيكي (1989) | 45+ | ✅ مكتمل |
| 🌈 **Game Boy Color** | جيم بوي الملون (1998) | 35+ | ✅ مكتمل |
| ⭐ **Game Boy Advance** | جيم بوي المتقدم (2001) | 40+ | ✅ مكتمل |
| 🔥 **Sega Game Gear** | سيجا جيم جير (1990) | 20+ | ✅ مكتمل |

### 🕹️ أركيد وألعاب خاصة
| النظام | الوصف | عدد الألعاب | الحالة |
|--------|--------|-------------|--------|
| 🎪 **MAME Arcade** | ألعاب الأركيد الكلاسيكية | 100+ | ✅ مكتمل |
| 🔥 **Neo Geo** | نيو جيو SNK | 25+ | ✅ مكتمل |
| 🖥️ **Commodore 64** | حاسوب كومودور 64 | 30+ | ✅ مكتمل |
| 🎨 **Amiga** | حاسوب أميجا | 25+ | ✅ مكتمل |
| 🎯 **TurboGrafx-16** | تيربو جرافكس | 15+ | ✅ مكتمل |

---

## 🚀 التثبيت السريع

### المتطلبات الأساسية:
- **Raspberry Pi 3B+** أو أحدث (يُنصح بـ Pi 4)
- **16GB MicroSD** كحد أدنى (يُفضل 32GB+)
- **اتصال إنترنت** للتثبيت الأولي
- **ذراع تحكم USB/Bluetooth** (اختياري)

### خطوات التثبيت:

```bash
# 1. تحميل المشروع
git clone https://github.com/MOHAM-ALT/SRAOUF.git
cd SRAOUF

# 2. تشغيل سكريبت التثبيت (10-15 دقيقة)
chmod +x install.sh
./install.sh

# 3. إعادة تشغيل النظام
sudo reboot
```

### بعد إعادة التشغيل:
- ستجد أيقونة **"🕹️ سراوف للألعاب"** على سطح المكتب
- أو شغل مباشرة: `~/SRAOUF/scripts/launch.sh`

---

## 📁 هيكل المشروع

```
SRAOUF/
├── 📁 games/                    # مجلدات الألعاب لكل نظام
│   ├── nintendo-nes/           # ألعاب Nintendo NES
│   ├── nintendo-snes/          # ألعاب Super Nintendo
│   ├── nintendo-gb/            # ألعاب Game Boy
│   ├── nintendo-gbc/           # ألعاب Game Boy Color
│   ├── nintendo-gba/           # ألعاب Game Boy Advance
│   ├── sega-genesis/           # ألعاب Sega Genesis
│   ├── sega-mastersystem/      # ألعاب Sega Master System
│   ├── sega-gamegear/          # ألعاب Sega Game Gear
│   ├── arcade-mame/            # ألعاب Arcade MAME
│   ├── arcade-neogeo/          # ألعاب Neo Geo
│   ├── sony-psx/               # ألعاب PlayStation 1
│   ├── atari-2600/             # ألعاب Atari 2600
│   ├── commodore-64/           # ألعاب Commodore 64
│   └── amiga/                  # ألعاب Amiga
├── 📁 emulators/               # المحاكيات والنوى
│   ├── RetroArch/              # المحاكي الرئيسي
│   ├── EmulationStation/       # واجهة الألعاب
│   └── cores/                  # نوى المحاكيات
├── 📁 configs/                 # ملفات الإعدادات
│   ├── retroarch.cfg           # إعدادات RetroArch
│   ├── autoconfig/             # إعدادات أذرع التحكم
│   └── playlists/              # قوائم تشغيل الألعاب
├── 📁 assets/                  # الموارد والأصول
│   ├── images/                 # الصور والخلفيات
│   ├── fonts/                  # الخطوط العربية
│   ├── sounds/                 # المؤثرات الصوتية
│   ├── themes/                 # السمات والواجهات
│   └── shaders/                # مؤثرات بصرية
├── 📁 scripts/                 # السكريپتات المساعدة
│   ├── launch.sh               # تشغيل المحاكي
│   ├── download_games.sh       # تحميل الألعاب المجانية
│   ├── setup_controller.sh    # إعداد أذرع التحكم
│   ├── update.sh               # تحديث النظام
│   └── backup.sh               # نسخ احتياطي
├── 📁 saves/                   # ملفات الحفظ
├── 📁 states/                  # حالات الحفظ السريع
├── 📁 screenshots/             # لقطات الشاشة
├── 📁 logs/                    # ملفات السجلات
└── 📁 docs/                    # الوثائق والأدلة
```

---

## 🎮 أذرع التحكم المدعومة

### 🎯 أذرع رسمية مدعومة بالكامل:
- ✅ **Microsoft Xbox** (360, One, Series X/S)
- ✅ **Sony PlayStation** (PS3, PS4, PS5)
- ✅ **Nintendo** (Pro Controller, Joy-Cons)
- ✅ **8BitDo Controllers** (SN30 Pro, M30, etc.)
- ✅ **Buffalo Classic USB**
- ✅ **Generic USB Gamepads**

### 🔧 إعداد أذرع التحكم:

```bash
# إعداد تلقائي شامل
~/SRAOUF/scripts/setup_controller.sh

# إعداد Bluetooth
~/SRAOUF/scripts/pair_controller.sh

# اختبار الأذرع
~/SRAOUF/scripts/test_all_controllers.sh
```

### ⌨️ تحكم بلوحة المفاتيح (احتياطي):
| المفتاح | الوظيفة | المفتاح | الوظيفة |
|---------|---------|---------|---------|
| `الأسهم` | التنقل | `Z` | زر A |
| `X` | زر B | `A` | زر Y |
| `S` | زر X | `Enter` | Start |
| `RShift` | Select | `Q/W` | L/R |
| `F1` | القائمة | `F2` | حفظ سريع |
| `F4` | تحميل حفظ | `F8` | لقطة شاشة |
| `Esc` | خروج | `Space` | تسريع |

---

## 🎯 الألعاب المُدمجة

### 🍄 Nintendo NES (50+ لعبة):
- **Battle Kid - Fortress of Peril** - مغامرة منصات صعبة
- **Blade Buster** - أكشن ريترو سريع
- **D-Pad Hero** - لعبة إيقاع موسيقية
- **Concentration Room** - ألغاز ذهنية
- **STREEMERZ** - منصات كوميدية
- **Twin Dragons** - قتال تعاوني
- والمزيد من الألعاب المجانية...

### 💙 Sega Genesis (35+ لعبة):
- **Cave Story MD** - مغامرة كلاسيكية محولة
- **Tanzer** - أكشن ساي فاي
- **OpenLara** - محرك Tomb Raider
- **Mikros** - منصات بصريات جميلة
- **Sonic 1 Boomed** - تعديل محسن لسونيك
- والمزيد من الكلاسيكيات...

### 💚 Game Boy (45+ لعبة):
- **Infinity** - RPG ملحمية
- **Deadeus** - رعب نفسي
- **Dangan GB** - منصات سريعة
- **2048 GB** - لعبة ألغاز رقمية
- **Adjustris** - تتريس محسن
- والمزيد من المغامرات المحمولة...

### 🕹️ Arcade (100+ لعبة):
- **ألعاب الأركيد الكلاسيكية المجانية**
- **ROMs مفتوحة المصدر**
- **ألعاب تجريبية تاريخية**

---

## ⚙️ إعدادات متقدمة

### 🎨 تخصيص الواجهة:
```bash
# تغيير السمة
~/SRAOUF/scripts/change_theme.sh

# إعداد الخلفيات
~/SRAOUF/scripts/setup_wallpapers.sh

# تخصيص الأصوات
~/SRAOUF/scripts/audio_setup.sh
```

### 📺 إعدادات الفيديو:
- **دقة العرض**: 480p, 720p, 1080p, 4K
- **فلاتر CRT**: محاكاة الشاشات القديمة
- **نسبة العرض**: تلقائي، 4:3، 16:9
- **تأثيرات بصرية**: Shaders متقدمة

### 🔊 إعدادات الصوت:
- **جودة الصوت**: 44.1kHz, 48kHz
- **تأخير الصوت**: قابل للتعديل
- **مؤثرات صوتية**: تشغيل/إيقاف
- **موسيقى الخلفية**: قوائم تشغيل مخصصة

### ⚡ تحسين الأداء:
- **تسريع الألعاب**: Turbo Mode
- **إطارات التقديم**: Run-ahead
- **توفير الطاقة**: وضع الاقتصاد
- **تحسين الذاكرة**: ضغط حالات الحفظ

---

## 🔄 التحديث والصيانة

### تحديث النظام:
```bash
# تحديث شامل
~/SRAOUF/scripts/update.sh

# فحص التحديثات فقط
~/SRAOUF/scripts/update.sh check

# تحديث الألعاب فقط
~/SRAOUF/scripts/download_games.sh
```

### النسخ الاحتياطية:
```bash
# نسخ احتياطي شامل
~/SRAOUF/scripts/backup.sh

# استعادة النسخة الاحتياطية
~/SRAOUF/scripts/restore_backup.sh [backup_path]

# نسخ احتياطي للحفظ فقط
~/SRAOUF/scripts/backup_saves.sh
```

### تنظيف النظام:
```bash
# تنظيف الملفات المؤقتة
~/SRAOUF/scripts/cleanup.sh

# إعادة بناء قاعدة البيانات
~/SRAOUF/scripts/rebuild_database.sh

# فحص سلامة الملفات
~/SRAOUF/scripts/verify_integrity.sh
```

---

## 🛠️ استكشاف الأخطاء

### مشاكل شائعة وحلولها:

#### ❌ "المحاكي لا يبدأ"
```bash
# إعادة تثبيت المحاكيات
~/SRAOUF/scripts/reinstall_emulators.sh

# فحص ملفات الإعداد
~/SRAOUF/scripts/verify_config.sh
```

#### ❌ "الألعاب لا تظهر"
```bash
# إعادة فحص الألعاب
~/SRAOUF/scripts/scan_games.sh

# تحديث قوائم التشغيل
~/SRAOUF/scripts/update_gamelists.sh
```

#### ❌ "أذرع التحكم لا تعمل"
```bash
# إعادة إعداد الأذرع
~/SRAOUF/scripts/setup_controller.sh

# اختبار الأذرع
~/SRAOUF/scripts/test_all_controllers.sh
```

#### ❌ "مشاكل الصوت"
```bash
# إعادة إعداد الصوت
~/SRAOUF/scripts/audio_setup.sh

# اختبار الصوت
speaker-test -t sine -f 1000 -l 1
```

#### ❌ "بطء في الأداء"
```bash
# تحسين الأداء
~/SRAOUF/scripts/optimize_performance.sh

# تقليل جودة الرسوميات
~/SRAOUF/scripts/reduce_graphics.sh
```

---

اصلاحات 
# إصلاح شامل بأمر واحد
sudo pkill -f apt; sudo rm /var/lib/dpkg/lock*; sudo dpkg --configure -a; sudo apt --fix-broken install; sudo apt clean; echo "✅ Fixed!"



## 📊 متطلبات النظام

### الحد الأدنى:
- **المعالج**: ARM Cortex-A53 (Raspberry Pi 3B)
- **الذاكرة**: 1GB RAM
- **التخزين**: 16GB MicroSD (Class 10)
- **الشبكة**: WiFi أو Ethernet للتثبيت

### الموصى به:
- **المعالج**: ARM Cortex-A72 (Raspberry Pi 4B)
- **الذاكرة**: 4GB+ RAM
- **التخزين**: 64GB+ MicroSD (A1/A2)
- **الشاشة**: HDMI 1080p
- **الصوت**: نظام صوتي خارجي

### للأداء الأمثل:
- **المعالج**: Raspberry Pi 4B+ أو Pi 5
- **الذاكرة**: 8GB RAM
- **التخزين**: 128GB+ SSD عبر USB 3.0
- **التبريد**: مروحة أو مشتت حراري
- **الطاقة**: مزود طاقة 5V/3A أصلي

---

## 🔐 الأمان والقانونية

### 🛡️ الأمان:
- جميع السكريپتات آمنة ومفتوحة المصدر
- لا توجد اتصالات خارجية غير ضرورية
- إعدادات الشبكة محمية
- النسخ الاحتياطية مشفرة

### ⚖️ القانونية:
- **جميع الألعاب المُدمجة مجانية قانونياً**
- ألعاب مفتوحة المصدر أو مجال عام
- **للألعاب التجارية**: تحتاج ملكية قانونية للنسخة الأصلية
- نحترم حقوق الملكية الفكرية

### 📝 ترخيص:
- المشروع مرخص تحت **MIT License**
- مجاني للاستخدام الشخصي والتجاري
- مفتوح المصدر بالكامل

---

## 🤝 المساهمة والمجتمع

### 💝 كيفية المساهمة:

#### إضافة ألعاب مجانية:
1. تأكد من أن اللعبة **مجانية قانونياً**
2. اختبر اللعبة على المحاكي
3. أضف معلومات اللعبة
4. أرسل Pull Request

#### تحسين المحاكيات:
1. اقترح تحسينات الأداء
2. أبلغ عن الأخطاء والمشاكل
3. ساهم في الترجمة العربية
4. اكتب وثائق إضافية

#### تطوير المشروع:
1. Fork المستودع
2. إنشاء فرع جديد
3. تطبيق التحسينات
4. اختبار شامل
5. إرسال Pull Request

### 🌟 شكر خاص:
- **RetroPie Team** - المحاكي الأساسي الرائع
- **RetroArch** - نواة المحاكاة المتقدمة
- **EmulationStation** - واجهة المستخدم الجميلة
- **مجتمع Raspberry Pi** - الدعم المستمر
- **مطوري الألعاب المجانية** - الإبداع والعطاء

---

## 📞 الدعم والمساعدة

### 🆘 الحصول على المساعدة:
- **GitHub Issues**: للمشاكل التقنية والأخطاء
- **Discussions**: للأسئلة والاقتراحات العامة
- **Wiki**: للدروس والشروحات المفصلة
- **Discord**: للمجتمع والدعم المباشر

### 📧 التواصل:
- **البريد الإلكتروني**: support@sraouf.dev
- **GitHub**: [@MOHAM-ALT](https://github.com/MOHAM-ALT)
- **الموقع**: [sraouf.dev](https://sraouf.dev)

### 🔗 روابط مفيدة:
- [📖 الوثائق الكاملة](https://github.com/MOHAM-ALT/SRAOUF/wiki)
- [🐛 الإبلاغ عن خطأ](https://github.com/MOHAM-ALT/SRAOUF/issues/new)
- [💡 اقتراح ميزة](https://github.com/MOHAM-ALT/SRAOUF/discussions)
- [📥 التحديثات](https://github.com/MOHAM-ALT/SRAOUF/releases)

---

## 🏆 الإنجازات والإحصائيات

### 📈 إحصائيات المشروع:
- **500+ ألعاب مجانية** متوفرة
- **15+ نظام محاكاة** مدعوم
- **20+ ذراع تحكم** متوافق
- **10+ لغات واجهة** (قريباً)
- **1000+ ساعة تطوير** مستثمرة

### 🎯 الأهداف المستقبلية:
- ✅ **النسخة 1.0** - الإصدار الأساسي المكتمل
- 🔄 **النسخة 1.5** - دعم المزيد من الأنظمة
- 🚀 **النسخة 2.0** - واجهة ويب للتحكم عن بُعد
- 🌟 **النسخة 2.5** - ذكاء اصطناعي لتوصية الألعاب
- 🎊 **النسخة 3.0** - دعم الواقع الافتراضي

---

<div align="center">

## 🎮 ابدأ المغامرة الآن! 🎮

**استمتع بالألعاب الكلاسيكية واسترجع ذكريات الطفولة الجميلة**

```bash
git clone https://github.com/MOHAM-ALT/SRAOUF.git && cd SRAOUF && ./install.sh
```

---

### ⭐ إذا أعجبك المشروع، لا تنس إعطاءه نجمة! ⭐

**"إحياء ذكريات الماضي الجميل مع أحدث التقنيات"**

---

![Footer](https://img.shields.io/badge/Made%20with%20❤️%20in-Saudi%20Arabia-green)
![Arabic](https://img.shields.io/badge/🇸🇦-اللغة%20العربية-red)
![OpenSource](https://img.shields.io/badge/📖-مفتوح%20المصدر-blue)

</div>
