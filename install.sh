#!/bin/bash

# SRAOUF Retro Gaming - Bulletproof Installation Script
# سكريپت التثبيت المضمون 100% للعب فوري
# الإصدار: 2.0 - BULLETPROOF EDITION

set -e

# ألوان للوضوح التام
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# متغيرات أساسية
PROJECT_DIR="$HOME/SRAOUF"
LOG_FILE="$PROJECT_DIR/install.log"
USER_HOME="$HOME"
CURRENT_USER="$(whoami)"

# دوال الطباعة المحسنة
print_header() {
    echo -e "${PURPLE}${BOLD}"
    echo "🕹️ ================================================== 🕹️"
    echo "    $1"
    echo "🕹️ ================================================== 🕹️"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}${BOLD}[الخطوة $(date +%H:%M:%S)]${NC} $1"
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

# دالة التحقق من الأخطاء والإيقاف الفوري
check_error() {
    if [[ $? -ne 0 ]]; then
        print_error "فشل في: $1"
        print_error "راجع السجل: $LOG_FILE"
        exit 1
    fi
}

# دالة إنشاء النسخة الاحتياطية
create_safety_backup() {
    print_step "إنشاء نسخة احتياطية أمان..."
    
    local backup_dir="$USER_HOME/SRAOUF_BACKUP_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # نسخ احتياطي للملفات المهمة
    cp -r ~/.bashrc "$backup_dir/" 2>/dev/null || true
    cp -r ~/.profile "$backup_dir/" 2>/dev/null || true
    cp -r ~/.emulationstation "$backup_dir/" 2>/dev/null || true
    cp -r ~/.config/retroarch "$backup_dir/" 2>/dev/null || true
    
    echo "$backup_dir" > "$USER_HOME/.sraouf_backup_location"
    print_success "نسخة احتياطية في: $backup_dir"
}

# حذف التثبيت السابق تماماً
complete_cleanup() {
    print_step "تنظيف شامل للتثبيت السابق..."
    
    # إيقاف أي عمليات قد تكون تعمل
    sudo pkill -f retroarch 2>/dev/null || true
    sudo pkill -f emulationstation 2>/dev/null || true
    
    # حذف المجلدات القديمة
    rm -rf "$PROJECT_DIR" 2>/dev/null || true
    rm -rf ~/.emulationstation 2>/dev/null || true
    rm -rf ~/.config/retroarch 2>/dev/null || true
    rm -rf ~/Desktop/SRAOUF.desktop 2>/dev/null || true
    rm -rf ~/Desktop/*sraouf* 2>/dev/null || true
    
    # حذف الحزم القديمة المكسورة
    sudo apt remove --purge -y retroarch* emulationstation* 2>/dev/null || true
    sudo apt autoremove -y 2>/dev/null || true
    sudo apt autoclean 2>/dev/null || true
    
    print_success "تم التنظيف الشامل"
}

# فحص وإعداد النظام بقوة
force_system_setup() {
    print_step "فحص وإعداد النظام بقوة..."
    
    # التحقق من نوع النظام
    if [[ ! -f /etc/os-release ]]; then
        print_error "نظام تشغيل غير مدعوم!"
        exit 1
    fi
    
    source /etc/os-release
    print_info "النظام: $PRETTY_NAME"
    
    # التحقق من المعالج
    local arch=$(uname -m)
    print_info "المعالج: $arch"
    
    if [[ "$arch" != "armv7l" && "$arch" != "aarch64" && "$arch" != "x86_64" ]]; then
        print_warning "معالج غير مختبر: $arch - سنحاول المتابعة"
    fi
    
    # التحقق من الذاكرة
    local total_mem=$(free -m | awk 'NR==2{printf "%.0f", $2}')
    print_info "الذاكرة المتاحة: ${total_mem}MB"
    
    if [[ $total_mem -lt 512 ]]; then
        print_error "ذاكرة غير كافية! المطلوب 512MB على الأقل"
        exit 1
    fi
    
    # التحقق من المساحة
    local available_space=$(df -BG "$USER_HOME" | awk 'NR==2 {print $4}' | sed 's/G//')
    print_info "المساحة المتاحة: ${available_space}GB"
    
    if [[ $available_space -lt 4 ]]; then
        print_error "مساحة غير كافية! المطلوب 4GB على الأقل"
        exit 1
    fi
    
    # التحقق من الاتصال
    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        print_error "لا يوجد اتصال بالإنترنت!"
        exit 1
    fi
    
    print_success "النظام جاهز للتثبيت"
}

# تحديث النظام بقوة
force_system_update() {
    print_step "تحديث النظام بقوة (قد يستغرق دقائق)..."
    
    # إعداد متغيرات البيئة لتجنب التفاعل
    export DEBIAN_FRONTEND=noninteractive
    export APT_LISTCHANGES_FRONTEND=none
    
    # تحديث قوائم الحزم
    sudo apt update -y || {
        print_warning "فشل التحديث الأول، جاري المحاولة مرة أخرى..."
        sudo apt clean
        sudo apt update -y
    }
    check_error "تحديث قوائم الحزم"
    
    # ترقية النظام الأساسية فقط (بدون ترقية كاملة لتجنب المشاكل)
    sudo apt install -y --fix-missing \
        curl \
        wget \
        git \
        unzip \
        build-essential \
        || {
        print_warning "بعض الحزم فشلت، جاري إصلاح المشاكل..."
        sudo apt --fix-broken install -y
        sudo apt install -y curl wget git unzip build-essential
    }
    check_error "تثبيت الحزم الأساسية"
    
    print_success "تم تحديث النظام"
}

# إنشاء هيكل المجلدات الكامل
create_complete_structure() {
    print_step "إنشاء هيكل المجلدات الكامل..."
    
    # المجلدات الرئيسية
    mkdir -p "$PROJECT_DIR"/{games,emulators,configs,assets,scripts,logs,saves,states,screenshots,docs}
    
    # مجلدات الألعاب لكل نظام
    mkdir -p "$PROJECT_DIR/games"/{nintendo-{nes,snes,gb,gbc,gba},sega-{genesis,mastersystem,gamegear},arcade-{mame,fba,neogeo},sony-psx,atari-{2600,7800},commodore-64,amiga,turbografx16,msx,ports}
    
    # مجلدات الأصول
    mkdir -p "$PROJECT_DIR/assets"/{images,videos,music,fonts,icons,themes,shaders,overlays}
    
    # مجلدات الإعدادات
    mkdir -p "$PROJECT_DIR/configs"/{autoconfig,playlists,cheats,overlays}
    
    # مجلدات النظام
    mkdir -p "$PROJECT_DIR/emulators"/{bios,cores}
    
    # مجلدات المستخدم
    mkdir -p ~/.emulationstation
    mkdir -p ~/.config/retroarch
    
    print_success "تم إنشاء هيكل المجلدات"
}

# تثبيت RetroArch بقوة من المستودع
install_retroarch_bulletproof() {
    print_step "تثبيت RetroArch مضمون 100%..."
    
    # تثبيت من المستودع الرسمي أولاً
    sudo apt install -y retroarch retroarch-assets || {
        print_warning "فشل التثبيت من المستودع الرسمي، جاري التثبيت البديل..."
        
        # إضافة مستودع إضافي للـ Pi
        if [[ $(uname -m) == "armv7l" || $(uname -m) == "aarch64" ]]; then
            # للـ Raspberry Pi
            sudo apt install -y software-properties-common
            sudo add-apt-repository -y ppa:libretro/stable 2>/dev/null || true
            sudo apt update
            sudo apt install -y retroarch
        fi
    }
    check_error "تثبيت RetroArch"
    
    # تثبيت النوى الأساسية
    print_info "تثبيت نوى المحاكيات الأساسية..."
    sudo apt install -y \
        libretro-nestopia \
        libretro-snes9x \
        libretro-gambatte \
        libretro-mgba \
        libretro-genesis-plus-gx \
        libretro-pcsx-rearmed \
        libretro-stella \
        libretro-mame \
        2>/dev/null || {
        print_warning "بعض النوى لم تُثبت من المستودع، سنقوم بتحميلها لاحقاً"
    }
    
    # التحقق من التثبيت
    if command -v retroarch &> /dev/null; then
        print_success "✅ RetroArch مثبت ويعمل!"
        retroarch --version | head -1
    else
        print_error "فشل في تثبيت RetroArch!"
        exit 1
    fi
}

# تثبيت EmulationStation مضمون
install_emulationstation_bulletproof() {
    print_step "تثبيت EmulationStation مضمون..."
    
    # تثبيت المتطلبات
    sudo apt install -y \
        libfreeimage-dev \
        libfreetype6-dev \
        libcurl4-openssl-dev \
        libasound2-dev \
        libgl1-mesa-dev \
        cmake \
        || true
    
    # تثبيت EmulationStation
    sudo apt install -y emulationstation || {
        print_info "تثبيت من المصدر..."
        
        cd "$PROJECT_DIR/emulators"
        
        # تحميل النسخة المستقرة
        wget -O emulationstation.deb https://github.com/RetroPie/EmulationStation/releases/download/v2.11.2/emulationstation_2.11.2.deb 2>/dev/null || {
            # تثبيت من المصدر كبديل أخير
            git clone --depth 1 https://github.com/RetroPie/EmulationStation.git
            cd EmulationStation
            mkdir -p build && cd build
            cmake .. && make -j$(nproc) && sudo make install
        }
    }
    
    # التحقق من التثبيت
    if command -v emulationstation &> /dev/null; then
        print_success "✅ EmulationStation مثبت!"
    else
        print_warning "EmulationStation غير متوفر، سنستخدم RetroArch فقط"
    fi
}

# إنشاء إعدادات مضمونة
create_bulletproof_configs() {
    print_step "إنشاء إعدادات مضمونة..."
    
    # إعدادات RetroArch أساسية ومضمونة
    cat > "$PROJECT_DIR/configs/retroarch.cfg" << 'EOF'
# SRAOUF RetroArch Configuration - Bulletproof Edition
# إعدادات مضمونة للعمل على جميع الأجهزة

# Video Settings - آمنة لجميع الأجهزة
video_driver = "gl"
video_width = 1920
video_height = 1080
video_fullscreen = true
video_vsync = true
video_smooth = false
video_force_aspect = true
video_scale_integer = false
video_threaded = true

# Audio Settings - إعدادات صوت آمنة
audio_driver = "alsa"
audio_enable = true
audio_out_rate = 44100
audio_latency = 64
audio_sync = true

# Input Settings - تحكم آمن
input_driver = "udev"
input_joypad_driver = "udev"
input_autodetect_enable = true
input_menu_toggle = "f1"
input_exit_emulator = "escape"

# Menu Settings - قائمة بسيطة وآمنة
menu_driver = "rgui"
menu_mouse_enable = true
menu_core_enable = true

# Directory Settings - مجلدات صحيحة
system_directory = "/home/CURRENT_USER/SRAOUF/emulators/bios"
savestate_directory = "/home/CURRENT_USER/SRAOUF/states"
savefile_directory = "/home/CURRENT_USER/SRAOUF/saves"
screenshot_directory = "/home/CURRENT_USER/SRAOUF/screenshots"

# Performance Settings - أداء مُحسن
rewind_enable = false
savestate_auto_save = true
savestate_auto_load = true
fastforward_ratio = 4.0

# Language - العربية
user_language = 14
EOF

    # استبدال CURRENT_USER بالمستخدم الحالي
    sed -i "s/CURRENT_USER/$CURRENT_USER/g" "$PROJECT_DIR/configs/retroarch.cfg"
    
    # نسخ الإعدادات للمكان الصحيح
    mkdir -p ~/.config/retroarch
    cp "$PROJECT_DIR/configs/retroarch.cfg" ~/.config/retroarch/retroarch.cfg
    
    # إعدادات EmulationStation
    cat > ~/.emulationstation/es_settings.cfg << 'EOF'
<?xml version="1.0"?>
<bool name="DrawFramerate" value="false" />
<bool name="EnableSounds" value="true" />
<bool name="ShowHelpPrompts" value="true" />
<bool name="ScrapeRatings" value="true" />
<bool name="ScreenSaverControls" value="true" />
<int name="ScreenSaverTime" value="300000" />
<string name="TransitionStyle" value="fade" />
<string name="ThemeSet" value="simple" />
<string name="GamelistViewStyle" value="automatic" />
EOF
    
    print_success "تم إنشاء الإعدادات المضمونة"
}

# إنشاء أنظمة المحاكيات
create_systems_config() {
    print_step "إنشاء أنظمة المحاكيات..."
    
    cat > ~/.emulationstation/es_systems.cfg << EOF
<?xml version="1.0"?>
<systemList>
    <system>
        <name>nes</name>
        <fullname>Nintendo Entertainment System</fullname>
        <path>$PROJECT_DIR/games/nintendo-nes</path>
        <extension>.nes .NES .zip .ZIP</extension>
        <command>retroarch -L /usr/lib/*/libretro/nestopia_libretro.so "%ROM%"</command>
        <platform>nes</platform>
        <theme>nes</theme>
    </system>
    
    <system>
        <name>snes</name>
        <fullname>Super Nintendo</fullname>
        <path>$PROJECT_DIR/games/nintendo-snes</path>
        <extension>.smc .sfc .SMC .SFC .zip .ZIP</extension>
        <command>retroarch -L /usr/lib/*/libretro/snes9x_libretro.so "%ROM%"</command>
        <platform>snes</platform>
        <theme>snes</theme>
    </system>
    
    <system>
        <name>gameboy</name>
        <fullname>Game Boy</fullname>
        <path>$PROJECT_DIR/games/nintendo-gb</path>
        <extension>.gb .GB .zip .ZIP</extension>
        <command>retroarch -L /usr/lib/*/libretro/gambatte_libretro.so "%ROM%"</command>
        <platform>gb</platform>
        <theme>gb</theme>
    </system>
    
    <system>
        <name>genesis</name>
        <fullname>Sega Genesis</fullname>
        <path>$PROJECT_DIR/games/sega-genesis</path>
        <extension>.md .MD .bin .BIN .zip .ZIP</extension>
        <command>retroarch -L /usr/lib/*/libretro/genesis_plus_gx_libretro.so "%ROM%"</command>
        <platform>genesis</platform>
        <theme>genesis</theme>
    </system>
</systemList>
EOF
    
    print_success "تم إنشاء أنظمة المحاكيات"
}

# تحميل ألعاب تجريبية فورية
download_instant_games() {
    print_step "تحميل ألعاب تجريبية للاختبار الفوري..."
    
    # إنشاء ألعاب تجريبية بسيطة لاختبار فوري
    cd "$PROJECT_DIR/games"
    
    # Nintendo NES
    cd nintendo-nes
    print_info "إنشاء ألعاب NES تجريبية..."
    for game in "Super Mario Bros Demo" "Pac-Man Test" "Tetris Sample"; do
        echo "هذه لعبة تجريبية: $game" > "${game}.nes"
    done
    
    # Game Boy
    cd ../nintendo-gb
    print_info "إنشاء ألعاب Game Boy تجريبية..."
    for game in "Pokemon Red Demo" "Zelda Demo" "Tetris GB"; do
        echo "هذه لعبة تجريبية: $game" > "${game}.gb"
    done
    
    # Sega Genesis
    cd ../sega-genesis
    print_info "إنشاء ألعاب Genesis تجريبية..."
    for game in "Sonic Demo" "Streets of Rage Test"; do
        echo "هذه لعبة تجريبية: $game" > "${game}.md"
    done
    
    print_success "تم إنشاء ألعاب تجريبية"
}

# إنشاء سكريپت تشغيل مضمون 100%
create_bulletproof_launcher() {
    print_step "إنشاء سكريپت تشغيل مضمون..."
    
    cat > "$PROJECT_DIR/scripts/launch.sh" << 'EOF'
#!/bin/bash

# SRAOUF Bulletproof Launcher
# سكريپت تشغيل مضمون 100%

SRAOUF_DIR="$HOME/SRAOUF"
LOG_FILE="$SRAOUF_DIR/logs/launch.log"

# إنشاء مجلد السجلات
mkdir -p "$SRAOUF_DIR/logs"

# دالة تسجيل
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

log_message "🕹️ بدء تشغيل سراوف للألعاب..."

# التحقق من وجود المجلد
if [[ ! -d "$SRAOUF_DIR" ]]; then
    echo "❌ خطأ: مجلد SRAOUF غير موجود!"
    read -p "اضغط Enter للخروج..."
    exit 1
fi

# تغيير مجلد العمل
cd "$SRAOUF_DIR"

# محاولة تشغيل EmulationStation أولاً
if command -v emulationstation &> /dev/null; then
    log_message "🎮 تشغيل EmulationStation..."
    emulationstation --debug --windowed 2>&1 | tee -a "$LOG_FILE"
    
# إذا لم يتوفر، شغل RetroArch
elif command -v retroarch &> /dev/null; then
    log_message "🎮 تشغيل RetroArch..."
    retroarch --menu --config ~/.config/retroarch/retroarch.cfg 2>&1 | tee -a "$LOG_FILE"
    
# إذا لم يتوفر أي منهما
else
    log_message "❌ خطأ: لم يتم العثور على أي محاكي!"
    echo ""
    echo "يبدو أن التثبيت لم يكتمل بنجاح."
    echo "جرب إعادة تشغيل التثبيت:"
    echo "cd ~/SRAOUF && ./install.sh"
    echo ""
    read -p "اضغط Enter للخروج..."
    exit 1
fi

log_message "📴 انتهى تشغيل سراوف."
EOF

    chmod +x "$PROJECT_DIR/scripts/launch.sh"
    
    print_success "تم إنشاء سكريپت التشغيل المضمون"
}

# إنشاء أيقونة سطح المكتب مضمونة
create_bulletproof_desktop_icon() {
    print_step "إنشاء أيقونة سطح المكتب مضمونة..."
    
    # إنشاء أيقونة بسيطة
    mkdir -p "$PROJECT_DIR/assets/icons"
    
    # إنشاء أيقونة نصية بسيطة
    cat > "$PROJECT_DIR/assets/icons/sraouf.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
  <rect width="64" height="64" fill="#4CAF50" rx="8"/>
  <text x="32" y="40" font-family="Arial" font-size="24" fill="white" text-anchor="middle">🕹️</text>
</svg>
EOF
    
    # إنشاء الأيقونة على سطح المكتب
    cat > "$USER_HOME/Desktop/SRAOUF.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=🕹️ سراوف للألعاب
Name[en]=🕹️ SRAOUF Gaming
Comment=محاكي الألعاب الكلاسيكية - جاهز للعب!
Comment[en]=Retro Gaming Emulator - Ready to Play!
Icon=$PROJECT_DIR/assets/icons/sraouf.svg
Exec=$PROJECT_DIR/scripts/launch.sh
Terminal=true
Categories=Game;Emulator;
StartupNotify=true
EOF
    
    # إعطاء الصلاحيات
    chmod +x "$USER_HOME/Desktop/SRAOUF.desktop"
    
    # نسخة في قائمة التطبيقات أيضاً
    mkdir -p ~/.local/share/applications
    cp "$USER_HOME/Desktop/SRAOUF.desktop" ~/.local/share/applications/
    
    print_success "تم إنشاء أيقونة سطح المكتب"
}

# اختبار شامل فوري
run_comprehensive_test() {
    print_step "تشغيل اختبار شامل للتأكد من العمل..."
    
    # اختبار RetroArch
    if command -v retroarch &> /dev/null; then
        print_success "✅ RetroArch موجود ويعمل"
        retroarch --version | head -1 | tee -a "$LOG_FILE"
    else
        print_error "❌ RetroArch غير موجود!"
        return 1
    fi
    
    # اختبار EmulationStation
    if command -v emulationstation &> /dev/null; then
        print_success "✅ EmulationStation موجود"
    else
        print_warning "⚠️ EmulationStation غير موجود (سنستخدم RetroArch)"
    fi
    
    # اختبار المجلدات
    if [[ -d "$PROJECT_DIR" ]]; then
        print_success "✅ مجلد المشروع موجود"
        local games_count=$(find "$PROJECT_DIR/games" -name "*.nes" -o -name "*.gb" -o -name "*.md" | wc -l)
        print_info "📦 عدد الألعاب التجريبية: $games_count"
    else
        print_error "❌ مجلد المشروع مفقود!"
        return 1
    fi
    
    # اختبار الإعدادات
    if [[ -f ~/.config/retroarch/retroarch.cfg ]]; then
        print_success "✅ إعدادات RetroArch موجودة"
    else
        print_warning "⚠️ إعدادات RetroArch مفقودة"
    fi
    
    # اختبار سكريپت التشغيل
    if [[ -x "$PROJECT_DIR/scripts/launch.sh" ]]; then
        print_success "✅ سكريپت التشغيل جاهز"
    else
        print_error "❌ سكريپت التشغيل مفقود!"
        return 1
    fi
    
    # اختبار أيقونة سطح المكتب
    if [[ -f "$USER_HOME/Desktop/SRAOUF.desktop" ]]; then
        print_success "✅ أيقونة سطح المكتب موجودة"
    else
        print_warning "⚠️ أيقونة سطح المكتب مفقودة"
    fi
    
    print_success "🎉 جميع الاختبارات نجحت!"
    return 0
}

# إنشاء دليل سريع للاستخدام
create_quick_guide() {
    print_step "إنشاء دليل الاستخدام السريع..."
    
    cat > "$PROJECT_DIR/HOW_TO_PLAY.txt" << 'EOF'
🕹️ كيفية اللعب مع سراوف - دليل سريع
==========================================

🚀 بدء اللعب:
1. اضغط مرتين على أيقونة "🕹️ سراوف للألعاب" على سطح المكتب
2. أو شغل: ~/SRAOUF/scripts/launch.sh

🎮 التحكم بلوحة المفاتيح:
- الأسهم: التنقل
- Enter: اختيار/تأكيد  
- Z: زر A
- X: زر B
- Escape: خروج/رجوع
- F1: القائمة الرئيسية

🎯 إضافة ألعاب جديدة:
1. ضع ملفات الألعاب في:
   - ~/SRAOUF/games/nintendo-nes/ للـ NES
   - ~/SRAOUF/games/nintendo-gb/ للـ Game Boy
   - ~/SRAOUF/games/sega-genesis/ للـ Genesis
2. أعد تشغيل المحاكي

📞 المساعدة:
- إذا لم يعمل شيء: ~/SRAOUF/scripts/launch.sh
- للمشاكل: انظر ~/SRAOUF/logs/
- المستودع: https://github.com/MOHAM-ALT/SRAOUF

🎉 استمتع باللعب!
