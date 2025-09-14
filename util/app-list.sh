#!/bin/bash
# Kurulu paketleri listeleyip app-list.txt dosyasına kaydeder

out_file="app-list.txt"
: > "$out_file"   # dosyayı sıfırla

# Pacman (resmi repo)
pacman -Qent | awk '{print "pacman:" $1}' >> "$out_file"

# AUR / Foreign
pacman -Qm | awk '{print "aur:" $1}' >> "$out_file"

# Flatpak
flatpak list --app --columns=application | awk '{print "flatpak:" $1}' >> "$out_file"

echo "✅ Paket listesi '$out_file' dosyasına yazıldı."
