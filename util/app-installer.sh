#!/bin/bash
# app-list.txt dosyasını okuyup paketleri topluca yükler

in_file="app-list.txt"

if [[ ! -f "$in_file" ]]; then
   echo -e "❌ Hata: '$in_file' bulunamadı. Önce app-list.sh çalıştır."
   exit 1
fi

# Paket listelerini tutacak diziler
pacman_pkgs=()
aur_pkgs=()
flatpak_pkgs=()

# Dosyayı oku ve ilgili diziye ekle
while IFS=: read -r source pkg; do
   case "$source" in
      pacman)
         pacman_pkgs+=("$pkg")
         ;;
      aur)
         aur_pkgs+=("$pkg")
         ;;
      flatpak)
         flatpak_pkgs+=("$pkg")
         ;;
      *)
         echo -e "⚠️ Bilinmeyen kaynak: $source ($pkg)"
         ;;
   esac
done < "$in_file"

# Pacman paketlerini kur
if [[ ${#pacman_pkgs[@]} -gt 0 ]]; then
   echo -e "📦 Pacman ile kuruluyor: ${pacman_pkgs[*]}"
   sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"
fi

# AUR paketlerini kur (yay)
if [[ ${#aur_pkgs[@]} -gt 0 ]]; then
   echo -e "📦 AUR (yay) ile kuruluyor: ${aur_pkgs[*]}"
   yay -S --needed --noconfirm "${aur_pkgs[@]}"
fi

# Flatpak paketlerini kur
if [[ ${#flatpak_pkgs[@]} -gt 0 ]]; then
   echo -e "📦 Flatpak ile kuruluyor: ${flatpak_pkgs[*]}"
   flatpak install -y "${flatpak_pkgs[@]}"
fi

echo -e "✅ Tüm paketler işlendi."
