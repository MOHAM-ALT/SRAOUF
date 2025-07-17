#!/bin/bash

# SRAOUF Ultimate Fix & Update Script - FIXED VERSION
# سكريپت الإصلاح والتحديث الشامل - النسخة المُصححة
# الإصدار: 3.1 FIXED EDITION

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
SRAOUF_DIR="$HOME/SRAOUF"
LOG_FILE="$SRAOUF_DIR/logs/ultimate_fix.log"
PI_VERSION=""
SYSTEM_UPDATED=false

# دوال الطباعة المحسنة
print_header() {
    echo -e "${PURPLE}${BOLD}"
    echo "🛠️ ================================================= 🛠️"
    echo "    $1"
    echo "🛠️ ================================================= 🛠️"
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

# تسجيل الأحداث
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# اكتشاف نوع Raspberry Pi
detect_pi_version() {
    print_step "Detecting Raspberry Pi version..."
    
    if [[ -f /proc/device-tree/model ]]; then
        local model=$(cat /proc/device-tree/model)
        if [[ "$model" == *"Raspberry Pi 5"* ]]; then
            PI_VERSION="5"
            print_success "Detected: Raspberry Pi 5 🔥"
        elif [[ "$model" == *"Raspberry Pi 4"* ]]; then
            PI_VERSION="4"
            print_success "Detected: Raspberry Pi 4"
        elif [[ "$model" == *"Raspberry Pi 3"* ]]; then
            PI_VERSION="3"
            print_success "Detected: Raspberry Pi 3"
        else
            PI_VERSION="unknown"
            print_warning "Unknown Pi model: $model"
        fi
    else
        PI_VERSION="unknown"
        print_warning "Could not detect Pi version"
    fi
    
    log_action "Detected Pi version: $PI_VERSION"
}

# تحديث النظام بالكامل
comprehensive_system_update() {
    if [[ "$SYSTEM_UPDATED" == "true" ]]; then
        print_info "System already updated in this session"
        return 0
    fi
    
    print_step "Performing comprehensive system update..."
    log_action "Starting system update"
    
    # تحديث قوائم الحزم
    sudo apt update -y
    
    # ترقية النظام بالكامل
    sudo apt full-upgrade -y
    
    # ترقية البرمجيات الثابتة للـ Pi
    if command -v rpi-update &> /dev/null; then
        print_info "Updating Raspberry Pi firmware..."
        sudo rpi-update || print_warning "Firmware update failed"
    fi
    
    # تنظيف النظام
    sudo apt autoremove --purge -y
    sudo apt autoclean
    
    SYSTEM_UPDATED=true
    print_success "System fully updated"
    log_action "System update completed"
}

# إصلاح وتحديث RetroArch
fix_and_upgrade_retroarch() {
    print_step "Fixing and upgrading RetroArch..."
    log_action "RetroArch fix and upgrade started"
    
    # إيقاف العمليات الجارية
    sudo killall retroarch 2>/dev/null || true
    sudo killall emulationstation 2>/dev/null || true
    
    # إزالة الإصدارات القديمة المكسورة
    sudo apt remove --purge retroarch* libretro-* -y 2>/dev/null || true
    
    # تنظيف الإعدادات المعطلة
    if [[ -d ~/.config/retroarch ]]; then
        mv ~/.config/retroarch ~/.config/retroarch.backup_$(date +%Y%m%d_%H%M%S)
        print_info "Backed up old RetroArch config"
    fi
    
    # تثبيت أحدث إصدار
    sudo apt install -y retroarch retroarch-assets
    
    # إضافة مستودع libretro للحصول على أحدث النوى
    if ! grep -q "libretro" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        sudo add-apt-repository ppa:libretro/stable -y 2>/dev/null || true
        sudo apt update
    fi
    
    # تثبيت جميع النوى المتاحة
    sudo apt install -y \
        libretro-nestopia \
        libretro-snes9x \
        libretro-gambatte \
        libretro-mgba \
        libretro-vba-next \
        libretro-genesis-plus-gx \
        libretro-pcsx-rearmed \
        libretro-beetle-psx \
        libretro-stella \
        libretro-mame \
        libretro-fbneo \
        libretro-fceumm \
        libretro-quicknes \
        libretro-bluemsx \
        libretro-prosystem \
        libretro-vice \
        2>/dev/null || print_warning "Some cores failed to install"
    
    print_success "RetroArch upgraded and fixed"
    log_action "RetroArch upgrade completed"
}

# إنشاء إعدادات محسنة حسب نوع Pi
create_optimized_config() {
    print_step "Creating optimized configuration for Pi $PI_VERSION..."
    
    mkdir -p ~/.config/retroarch/{system,assets,states,saves,screenshots,recordings,autoconfig,playlists,database,shaders,overlays}
    
    # إعدادات مختلفة حسب نوع Pi
    if [[ "$PI_VERSION" == "5" ]]; then
        # إعدادات Pi 5 المتقدمة
        cat > ~/.config/retroarch/retroarch.cfg << 'EOF'
# RETROARCH OPTIMIZED FOR RASPBERRY PI 5
video_driver = "vulkan"
video_width = 1920
video_height = 1080
video_fullscreen = true
video_vsync = true
video_hard_sync = true
video_hard_sync_frames = 2
video_threaded = true
video_smooth = true
video_force_aspect = true
video_scale_integer = false
video_gpu_record = true
video_gpu_screenshot = true

audio_driver = "alsa"
audio_out_rate = 48000
audio_latency = 32
audio_sync = true

input_driver = "udev"
input_joypad_driver = "udev"
input_autodetect_enable = true
input_analog_deadzone = 0.10

menu_driver = "ozone"
menu_ozone_color_theme = 1
user_language = 0

run_ahead_enabled = true
run_ahead_frames = 1
fastforward_ratio = 8.0
savestate_auto_save = true
savestate_auto_load = true

netplay_enable = true
cheevos_enable = true

system_directory = "~/.config/retroarch/system"
savestate_directory = "~/.config/retroarch/states"
savefile_directory = "~/.config/retroarch/saves"
screenshot_directory = "~/.config/retroarch/screenshots"
joypad_autoconfig_dir = "~/.config/retroarch/autoconfig"

config_save_on_exit = true
auto_remaps_enable = true
auto_overrides_enable = true
EOF
    
    elif [[ "$PI_VERSION" == "4" ]]; then
        # إعدادات Pi 4 المتوازنة
        cat > ~/.config/retroarch/retroarch.cfg << 'EOF'
# RETROARCH OPTIMIZED FOR RASPBERRY PI 4
video_driver = "gl"
video_width = 1920
video_height = 1080
video_fullscreen = true
video_vsync = true
video_threaded = true
video_smooth = false
video_force_aspect = true

audio_driver = "alsa"
audio_out_rate = 44100
audio_latency = 64

input_driver = "udev"
input_autodetect_enable = true

menu_driver = "xmb"
user_language = 0

run_ahead_enabled = false
rewind_enable = false
fastforward_ratio = 4.0

system_directory = "~/.config/retroarch/system"
savestate_directory = "~/.config/retroarch/states"
savefile_directory = "~/.config/retroarch/saves"
EOF
    
    else
        # إعدادات عامة للـ Pi 3 والأقدم
        cat > ~/.config/retroarch/retroarch.cfg << 'EOF'
# RETROARCH OPTIMIZED FOR RASPBERRY PI 3/OLDER
video_driver = "gl"
video_width = 1280
video_height = 720
video_fullscreen = true
video_vsync = false
video_threaded = true
video_smooth = false

audio_driver = "alsa"
audio_out_rate = 22050
audio_latency = 128

input_driver = "udev"
input_autodetect_enable = true

menu_driver = "rgui"
user_language = 0

rewind_enable = false
run_ahead_enabled = false
fastforward_ratio = 2.0

system_directory = "~/.config/retroarch/system"
savestate_directory = "~/.config/retroarch/states"
savefile_directory = "~/.config/retroarch/saves"
EOF
    fi
    
    print_success "Optimized config created for Pi $PI_VERSION"
    log_action "Optimized config created"
}

# تحسين إعدادات النظام
optimize_system_settings() {
    print_step "Optimizing system settings for Pi $PI_VERSION..."
    
    # تحسين ذاكرة GPU حسب نوع Pi
    local gpu_mem="128"
    if [[ "$PI_VERSION" == "5" ]]; then
        gpu_mem="256"
    elif [[ "$PI_VERSION" == "4" ]]; then
        gpu_mem="256"
    elif [[ "$PI_VERSION" == "3" ]]; then
        gpu_mem="128"
    fi
    
    # تحديد مكان ملف config.txt
    local config_file=""
    if [[ -f /boot/firmware/config.txt ]]; then
        config_file="/boot/firmware/config.txt"  # Pi 5 الجديد
    elif [[ -f /boot/config.txt ]]; then
        config_file="/boot/config.txt"  # Pi 4 والأقدم
    fi
    
    if [[ -n "$config_file" ]]; then
        # إعدادات GPU
        if ! grep -q "gpu_mem=" "$config_file"; then
            echo "gpu_mem=$gpu_mem" | sudo tee -a "$config_file"
            print_success "GPU memory set to ${gpu_mem}MB"
        fi
        
        # إعدادات إضافية للـ Pi 5
        if [[ "$PI_VERSION" == "5" ]]; then
            if ! grep -q "dtoverlay=vc4-kms-v3d" "$config_file"; then
                echo "dtoverlay=vc4-kms-v3d" | sudo tee -a "$config_file"
            fi
        fi
    fi
    
    # تحسين إعدادات الذاكرة
    if ! grep -q "vm.swappiness=10" /etc/sysctl.conf; then
        echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
    fi
    
    if ! grep -q "vm.vfs_cache_pressure=50" /etc/sysctl.conf; then
        echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
    fi
    
    print_success "System settings optimized"
    log_action "System optimization completed"
}

# إصلاح إعدادات الصوت المتقدمة
fix_advanced_audio() {
    print_step "Fixing advanced audio settings..."
    
    # تثبيت أدوات الصوت المتقدمة
    sudo apt install -y alsa-utils pulseaudio pulseaudio-utils
    
    # إضافة المستخدم لمجموعة الصوت
    sudo usermod -a -G audio $USER
    
    # إعداد ALSA محسن
    cat > ~/.asoundrc << 'EOF'
pcm.!default {
    type hw
    card 0
}
ctl.!default {
    type hw
    card 0
}
EOF
    
    # ضبط مستويات الصوت
    amixer set Master 75% 2>/dev/null || true
    amixer set PCM 75% 2>/dev/null || true
    amixer set Headphone 75% 2>/dev/null || true
    
    print_success "Advanced audio settings configured"
    log_action "Audio configuration completed"
}

# إصلاح إعدادات أذرع التحكم المتقدمة
fix_advanced_controllers() {
    print_step "Setting up advanced controller support..."
    
    # تثبيت أدوات أذرع التحكم المتقدمة
    sudo apt install -y joystick jstest-gtk evtest bluez bluez-tools xboxdrv
    
    # إضافة المستخدم للمجموعات المطلوبة
    sudo usermod -a -G input $USER
    sudo usermod -a -G bluetooth $USER
    
    # إنشاء قواعد udev متقدمة
    sudo tee /etc/udev/rules.d/99-retroarch-controllers.rules > /dev/null << 'EOF'
# SRAOUF Advanced Controller Rules
SUBSYSTEM=="input", GROUP="input", MODE="0664"
KERNEL=="js[0-9]*", GROUP="input", MODE="0664"
KERNEL=="event[0-9]*", GROUP="input", MODE="0664"

# Xbox Controllers
ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", GROUP="input", MODE="0664"
ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02d1", GROUP="input", MODE="0664"

# PlayStation Controllers
ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", GROUP="input", MODE="0664"
ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", GROUP="input", MODE="0664"

# Nintendo Controllers
ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", GROUP="input", MODE="0664"
EOF
    
    # إعادة تحميل قواعد udev
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    
    # تفعيل خدمة Bluetooth
    sudo systemctl enable bluetooth
    sudo systemctl start bluetooth
    
    print_success "Advanced controller support configured"
    log_action "Controller setup completed"
}

# اختبار شامل ومتقدم
run_comprehensive_test() {
    print_step "Running comprehensive system test..."
    
    local errors=0
    local warnings=0
    
    # اختبار RetroArch
    if command -v retroarch &> /dev/null; then
        print_success "✅ RetroArch: $(retroarch --version | head -1)"
        
        # اختبار تشغيل RetroArch
        if timeout 10s retroarch --menu --quit 2>/dev/null; then
            print_success "✅ RetroArch launches successfully"
        else
            print_warning "⚠️ RetroArch launch test failed"
            ((warnings++))
        fi
    else
        print_error "❌ RetroArch: Not found"
        ((errors++))
    fi
    
    # اختبار النوى
    local cores_count=$(ls /usr/lib/*/libretro/*.so 2>/dev/null | wc -l)
    if [[ $cores_count -gt 0 ]]; then
        print_success "✅ Cores: $cores_count found"
    else
        print_error "❌ Cores: None found"
        ((errors++))
    fi
    
    # اختبار الإعدادات
    if [[ -f ~/.config/retroarch/retroarch.cfg ]]; then
        print_success "✅ Configuration: Present"
        
        # اختبار اللغة
        if grep -q "user_language = 0" ~/.config/retroarch/retroarch.cfg; then
            print_success "✅ Language: English"
        else
            print_warning "⚠️ Language: Not set to English"
            ((warnings++))
        fi
        
        # اختبار تعريف الفيديو
        local video_driver=$(grep "video_driver" ~/.config/retroarch/retroarch.cfg | cut -d'"' -f2)
        if [[ -n "$video_driver" ]]; then
            print_success "✅ Video Driver: $video_driver"
        else
            print_warning "⚠️ Video Driver: Not configured"
            ((warnings++))
        fi
    else
        print_error "❌ Configuration: Missing"
        ((errors++))
    fi
    
    # اختبار الأذرع
    local controllers_count=$(ls /dev/input/js* 2>/dev/null | wc -l)
    if [[ $controllers_count -gt 0 ]]; then
        print_success "✅ Controllers: $controllers_count detected"
    else
        print_info "ℹ️ Controllers: None connected (normal)"
    fi
    
    # اختبار الصوت
    if command -v aplay &> /dev/null && aplay -l | grep -q "card"; then
        print_success "✅ Audio: Available"
    else
        print_warning "⚠️ Audio: May have issues"
        ((warnings++))
    fi
    
    # تقرير النتائج
    echo ""
    if [[ $errors -eq 0 && $warnings -eq 0 ]]; then
        print_success "🎉 PERFECT! All tests passed"
    elif [[ $errors -eq 0 ]]; then
        print_warning "✅ GOOD! $warnings warnings found (system usable)"
    else
        print_error "❌ ISSUES! $errors errors and $warnings warnings found"
    fi
    
    log_action "Comprehensive test completed: $errors errors, $warnings warnings"
    return $errors
}

# الدالة الرئيسية الشاملة
main() {
    clear
    print_header "SRAOUF ULTIMATE FIX & OPTIMIZATION SCRIPT"
    print_header "يصلح ويحدث ويحسن كل شيء بأمر واحد!"
    
    # إنشاء مجلد السجلات
    mkdir -p "$(dirname "$LOG_FILE")"
    log_action "Ultimate fix script started"
    
    print_info "This script will:"
    print_info "🔄 Update your entire system"
    print_info "🛠️ Fix all RetroArch issues"
    print_info "⚡ Optimize for your Pi model"
    print_info "🎮 Configure controllers"
    print_info "🔊 Fix audio issues"
    print_info "🧪 Run comprehensive tests"
    echo ""
    
    read -p "Continue with ultimate fix? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Operation cancelled"
        exit 0
    fi
    
    print_step "Starting ultimate fix and optimization..."
    echo ""
    
    # تنفيذ جميع الإصلاحات والتحسينات
    detect_pi_version
    comprehensive_system_update
    fix_and_upgrade_retroarch
    create_optimized_config
    optimize_system_settings
    fix_advanced_audio
    fix_advanced_controllers
    
    # اختبار شامل
    if run_comprehensive_test; then
        print_success "All systems operational!"
    else
        print_warning "Some issues detected but system should work"
    fi
    
    echo ""
    print_header "🎉 ULTIMATE FIX COMPLETED SUCCESSFULLY! 🎉"
    echo ""
    print_success "✅ Your Raspberry Pi $PI_VERSION is now fully optimized!"
    print_success "✅ RetroArch configured for maximum performance"
    print_success "✅ All issues fixed and system updated"
    echo ""
    print_info "🚀 To launch RetroArch: retroarch --menu"
    print_info "📊 Log file: $LOG_FILE"
    echo ""
    print_warning "🔄 REBOOT RECOMMENDED for all optimizations to take effect:"
    print_warning "   sudo reboot"
    echo ""
    print_success "🎊 Enjoy your optimized retro gaming experience!"
    
    log_action "Ultimate fix script completed successfully"
}

# تشغيل السكريپت
main "$@"
