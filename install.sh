#!/bin/bash

# SRAOUF Retro Gaming Installation Script
# محاكي الألعاب الكلاسيكية - سكريبت التثبيت
# المؤلف: محمد علي
# الإصدار: 1.0

set -e

# ألوان النص
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# متغيرات المشروع
PROJECT_NAME="SRAOUF Retro Gaming"
PROJECT_DIR="$HOME/SRAOUF"
LOG_FILE="$PROJECT_DIR/install.log"

# دالة طباعة الرسائل الملونة
print_message() {
    echo -e "${CYAN}[SRAOUF]${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# دالة التحقق من نظام التشغيل
check_system() {
    print_message "فحص نظام التشغيل..."
    
    if [[ ! -f /etc/os-release ]]; then
        print_error "نظام تشغيل غير مدعوم"
        exit 1
    fi
    
    source /etc/os-release
    
    if [[ "$ID" != "raspbian" ]] && [[ "$ID" != "debian" ]] && [[ "$ID" != "ubuntu" ]]; then
        print_warning "نظام التشغيل قد لا يكون مدعوماً بالكامل: $PRETTY_NAME"
    else
        print_success "نظام التشغيل مدعوم: $PRETTY_NAME"
    fi
    
    # التحقق من معمارية المعالج
    ARCH=$(uname -m)
    if [[ "$ARCH" != "armv7l" ]] && [[ "$ARCH" != "aarch64" ]] && [[ "$ARCH" != "x86_64" ]]; then
        print_error "معمارية المعالج غير مدعومة: $ARCH"
        exit 1
    fi
    
    print_success "معمارية المعالج مدعومة: $ARCH"
}

# دالة التحقق من المتطلبات
check_requirements() {
    print_message "فحص متطلبات النظام..."
    
    # التحقق من الذاكرة
    TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.0f", $2}')
    if [[ $TOTAL_MEM -lt 1024 ]]; then
        print_warning "الذاكرة المتاحة أقل من المطلوب (1GB). المتاح: ${TOTAL_MEM}MB"
    else
        print_success "الذاكرة المتاحة كافية: ${TOTAL_MEM}MB"
    fi
    
    # التحقق من مساحة التخزين
    AVAILABLE_SPACE=$(df -BG "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')
    if [[ $AVAILABLE_SPACE -lt 8 ]]; then
        print_error "مساحة تخزين غير كافية. المطلوب: 8GB، المتاح: ${AVAILABLE_SPACE}GB"
        exit 1
    else
        print_success "مساحة التخزين كافية: ${AVAILABLE_SPACE}GB"
    fi
    
    # التحقق من الاتصال بالإنترنت
    if ! ping -c 1 google.com &> /dev/null; then
        print_error "لا يوجد اتصال بالإنترنت"
        exit 1
    else
        print_success "الاتصال بالإنترنت متوفر"
    fi
}

# دالة إنشاء المجلدات
create_directories() {
    print_message "إنشاء هيكل المجلدات..."
    
    # إنشاء المجلدات الرئيسية
    mkdir -p "$PROJECT_DIR"/{games,emulators,configs,assets,scripts,logs,saves,states,themes,sounds}
    
    # إنشاء مجلدات الألعاب لكل نظام
    mkdir -p "$PROJECT_DIR/games"/{nintendo-nes,nintendo-snes,nintendo-gb,nintendo-gbc,nintendo-gba}
    mkdir -p "$PROJECT_DIR/games"/{sega-genesis,sega-mastersystem,sega-gamegear}
    mkdir -p "$PROJECT_DIR/games"/{arcade-mame,arcade-fba,arcade-neogeo}
    mkdir -p "$PROJECT_DIR/games"/{sony-psx,atari-2600,atari-7800}
    mkdir -p "$PROJECT_DIR/games"/{commodore-64,amiga,turbografx16,msx}
    
    # إنشاء مجلدات الأصول
    mkdir -p "$PROJECT_DIR/assets"/{images,videos,music,fonts,icons}
    mkdir -p "$PROJECT_DIR/themes"/{classic,modern,retro,dark}
    mkdir -p "$PROJECT_DIR/sounds"/{effects,music,voices}
    
    print_success "تم إنشاء هيكل المجلدات"
}

# دالة تحديث النظام
update_system() {
    print_message "تحديث النظام..."
    
    sudo apt update
    sudo apt upgrade -y
    
    print_success "تم تحديث النظام"
}

# دالة تثبيت الحزم الأساسية
install_basic_packages() {
    print_message "تثبيت الحزم الأساسية..."
    
    sudo apt install -y \
        git \
        curl \
        wget \
        unzip \
        build-essential \
        cmake \
        python3 \
        python3-pip \
        libsdl2-dev \
        libsdl2-image-dev \
        libsdl2-mixer-dev \
        libsdl2-ttf-dev \
        libopenal-dev \
        libfreetype6-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libasound2-dev \
        libpulse-dev \
        libudev-dev \
        libxkbcommon-dev \
        libdrm-dev \
        libxkbcommon-x11-dev \
        fontconfig
    
    print_success "تم تثبيت الحزم الأساسية"
}

# دالة تثبيت RetroArch
install_retroarch() {
    print_message "تثبيت RetroArch..."
    
    cd "$PROJECT_DIR/emulators"
    
    # تحميل RetroArch
    if [[ ! -d "RetroArch" ]]; then
        git clone https://github.com/libretro/RetroArch.git
    fi
    
    cd RetroArch
    
    # بناء RetroArch
    ./configure --enable-neon --enable-floathard --enable-gles --enable-kms --enable-udev
    make -j$(nproc)
    sudo make install
    
    print_success "تم تثبيت RetroArch"
}

# دالة تثبيت المحاكيات الأساسية
install_cores() {
    print_message "تثبيت نوى المحاكيات..."
    
    cd "$PROJECT_DIR/emulators"
    
    # قائمة المحاكيات المطلوبة
    cores=(
        "https://github.com/libretro/nestopia.git nestopia"
        "https://github.com/libretro/snes9x.git snes9x"
        "https://github.com/libretro/gambatte-libretro.git gambatte"
        "https://github.com/libretro/Genesis-Plus-GX.git genesis_plus_gx"
        "https://github.com/libretro/mame.git mame"
        "https://github.com/libretro/pcsx_rearmed.git pcsx_rearmed"
        "https://github.com/libretro/stella.git stella"
        "https://github.com/libretro/vice-libretro.git vice"
    )
    
    for core in "${cores[@]}"; do
        repo_url=$(echo $core | cut -d' ' -f1)
        core_name=$(echo $core | cut -d' ' -f2)
        
        print_info "تثبيت محاكي: $core_name"
        
        if [[ ! -d "$core_name" ]]; then
            git clone "$repo_url" "$core_name"
        fi
        
        cd "$core_name"
        make -j$(nproc)
        sudo make install
        cd ..
    done
    
    print_success "تم تثبيت نوى المحاكيات"
}

# دالة تثبيت EmulationStation
install_emulationstation() {
    print_message "تثبيت EmulationStation..."
    
    cd "$PROJECT_DIR/emulators"
    
    if [[ ! -d "EmulationStation" ]]; then
        git clone https://github.com/RetroPie/EmulationStation.git
    fi
    
    cd EmulationStation
    
    # تثبيت المتطلبات
    sudo apt install -y libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev rapidjson-dev libasound2-dev libgl1-mesa-dev help2man libeigen3-dev libsm-dev
    
    # بناء EmulationStation
    mkdir -p build
    cd build
    cmake ..
    make -j$(nproc)
    sudo make install
    
    print_success "تم تثبيت EmulationStation"
}

# دالة تحميل الألعاب المجانية
download_free_games() {
    print_message "تحميل الألعاب المجانية..."
    
    cd "$PROJECT_DIR/games"
    
    # إنشاء ملف قائمة الألعاب
    cat > free_games_list.txt << 'EOF'
# Nintendo NES Games (Homebrew/Public Domain)
nintendo-nes/Battle Kid - Fortress of Peril.nes|https://www.romhacking.net/homebrew/58/
nintendo-nes/Blade Buster.nes|https://www.romhacking.net/homebrew/34/
nintendo-nes/Concentration Room.nes|https://www.romhacking.net/homebrew/67/

# Sega Genesis Games (Homebrew)
sega-genesis/Cave Story MD.bin|https://github.com/andwn/cave-story-md/releases/
sega-genesis/Tanzer.bin|https://github.com/moon-watcher/tanzer/releases/
sega-genesis/OpenLara.bin|https://github.com/XProger/OpenLara/releases/

# Game Boy Games (Homebrew)
nintendo-gb/Infinity.gb|https://github.com/infinity-gbc/infinity/releases/
nintendo-gb/Deadeus.gb|https://izma.itch.io/deadeus
nintendo-gb/Dangan.gb|https://snorpung.itch.io/dangan-gb

# Arcade Games (Open Source)
arcade-mame/xevious.zip|https://archive.org/details/MAME_0.149_ROMs_merged
arcade-mame/galaga.zip|https://archive.org/details/MAME_0.149_ROMs_merged
arcade-mame/pacman.zip|https://archive.org/details/MAME_0.149_ROMs_merged
EOF
    
    print_info "قائمة الألعاب المجانية تم إنشاؤها"
    print_warning "لتحميل الألعاب، استخدم: $PROJECT_DIR/scripts/download_games.sh"
    
    print_success "تم إعداد قائمة الألعاب المجانية"
}

# دالة إنشاء الإعدادات
create_configs() {
    print_message "إنشاء ملفات الإعدادات..."
    
    # إعدادات RetroArch
    cat > "$PROJECT_DIR/configs/retroarch.cfg" << 'EOF'
# SRAOUF RetroArch Configuration
# إعدادات ريترو آرش لسراوف

# Video Settings
video_driver = "gl"
video_width = 1920
video_height = 1080
video_fullscreen = true
video_vsync = true
video_smooth = false
video_scale_integer = false

# Audio Settings
audio_driver = "alsa"
audio_enable = true
audio_out_rate = 48000
audio_latency = 64

# Input Settings
input_driver = "udev"
input_joypad_driver = "udev"
input_autodetect_enable = true

# Menu Settings
menu_driver = "xmb"
menu_wallpaper = "/home/pi/SRAOUF/assets/images/background.png"
menu_core_enable = true
menu_dynamic_wallpaper_enable = true

# Directory Settings
system_directory = "/home/pi/SRAOUF/emulators/bios"
savestate_directory = "/home/pi/SRAOUF/states"
savefile_directory = "/home/pi/SRAOUF/saves"
screenshot_directory = "/home/pi/SRAOUF/screenshots"

# Performance Settings
rewind_enable = true
savestate_auto_save = true
savestate_auto_load = true
fastforward_ratio = 4.0

# Language
user_language = 14
EOF

    # إعدادات EmulationStation
    mkdir -p "$HOME/.emulationstation"
    cat > "$HOME/.emulationstation/es_settings.cfg" << 'EOF'
<?xml version="1.0"?>
<bool name="BackgroundJoystickInput" value="false" />
<bool name="CaptionsCompatibility" value="true" />
<bool name="CollectionShowSystemInfo" value="true" />
<bool name="DrawFramerate" value="false" />
<bool name="EnableSounds" value="true" />
<bool name="LocalArt" value="false" />
<bool name="MoveCarousel" value="true" />
<bool name="ParseGamelistOnly" value="false" />
<bool name="QuickSystemSelect" value="true" />
<bool name="SaveGamelistsOnExit" value="true" />
<bool name="ScrapeRatings" value="true" />
<bool name="ScreenSaverControls" value="true" />
<bool name="ScreenSaverOmxPlayer" value="false" />
<bool name="ShowHelpPrompts" value="true" />
<bool name="ShowHidden" value="false" />
<bool name="SlideshowScreenSaverCustomImageSource" value="false" />
<bool name="SlideshowScreenSaverRecurse" value="false" />
<bool name="SortAllSystems" value="false" />
<bool name="StretchVideoOn" value="false" />
<bool name="UseOSK" value="true" />
<bool name="VirtualKeyboard" value="true" />
<bool name="Windowed" value="false" />
<int name="ScreenSaverTime" value="300000" />
<int name="ScraperResizeHeight" value="0" />
<int name="ScraperResizeWidth" value="400" />
<string name="AudioDevice" value="PCM" />
<string name="CollectionSystemsAuto" value="favorites,recent" />
<string name="CollectionSystemsCustom" value="" />
<string name="GameTransitionStyle" value="auto" />
<string name="GamelistViewStyle" value="automatic" />
<string name="Language" value="ar" />
<string name="PowerSaverMode" value="disabled" />
<string name="Scraper" value="ScreenScraper" />
<string name="ScreenSaverBehavior" value="random video" />
<string name="ScreenSaverGameInfo" value="never" />
<string name="StartupSystem" value="" />
<string name="ThemeSet" value="carbon" />
<string name="TransitionStyle" value="auto" />
<string name="UIMode" value="Full" />
<string name="UIMode_passkey" value="uuddlrlrba" />
EOF

    print_success "تم إنشاء ملفات الإعدادات"
}

# دالة إنشاء أيقونة سطح المكتب
create_desktop_icon() {
    print_message "إنشاء أيقونة سطح المكتب..."
    
    cat > "$HOME/Desktop/SRAOUF.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=🕹️ سراوف للألعاب
Name[en]=🕹️ SRAOUF Gaming
Comment=محاكي الألعاب الكلاسيكية
Comment[en]=Retro Gaming Emulator
Icon=$PROJECT_DIR/assets/icons/sraouf.png
Exec=$PROJECT_DIR/scripts/launch.sh
Terminal=false
Categories=Game;
StartupNotify=true
EOF

    chmod +x "$HOME/Desktop/SRAOUF.desktop"
    
    print_success "تم إنشاء أيقونة سطح المكتب"
}

# دالة تثبيت الخطوط العربية
install_arabic_fonts() {
    print_message "تثبيت الخطوط العربية..."
    
    sudo apt install -y fonts-noto-cjk fonts-noto-color-emoji fonts-liberation
    
    # تحميل خطوط عربية إضافية
    mkdir -p "$PROJECT_DIR/assets/fonts"
    cd "$PROJECT_DIR/assets/fonts"
    
    # خط أميري
    wget -O amiri.zip "https://github.com/aliftype/amiri/releases/latest/download/Amiri.zip"
    unzip -o amiri.zip
    
    # خط نوتو العربي
    wget -O noto-arabic.zip "https://fonts.google.com/download?family=Noto%20Sans%20Arabic"
    unzip -o noto-arabic.zip
    
    # تثبيت الخطوط في النظام
    sudo cp *.ttf /usr/share/fonts/truetype/
    sudo fc-cache -fv
    
    print_success "تم تثبيت الخطوط العربية"
}

# دالة إنشاء السكريبتات المساعدة
create_helper_scripts() {
    print_message "إنشاء السكريبتات المساعدة..."
    
    # سكريبت التشغيل الرئيسي
    cat > "$PROJECT_DIR/scripts/launch.sh" << 'EOF'
#!/bin/bash
# SRAOUF Launch Script

SRAOUF_DIR="$HOME/SRAOUF"
LOG_FILE="$SRAOUF_DIR/logs/launch.log"

# إنشاء ملف اللوج
mkdir -p "$SRAOUF_DIR/logs"
echo "$(date): Starting SRAOUF Gaming..." >> "$LOG_FILE"

# التحقق من وجود EmulationStation
if command -v emulationstation &> /dev/null; then
    cd "$SRAOUF_DIR"
    emulationstation --windowed --debug --home "$SRAOUF_DIR"
else
    # إذا لم يتم العثور على EmulationStation، تشغيل RetroArch
    retroarch --config "$SRAOUF_DIR/configs/retroarch.cfg"
fi

echo "$(date): SRAOUF Gaming stopped." >> "$LOG_FILE"
EOF

    # سكريبت فحص الألعاب
    cat > "$PROJECT_DIR/scripts/scan_games.sh" << 'EOF'
#!/bin/bash
# Game Scanner Script

SRAOUF_DIR="$HOME/SRAOUF"
GAMES_DIR="$SRAOUF_DIR/games"

echo "Scanning for games..."

# فحص كل مجلد من مجلدات الألعاب
for system_dir in "$GAMES_DIR"/*; do
    if [[ -d "$system_dir" ]]; then
        system_name=$(basename "$system_dir")
        game_count=$(find "$system_dir" -type f \( -name "*.nes" -o -name "*.sfc" -o -name "*.gb" -o -name "*.gbc" -o -name "*.gba" -o -name "*.bin" -o -name "*.zip" -o -name "*.iso" \) | wc -l)
        echo "$system_name: $game_count games found"
    fi
done

# تحديث قاعدة بيانات EmulationStation
if command -v emulationstation &> /dev/null; then
    emulationstation --force-update-gamelist
fi

echo "Game scan completed."
EOF

    # سكريبت إعداد أذرع التحكم
    cat > "$PROJECT_DIR/scripts/setup_controller.sh" << 'EOF'
#!/bin/bash
# Controller Setup Script

echo "Setting up game controllers..."

# التحقق من أذرع التحكم المتصلة
echo "Connected controllers:"
ls /dev/input/js* 2>/dev/null || echo "No joysticks detected"

# إعداد أذرع PS4/PS5
if lsusb | grep -i sony &> /dev/null; then
    echo "Sony controller detected"
    sudo modprobe hid_sony
fi

# إعداد أذرع Xbox
if lsusb | grep -i microsoft &> /dev/null; then
    echo "Xbox controller detected"
    sudo modprobe xpad
fi

# اختبار الإدخال
echo "Testing input devices..."
for js in /dev/input/js*; do
    if [[ -e "$js" ]]; then
        echo "Testing $js..."
        timeout 3s jstest "$js" --event || echo "Could not test $js"
    fi
done

echo "Controller setup completed."
EOF

    # سكريبت إعداد الصوت
    cat > "$PROJECT_DIR/scripts/audio_setup.sh" << 'EOF'
#!/bin/bash
# Audio Setup Script

echo "Setting up audio..."

# تعيين مستوى الصوت الافتراضي
amixer set Master 80%
amixer set PCM 80%

# إعداد ALSA
if [[ ! -f "$HOME/.asoundrc" ]]; then
    cat > "$HOME/.asoundrc" << 'ALSAEOF'
pcm.!default {
    type hw
    card 0
}
ctl.!default {
    type hw
    card 0
}
ALSAEOF
fi

# اختبار الصوت
echo "Testing audio..."
speaker-test -t sine -f 1000 -l 1 &
sleep 2
killall speaker-test 2>/dev/null

echo "Audio setup completed."
EOF

    # سكريبت التحديث
    cat > "$PROJECT_DIR/scripts/update.sh" << 'EOF'
#!/bin/bash
# Update Script

SRAOUF_DIR="$HOME/SRAOUF"
cd "$SRAOUF_DIR"

echo "Updating SRAOUF..."

# تحديث المشروع من Git
git pull origin main

# تحديث RetroArch
if [[ -d "emulators/RetroArch" ]]; then
    cd "emulators/RetroArch"
    git pull
    make clean
    make -j$(nproc)
    sudo make install
    cd "$SRAOUF_DIR"
fi

# تحديث المحاكيات
echo "Updating cores..."
./scripts/update_cores.sh

echo "Update completed."
EOF

    # منح صلاحيات التنفيذ لجميع السكريبتات
    chmod +x "$PROJECT_DIR"/scripts/*.sh
    
    print_success "تم إنشاء السكريپتات المساعدة"
}

# دالة إنشاء ملفات النظام
create_system_files() {
    print_message "إنشاء ملفات النظام..."
    
    # ملف es_systems.cfg
    mkdir -p "$HOME/.emulationstation"
    cat > "$HOME/.emulationstation/es_systems.cfg" << 'EOF'
<?xml version="1.0"?>
<systemList>
    <system>
        <name>nes</name>
        <fullname>Nintendo Entertainment System</fullname>
        <path>/home/pi/SRAOUF/games/nintendo-nes</path>
        <extension>.nes .NES .zip .ZIP</extension>
        <command>retroarch -L /usr/local/lib/libretro/nestopia_libretro.so "%ROM%"</command>
        <platform>nes</platform>
        <theme>nes</theme>
    </system>
    
    <system>
        <name>snes</name>
        <fullname>Super Nintendo Entertainment System</fullname>
        <path>/home/pi/SRAOUF/games/nintendo-snes</path>
        <extension>.smc .sfc .SMC .SFC .zip .ZIP</extension>
        <command>retroarch -L /usr/local/lib/libretro/snes9x_libretro.so "%ROM%"</command>
        <platform>snes</platform>
        <theme>snes</theme>
    </system>
    
    <system>
        <name>gb</name>
        <fullname>Game Boy</fullname>
        <path>/home/pi/SRAOUF/games/nintendo-gb</path>
        <extension>.gb .GB .zip .ZIP</extension>
        <command>retroarch -L /usr/local/lib/libretro/gambatte_libretro.so "%ROM%"</command>
        <platform>gb</platform>
        <theme>gb</theme>
    </system>
    
    <system>
        <name>genesis</name>
        <fullname>Sega Genesis</fullname>
        <path>/home/pi/SRAOUF/games/sega-genesis</path>
        <extension>.smd .SMD .bin .BIN .gen .GEN .zip .ZIP</extension>
        <command>retroarch -L /usr/local/lib/libretro/genesis_plus_gx_libretro.so "%ROM%"</command>
        <platform>genesis</platform>
        <theme>genesis</theme>
    </system>
    
    <system>
        <name>arcade</name>
        <fullname>Arcade</fullname>
        <path>/home/pi/SRAOUF/games/arcade-mame</path>
        <extension>.zip .ZIP</extension>
        <command>retroarch -L /usr/local/lib/libretro/mame_libretro.so "%ROM%"</command>
        <platform>arcade</platform>
        <theme>arcade</theme>
    </system>
</systemList>
EOF

    print_success "تم إنشاء ملفات النظام"
}

# دالة التنظيف النهائي
final_cleanup() {
    print_message "تنظيف الملفات المؤقتة..."
    
    # تنظيف ملفات البناء المؤقتة
    cd "$PROJECT_DIR"
    find . -name "*.o" -delete
    find . -name "*.tmp" -delete
    find . -name "*.log" -delete 2>/dev/null || true
    
    # تحديث قاعدة بيانات الخطوط
    sudo fc-cache -fv
    
    # إنشاء ملف معلومات التثبيت
    cat > "$PROJECT_DIR/install_info.txt" << EOF
SRAOUF Retro Gaming Installation Information
تاريخ التثبيت: $(date)
نسخة المشروع: 1.0
نظام التشغيل: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
معمارية المعالج: $(uname -m)
إجمالي الذاكرة: $(free -h | awk 'NR==2{print $2}')
مساحة التخزين المستخدمة: $(du -sh $PROJECT_DIR | cut -f1)

المجلدات المهمة:
- الألعاب: $PROJECT_DIR/games
- المحاكيات: $PROJECT_DIR/emulators  
- الإعدادات: $PROJECT_DIR/configs
- السكريپتات: $PROJECT_DIR/scripts

للحصول على المساعدة، راجع ملف README.md
EOF
    
    print_success "تم التنظيف النهائي"
}

# الدالة الرئيسية
main() {
    clear
    echo -e "${PURPLE}"
    echo "🕹️ ================================== 🕹️"
    echo "    مرحباً بك في تثبيت سراوف للألعاب    "
    echo "        SRAOUF Retro Gaming Installer        "
    echo "🕹️ ================================== 🕹️"
    echo -e "${NC}"
    echo
    
    print_message "بدء عملية التثبيت..."
    echo "هذه العملية ستستغرق 10-15 دقيقة"
    echo
    
    # إنشاء ملف اللوج
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "$(date): Starting SRAOUF installation..." > "$LOG_FILE"
    
    # تنفيذ خطوات التثبيت
    check_system | tee -a "$LOG_FILE"
    check_requirements | tee -a "$LOG_FILE"
    create_directories | tee -a "$LOG_FILE"
    update_system | tee -a "$LOG_FILE"
    install_basic_packages | tee -a "$LOG_FILE"
    install_arabic_fonts | tee -a "$LOG_FILE"
    install_retroarch | tee -a "$LOG_FILE"
    install_cores | tee -a "$LOG_FILE"
    install_emulationstation | tee -a "$LOG_FILE"
    download_free_games | tee -a "$LOG_FILE"
    create_configs | tee -a "$LOG_FILE"
    create_system_files | tee -a "$LOG_FILE"
    create_helper_scripts | tee -a "$LOG_FILE"
    create_desktop_icon | tee -a "$LOG_FILE"
    final_cleanup | tee -a "$LOG_FILE"
    
    echo
    echo -e "${GREEN}"
    echo "🎉 ================================== 🎉"
    echo "        تم تثبيت سراوف بنجاح!          "
    echo "    SRAOUF Installation Completed!     "
    echo "🎉 ================================== 🎉"
    echo -e "${NC}"
    echo
    print_success "التثبيت مكتمل!"
    print_info "ستجد أيقونة '🕹️ سراوف للألعاب' على سطح المكتب"
    print_info "أو يمكنك تشغيل: $PROJECT_DIR/scripts/launch.sh"
    echo
    print_warning "يُنصح بإعادة تشغيل النظام الآن: sudo reboot"
    
    echo "$(date): SRAOUF installation completed successfully." >> "$LOG_FILE"
}

# التحقق من كون السكريبت يعمل كمدير
if [[ $EUID -eq 0 ]]; then
    print_error "لا تشغل هذا السكريپت كمدير (root)"
    print_info "استخدم: ./install.sh (بدون sudo)"
    exit 1
fi

# تشغيل الدالة الرئيسية
main "$@"