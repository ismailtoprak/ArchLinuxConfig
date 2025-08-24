#!/bin/bash
echo "===================================="
echo "Pacman (resmi repo) paketleri"
echo "===================================="
pacman -Qent

echo
echo "===================================="
echo "AUR / Foreign paketler"
echo "===================================="
pacman -Qm

echo
echo "===================================="
echo "Flatpak paketleri"
echo "===================================="
flatpak list --app

