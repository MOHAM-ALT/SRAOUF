# أوامر تحديث SRAOUF من GitHub على Raspberry Pi
# GitHub Update Commands for SRAOUF on Raspberry Pi

# ===============================================
# الطريقة الأولى: تحديث المشروع الموجود
# Method 1: Update Existing Project
# ===============================================

# 1. الانتقال لمجلد المشروع
cd ~/SRAOUF

# 2. التحقق من حالة Git
echo "🔍 Checking Git status..."
git status

# 3. حفظ أي تغييرات محلية (إذا وجدت)
echo "💾 Saving local changes..."
git stash push -m "Local changes backup $(date)"

# 4. جلب أحدث التغييرات من GitHub
echo "📥 Fetching latest updates from GitHub..."
git fetch origin

# 5. التحقق من الفروق بين النسخة المحلية والبعيدة
echo "📊 Checking differences..."
git diff HEAD origin/main --name-only

# 6. دمج التحديثات
echo "🔄 Merging updates..."
git pull origin main

# 7. التحقق من النجاح
if [[ $? -eq 0 ]]; then
    echo "✅ Update successful!"
else
    echo "❌ Update failed!"
    exit 1
fi

# ===============================================
# الطريقة الثانية: تحديث قسري (في حالة التعارض)
# Method 2: Force Update (In case of conflicts)
# ===============================================

# إذا فشلت الطريقة الأولى، استخدم هذه الأوامر:

# 1. نسخ احتياطي للملفات المهمة
echo "📦 Creating backup..."
cp -r ~/SRAOUF ~/SRAOUF_backup_$(date +%Y%m%d_%H%M%S)

# 2. إعادة تعيين قوي للمستودع
echo "🔄 Force reset to GitHub version..."
git fetch origin
git reset --hard origin/main

# 3. تنظيف الملفات غير المتتبعة
git clean -fd

# ===============================================
# الطريقة الثالثة: تثبيت جديد تماماً
# Method 3: Fresh Installation
# ===============================================

# إذا كانت هناك مشاكل كثيرة، احذف كل شيء وابدأ من جديد:

# 1. حذف المجلد القديم
echo "🗑️ Removing old installation..."
rm -rf ~/SRAOUF

# 2. تثبيت جديد من GitHub
echo "📥 Fresh clone from GitHub..."
git clone https://github.com/MOHAM-ALT/SRAOUF.git ~/SRAOUF

# 3. الانتقال للمجلد الجديد
cd ~/SRAOUF

# ===============================================
# فحص شامل بعد التحديث
# Comprehensive Check After Update
# ===============================================

echo "🧪 Running post-update checks..."

# 1. التحقق من وجود الملفات الرئيسية
echo "📁 Checking main files..."
files_to_check=(
    "install.sh"
    "scripts/fix_problems.sh"
    "scripts/setup_controller.sh"
    "configs/es_systems.cfg"
    "configs/retroarch.cfg"
    "README.md"
)

for file in "${files_to_check[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file - Found"
    else
        echo "❌ $file - Missing!"
    fi
done

# 2. التحقق من الأذونات
echo "🔐 Checking permissions..."
chmod +x install.sh
chmod +x scripts/*.sh 2>/dev/null || true
chmod 644 configs/*.cfg 2>/dev/null || true

# 3. التحقق من تركيب الملفات
echo "🔧 Checking file syntax..."
bash -n install.sh && echo "✅ install.sh syntax OK" || echo "❌ install.sh syntax error"
bash -n scripts/fix_problems.sh && echo "✅ fix_problems.sh syntax OK" || echo "❌ fix_problems.sh syntax error"

# 4. التحقق من ملف XML
if command -v xmllint &> /dev/null; then
    xmllint configs/es_systems.cfg > /dev/null && echo "✅ es_systems.cfg XML OK" || echo "❌ es_systems.cfg XML error"
else
    echo "⚠️ xmllint not available - skipping XML check"
fi

# 5. عرض معلومات المشروع المحدث
echo ""
echo "📊 Updated Project Information:"
echo "Git commit: $(git rev-parse --short HEAD)"
echo "Last update: $(git log -1 --format='%cd' --date=format:'%Y-%m-%d %H:%M:%S')"
echo "Branch: $(git branch --show-current)"
echo "Files count: $(find . -type f | wc -l)"
echo ""

# ===============================================
# أوامر سريعة للتنفيذ المباشر
# Quick Commands for Direct Execution
# ===============================================

# الأمر الشامل الواحد - انسخ والصق هذا:
echo "🚀 One-command update (copy and paste this):"
echo 'cd ~/SRAOUF && git stash && git fetch origin && git pull origin main && chmod +x install.sh scripts/*.sh && echo "✅ SRAOUF Updated Successfully!"'

# أو هذا الأمر للتحديث القسري:
echo ""
echo "💥 Force update command (if above fails):"
echo 'cd ~/SRAOUF && git fetch origin && git reset --hard origin/main && git clean -fd && chmod +x install.sh scripts/*.sh && echo "✅ SRAOUF Force Updated!"'

# أو هذا للتثبيت الجديد:
echo ""
echo "🆕 Fresh installation command:"
echo 'rm -rf ~/SRAOUF && git clone https://github.com/MOHAM-ALT/SRAOUF.git ~/SRAOUF && cd ~/SRAOUF && chmod +x install.sh scripts/*.sh && echo "✅ SRAOUF Fresh Installation Complete!"'
