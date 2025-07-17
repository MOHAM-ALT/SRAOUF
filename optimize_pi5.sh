#!/bin/bash

# تطبيق تحسينات Raspberry Pi 5 مع اللغة الإنجليزية
# Apply Raspberry Pi 5 Optimizations with English Language

echo "🚀 Applying Raspberry Pi 5 Optimizations..."

# خطوة 1: إيقاف RetroArch إذا كان يعمل
echo "⏹️ Stopping RetroArch processes..."
sudo killall retroarch 2>/dev/null || true
sudo killall emulationstation 2>/dev/null || true

# خطوة 2: نسخ احتياطي للإعدادات الحالية
echo "💾 Creating backup of current settings..."
mkdir -p ~/.config/retroarch/backups
if [[ -f ~/.config/retroarch/retroarch.cfg ]]; then
    cp ~/.config/retroarch/retroarch.cfg ~/.config/retroarch/backups/retroarch.cfg.backup_$(date +%Y%m%d_%H%M%S)
    echo "✅ Backup created"
else
    echo "ℹ️ No existing config found"
fi

# خطوة 3: إنشاء المجلدات المطلوبة
echo "📁 Creating required directories..."
mkdir -p ~/.config/retroarch/{system,assets,states,saves,screenshots,recordings,autoconfig,playlists,database,shaders,overlays,wallpapers,thumbnails}

# خطوة 4: تطبيق الإعدادات المُحسنة
echo "⚙️ Applying optimized configuration for Raspberry Pi 5..."

cat > ~/.config/retroarch/retroarch.cfg << 'EOF'
# =============================================================================
# RETROARCH OPTIMIZED CONFIGURATION FOR RASPBERRY PI 5 - ENGLISH
# أقصى أداء وجودة للراسبيري باي 5 - باللغة الإنجليزية
# =============================================================================

# === VIDEO SETTINGS - إعدادات الفيديو المُحسنة ===
video_driver = "vulkan"
video_width = 1920
video_height = 1080
video_fullscreen = true
video_windowed_fullscreen = false
video_vsync = true
video_hard_sync = true
video_hard_sync_frames = 2
video_frame_delay = 0
video_max_swapchain_images = 3
video_swap_interval = 1
video_adaptive_vsync = false
video_threaded = true

# Visual Quality Settings
video_smooth = true
video_force_aspect = true
video_scale_integer = false
video_aspect_ratio_auto = true
video_crop_overscan = true
video_rotation = 0

# Shaders for enhanced visuals
video_shader_enable = true
video_shader_dir = "~/.config/retroarch/shaders"

# === AUDIO SETTINGS - إعدادات الصوت عالية الجودة ===
audio_driver = "alsa"
audio_enable = true
audio_mute_enable = false
audio_out_rate = 48000
audio_latency = 32
audio_sync = true
audio_max_timing_skew = 0.05
audio_volume = 0.0
audio_mixer_volume = 0.0
audio_rate_control = true
audio_rate_control_delta = 0.005

# === INPUT SETTINGS - إعدادات التحكم المُحسنة ===
input_driver = "udev"
input_joypad_driver = "udev"
input_autodetect_enable = true
input_autoconfigure_joypad_init = true
input_analog_deadzone = 0.10
input_analog_sensitivity = 1.0

# Hotkeys for quick access
input_exit_emulator = "escape"
input_menu_toggle = "f1"
input_load_state = "f4"
input_save_state = "f2"
input_state_slot_increase = "f7"
input_state_slot_decrease = "f6"
input_reset = "f9"
input_screenshot = "f8"
input_pause_toggle = "p"
input_hold_fast_forward = "space"

# === MENU SETTINGS - واجهة Ozone الحديثة ===
menu_driver = "ozone"
menu_unified_controls = true
menu_mouse_enable = true
menu_pointer_enable = true
menu_timedate_enable = true
menu_battery_level_enable = true
menu_core_enable = true
menu_pause_libretro = true
menu_show_start_screen = false

# Ozone theme settings
menu_ozone_color_theme = 1
menu_ozone_collapse_sidebar = false
menu_ozone_thumbnail_scale_factor = 1.0

# === LANGUAGE SETTINGS - اللغة الإنجليزية ===
user_language = 0
menu_unicode_enable = true

# === FONT SETTINGS - خطوط واضحة ===
menu_font_size = 18.0
menu_font_color_red = 255
menu_font_color_green = 255
menu_font_color_blue = 255

# === DIRECTORY SETTINGS ===
system_directory = "~/.config/retroarch/system"
core_assets_directory = "~/.config/retroarch/assets"
assets_directory = "~/.config/retroarch/assets"
savestate_directory = "~/.config/retroarch/states"
savefile_directory = "~/.config/retroarch/saves"
screenshot_directory = "~/.config/retroarch/screenshots"
joypad_autoconfig_dir = "~/.config/retroarch/autoconfig"
playlist_directory = "~/.config/retroarch/playlists"
thumbnails_directory = "~/.config/retroarch/thumbnails"

# === PERFORMANCE SETTINGS - تحسينات الأداء لـ Pi 5 ===
rewind_enable = false
run_ahead_enabled = true
run_ahead_frames = 1
run_ahead_secondary_instance = false
pause_nonactive = true

# Save states optimization
savestate_auto_save = true
savestate_auto_load = true
savestate_auto_index = true
savestate_thumbnail_enable = true
savestate_file_compression = true

# Speed settings
fastforward_ratio = 8.0
slowmotion_ratio = 3.0

# === NETWORK SETTINGS ===
netplay_enable = true
netplay_public_announce = false
netplay_nat_traversal = true

# === ACHIEVEMENTS ===
cheevos_enable = true
cheevos_hardcore_mode_enable = false
cheevos_leaderboards_enable = true
cheevos_auto_screenshot = true

# === RASPBERRY PI 5 SPECIFIC OPTIMIZATIONS ===
video_gpu_record = true
video_gpu_screenshot = true
video_shared_context = false

# === MISC SETTINGS ===
config_save_on_exit = true
fps_show = false
memory_show = false
auto_remaps_enable = true
auto_overrides_enable = true

EOF

# خطوة 5: ضبط الأذونات
echo "🔐 Setting correct permissions..."
chmod -R 755 ~/.config/retroarch/
chmod 644 ~/.config/retroarch/retroarch.cfg

# خطوة 6: تحديث إعدادات النظام للـ Pi 5
echo "🔧 Updating system settings for Pi 5..."

# زيادة ذاكرة GPU
if [[ -f /boot/firmware/config.txt ]]; then
    # للـ Pi 5 الجديد
    if ! grep -q "gpu_mem" /boot/firmware/config.txt; then
        echo "gpu_mem=256" | sudo tee -a /boot/firmware/config.txt
        echo "✅ GPU memory increased to 256MB"
    fi
elif [[ -f /boot/config.txt ]]; then
    # للإصدارات الأقدم
    if ! grep -q "gpu_mem" /boot/config.txt; then
        echo "gpu_mem=256" | sudo tee -a /boot/config.txt
        echo "✅ GPU memory increased to 256MB"
    fi
fi

# تحسين إعدادات الذاكرة
if ! grep -q "vm.swappiness=10" /etc/sysctl.conf; then
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
    echo "✅ Memory optimization applied"
fi

# خطوة 7: تثبيت أو تحديث RetroArch للـ Pi 5
echo "📦 Updating RetroArch for Pi 5..."
sudo apt update
sudo apt install -y retroarch retroarch-assets

# تثبيت النوى المُحسنة
echo "🎮 Installing optimized cores..."
sudo apt install -y \
    libretro-nestopia \
    libretro-snes9x \
    libretro-gambatte \
    libretro-mgba \
    libretro-genesis-plus-gx \
    libretro-pcsx-rearmed \
    libretro-stella \
    libretro-mame \
    libretro-fbneo \
    libretro-beetle-psx

# خطوة 8: تحميل شيدرز عالية الجودة (اختياري)
echo "🎨 Downloading high-quality shaders..."
cd ~/.config/retroarch/
if [[ ! -d "shaders" ]]; then
    git clone --depth 1 https://github.com/libretro/slang-shaders.git shaders/ 2>/dev/null || {
        echo "⚠️ Could not download shaders (internet required)"
    }
fi

# خطوة 9: تحميل أصول إضافية
echo "📥 Downloading additional assets..."
cd ~/.config/retroarch/assets/
wget -O fonts/font.ttf "https://github.com/libretro/common-shaders/raw/master/xmb/monospace.ttf" 2>/dev/null || echo "تخطي تحميل الخط"

# خطوة 10: اختبار الإعدادات
echo "🧪 Testing configuration..."

# التحقق من وجود RetroArch
if command -v retroarch &> /dev/null; then
    echo "✅ RetroArch found: $(retroarch --version | head -1)"
else
    echo "❌ RetroArch not found"
    exit 1
fi

# التحقق من ملف الإعدادات
if [[ -f ~/.config/retroarch/retroarch.cfg ]]; then
    echo "✅ Configuration file created successfully"
    
    # التحقق من اللغة الإنجليزية
    if grep -q "user_language = 0" ~/.config/retroarch/retroarch.cfg; then
        echo "✅ Language set to English"
    else
        echo "⚠️ Language setting issue"
    fi
    
    # التحقق من تعريف الفيديو
    if grep -q "video_driver = \"vulkan\"" ~/.config/retroarch/retroarch.cfg; then
        echo "✅ Vulkan driver enabled for better performance"
    fi
    
else
    echo "❌ Configuration file not found"
    exit 1
fi

# التحقق من النوى
cores_count=$(ls /usr/lib/*/libretro/*.so 2>/dev/null | wc -l)
if [[ $cores_count -gt 0 ]]; then
    echo "✅ Found $cores_count cores installed"
else
    echo "⚠️ No cores found"
fi

echo ""
echo "🎉 ============================================ 🎉"
echo "     RASPBERRY PI 5 OPTIMIZATION COMPLETE!     "
echo "     تم تحسين الراسبيري باي 5 بنجاح!           "
echo "🎉 ============================================ 🎉"
echo ""
echo "✅ RetroArch optimized for Raspberry Pi 5"
echo "✅ Language set to English"
echo "✅ Vulkan driver enabled"
echo "✅ High-quality audio (48kHz)"
echo "✅ Performance enhancements applied"
echo "✅ GPU memory optimized"
echo "✅ Run-ahead enabled for lower latency"
echo ""
echo "🚀 To launch RetroArch:"
echo "   retroarch --menu"
echo ""
echo "🎮 To test with a core:"
echo "   retroarch -L /usr/lib/*/libretro/snes9x_libretro.so --menu"
echo ""
echo "📋 Configuration backup saved in:"
echo "   ~/.config/retroarch/backups/"
echo ""
echo "🔄 Reboot recommended for GPU memory changes:"
echo "   sudo reboot"
echo ""
echo "🎊 Enjoy your optimized gaming experience!"
