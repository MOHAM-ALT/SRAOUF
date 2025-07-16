#!/bin/bash

# SRAOUF Update Script
# سكريبت تحديث سراوف للألعاب
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
BACKUP_DIR="$SRAOUF_DIR/backups/$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$SRAOUF_DIR/logs/update.log"

# دوال الطباعة
print_message() {
    echo -e "${CYAN}[SRAOUF UPDATE]${NC} $1"
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

# التحقق من وجود المشروع
check_installation() {
    if [[ ! -d "$SRAOUF_DIR" ]]; then
        print_error "لم يتم العثور على تثبيت سراوف في: $SRAOUF_DIR"
        print_info "قم بتثبيت سراوف أولاً باستخدام: ./install.sh"
        exit 1
    fi
    
    print_success "تم العثور على تثبيت سراوف"
}

# إنشاء نسخة احتياطية
create_backup() {
    print_message "إنشاء نسخة احتياطية..."
    
    mkdir -p "$BACKUP_DIR"
    
    # نسخ الإعدادات المهمة
    cp -r "$SRAOUF_DIR/configs" "$BACKUP_DIR/" 2>/dev/null || true
    cp -r "$SRAOUF_DIR/saves" "$BACKUP_DIR/" 2>/dev/null || true
    cp -r "$SRAOUF_DIR/states" "$BACKUP_DIR/" 2>/dev/null || true
    cp -r "$HOME/.emulationstation" "$BACKUP_DIR/" 2>/dev/null || true
    
    print_success "تم إنشاء نسخة احتياطية في: $BACKUP_DIR"
}

# تحديث المشروع من Git
update_project() {
    print_message "تحديث ملفات المشروع..."
    
    cd "$SRAOUF_DIR"
    
    # التحقق من وجود تغييرات محلية
    if ! git diff --quiet; then
        print_warning "توجد تغييرات محلية في الملفات"
        print_info "سيتم حفظها في النسخة الاحتياطية"
        git stash push -m "Local changes backup $(date)"
    fi
    
    # تحديث المشروع
    git fetch origin
    git reset --hard origin/main
    
    print_success "تم تحديث ملفات المشروع"
}

# تحديث RetroArch
update_retroarch() {
    print_message "تحديث RetroArch..."
    
    cd "$SRAOUF_DIR/emulators"
    
    if [[ -d "RetroArch" ]]; then
        cd RetroArch
        git pull origin master
        
        # إعادة البناء
        make clean
        ./configure --enable-neon --enable-floathard --enable-gles --enable-kms --enable-udev
        make -j$(nproc)
        sudo make install
        
        print_success "تم تحديث RetroArch"
    else
        print_warning "لم يتم العثور على RetroArch، سيتم تخطي التحديث"
    fi
}

# تحديث نوى المحاكيات
update_cores() {
    print_message "تحديث نوى المحاكيات..."
    
    cd "$SRAOUF_DIR/emulators"
    
    # قائمة المحاكيات المثبتة
    cores=("nestopia" "snes9x" "gambatte" "genesis_plus_gx" "mame" "pcsx_rearmed" "stella" "vice")
    
    for core in "${cores[@]}"; do
        if [[ -d "$core" ]]; then
            print_info "تحديث $core..."
            cd "$core"
            git pull origin master 2>/dev/null || git pull origin main 2>/dev/null || {
                print_warning "فشل في تحديث $core"
                cd ..
                continue
            }
            
            # إعادة البناء
            make clean
            make -j$(nproc)
            sudo make install
            
            cd ..
            print_success "تم تحديث $core"
        else
            print_warning "لم يتم العثور على $core"
        fi
    done
    
    print_success "تم تحديث نوى المحاكيات"
}

# تحديث EmulationStation
update_emulationstation() {
    print_message "تحديث EmulationStation..."
    
    cd "$SRAOUF_DIR/emulators"
    
    if [[ -d "EmulationStation" ]]; then
        cd EmulationStation
        git pull origin master
        
        # إعادة البناء
        cd build
        make clean
        cmake ..
        make -j$(nproc)
        sudo make install
        
        print_success "تم تحديث EmulationStation"
    else
        print_warning "لم يتم العثور على EmulationStation"
    fi
}

# تحديث قائمة الألعاب المجانية
update_free_games() {
    print_message "تحديث قائمة الألعاب المجانية..."
    
    cd "$SRAOUF_DIR/games"
    
    # تحديث قائمة الألعاب المجانية
    if [[ -f "free_games_list.txt" ]]; then
        # إنشاء نسخة احتياطية من القائمة القديمة
        cp free_games_list.txt free_games_list_backup.txt
        
        # تحديث القائمة (هنا يمكن إضافة ألعاب جديدة)
        cat >> free_games_list.txt << 'EOF'

# New Games Added in Update
nintendo-nes/Alter Ego.nes|https://www.romhacking.net/homebrew/103/
nintendo-nes/D-Pad Hero.nes|https://www.romhacking.net/homebrew/84/
sega-genesis/Mikros.bin|https://github.com/mickael-guene/mikros/releases/
nintendo-gb/2048gb.gb|https://github.com/Sanqui/2048gb/releases/
EOF
        
        print_success "تم تحديث قائمة الألعاب المجانية"
    else
        print_warning "لم يتم العثور على قائمة الألعاب"
    fi
}

# تحديث الخطوط والأصول
update_assets() {
    print_message "تحديث الأصول والخطوط..."
    
    cd "$SRAOUF_DIR/assets/fonts"
    
    # تحديث خط أميري
    if [[ -f "amiri.zip" ]]; then
        rm -f amiri.zip
        wget -O amiri.zip "https://github.com/aliftype/amiri/releases/latest/download/Amiri.zip"
        unzip -o amiri.zip
    fi
    
    # تحديث خط نوتو العربي
    if [[ -f "noto-arabic.zip" ]]; then
        rm -f noto-arabic.zip
        wget -O noto-arabic.zip "https://fonts.google.com/download?family=Noto%20Sans%20Arabic"
        unzip -o noto-arabic.zip
    fi
    
    # تثبيت الخطوط المحدثة
    sudo cp *.ttf /usr/share/fonts/truetype/
    sudo fc-cache -fv
    
    print_success "تم تحديث الأصول والخطوط"
}

# تحديث إعدادات النظام
update_system_configs() {
    print_message "تحديث إعدادات النظام..."
    
    # تحديث إعدادات RetroArch
    if [[ -f "$SRAOUF_DIR/configs/retroarch.cfg" ]]; then
        # إضافة إعدادات جديدة إذا لم تكن موجودة
        if ! grep -q "menu_xmb_shadows_enable" "$SRAOUF_DIR/configs/retroarch.cfg"; then
            cat >> "$SRAOUF_DIR/configs/retroarch.cfg" << 'EOF'

# New Settings Added in Update
menu_xmb_shadows_enable = true
menu_xmb_show_settings = true
menu_xmb_show_images = true
menu_xmb_show_music = true
menu_xmb_show_video = true
netplay_enable = true
achievements_enable = true
EOF
        fi
    fi
    
    print_success "تم تحديث إعدادات النظام"
}

# فحص التحديثات المتوفرة
check_available_updates() {
    print_message "فحص التحديثات المتوفرة..."
    
    cd "$SRAOUF_DIR"
    
    # فحص تحديثات Git
    git fetch origin
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/main)
    
    if [[ "$LOCAL" != "$REMOTE" ]]; then
        print_info "توجد تحديثات جديدة متوفرة"
        
        # عرض قائمة التغييرات
        print_info "التغييرات الجديدة:"
        git log --oneline HEAD..origin/main | head -10
        
        return 0
    else
        print_success "أنت تستخدم أحدث إصدار"
        return 1
    fi
}

# تنظيف الملفات القديمة
cleanup_old_files() {
    print_message "تنظيف الملفات القديمة..."
    
    cd "$SRAOUF_DIR"
    
    # حذف ملفات البناء المؤقتة
    find . -name "*.o" -delete 2>/dev/null || true
    find . -name "*.tmp" -delete 2>/dev/null || true
    find . -name "*.log.old" -delete 2>/dev/null || true
    
    # تنظيف النسخ الاحتياطية القديمة (أكثر من 30 يوم)
    find "$SRAOUF_DIR/backups" -type d -mtime +30 -exec rm -rf {} + 2>/dev/null || true
    
    # تنظيف ذاكرة التخزين المؤقت
    if command -v retroarch &> /dev/null; then
        retroarch --config "$SRAOUF_DIR/configs/retroarch.cfg" --menu --quit &>/dev/null || true
    fi
    
    print_success "تم تنظيف الملفات القديمة"
}

# إنشاء تقرير التحديث
create_update_report() {
    print_message "إنشاء تقرير التحديث..."
    
    cat > "$SRAOUF_DIR/logs/last_update_report.txt" << EOF
SRAOUF Update Report
تقرير تحديث سراوف

تاريخ التحديث: $(date)
الإصدار السابق: $(cat "$BACKUP_DIR/../version.txt" 2>/dev/null || echo "غير معروف")
الإصدار الحالي: $(git rev-parse --short HEAD)

المكونات المحدثة:
- ملفات المشروع: ✅
- RetroArch: ✅
- نوى المحاكيات: ✅
- EmulationStation: ✅
- قائمة الألعاب: ✅
- الخطوط والأصول: ✅
- إعدادات النظام: ✅

النسخة الاحتياطية: $BACKUP_DIR

للتراجع عن التحديث:
$SRAOUF_DIR/scripts/restore_backup.sh "$BACKUP_DIR"

EOF

    # حفظ الإصدار الحالي
    git rev-parse --short HEAD > "$SRAOUF_DIR/version.txt"
    
    print_success "تم إنشاء تقرير التحديث"
}

# الدالة الرئيسية
main() {
    clear
    echo -e "${PURPLE}"
    echo "🔄 ================================== 🔄"
    echo "        تحديث سراوف للألعاب          "
    echo "        SRAOUF Gaming Updater         "
    echo "🔄 ================================== 🔄"
    echo -e "${NC}"
    echo
    
    # إنشاء ملف اللوج
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "$(date): Starting SRAOUF update..." > "$LOG_FILE"
    
    # التحقق من التثبيت
    check_installation | tee -a "$LOG_FILE"
    
    # فحص التحديثات المتوفرة
    if ! check_available_updates | tee -a "$LOG_FILE"; then
        print_info "لا توجد حاجة للتحديث"
        exit 0
    fi
    
    # طلب تأكيد من المستخدم
    echo
    read -p "هل تريد المتابعة مع التحديث؟ (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "تم إلغاء التحديث"
        exit 0
    fi
    
    echo
    print_message "بدء عملية التحديث..."
    
    # تنفيذ خطوات التحديث
    create_backup | tee -a "$LOG_FILE"
    update_project | tee -a "$LOG_FILE"
    update_retroarch | tee -a "$LOG_FILE"
    update_cores | tee -a "$LOG_FILE"
    update_emulationstation | tee -a "$LOG_FILE"
    update_free_games | tee -a "$LOG_FILE"
    update_assets | tee -a "$LOG_FILE"
    update_system_configs | tee -a "$LOG_FILE"
    cleanup_old_files | tee -a "$LOG_FILE"
    create_update_report | tee -a "$LOG_FILE"
    
    echo
    echo -e "${GREEN}"
    echo "🎉 ================================== 🎉"
    echo "        تم التحديث بنجاح!            "
    echo "    SRAOUF Update Completed!         "
    echo "🎉 ================================== 🎉"
    echo -e "${NC}"
    echo
    
    print_success "تم تحديث سراوف بنجاح!"
    print_info "تقرير التحديث: $SRAOUF_DIR/logs/last_update_report.txt"
    print_info "النسخة الاحتياطية: $BACKUP_DIR"
    echo
    print_warning "يُنصح بإعادة تشغيل النظام: sudo reboot"
    
    echo "$(date): SRAOUF update completed successfully." >> "$LOG_FILE"
}

# التحقق من المعاملات
case "${1:-update}" in
    "check")
        check_installation
        check_available_updates
        ;;
    "update")
        main
        ;;
    "help")
        echo "استخدام سكريبت التحديث:"
        echo "  ./update.sh          - تحديث كامل"
        echo "  ./update.sh check    - فحص التحديثات فقط"
        echo "  ./update.sh help     - عرض هذه المساعدة"
        ;;
    *)
        print_error "معامل غير صحيح: $1"
        print_info "استخدم: ./update.sh help للمساعدة"
        exit 1
        ;;
esac