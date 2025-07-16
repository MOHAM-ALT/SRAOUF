#!/bin/bash

# SRAOUF Controller Setup Script
# سكريپت إعداد أذرع التحكم لسراوف
# الإصدار: 1.0

set -e

# ألوان النص
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# متغيرات
SRAOUF_DIR="$HOME/SRAOUF"
AUTOCONFIG_DIR="$SRAOUF_DIR/configs/autoconfig"
LOG_FILE="$SRAOUF_DIR/logs/controller_setup.log"

# دوال الطباعة
print_message() {
    echo -e "${CYAN}[CONTROLLER SETUP]${NC} $1"
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

# دالة التحقق من أذرع التحكم المتصلة
detect_controllers() {
    print_message "البحث عن أذرع التحكم المتصلة..."
    
    # التحقق من /dev/input/js*
    local js_controllers=()
    for js in /dev/input/js*; do
        if [[ -e "$js" ]]; then
            js_controllers+=("$js")
        fi
    done
    
    if [[ ${#js_controllers[@]} -eq 0 ]]; then
        print_warning "لم يتم العثور على أذرع تحكم في /dev/input/"
    else
        print_success "تم العثور على ${#js_controllers[@]} ذراع تحكم:"
        for controller in "${js_controllers[@]}"; do
            local controller_name=$(cat "/sys/class/input/$(basename "$controller")/device/name" 2>/dev/null || echo "Unknown")
            print_info "  - $controller: $controller_name"
        done
    fi
    
    # فحص أذرع USB
    print_message "فحص أذرع USB المتصلة..."
    local usb_controllers=$(lsusb | grep -i -E "(gamepad|controller|joystick|xbox|playstation|nintendo)")
    
    if [[ -n "$usb_controllers" ]]; then
        print_success "أذرع USB متصلة:"
        echo "$usb_controllers" | while read line; do
            print_info "  - $line"
        done
    else
        print_warning "لم يتم العثور على أذرع USB"
    fi
    
    # فحص أذرع Bluetooth
    print_message "فحص أذرع Bluetooth..."
    if command -v bluetoothctl &> /dev/null; then
        local bt_devices=$(bluetoothctl devices | grep -i -E "(controller|gamepad|joystick)")
        if [[ -n "$bt_devices" ]]; then
            print_success "أذرع Bluetooth مقترنة:"
            echo "$bt_devices" | while read line; do
                print_info "  - $line"
            done
        else
            print_info "لا توجد أذرع Bluetooth مقترنة"
        fi
    else
        print_warning "Bluetooth غير متوفر"
    fi
}

# دالة تثبيت تعاريف أذرع التحكم
install_controller_drivers() {
    print_message "تثبيت تعاريف أذرع التحكم..."
    
    # تثبيت حزم أساسية
    if command -v apt &> /dev/null; then
        print_info "تثبيت الحزم المطلوبة..."
        sudo apt update
        sudo apt install -y \
            joystick \
            jstest-gtk \
            evtest \
            bluez \
            bluez-tools \
            bluetooth \
            libbluetooth-dev
        
        print_success "تم تثبيت الحزم الأساسية"
    fi
    
    # تحميل تعاريف النواة
    print_info "تحميل تعاريف النواة..."
    
    # تعاريف Xbox
    sudo modprobe xpad 2>/dev/null && print_success "تم تحميل تعريف Xbox (xpad)" || print_warning "فشل في تحميل تعريف Xbox"
    
    # تعاريف PlayStation
    sudo modprobe hid_sony 2>/dev/null && print_success "تم تحميل تعريف PlayStation (hid_sony)" || print_warning "فشل في تحميل تعريف PlayStation"
    
    # تعاريف Nintendo
    sudo modprobe hid_nintendo 2>/dev/null && print_success "تم تحميل تعريف Nintendo (hid_nintendo)" || print_warning "فشل في تحميل تعريف Nintendo"
    
    # تعاريف عامة
    sudo modprobe uinput 2>/dev/null && print_success "تم تحميل تعريف الإدخال العام (uinput)" || print_warning "فشل في تحميل تعريف الإدخال العام"
}

# دالة إنشاء ملفات الإعداد التلقائي
create_autoconfig_files() {
    print_message "إنشاء ملفات الإعداد التلقائي..."
    
    mkdir -p "$AUTOCONFIG_DIR"
    
    # إعداد Xbox 360 Controller
    cat > "$AUTOCONFIG_DIR/Xbox 360 Controller.cfg" << 'EOF'
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
    cat > "$AUTOCONFIG_DIR/Xbox One Controller.cfg" << 'EOF'
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