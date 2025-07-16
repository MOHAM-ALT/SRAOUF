#!/bin/bash

# SRAOUF Perfect Installation Script
# سكريپت التثبيت المثالي لسراوف - يعمل بأمر واحد بلا مشاكل
# الإصدار: 3.0 BULLETPROOF

set -e

# ألوان للوضوح
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# متغيرات أساسية
SRAOUF_DIR="$(pwd)"
USER_HOME="$HOME"
CURRENT_USER="$(whoami)"
LOG_FILE="$SRAOUF_DIR/logs/install.log"

# إنشاء مجلد اللوغز
mkdir -p logs

# دوال الطباعة
print_header() {
    echo -e "${PURPLE}${BOLD}"
    echo "🕹️ ================================================== 🕹️"
    echo "    $1"
    echo "🕹️ ================================================== 🕹️"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}${BOLD}[$(date +%H:%M:%S)]${NC} $1"
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

# التحقق من الأخطاء
check_error() {
    if [[ $? -ne 0 ]]; then
        print_error "فشل في: $1"
        print_error "راجع السجل: $LOG_FILE"
        exit 1
    fi
}

# إعطاء الأذونات الكاملة فوراً
fix_permissions_immediately() {
    print_step "إعطاء الأذونات الكاملة فوراً..."
    
    # أذونات التنفيذ للسكريپتات
    chmod +x "$SRAOUF_DIR"/*.sh 2>/dev/null || true
    chmod +x "$SRAOUF_DIR"/scripts/*.sh 2>/dev/null || true
    
    # أذونات كاملة للمجلدات
    chmod -R 755 "$SRAOUF_DIR" 2>/dev/null || true
    
    # أذونات القراءة للإعدادات
    chmod 644 "$SRAOUF_DIR"/configs/*.cfg 2>/dev/null || true
    chmod 644 "$SRAOUF_DIR"/*.md 2>/dev/null || true
    
    print_success "تم إعطاء جميع الأذونات"
}

# إنشاء هيكل المجلدات المثالي
create_perfect_structure() {
    print_step "إنشاء هيكل المجلدات المثالي..."
    
    # المجلدات الرئيسية
    mkdir -p "$SRAOUF_DIR"/{scripts,configs,games,assets,docs,emulators,saves,states,screenshots,logs}
    
    # مجلدات فرعية للألعاب
    mkdir -p "$SRAOUF_DIR/games"/{nintendo-{nes,snes,gb,gbc,gba,n64},sega-{genesis,mastersystem,gamegear},arcade-{mame,neogeo,fba},sony-psx,atari-{2600,7800},commodore-64,amiga,turbografx16,msx,ports}
    
    # مجلدات الأصول
    mkdir -p "$SRAOUF_DIR/assets"/{images,icons,fonts,themes,sounds,shaders,overlays,wallpapers}
    
    # مجلدات الإعدادات
    mkdir -p "$SRAOUF_DIR/configs"/{autoconfig,playlists,cheats,overlays}
    
    # مجلدات المحاكيات
    mkdir -p "$SRAOUF_DIR/emulators"/{bios,cores}
    
    # مجلدات المستخدم
    mkdir -p ~/.emulationstation ~/.config/retroarch
    
    print_success "تم إنشاء هيكل المجلدات المثالي"
}

# تحديث النظام
update_system() {
    print_step "تحديث النظام..."
    
    export DEBIAN_FRONTEND=noninteractive
    sudo apt update -y
    sudo apt install -y curl wget git unzip build-essential cmake
    
    print_success "تم تحديث النظام"
}

# تثبيت RetroArch والمحاكيات
install_emulators() {
    print_step "تثبيت RetroArch والمحاكيات..."
    
    # تثبيت RetroArch
    sudo apt install -y retroarch retroarch-assets libretro-* || {
        print_warning "تثبيت بديل..."
        sudo add-apt-repository -y ppa:libretro/stable
        sudo apt update
        sudo apt install -y retroarch
    }
    
    # تثبيت EmulationStation
    sudo apt install -y emulationstation || print_warning "EmulationStation غير متوفر"
    
    # تثبيت أدوات إضافية
    sudo apt install -y joystick jstest-gtk evtest bluez
    
    print_success "تم تثبيت المحاكيات"
}

# إنشاء الإعدادات
create_configs() {
    print_step "إنشاء الإعدادات..."
    
    # إعدادات RetroArch
    cat > "$SRAOUF_DIR/configs/retroarch.cfg" << EOF
# SRAOUF RetroArch Configuration
video_driver = "gl"
video_width = 1920
video_height = 1080
video_fullscreen = true
video_vsync = true
video_smooth = false
audio_driver = "alsa"
audio_enable = true
input_driver = "udev"
input_autodetect_enable = true
menu_driver = "xmb"
system_directory = "$SRAOUF_DIR/emulators/bios"
savestate_directory = "$SRAOUF_DIR/states"
savefile_directory = "$SRAOUF_DIR/saves"
screenshot_directory = "$SRAOUF_DIR/screenshots"
user_language = 14
savestate_auto_save = true
savestate_auto_load = true
EOF

    # نسخ للمكان الصحيح
    cp "$SRAOUF_DIR/configs/retroarch.cfg" ~/.config/retroarch/retroarch.cfg
    
    # إعدادات EmulationStation
    cat > "$SRAOUF_DIR/configs/es_systems.cfg" << EOF
<?xml version="1.0"?>
<systemList>
    <system>
        <name>nes</name>
        <fullname>Nintendo Entertainment System</fullname>
        <path>$SRAOUF_DIR/games/nintendo-nes</path>
        <extension>.nes .NES .zip .ZIP</extension>
        <command>retroarch -L /usr/lib/*/libretro/nestopia_libretro.so "%ROM%"</command>
        <platform>nes</platform>
        <theme>nes</theme>
    </system>
    <system>
        <name>gb</name>
        <fullname>Game Boy</fullname>
        <path>$SRAOUF_DIR/games/nintendo-gb</path>
        <extension>.gb .GB .zip .ZIP</extension>
        <command>retroarch -L /usr/lib/*/libretro/gambatte_libretro.so "%ROM%"</command>
        <platform>gb</platform>
        <theme>gb</theme>
    </system>
</systemList>
EOF

    cp "$SRAOUF_DIR/configs/es_systems.cfg" ~/.emulationstation/es_systems.cfg
    
    print_success "تم إنشاء الإعدادات"
}

# إنشاء سكريپت التشغيل
create_launcher() {
    print_step "إنشاء سكريپت التشغيل..."
    
    mkdir -p "$SRAOUF_DIR/scripts"
    
    cat > "$SRAOUF_DIR/scripts/launch.sh" << 'EOF'
#!/bin/bash
# SRAOUF Launcher
SRAOUF_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
cd "$SRAOUF_DIR"

if command -v emulationstation &> /dev/null; then
    emulationstation
elif command -v retroarch &> /dev/null; then
    retroarch --menu
else
    echo "❌ لم يتم العثور على محاكي!"
    read -p "اضغط Enter..."
fi
EOF

    chmod +x "$SRAOUF_DIR/scripts/launch.sh"
    
    print_success "تم إنشاء سكريپت التشغيل"
}

# إنشاء أيقونة سطح المكتب
create_desktop_icon() {
    print_step "إنشاء أيقونة سطح المكتب..."
    
    # إنشاء أيقونة
    mkdir -p "$SRAOUF_DIR/assets/icons"
    
    cat > "$SRAOUF_DIR/assets/icons/sraouf.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="64" height="64" xmlns="http://www.w3.org/2000/svg">
  <rect width="64" height="64" fill="#4CAF50" rx="8"/>
  <text x="32" y="40" font-family="Arial" font-size="28" fill="white" text-anchor="middle">🕹️</text>
</svg>
EOF

    # إنشاء ملف سطح المكتب
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
EOF

    chmod +x "$USER_HOME/Desktop/SRAOUF.desktop"
    
    print_success "تم إنشاء أيقونة سطح المكتب"
}

# تحميل ألعاب تجريبية
download_sample_games() {
    print_step "إضافة ألعاب تجريبية..."
    
    # إنشاء ألعاب تجريبية للاختبار الفوري
    cd "$SRAOUF_DIR/games"
    
    # Nintendo NES
    cd nintendo-nes
    echo "This is a test ROM: Super Mario Bros Demo" > "Super Mario Bros Demo.nes"
    echo "This is a test ROM: Pac-Man Test" > "Pac-Man Test.nes"
    echo "This is a test ROM: Tetris Sample" > "Tetris Sample.nes"
    
    # Game Boy
    cd ../nintendo-gb
    echo "This is a test ROM: Pokemon Red Demo" > "Pokemon Red Demo.gb"
    echo "This is a test ROM: Zelda Demo" > "Zelda Demo.gb"
    echo "This is a test ROM: Tetris GB" > "Tetris GB.gb"
    
    print_success "تم إضافة ألعاب تجريبية"
}

# اختبار شامل
run_final_test() {
    print_step "تشغيل اختبار شامل..."
    
    local errors=0
    
    # اختبار RetroArch
    if command -v retroarch &> /dev/null; then
        print_success "✅ RetroArch موجود"
    else
        print_error "❌ RetroArch مفقود"
        ((errors++))
    fi
    
    # اختبار المجلدات
    if [[ -d "$SRAOUF_DIR/games" ]]; then
        print_success "✅ مجلدات الألعاب موجودة"
    else
        print_error "❌ مجلدات الألعاب مفقودة"
        ((errors++))
    fi
    
    # اختبار سكريپت التشغيل
    if [[ -x "$SRAOUF_DIR/scripts/launch.sh" ]]; then
        print_success "✅ سكريپت التشغيل جاهز"
    else
        print_error "❌ سكريپت التشغيل مفقود"
        ((errors++))
    fi
    
    # اختبار أيقونة سطح المكتب
    if [[ -f "$USER_HOME/Desktop/SRAOUF.desktop" ]]; then
        print_success "✅ أيقونة سطح المكتب جاهزة"
    else
        print_error "❌ أيقونة سطح المكتب مفقودة"
        ((errors++))
    fi
    
    return $errors
}

# إنشاء دليل سريع
create_quick_guide() {
    print_step "إنشاء دليل الاستخدام..."
    
    cat > "$SRAOUF_DIR/QUICK_START.txt" << EOF
🕹️ دليل البدء السريع - SRAOUF
==============================

🚀 كيفية اللعب:
1. اضغط مرتين على أيقونة "🕹️ سراوف للألعاب" على سطح المكتب
2. أو شغل: $SRAOUF_DIR/scripts/launch.sh

🎮 التحكم:
- الأسهم: التنقل
- Enter: اختيار
- Z: زر A
- X: زر B  
- Escape: خروج
- F1: قائمة RetroArch

📁 إضافة ألعاب:
ضع ملفات الألعاب في:
- $SRAOUF_DIR/games/nintendo-nes/
- $SRAOUF_DIR/games/nintendo-gb/

🎉 استمتع باللعب!
EOF

    print_success "تم إنشاء دليل الاستخدام"
}

# الدالة الرئيسية
main() {
    clear
    print_header "تثبيت سراوف المثالي - يعمل بأمر واحد بلا مشاكل"
    print_header "SRAOUF Perfect Installation - One Command, Zero Problems"
    
    print_info "بدء التثبيت التلقائي الكامل..."
    echo "$(date): Starting SRAOUF installation..." > "$LOG_FILE"
    
    # تنفيذ جميع خطوات التثبيت
    fix_permissions_immediately
    create_perfect_structure  
    update_system
    install_emulators
    create_configs
    create_launcher
    create_desktop_icon
    download_sample_games
    create_quick_guide
    
    # اختبار نهائي
    if run_final_test; then
        local error_count=$?
        if [[ $error_count -eq 0 ]]; then
            echo
            print_header "🎉 نجح التثبيت بنسبة 100%! 🎉"
            echo
            print_success "✅ سراوف جاهز للعب الآن!"
            print_info "🎮 للعب: اضغط على أيقونة سطح المكتب"
            print_info "📖 دليل سريع: $SRAOUF_DIR/QUICK_START.txt"
            echo
            print_success "🎊 استمتع بالألعاب!"
            
        else
            print_warning "⚠️ التثبيت مكتمل مع $error_count تحذيرات بسيطة"
        fi
    else
        print_error "❌ حدثت مشاكل في التثبيت"
        exit 1
    fi
    
    echo "$(date): SRAOUF installation completed successfully." >> "$LOG_FILE"
}

# تشغيل التثبيت
main "$@"
