#!/bin/bash
# Paket Listesi Asistanı (Sıralı Karşılaştırıcı - Blacklist YOK)

# Betiğin bulunduğu dizine geç
cd "$(dirname "$0")"

APP_LIST="app-list.txt"

if [[ ! -f "$APP_LIST" ]]; then 
    echo "❌ $APP_LIST bulunamadı!"
    exit 1
fi

echo "🔍 Sistem ile $APP_LIST karşılaştırılıyor (Tüm paketler)..."

# 1. Sistem paketlerini tara ve grupla
(pacman -Qeq ; pacman -Qqg plasma kde-applications 2>/dev/null) | sort -u > p.tmp
pacman -Qmq | sort -u > a.tmp

# Tür etiketlerini ekle
awk '{print "pacman:" $1}' p.tmp > p2.tmp
awk '{print "aur:" $1}' a.tmp > a2.tmp

# Flatpak varsa işle, yoksa boş dosya oluştur
if command -v flatpak &> /dev/null; then
    flatpak list --app --columns=application | tail -n +1 | sort -u > f.tmp
    awk '{print "flatpak:" $1}' f.tmp > f2.tmp
else
    touch f.tmp f2.tmp
fi

# Birleşik sistem listesi
cat p2.tmp a2.tmp f2.tmp > sys.tmp

# 2. Farkları ayıkla
NEW_APPS=$(grep -vFf "$APP_LIST" sys.tmp)
MISSING_APPS=$(grep -vFf sys.tmp "$APP_LIST")

# Sonuçları Göster (Pacman -> AUR -> Flatpak sırasıyla)
echo -e "\n--- ✨ YENİ PAKET ÖNERİLERİ (Sistemde var, listede yok) ---"
if [[ -n "$NEW_APPS" ]]; then
    echo "$NEW_APPS" | grep "^pacman:"
    echo "$NEW_APPS" | grep "^aur:"
    echo "$NEW_APPS" | grep "^flatpak:"
    echo -e "\n💡 İpucu: Bunlar sisteminde yüklü ama $APP_LIST dosyasında yok."
else
    echo "✅ Liste güncel (Yeni öneri yok)."
fi

echo -e "\n--- ❓ LİSTEDEKİ EKSİK PAKETLER (Dosyada var, sistemde yok) ---"
if [[ -n "$MISSING_APPS" ]]; then
    echo "$MISSING_APPS"
else
    echo "✅ Listedeki tüm paketler sistemde yüklü."
fi

rm -f p.tmp a.tmp f.tmp p2.tmp a2.tmp f2.tmp sys.tmp