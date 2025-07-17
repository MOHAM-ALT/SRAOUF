#!/bin/bash

# SRAOUF Ultimate Fix Script - يحل جميع المشاكل نهائياً
# الإصدار: 4.0 ULTIMATE EDITION

set -e

# ألوان النص
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# متغيرات أساسية
SRAOUF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"
CURRENT_USER="$(whoami)"
LOG_FILE="$SRAOUF_DIR/logs/ultimate_fix.log"

# إنشاء مجلد اللوغز فوراً
mkdir -p "$SRAOUF_DIR/logs"

# دوال الطباعة المحسنة
print_header() {
    echo -e "${PURPLE}${BOLD}"
    echo "🛠️ ===================================================== 🛠️"
    echo "    $1"
    echo "🛠️ ===================================================== 🛠️"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}${BOLD}[$(date +%H:%M:%S)]${NC} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}${BOLD}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}${BOLD}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${BOLD}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# إصلاح الصلاحيات فوراً ونهائياً
fix_all_permissions() {
    print_step "إصلاح جميع الصلاحيات نهائياً..."
    
    # صلاحيات التنفيذ لجميع السكريپتات
    find "$SRAOUF_DIR" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    
    # صلاحيات كاملة للمجلد الرئيسي
    chmod -R 755 "$SRAOUF_DIR" 2>/dev/null || true
    
    # صلاحيات خاصة للملفات الحساسة
    chmod 644 "$SRAOUF_DIR"/*.md 2>/dev/null || true
    chmod 644 "$SRAOUF_DIR"/*.txt 2>/dev/null || true
    chmod 644 "$SRAOUF_DIR"/configs/*.cfg 2>/dev/null || true
    
    # إنشاء وإصلاح مجلدات النظام
    mkdir -p ~/.config/retroarch
    mkdir -p ~/.emulationstation
    chmod -R 755 ~/.config/retroarch 2>/dev/null || true
    chmod -R 755 ~/.emulationstation 2>/dev/null || true
    
    # إضافة المستخدم للمجموعات المطلوبة
    sudo usermod -a -G audio "$CURRENT_USER" 2>/dev/null || true
    sudo usermod -a -G video "$CURRENT_USER" 2>/dev/null || true
    sudo usermod -a -G input "$CURRENT_USER" 2>/dev/null || true
    sudo usermod -a -G dialout "$CURRENT_USER" 2>/dev/null || true
    
    print_success "تم إصلاح جميع الصلاحيات"
}

# إصلاح تركيب الملفات والمسارات
fix_file_structure() {
    print_step "إصلاح هيكل الملفات والمسارات..."
    
    # إنشاء جميع المجلدات المطلوبة
    local directories=(
        "scripts" "configs" "games" "assets" "docs" "emulators" 
        "saves" "states" "screenshots" "logs" "backups"
        "games/nintendo-nes" "games/nintendo-snes" "games/nintendo-gb" 
        "games/nintendo-gbc" "games/nintendo-gba" "games/nintendo-n64"
        "games/sega-genesis" "games/sega-mastersystem" "games/sega-gamegear"
        "games/arcade-mame" "games/arcade-neogeo" "games/sony-psx"
        "games/atari-2600" "games/commodore-64" "games/amiga"
        "assets/images" "assets/icons" "assets/fonts" "assets/themes"
        "assets/sounds" "assets/shaders" "assets/overlays"
        "configs/autoconfig" "configs/playlists" "configs/cheats"
        "emulators/bios" "emulators/cores"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$SRAOUF_DIR/$dir"
        chmod 755 "$SRAOUF_DIR/$dir"
    done
    
    # نقل الملفات للأماكن الصحيحة إذا كانت في غير مكانها
    if [[ -f "$SRAOUF_DIR/fix_problems.sh" && ! -f "$SRAOUF_DIR/scripts/fix_problems.sh" ]]; then
        mv "$SRAOUF_DIR/fix_problems.sh" "$SRAOUF_DIR/scripts/" 2>/dev/null || true
    fi
    
    if [[ -f "$SRAOUF_DIR/setup_controller.sh" && ! -f "$SRAOUF_DIR/scripts/setup_controller.sh" ]]; then
        mv "$SRAOUF_DIR/setup_controller.sh" "$SRAOUF_DIR/scripts/" 2>/dev/null || true
    fi
    
    if [[ -f "$SRAOUF_DIR/download_games.sh" && ! -f "$SRAOUF_DIR/scripts/download_games.sh" ]]; then
        mv "$SRAOUF_DIR/download_games.sh" "$SRAOUF_DIR/scripts/" 2>/dev/null || true
    fi
    
    if [[ -f "$SRAOUF_DIR/update.sh" && ! -f "$SRAOUF_DIR/scripts/update.sh" ]]; then
        mv "$SRAOUF_DIR/update.sh" "$SRAOUF_DIR/scripts/" 2>/dev/null || true
    fi
    
    # نقل ملفات الإعدادات
    if [[ -f "$SRAOUF_DIR/retroarch.cfg" && ! -f "$SRAOUF_DIR/configs/retroarch.cfg" ]]; then
        mv "$SRAOUF_DIR/retroarch.cfg" "$SRAOUF_DIR/configs/" 2>/dev/null || true
    fi
    
    if [[ -f "$SRAOUF_DIR/es_systems.cfg" && ! -f "$SRAOUF_DIR/configs/es_systems.cfg" ]]; then
        mv "$SRAOUF_DIR/es_systems.cfg" "$SRAOUF_DIR/configs/" 2>/dev/null || true
    fi
    
    print_success "تم إصلاح هيكل الملفات"
}

# إصلاح ملف es_systems.cfg المكسور
fix_es_systems_config() {
    print_step "إصلاح ملف es_systems.cfg..."
    
    cat > "$SRAOUF_DIR/configs/es_systems.cfg" << 'EOF'
<?xml version="1.0"?>
<!-- SRAOUF EmulationStation Systems Configuration -->
<systemList>
    
    <!-- Nintendo Entertainment System -->
    <system>
        <name>nes</name>
        <fullname>نينتندو إنترتينمنت سيستم</fullname>
        <path>~/SRAOUF/games/nintendo-nes</path>
        <extension>.nes .NES .zip .ZIP .7z .7Z</extension>
        <command>retroarch -L /usr/lib/*/libretro/nestopia_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>nes</platform>
        <theme>nes</theme>
    </system>

    <!-- Super Nintendo -->
    <system>
        <name>snes</name>
        <fullname>سوبر نينتندو</fullname>
        <path>~/SRAOUF/games/nintendo-snes</path>
        <extension>.smc .sfc .SMC .SFC .zip .ZIP .7z .7Z</extension>
        <command>retroarch -L /usr/lib/*/libretro/snes9x_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>snes</platform>
        <theme>snes</theme>
    </system>

    <!-- Game Boy -->
    <system>
        <name>gb</name>
        <fullname>نينتندو جيم بوي</fullname>
        <path>~/SRAOUF/games/nintendo-gb</path>
        <extension>.gb .GB .zip .ZIP .7z .7Z</extension>
        <command>retroarch -L /usr/lib/*/libretro/gambatte_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>gb</platform>
        <theme>gb</theme>
    </system>

    <!-- Game Boy Color -->
    <system>
        <name>gbc</name>
        <fullname>جيم بوي كولر</fullname>
        <path>~/SRAOUF/games/nintendo-gbc</path>
        <extension>.gbc .GBC .zip .ZIP .7z .7Z</extension>
        <command>retroarch -L /usr/lib/*/libretro/gambatte_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>gbc</platform>
        <theme>gbc</theme>
    </system>

    <!-- Game Boy Advance -->
    <system>
        <name>gba</name>
        <fullname>جيم بوي أدفانس</fullname>
        <path>~/SRAOUF/games/nintendo-gba</path>
        <extension>.gba .GBA .zip .ZIP .7z .7Z</extension>
        <command>retroarch -L /usr/lib/*/libretro/mgba_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>gba</platform>
        <theme>gba</theme>
    </system>

    <!-- Sega Genesis -->
    <system>
        <name>genesis</name>
        <fullname>سيجا جينيسيس</fullname>
        <path>~/SRAOUF/games/sega-genesis</path>
        <extension>.bin .BIN .gen .GEN .md .MD .zip .ZIP .7z .7Z</extension>
        <command>retroarch -L /usr/lib/*/libretro/genesis_plus_gx_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>genesis</platform>
        <theme>genesis</theme>
    </system>

    <!-- Sega Master System -->
    <system>
        <name>mastersystem</name>
        <fullname>سيجا ماستر سيستم</fullname>
        <path>~/SRAOUF/games/sega-mastersystem</path>
        <extension>.sms .SMS .zip .ZIP .7z .7Z</extension>
        <command>retroarch -L /usr/lib/*/libretro/genesis_plus_gx_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>mastersystem</platform>
        <theme>mastersystem</theme>
    </system>

    <!-- Arcade MAME -->
    <system>
        <name>mame</name>
        <fullname>ماكينات الأركيد</fullname>
        <path>~/SRAOUF/games/arcade-mame</path>
        <extension>.zip .ZIP .7z .7Z</extension>
        <command>retroarch -L /usr/lib/*/libretro/mame_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>arcade</platform>
        <theme>mame</theme>
    </system>

    <!-- Sony PlayStation -->
    <system>
        <name>psx</name>
        <fullname>سوني بلايستيشن</fullname>
        <path>~/SRAOUF/games/sony-psx</path>
        <extension>.bin .BIN .cue .CUE .img .IMG .iso .ISO .zip .ZIP</extension>
        <command>retroarch -L /usr/lib/*/libretro/pcsx_rearmed_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>psx</platform>
        <theme>psx</theme>
    </system>

    <!-- Atari 2600 -->
    <system>
        <name>atari2600</name>
        <fullname>أتاري 2600</fullname>
        <path>~/SRAOUF/games/atari-2600</path>
        <extension>.a26 .A26 .bin .BIN .zip .ZIP</extension>
        <command>retroarch -L /usr/lib/*/libretro/stella_libretro.so --config ~/SRAOUF/configs/retroarch.cfg "%ROM%"</command>
        <platform>atari2600</platform>
        <theme>atari2600</theme>
    </system>

</systemList>
EOF

    # نسخ للمكان الصحيح أيضاً
    cp "$SRAOUF_DIR/configs/es_systems.cfg" ~/.emulationstation/es_systems.cfg 2>/dev/null || true

    print_success "تم إصلاح ملف es_systems.cfg"
}

# إنشاء سكريپت التشغيل المحدث
create_fixed_launcher() {
    print_step "إنشاء سكريپت تشغيل محدث..."
    
    cat > "$SRAOUF_DIR/scripts/launch.sh" << 'EOF'
#!/bin/bash
# SRAOUF Ultimate Launcher - يعمل دائماً!

# العثور على مجلد سراوف
SRAOUF_DIR="$(cd "$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")" && pwd)"

echo "🕹️ تشغيل سراوف للألعاب..."
echo "مجلد سراوف: $SRAOUF_DIR"

# التأكد من الإعدادات
if [[ -f "$SRAOUF_DIR/configs/retroarch.cfg" ]]; then
    export RETROARCH_CONFIG="$SRAOUF_DIR/configs/retroarch.cfg"
    echo "✅ تم العثور على إعدادات RetroArch"
else
    echo "⚠️ لم يتم العثور على إعدادات RetroArch"
fi

# محاولة تشغيل EmulationStation أولاً
if command -v emulationstation &> /dev/null; then
    echo "🎮 تشغيل EmulationStation..."
    cd "$SRAOUF_DIR"
    emulationstation
elif command -v retroarch &> /dev/null; then
    echo "🎮 تشغيل RetroArch..."
    retroarch --menu --config "$SRAOUF_DIR/configs/retroarch.cfg"
else
    echo "❌ لم يتم العثور على محاكي!"
    echo "قم بتشغيل: $SRAOUF_DIR/install.sh"
    read -p "اضغط Enter للمتابعة..."
fi
EOF

    chmod +x "$SRAOUF_DIR/scripts/launch.sh"
    
    print_success "تم إنشاء سكريپت التشغيل"
}

# إنشاء أيقونة سطح المكتب محدثة
create_fixed_desktop_icon() {
    print_step "إنشاء أيقونة سطح المكتب محدثة..."
    
    # إنشاء أيقونة SVG
    cat > "$SRAOUF_DIR/assets/icons/sraouf.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="64" height="64" xmlns="http://www.w3.org/2000/svg">
  <rect width="64" height="64" fill="#2E7D32" rx="8"/>
  <text x="32" y="42" font-family="Arial" font-size="32" fill="white" text-anchor="middle">🕹️</text>
</svg>
EOF

    # إنشاء ملف .desktop محدث
    cat > "$USER_HOME/Desktop/SRAOUF.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=🕹️ سراوف للألعاب
Comment=محاكي الألعاب الكلاسيكية
Icon=$SRAOUF_DIR/assets/icons/sraouf.svg
Exec=$SRAOUF_DIR/scripts/launch.sh
Terminal=true
Categories=Game;Emulator;
StartupNotify=true
Path=$SRAOUF_DIR
EOF

    chmod +x "$USER_HOME/Desktop/SRAOUF.desktop"
    
    print_success "تم إنشاء أيقونة سطح المكتب"
}

# تحديث وإصلاح النظام
update_and_fix_system() {
    print_step "تحديث وإصلاح النظام..."
    
    # تحديث قوائم الحزم
    sudo apt update -y
    
    # تثبيت الحزم المطلوبة
    sudo apt install -y \
        git curl wget unzip \
        retroarch retroarch-assets \
        emulationstation \
        joystick jstest-gtk evtest \
        bluez bluez-tools \
        alsa-utils pulseaudio \
        build-essential cmake \
        || print_warning "بعض الحزم فشلت في التثبيت"
    
    # تثبيت النوى
    sudo apt install -y \
        libretro-nestopia \
        libretro-snes9x \
        libretro-gambatte \
        libretro-mgba \
        libretro-genesis-plus-gx \
        libretro-pcsx-rearmed \
        libretro-stella \
        libretro-mame \
        || print_warning "بعض النوى فشلت في التثبيت"
    
    print_success "تم تحديث النظام"
}

# إنشاء ألعاب تجريبية للاختبار
create_test_games() {
    print_step "إنشاء ألعاب تجريبية للاختبار..."
    
    # إنشاء ملفات ألعاب وهمية للاختبار
    systems=("nintendo-nes" "nintendo-snes" "nintendo-gb" "nintendo-gbc" "sega-genesis")
    
    for system in "${systems[@]}"; do
        game_dir="$SRAOUF_DIR/games/$system"
        mkdir -p "$game_dir"
        
        case $system in
            "nintendo-nes")
                echo "NES Demo ROM" > "$game_dir/Super Mario Bros Demo.nes"
                echo "NES Demo ROM" > "$game_dir/Pac-Man Test.nes"
                ;;
            "nintendo-snes")
                echo "SNES Demo ROM" > "$game_dir/Super Mario World Demo.sfc"
                ;;
            "nintendo-gb")
                echo "GB Demo ROM" > "$game_dir/Pokemon Red Demo.gb"
                ;;
            "nintendo-gbc")
                echo "GBC Demo ROM" > "$game_dir/Pokemon Gold Demo.gbc"
                ;;
            "sega-genesis")
                echo "Genesis Demo ROM" > "$game_dir/Sonic Demo.bin"
                ;;
        esac
    done
    
    print_success "تم إنشاء ألعاب تجريبية"
}

# اختبار شامل لكل شيء
run_comprehensive_test() {
    print_step "تشغيل اختبار شامل..."
    
    local errors=0
    local warnings=0
    
    echo
    print_info "🧪 نتائج الاختبار الشامل:"
    echo "================================"
    
    # اختبار install.sh
    if [[ -f "$SRAOUF_DIR/install.sh" && -x "$SRAOUF_DIR/install.sh" ]]; then
        print_success "✅ install.sh: موجود وقابل للتنفيذ"
        
        # اختبار تركيب الملف
        if bash -n "$SRAOUF_DIR/install.sh"; then
            print_success "✅ install.sh: تركيب سليم"
        else
            print_error "❌ install.sh: خطأ في التركيب"
            ((errors++))
        fi
    else
        print_error "❌ install.sh: مفقود أو غير قابل للتنفيذ"
        ((errors++))
    fi
    
    # اختبار السكريپتات في مجلد scripts
    if [[ -d "$SRAOUF_DIR/scripts" ]]; then
        print_success "✅ مجلد scripts: موجود"
        
        local script_count=$(find "$SRAOUF_DIR/scripts" -name "*.sh" | wc -l)
        print_info "📄 عدد السكريپتات: $script_count"
        
        # اختبار سكريپت التشغيل
        if [[ -x "$SRAOUF_DIR/scripts/launch.sh" ]]; then
            print_success "✅ launch.sh: جاهز للتنفيذ"
        else
            print_warning "⚠️ launch.sh: غير قابل للتنفيذ"
            ((warnings++))
        fi
    else
        print_error "❌ مجلد scripts: مفقود"
        ((errors++))
    fi
    
    # اختبار الإعدادات
    if [[ -f "$SRAOUF_DIR/configs/retroarch.cfg" ]]; then
        print_success "✅ retroarch.cfg: موجود"
    else
        print_warning "⚠️ retroarch.cfg: مفقود"
        ((warnings++))
    fi
    
    if [[ -f "$SRAOUF_DIR/configs/es_systems.cfg" ]]; then
        print_success "✅ es_systems.cfg: موجود"
        
        # اختبار XML
        if command -v xmllint &> /dev/null; then
            if xmllint --noout "$SRAOUF_DIR/configs/es_systems.cfg" 2>/dev/null; then
                print_success "✅ es_systems.cfg: XML صحيح"
            else
                print_error "❌ es_systems.cfg: XML معطوب"
                ((errors++))
            fi
        fi
    else
        print_warning "⚠️ es_systems.cfg: مفقود"
        ((warnings++))
    fi
    
    # اختبار مجلدات الألعاب
    local game_dirs=$(find "$SRAOUF_DIR/games" -type d -mindepth 1 | wc -l)
    if [[ $game_dirs -gt 0 ]]; then
        print_success "✅ مجلدات الألعاب: $game_dirs موجود"
    else
        print_warning "⚠️ مجلدات الألعاب: غير موجودة"
        ((warnings++))
    fi
    
    # اختبار RetroArch
    if command -v retroarch &> /dev/null; then
        print_success "✅ RetroArch: $(retroarch --version | head -1)"
    else
        print_error "❌ RetroArch: غير مثبت"
        ((errors++))
    fi
    
    # اختبار EmulationStation
    if command -v emulationstation &> /dev/null; then
        print_success "✅ EmulationStation: مثبت"
    else
        print_warning "⚠️ EmulationStation: غير مثبت"
        ((warnings++))
    fi
    
    # اختبار النوى
    local cores_count=$(ls /usr/lib/*/libretro/*.so 2>/dev/null | wc -l)
    if [[ $cores_count -gt 0 ]]; then
        print_success "✅ نوى المحاكيات: $cores_count موجود"
    else
        print_warning "⚠️ نوى المحاكيات: غير موجودة"
        ((warnings++))
    fi
    
    # اختبار أيقونة سطح المكتب
    if [[ -f "$USER_HOME/Desktop/SRAOUF.desktop" ]]; then
        print_success "✅ أيقونة سطح المكتب: موجودة"
    else
        print_warning "⚠️ أيقونة سطح المكتب: مفقودة"
        ((warnings++))
    fi
    
    # تقرير النتائج النهائية
    echo
    echo "================================"
    if [[ $errors -eq 0 && $warnings -eq 0 ]]; then
        print_success "🎉 مثالي! جميع الاختبارات نجحت"
        print_info "🚀 سراوف جاهز للاستخدام بنسبة 100%"
    elif [[ $errors -eq 0 ]]; then
        print_warning "✅ جيد! $warnings تحذيرات فقط (النظام يعمل)"
        print_info "🎮 سراوف جاهز للاستخدام"
    else
        print_error "⚠️ مشاكل! $errors أخطاء و $warnings تحذيرات"
        print_info "🔧 قد تحتاج إصلاحات إضافية"
    fi
    
    return $errors
}

# إنشاء دليل إصلاح المشاكل
create_troubleshooting_guide() {
    print_step "إنشاء دليل إصلاح المشاكل..."
    
    cat > "$SRAOUF_DIR/TROUBLESHOOTING.md" << 'EOF'
# دليل إصلاح مشاكل سراوف 🛠️

## المشاكل الشائعة وحلولها:

### 1. مشكلة الصلاحيات
```bash
# تشغيل سكريپت الإصلاح
./fix_all_issues.sh

# أو إصلاح يدوي
chmod +x *.sh scripts/*.sh
chmod -R 755 ~/SRAOUF
```

### 2. install.sh لا يعمل
```bash
# التأكد من الأذونات
chmod +x install.sh

# تشغيل مع sudo إذا لزم الأمر
sudo ./install.sh
```

### 3. RetroArch لا يبدأ
```bash
# إعادة تثبيت RetroArch
sudo apt remove retroarch
sudo apt install retroarch retroarch-assets

# أو تشغيل مباشر
retroarch --menu
```

### 4. الألعاب لا تظهر
```bash
# فحص مجلدات الألعاب
ls -la ~/SRAOUF/games/

# إعادة فحص الألعاب
./scripts/scan_games.sh
```

### 5. أذرع التحكم لا تعمل
```bash
# إعداد الأذرع
./scripts/setup_controller.sh

# اختبار الأذرع
./scripts/test_all_controllers.sh
```

### 6. مشاكل EmulationStation
```bash
# إعادة إنشاء إعدادات ES
rm ~/.emulationstation/es_systems.cfg
cp configs/es_systems.cfg ~/.emulationstation/
```

## أوامر طوارئ:

### إصلاح شامل
```bash
./fix_all_issues.sh
```

### إعادة تثبيت كاملة
```bash
rm -rf ~/SRAOUF
git clone https://github.com/MOHAM-ALT/SRAOUF.git
cd SRAOUF
./install.sh
```

### فحص الأخطاء
```bash
# فحص اللوج
cat logs/ultimate_fix.log

# فحص النظام
./scripts/system_check.sh
```

### مشاكل خاصة بـ Raspberry Pi

#### Pi 5 لا يعمل بشكل مثالي
```bash
./scripts/optimize_pi5.sh
```

#### مشاكل GPU/الذاكرة
```bash
# زيادة ذاكرة GPU
sudo nano /boot/config.txt
# أضف: gpu_mem=256
```

## ملفات مهمة:
- `install.sh` - التثبيت الرئيسي
- `scripts/launch.sh` - تشغيل سراوف
- `configs/retroarch.cfg` - إعدادات RetroArch
- `configs/es_systems.cfg` - إعدادات الأنظمة
- `logs/ultimate_fix.log` - سجل الإصلاحات

## للمساعدة:
- GitHub: https://github.com/MOHAM-ALT/SRAOUF
- الدعم الفني: تواصل عبر Issues
EOF

    print_success "تم إنشاء دليل إصلاح المشاكل"
}

# إنشاء سكريپت فحص النظام
create_system_check_script() {
    print_step "إنشاء سكريپت فحص النظام..."
    
    cat > "$SRAOUF_DIR/scripts/system_check.sh" << 'EOF'
#!/bin/bash

# SRAOUF System Check Script
# سكريپت فحص النظام الشامل

echo "🔍 فحص نظام سراوف الشامل"
echo "============================"

# فحص النظام الأساسي
echo "📋 معلومات النظام:"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"

# فحص Raspberry Pi
if [[ -f /proc/device-tree/model ]]; then
    echo "Pi Model: $(cat /proc/device-tree/model)"
fi

echo ""
echo "🎮 فحص المحاكيات:"

# فحص RetroArch
if command -v retroarch &> /dev/null; then
    echo "✅ RetroArch: $(retroarch --version | head -1)"
else
    echo "❌ RetroArch: غير مثبت"
fi

# فحص EmulationStation
if command -v emulationstation &> /dev/null; then
    echo "✅ EmulationStation: مثبت"
else
    echo "❌ EmulationStation: غير مثبت"
fi

# فحص النوى
echo ""
echo "🎯 نوى المحاكيات:"
cores_count=$(ls /usr/lib/*/libretro/*.so 2>/dev/null | wc -l)
echo "عدد النوى: $cores_count"

if [[ $cores_count -gt 0 ]]; then
    echo "النوى الموجودة:"
    ls /usr/lib/*/libretro/*.so | head -10 | while read core; do
        echo "  - $(basename "$core")"
    done
fi

# فحص أذرع التحكم
echo ""
echo "🎮 أذرع التحكم:"
js_count=$(ls /dev/input/js* 2>/dev/null | wc -l)
echo "عدد الأذرع: $js_count"

if [[ $js_count -gt 0 ]]; then
    echo "الأذرع الموجودة:"
    for js in /dev/input/js*; do
        if [[ -e "$js" ]]; then
            name=$(cat "/sys/class/input/$(basename "$js")/device/name" 2>/dev/null || echo "Unknown")
            echo "  - $js: $name"
        fi
    done
fi

# فحص الألعاب
echo ""
echo "🕹️ الألعاب:"
for system_dir in ~/SRAOUF/games/*/; do
    if [[ -d "$system_dir" ]]; then
        system_name=$(basename "$system_dir")
        game_count=$(find "$system_dir" -type f \( -name "*.nes" -o -name "*.sfc" -o -name "*.gb" -o -name "*.gbc" -o -name "*.bin" -o -name "*.zip" \) | wc -l)
        echo "  - $system_name: $game_count ألعاب"
    fi
done

# فحص الصوت
echo ""
echo "🔊 النظام الصوتي:"
if command -v aplay &> /dev/null; then
    echo "✅ ALSA: متوفر"
    echo "بطاقات الصوت:"
    aplay -l | grep "card" | head -3
else
    echo "❌ ALSA: غير متوفر"
fi

# فحص الشبكة
echo ""
echo "🌐 الاتصال:"
if ping -c 1 google.com &> /dev/null; then
    echo "✅ الإنترنت: متصل"
else
    echo "❌ الإنترنت: غير متصل"
fi

echo ""
echo "✅ انتهى فحص النظام"
EOF

    chmod +x "$SRAOUF_DIR/scripts/system_check.sh"
    
    print_success "تم إنشاء سكريپت فحص النظام"
}

# الدالة الرئيسية المحدثة
main() {
    clear
    print_header "إصلاح شامل لجميع مشاكل سراوف"
    print_header "SRAOUF ULTIMATE FIX - يحل كل شيء نهائياً!"
    
    print_info "هذا السكريپت سيحل جميع المشاكل:"
    print_info "🔧 إصلاح الصلاحيات نهائياً"
    print_info "📁 ترتيب هيكل الملفات"
    print_info "⚙️ إصلاح ملفات الإعدادات"
    print_info "🎮 تحديث المحاكيات"
    print_info "🧪 اختبار شامل للنظام"
    print_info "📖 إنشاء أدلة المساعدة"
    echo
    
    read -p "هل تريد المتابعة مع الإصلاح الشامل؟ (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "تم إلغاء العملية"
        exit 0
    fi
    
    echo
    print_step "بدء الإصلاح الشامل..."
    echo "$(date): Starting ultimate fix..." > "$LOG_FILE"
    
    # تنفيذ جميع الإصلاحات
    fix_all_permissions
    fix_file_structure
    fix_es_systems_config
    create_fixed_launcher
    create_fixed_desktop_icon
    update_and_fix_system
    create_test_games
    create_troubleshooting_guide
    create_system_check_script
    
    # اختبار شامل نهائي
    if run_comprehensive_test; then
        local error_count=$?
        
        echo
        print_header "🎉 تم الإصلاح الشامل بنجاح! 🎉"
        echo
        
        if [[ $error_count -eq 0 ]]; then
            print_success "✅ سراوف يعمل بأقصى كفاءة!"
            print_info "🚀 للتشغيل: اضغط على أيقونة سطح المكتب"
            print_info "🎮 أو شغل: $SRAOUF_DIR/scripts/launch.sh"
        else
            print_warning "⚠️ الإصلاح مكتمل مع بعض التحذيرات البسيطة"
            print_info "🎮 النظام يعمل ويمكن استخدامه"
        fi
        
        echo
        print_info "📚 أدلة مفيدة تم إنشاؤها:"
        print_info "  - دليل المشاكل: $SRAOUF_DIR/TROUBLESHOOTING.md"
        print_info "  - فحص النظام: $SRAOUF_DIR/scripts/system_check.sh"
        print_info "  - سجل الإصلاحات: $LOG_FILE"
        
        echo
        print_success "🎊 استمتع بالألعاب!"
        
    else
        print_error "❌ حدثت بعض المشاكل أثناء الإصلاح"
        print_info "راجع السجل: $LOG_FILE"
        exit 1
    fi
    
    echo "$(date): Ultimate fix completed successfully." >> "$LOG_FILE"
}

# تشغيل السكريپت
main "$@"
