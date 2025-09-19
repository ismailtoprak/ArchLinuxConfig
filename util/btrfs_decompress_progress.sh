#!/bin/bash

# Renkler
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

# Root kontrolü
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Lütfen scripti root olarak çalıştırın:${NC} sudo ./btrfs_decompress_progress.sh"
   exit 1
fi

# Disk UUID'sini otomatik bul (nvme1n1p2 varsayıldı)
UUID=$(blkid -s UUID -o value /dev/nvme1n1p2)
if [ -z "$UUID" ]; then
    echo -e "${RED}UUID bulunamadı. Disk adını kontrol edin.${NC}"
    exit 1
fi

# Altvolümler listesi
SUBVOLS=("/" "/.snapshots" "/var/cache/pacman/pkg" "/home" "/var/log")

echo -e "${YELLOW}1. /etc/fstab yedeği alınıyor...${NC}"
cp /etc/fstab /etc/fstab.btrfs_decompress.bak

echo -e "${YELLOW}2. /etc/fstab güncelleniyor...${NC}"
for VOL in "${SUBVOLS[@]}"; do
    SUBVOL_NAME=$(mount | grep "on $VOL " | sed -n 's/.*subvol=\([^,]*\).*/\1/p')
    if [ -z "$SUBVOL_NAME" ]; then
        echo -e "${RED}Altvolüm bulunamadı: $VOL${NC}"
        continue
    fi

    grep -q "$VOL" /etc/fstab
    if [ $? -eq 0 ]; then
        sed -i "/$VOL/ s/compress=[^, ]*/compress=no/" /etc/fstab
    else
        echo "UUID=$UUID $VOL btrfs defaults,noatime,ssd,discard=async,space_cache=v2,subvol=$SUBVOL_NAME,compress=no 0 0" >> /etc/fstab
    fi
done

echo -e "${YELLOW}3. Altvolümler yeniden mount ediliyor (compress=no ile)...${NC}"
for VOL in "${SUBVOLS[@]}"; do
    echo -e "${GREEN}Remounting: $VOL${NC}"
    mount -o remount,compress=no "$VOL"
done

echo -e "${YELLOW}4. Var olan dosyalar decompress ediliyor...${NC}"
for VOL in "${SUBVOLS[@]}"; do
    echo -e "${GREEN}Decompress: $VOL${NC}"
    btrfs filesystem defragment -r -v -c no "$VOL" | while read line; do
        echo -e "${GREEN}$line${NC}"
    done
    echo -e "${YELLOW}✔ $VOL tamamlandı${NC}"
done

echo -e "${GREEN}✅ Tüm altvolümler artık sıkıştırmasız ve mevcut dosyalar açığa çıkarıldı.${NC}"
echo -e "${YELLOW}Yedek fstab: /etc/fstab.btrfs_decompress.bak${NC}"
