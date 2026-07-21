#!/usr/bin/env bash
set -e

cd "$(dirname "$(realpath "$0")")"

echo "[+] Installing packages..."

[[ -f packages/pacman.txt ]] || { echo "[!] Missing packages/pacman.txt"; exit 1; }
[[ -f packages/aur.txt ]]    || { echo "[!] Missing packages/aur.txt"; exit 1; }

echo "[+] Installing pacman packages..."
sudo pacman -S --needed --noconfirm - < packages/pacman.txt

if ! command -v yay &>/dev/null; then
  echo "[+] Installing yay..."
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
fi

echo "[+] Installing AUR packages with yay..."
yay -S --needed --noconfirm - < packages/aur.txt

echo "[+] Setting up desktop entries..."
./setup-desktop-entries.sh

echo "[+] All packages installed."
