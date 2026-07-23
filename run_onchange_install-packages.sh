#!/usr/bin/env bash
set -e

CHEZMOI_SRC="$HOME/.local/share/chezmoi"
PACKAGES_DIR="${CHEZMOI_SRC}/dot_config/omarchy/packages"

echo "[+] Installing packages..."

[[ -f "${PACKAGES_DIR}/pacman.txt" ]] || { echo "[!] Missing packages/pacman.txt"; exit 1; }
[[ -f "${PACKAGES_DIR}/aur.txt" ]]    || { echo "[!] Missing packages/aur.txt"; exit 1; }

echo "[+] Installing pacman packages..."
sudo pacman -S --needed --noconfirm - < "${PACKAGES_DIR}/pacman.txt"

if ! command -v yay &>/dev/null; then
  echo "[+] Installing yay..."
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
fi

echo "[+] Installing AUR packages with yay..."
yay -S --needed --noconfirm - < "${PACKAGES_DIR}/aur.txt"

echo "[+] Setting up desktop entries..."
bash "${CHEZMOI_SRC}/run_onchange_setup-desktop-entries.sh"

echo "[+] All packages installed."
