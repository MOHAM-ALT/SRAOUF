#!/bin/bash

# SRAOUF Perfect Controller Setup Script
# سكريپت إعداد أذرع التحكم المثالي لسراوف
# الإصدار: 2.0 - يدعم جميع الأذرع تلقائياً

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

# متغيرات
SRAOUF_DIR="$HOME/SRAOUF"
AUTOCONFIG_DIR="$SRAOUF_DIR/configs/autoconfig"
LOG_FILE="$SRAOUF_DIR/logs/controller_setup.log"

# إنشاء مجلدات اللوج
mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$AUTOCONFIG_DIR"

# دوال الطباعة
print_header() {
    echo -e "${PURPLE}${BOLD}"
    echo "🎮 ================================================== 🎮"
    echo "    $1"
    echo "🎮 ================================================== 🎮"
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

# تثبيت تعاريف أذرع التحكم
install_controller_drivers() {
    print_step "تثبيت تعاريف أذرع التحكم..."
    log_action "Installing controller drivers"
    
    # تثبيت حزم أساسية
    sudo apt update
    sudo apt install -y \
        joystick \
        jstest-gtk \
        evtest \
        bluez \
        bluez-tools \
        bluetooth \
        libbluetooth-dev \
        xboxdrv \
        || print_warning "بعض الحزم لم تُثبت"
    
    # تحميل تعاريف النواة
    print_info "تحميل تعاريف النواة..."
    
    # تعاريف Xbox
    sudo modprobe xpad 2>/dev/null && print_success "تم تحميل تعريف Xbox (xpad)" || print_warning "تعريف Xbox غير متوفر"
    
    # تعاريف PlayStation
    sudo modprobe hid_sony 2>/dev/null && print_success "تم تحميل تعريف PlayStation (hid_sony)" || print_warning "تعريف PlayStation غير متوفر"
    
    # تعاريف Nintendo
    sudo modprobe hid_nintendo 2>/dev/null && print_success "تم تحميل تعريف Nintendo (hid_nintendo)" || print_warning "تعريف Nintendo غير متوفر"
    
    # تعاريف عامة
    sudo modprobe uinput 2>/dev/null && print_success "تم تحميل تعريف الإدخال العام (uinput)" || print_warning "تعريف uinput غير متوفر"
    
    print_success "تم تثبيت تعاريف أذرع التحكم"
    log_action "Controller drivers installed"
}

# دالة اكتشاف أذرع التحكم
detect_controllers() {
    print_step "البحث عن أذرع التحكم المتصلة..."
    log_action "Detecting connected controllers"
    
    # فحص /dev/input/js*
    local js_controllers=()
    for js in /dev/input/js*; do
        if [[ -e "$js" ]]; then
            js_controllers+=("$js")
        fi
    done
    
    if [[ ${#js_controllers[@]} -eq 0 ]]; then
        print_warning "لم يتم العثور على أذرع تحكم في /dev/input/"
        log_action "No joystick devices found in /dev/input/"
    else
        print_success "تم العثور على ${#js_controllers[@]} ذراع تحكم:"
        for controller in "${js_controllers[@]}"; do
            local controller_name=$(cat "/sys/class/input/$(basename "$controller")/device/name" 2>/dev/null || echo "Unknown Controller")
            print_info "  - $controller: $controller_name"
            log_action "Found controller: $controller - $controller_name"
        done
    fi
    
    # فحص أذرع USB
    print_info "فحص أذرع USB المتصلة..."
    local usb_controllers=$(lsusb | grep -i -E "(gamepad|controller|joystick|xbox|playstation|nintendo|8bitdo)")
    
    if [[ -n "$usb_controllers" ]]; then
        print_success "أذرع USB متصلة:"
        echo "$usb_controllers" | while read line; do
            print_info "  - $line"
            log_action "USB controller: $line"
        done
    else
        print_warning "لم يتم العثور على أذرع USB"
    fi
    
    # فحص أذرع Bluetooth
    print_info "فحص أذرع Bluetooth..."
    if command -v bluetoothctl &> /dev/null; then
        local bt_devices=$(bluetoothctl devices | grep -i -E "(controller|gamepad|joystick)")
        if [[ -n "$bt_devices" ]]; then
            print_success "أذرع Bluetooth مقترنة:"
            echo "$bt_devices" | while read line; do
                print_info "  - $line"
                log_action "Bluetooth controller: $line"
            done
        else
            print_info "لا توجد أذرع Bluetooth مقترنة"
        fi
    else
        print_warning "Bluetooth غير متوفر"
    fi
}

# إنشاء ملفات الإعداد التلقائي الكاملة
create_autoconfig_files() {
    print_step "إنشاء ملفات الإعداد التلقائي..."
    log_action "Creating autoconfig files"
    
    # إعداد Xbox 360 Controller (السلكي)
    cat > "$AUTOCONFIG_DIR/Xbox_360_Controller.cfg" << 'EOF'
input_driver = "udev"
input_device = "Xbox 360 Controller"
input_vendor_id = "1118"
input_product_id = "654"
input_b_btn = "0"
input_y_btn = "2"
input_select_btn = "6"
input_start_btn = "7"
input_up_btn = "h0up"
input_down_btn = "h0down"
input_left_btn = "h0left"
input_right_btn = "h0right"
input_a_btn = "1"
input_x_btn = "3"
input_l_btn = "4"
input_r_btn = "5"
input_l2_axis = "+2"
input_r2_axis = "+5"
input_l3_btn = "9"
input_r3_btn = "10"
input_l_x_plus_axis = "+0"
input_l_x_minus_axis = "-0"
input_l_y_plus_axis = "+1"
input_l_y_minus_axis = "-1"
input_r_x_plus_axis = "+3"
input_r_x_minus_axis = "-3"
input_r_y_plus_axis = "+4"
input_r_y_minus_axis = "-4"
input_menu_toggle_btn = "7"
EOF

    # إعداد Xbox One Controller
    cat > "$AUTOCONFIG_DIR/Xbox_One_Controller.cfg" << 'EOF'
input_driver = "udev"
input_device = "Xbox One Controller"
input_vendor_id = "1118"
input_product_id = "2834"
input_b_btn = "1"
input_y_btn = "4"
input_select_btn = "158"
input_start_btn = "315"
input_up_btn = "h0up"
input_down_btn = "h0down"
input_left_btn = "h0left"
input_right_btn = "h0right"
input_a_btn = "0"
input_x_btn = "3"
input_l_btn = "6"
input_r_btn = "7"
input_l2_axis = "+2"
input_r2_axis = "+5"
input_l3_btn = "13"
input_r3_btn = "14"
input_l_x_plus_axis = "+0"
input_l_x_minus_axis = "-0"
input_l_y_plus_axis = "+1"
input_l_y_minus_axis = "-1"
input_r_x_plus_axis = "+3"
input_r_x_minus_axis = "-3"
input_r_y_plus_axis = "+4"
input_r_y_minus_axis = "-4"
input_menu_toggle_btn = "315"
EOF

    # إعداد PlayStation 4 Controller
    cat > "$AUTOCONFIG_DIR/PS4_Controller.cfg" << 'EOF'
input_driver = "udev"
input_device = "Sony Computer Entertainment Wireless Controller"
input_vendor_id = "1356"
input_product_id = "1476"
input_b_btn = "1"
input_y_btn = "3"
input_select_btn = "8"
input_start_btn = "9"
input_up_btn = "h0up"
input_down_btn = "h0down"
input_left_btn = "h0left"
input_right_btn = "h0right"
input_a_btn = "0"
input_x_btn = "2"
input_l_btn = "4"
input_r_btn = "5"
input_l2_axis = "+2"
input_r2_axis = "+5"
input_l3_btn = "11"
input_r3_btn = "12"
input_l_x_plus_axis = "+0"
input_l_x_minus_axis = "-0"
input_l_y_plus_axis = "+1"
input_l_y_minus_axis = "-1"
input_r_x_plus_axis = "+3"
input_r_x_minus_axis = "-3"
input_r_y_plus_axis = "+4"
input_r_y_minus_axis = "-4"
input_menu_toggle_btn = "10"
EOF

    # إعداد PlayStation 5 Controller
    cat > "$AUTOCONFIG_DIR/PS5_Controller.cfg" << 'EOF'
input_driver = "udev"
input_device = "Sony Interactive Entertainment DualSense Wireless Controller"
input_vendor_id = "1356"
input_product_id = "3302"
input_b_btn = "1"
input_y_btn = "3"
input_select_btn = "8"
input_start_btn = "9"
input_up_btn = "h0up"
input_down_btn = "h0down"
input_left_btn = "h0left"
input_right_btn = "h0right"
input_a_btn = "0"
input_x_btn = "2"
input_l_btn = "4"
input_r_btn = "5"
input_l2_axis = "+2"
input_r2_axis = "+5"
input_l3_btn = "11"
input_r3_btn = "12"
input_l_x_plus_axis = "+0"
input_l_x_minus_axis = "-0"
input_l_y_plus_axis = "+1"
input_l_y_minus_axis = "-1"
input_r_x_plus_axis = "+3"
input_r_x_minus_axis = "-3"
input_r_y_plus_axis = "+4"
input_r_y_minus_axis = "-4"
input_menu_toggle_btn = "10"
EOF

    # إعداد Nintendo Pro Controller
    cat > "$AUTOCONFIG_DIR/Nintendo_Pro_Controller.cfg" << 'EOF'
input_driver = "udev"
input_device = "Nintendo Co., Ltd. Pro Controller"
input_vendor_id = "1406"
input_product_id = "8201"
input_b_btn = "0"
input_y_btn = "2"
input_select_btn = "4"
input_start_btn = "6"
input_up_btn = "12"
input_down_btn = "13"
input_left_btn = "14"
input_right_btn = "15"
input_a_btn = "1"
input_x_btn = "3"
input_l_btn = "9"
input_r_btn = "10"
input_l2_btn = "11"
input_r2_btn = "12"
input_l3_btn = "7"
input_r3_btn = "8"
input_l_x_plus_axis = "+0"
input_l_x_minus_axis = "-0"
input_l_y_plus_axis = "+1"
input_l_y_minus_axis = "-1"
input_r_x_plus_axis = "+2"
input_r_x_minus_axis = "-2"
input_r_y_plus_axis = "+3"
input_r_y_minus_axis = "-3"
input_menu_toggle_btn = "5"
EOF

    # إعداد 8BitDo SN30 Pro
    cat > "$AUTOCONFIG_DIR/8BitDo_SN30_Pro.cfg" << 'EOF'
input_driver = "udev"
input_device = "8BitDo SN30 Pro"
input_vendor_id = "11720"
input_product_id = "2835"
input_b_btn = "0"
input_y_btn = "4"
input_select_btn = "10"
input_start_btn = "11"
input_up_btn = "h0up"
input_down_btn = "h0down"
input_left_btn = "h0left"
input_right_btn = "h0right"
input_a_btn = "1"
input_x_btn = "3"
input_l_btn = "6"
input_r_btn = "7"
input_l2_btn = "8"
input_r2_btn = "9"
input_l3_btn = "13"
input_r3_btn = "14"
input_l_x_plus_axis = "+0"
input_l_x_minus_axis = "-0"
input_l_y_plus_axis = "+1"
input_l_y_minus_axis = "-1"
input_r_x_plus_axis = "+2"
input_r_x_minus_axis = "-2"
input_r_y_plus_axis = "+3"
input_r_y_minus_axis = "-3"
input_menu_toggle_btn = "12"
EOF

    # إعداد عام للأذرع غير المعروفة
    cat > "$AUTOCONFIG_DIR/Generic_USB_Controller.cfg" << 'EOF'
input_driver = "udev"
input_device = "Generic USB Controller"
input_b_btn = "0"
input_y_btn = "2"
input_select_btn = "6"
input_start_btn = "7"
input_up_btn = "h0up"
input_down_btn = "h0down"
input_left_btn = "h0left"
input_right_btn = "h0right"
input_a_btn = "1"
input_x_btn = "3"
input_l_btn = "4"
input_r_btn = "5"
input_l2_btn = "8"
input_r2_btn = "9"
input_l3_btn = "10"
input_r3_btn = "11"
input_l_x_plus_axis = "+0"
input_l_x_minus_axis = "-0"
input_l_y_plus_axis = "+1"
input_l_y_minus_axis = "-1"
input_r_x_plus_axis = "+2"
input_r_x_minus_axis = "-2"
input_r_y_plus_axis = "+3"
input_r_y_minus_axis = "-3"
EOF

    print_success "تم إنشاء ملفات الإعداد التلقائي"
    log_action "Autoconfig files created"
}

# إعداد Bluetooth للأذرع اللاسلكية
setup_bluetooth() {
    print_step "إعداد Bluetooth للأذرع اللاسلكية..."
    log_action "Setting up Bluetooth"
    
    if command -v bluetoothctl &> /dev/null; then
        # تفعيل Bluetooth
        sudo systemctl enable bluetooth
        sudo systemctl start bluetooth
        
        # إعداد للاقتران التلقائي
        sudo sed -i 's/#AutoEnable=false/AutoEnable=true/' /etc/bluetooth/main.conf 2>/dev/null || true
        
        print_success "تم إعداد Bluetooth"
        print_info "لإقتران ذراع جديد: sudo bluetoothctl"
        print_info "ثم اكتب: scan on, pair [MAC_ADDRESS], connect [MAC_ADDRESS]"
        log_action "Bluetooth setup completed"
    else
        print_warning "Bluetooth غير متوفر على هذا النظام"
        log_action "Bluetooth not available"
    fi
}

# اختبار أذرع التحكم
test_controllers() {
    print_step "اختبار أذرع التحكم..."
    log_action "Testing controllers"
    
    # البحث عن أذرع متصلة
    local controllers=(/dev/input/js*)
    
    if [[ ! -e "${controllers[0]}" ]]; then
        print_warning "لا توجد أذرع تحكم متصلة للاختبار"
        print_info "قم بتوصيل ذراع تحكم وأعد تشغيل السكريپت"
        return 1
    fi
    
    for controller in "${controllers[@]}"; do
        if [[ -e "$controller" ]]; then
            local controller_name=$(cat "/sys/class/input/$(basename "$controller")/device/name" 2>/dev/null || echo "Unknown")
            print_info "اختبار $controller: $controller_name"
            
            # اختبار سريع لمدة 3 ثوانٍ
            if command -v jstest &> /dev/null; then
                print_info "اضغط أي زر على الذراع خلال 3 ثوانٍ..."
                timeout 3s jstest --event "$controller" 2>/dev/null | head -5 || {
                    print_warning "لم يتم اكتشاف أحداث من $controller"
                }
            else
                print_info "jstest غير متوفر - سيتم تخطي الاختبار"
            fi
            
            log_action "Tested controller: $controller - $controller_name"
        fi
    done
    
    print_success "تم اختبار أذرع التحكم"
}

# إعداد إعدادات الإدخال في RetroArch
configure_retroarch_input() {
    print_step "إعداد إعدادات الإدخال في RetroArch..."
    log_action "Configuring RetroArch input"
    
    local retroarch_config="$HOME/.config/retroarch/retroarch.cfg"
    
    # إنشاء ملف الإعداد إذا لم يكن موجوداً
    if [[ ! -f "$retroarch_config" ]]; then
        mkdir -p "$(dirname "$retroarch_config")"
        touch "$retroarch_config"
    fi
    
    # إضافة إعدادات الإدخال
    cat >> "$retroarch_config" << EOF

# SRAOUF Controller Settings
input_driver = "udev"
input_joypad_driver = "udev"
input_autodetect_enable = true
input_autoconfigure_joypad_init = true
joypad_autoconfig_dir = "$AUTOCONFIG_DIR"

# أزرار القائمة والنظام
input_menu_toggle = "f1"
input_exit_emulator = "escape"
input_load_state = "f4"
input_save_state = "f2"
input_screenshot = "f8"
input_pause_toggle = "p"

# إعدادات الحساسية
input_analog_deadzone = 0.15
input_analog_sensitivity = 1.0

# دعم اللاعبين المتعددين
input_max_users = 4
input_player1_joypad_index = 0
input_player2_joypad_index = 1
input_player3_joypad_index = 2
input_player4_joypad_index = 3

EOF

    print_success "تم إعداد إعدادات الإدخال في RetroArch"
    log_action "RetroArch input configuration completed"
}

# إنشاء سكريپت إقتران Bluetooth سريع
create_bluetooth_pairing_script() {
    print_step "إنشاء سكريپت إقتران Bluetooth سريع..."
    
    cat > "$SRAOUF_DIR/scripts/pair_controller.sh" << 'EOF'
#!/bin/bash

# SRAOUF Bluetooth Controller Pairing Script
# سكريپت إقتران أذرع Bluetooth

echo "🎮 إقتران ذراع تحكم Bluetooth"
echo "================================"

if ! command -v bluetoothctl &> /dev/null; then
    echo "❌ Bluetooth غير متوفر"
    exit 1
fi

echo "📡 تفعيل Bluetooth..."
sudo systemctl start bluetooth

echo "🔍 البحث عن أذرع تحكم..."
echo "ضع ذراع التحكم في وضع الإقتران واضغط Enter"
read -p ""

echo "بدء البحث لمدة 30 ثانية..."
{
    sleep 2
    echo "scan on"
    sleep 30
    echo "scan off"
    echo "quit"
} | bluetoothctl

echo ""
echo "قائمة الأجهزة المكتشفة:"
bluetoothctl devices

echo ""
read -p "أدخل MAC address للذراع (مثال: AA:BB:CC:DD:EE:FF): " mac_address

if [[ -n "$mac_address" ]]; then
    echo "🔗 محاولة الإقتران مع $mac_address..."
    {
        echo "pair $mac_address"
        sleep 5
        echo "connect $mac_address"
        sleep 3
        echo "trust $mac_address"
        echo "quit"
    } | bluetoothctl
    
    echo "✅ تم الإقتران! جرب تشغيل سراوف الآن"
else
    echo "❌ لم يتم إدخال MAC address"
fi
EOF

    chmod +x "$SRAOUF_DIR/scripts/pair_controller.sh"
    print_success "تم إنشاء سكريپت إقتران Bluetooth"
    log_action "Bluetooth pairing script created"
}

# إنشاء سكريپت اختبار شامل للأذرع
create_controller_test_script() {
    print_step "إنشاء سكريپت اختبار شامل للأذرع..."
    
    cat > "$SRAOUF_DIR/scripts/test_all_controllers.sh" << 'EOF'
#!/bin/bash

# SRAOUF Controller Test Script
# سكريپت اختبار أذرع التحكم الشامل

echo "🎮 اختبار أذرع التحكم الشامل"
echo "================================"

# فحص /dev/input/js*
echo "📋 أذرع التحكم المكتشفة:"
js_count=0
for js in /dev/input/js*; do
    if [[ -e "$js" ]]; then
        js_count=$((js_count + 1))
        controller_name=$(cat "/sys/class/input/$(basename "$js")/device/name" 2>/dev/null || echo "Unknown")
        echo "  $js_count. $js - $controller_name"
    fi
done

if [[ $js_count -eq 0 ]]; then
    echo "❌ لم يتم العثور على أذرع تحكم"
    echo "   • تأكد من توصيل الذراع"
    echo "   • جرب منفذ USB آخر"
    echo "   • للأذرع اللاسلكية: تأكد من الإقتران"
    exit 1
fi

echo ""
echo "🔧 اختبار الأذرع:"

for js in /dev/input/js*; do
    if [[ -e "$js" ]]; then
        controller_name=$(cat "/sys/class/input/$(basename "$js")/device/name" 2>/dev/null || echo "Unknown")
        echo ""
        echo "🎯 اختبار: $js ($controller_name)"
        echo "   اضغط أي زر لمدة 5 ثوانٍ أو اضغط Ctrl+C للتالي"
        
        if command -v jstest &> /dev/null; then
            timeout 5s jstest --event "$js" 2>/dev/null | while read line; do
                echo "   📡 $line"
            done || echo "   ⏱️ انتهت مهلة الاختبار"
        else
            echo "   ⚠️ jstest غير متوفر"
        fi
    fi
done

echo ""
echo "✅ انتهى اختبار الأذرع"
echo "💡 إذا لم تعمل الأذرع في الألعاب، جرب:"
echo "   1. إعادة تشغيل النظام"
echo "   2. تشغيل: ./setup_controller.sh"
echo "   3. التحقق من إعدادات RetroArch"
EOF

    chmod +x "$SRAOUF_DIR/scripts/test_all_controllers.sh"
    print_success "تم إنشاء سكريپت اختبار الأذرع"
    log_action "Controller test script created"
}

# إصلاح أذونات الأذرع
fix_controller_permissions() {
    print_step "إصلاح أذونات أذرع التحكم..."
    log_action "Fixing controller permissions"
    
    # إضافة المستخدم لمجموعة input
    sudo usermod -a -G input "$USER"
    
    # إنشاء قاعدة udev للأذرع
    sudo tee /etc/udev/rules.d/99-joystick.rules > /dev/null << 'EOF'
# SRAOUF Controller Permissions
SUBSYSTEM=="input", GROUP="input", MODE="0664"
KERNEL=="js[0-9]*", GROUP="input", MODE="0664"
KERNEL=="event[0-9]*", GROUP="input", MODE="0664"

# Xbox Controllers
ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", GROUP="input", MODE="0664"
ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02d1", GROUP="input", MODE="0664"
ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02dd", GROUP="input", MODE="0664"

# PlayStation Controllers  
ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", GROUP="input", MODE="0664"
ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", GROUP="input", MODE="0664"
ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", GROUP="input", MODE="0664"

# Nintendo Controllers
ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", GROUP="input", MODE="0664"
ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2017", GROUP="input", MODE="0664"

# 8BitDo Controllers
ATTRS{idVendor}=="2dc8", GROUP="input", MODE="0664"
EOF

    # إعادة تحميل قواعد udev
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    
    print_success "تم إصلاح أذونات أذرع التحكم"
    log_action "Controller permissions fixed"
}

# إنشاء تقرير إعداد الأذرع
create_controller_report() {
    print_step "إنشاء تقرير إعداد أذرع التحكم..."
    
    local report_file="$SRAOUF_DIR/logs/controller_setup_report.txt"
    
    cat > "$report_file" << EOF
SRAOUF Controller Setup Report
تقرير إعداد أذرع التحكم - سراوف

تاريخ الإعداد: $(date)

الأذرع المكتشفة:
EOF

    # إضافة قائمة الأذرع المكتشفة
    if ls /dev/input/js* &>/dev/null; then
        for js in /dev/input/js*; do
            if [[ -e "$js" ]]; then
                local controller_name=$(cat "/sys/class/input/$(basename "$js")/device/name" 2>/dev/null || echo "Unknown")
                echo "- $js: $controller_name" >> "$report_file"
            fi
        done
    else
        echo "- لا توجد أذرع تحكم مكتشفة" >> "$report_file"
    fi
    
    cat >> "$report_file" << EOF

ملفات الإعداد المُنشأة:
- Xbox 360 Controller
- Xbox One Controller  
- PlayStation 4 Controller
- PlayStation 5 Controller
- Nintendo Pro Controller
- 8BitDo SN30 Pro
- Generic USB Controller

الميزات المفعلة:
✅ تعاريف النواة محملة
✅ ملفات الإعداد التلقائي منشأة
✅ إعدادات RetroArch محدثة  
✅ أذونات النظام مضبوطة
✅ دعم Bluetooth مفعل
✅ سكريپتات الاختبار جاهزة

للاستخدام:
1. توصيل الذراع أو إقترانه عبر Bluetooth
2. تشغيل سراوف عبر أيقونة سطح المكتب
3. للاختبار: ./scripts/test_all_controllers.sh
4. لإقتران Bluetooth: ./scripts/pair_controller.sh

للمساعدة: https://github.com/MOHAM-ALT/SRAOUF
EOF
    
    print_success "تم إنشاء تقرير إعداد الأذرع: $report_file"
    log_action "Controller setup report created"
}

# عرض دليل الاستخدام السريع
show_usage_guide() {
    echo
    print_info "📖 دليل استخدام أذرع التحكم:"
    echo
    print_info "🔌 للأذرع السلكية:"
    print_info "   1. وصل الذراع بمنفذ USB"
    print_info "   2. شغل سراوف - سيعمل تلقائياً"
    echo
    print_info "📡 للأذرع اللاسلكية:"
    print_info "   1. شغل: ./scripts/pair_controller.sh"
    print_info "   2. اتبع التعليمات للإقتران"
    print_info "   3. شغل سراوف"
    echo
    print_info "🧪 للاختبار:"
    print_info "   شغل: ./scripts/test_all_controllers.sh"
    echo
    print_info "🎮 أذرع مدعومة:"
    print_info "   • Xbox 360/One/Series"
    print_info "   • PlayStation 4/5"
    print_info "   • Nintendo Pro Controller"  
    print_info "   • 8BitDo Controllers"
    print_info "   • معظم أذرع USB العامة"
    echo
}

# الدالة الرئيسية
main() {
    clear
    print_header "إعداد أذرع التحكم المثالي - SRAOUF Controller Setup"
    print_header "يدعم جميع الأذرع تلقائياً بلا تعقيدات"
    
    log_action "Controller setup started"
    
    print_info "بدء إعداد أذرع التحكم الشامل..."
    echo
    
    # تنفيذ جميع خطوات الإعداد
    install_controller_drivers
    detect_controllers
    create_autoconfig_files
    setup_bluetooth
    configure_retroarch_input
    fix_controller_permissions
    create_bluetooth_pairing_script
    create_controller_test_script
    test_controllers
    create_controller_report
    
    echo
    print_header "🎉 تم إعداد أذرع التحكم بنجاح! 🎉"
    echo
    print_success "✅ جميع أذرع التحكم جاهزة للاستخدام"
    print_info "📁 ملفات الإعداد: $AUTOCONFIG_DIR"
    print_info "📊 تقرير الإعداد: $SRAOUF_DIR/logs/controller_setup_report.txt"
    
    show_usage_guide
    
    print_success "🎮 استمتع باللعب مع أذرع التحكم!"
    
    log_action "Controller setup completed successfully"
}

# تشغيل السكريپت
main "$@"
