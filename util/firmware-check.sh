#!/bin/bash
# firmware-check.sh

# Kernel log'dan kullanılan firmware'leri al
USED=$(dmesg | grep -i "firmware" | awk '{print $NF}' | sort -u)

# Sistemdeki tüm firmware dosyalarını bul
ALL=$(find /usr/lib/firmware -type f | sort)

echo "=== Kullanılan firmware dosyaları ==="
echo "$USED"
echo

echo "=== Muhtemelen kullanılmayan firmware dosyaları ==="
comm -23 <(echo "$ALL") <(echo "$USED" | sed 's#^#/usr/lib/firmware/#')
