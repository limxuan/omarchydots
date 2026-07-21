#!/usr/bin/env bash
set -e

echo "[+] Starting bootstrap..."

# --- Package installation ----------------------------------------------------
echo "[+] Installing pacman packages..."
sudo pacman -S --needed --noconfirm - < "$HOME/.local/share/chezmoi/dot_config/omarchy/packages/pacman.txt"

if ! command -v yay &>/dev/null; then
  echo "[+] Installing yay..."
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
fi

echo "[+] Installing AUR packages with yay..."
yay -S --needed --noconfirm - < "$HOME/.local/share/chezmoi/dot_config/omarchy/packages/aur.txt"

# --- Setup keyd (system-level) ----------------------------------------------
echo "[+] Setting up keyd..."
sudo cp "$HOME/.local/share/chezmoi/dot_etc/keyd/default.conf" /etc/keyd/default.conf
sudo cp "$HOME/.local/share/chezmoi/dot_etc/libinput/local-overrides.quirks" /etc/libinput/local-overrides.quirks
sudo systemctl enable --now keyd.service

# --- Apply chezmoi (symlinks user configs) -----------------------------------
echo "[+] Applying chezmoi configs..."
chezmoi apply --force

# --- Inject hyprland configs (defaults + your deltas) -----------------------
echo "[+] Injecting hyprland configs..."
mkdir -p "$HOME/.config/hypr/deltas"
cp "$HOME/.local/share/chezmoi/dot_config/hypr/deltas/"* "$HOME/.config/hypr/deltas/" 2>/dev/null || true
python3 "$HOME/.local/share/chezmoi/dot_config/hypr/inject.py"

# --- Setup desktop entries ---------------------------------------------------
echo "[+] Setting up desktop entries..."
bash "$HOME/.local/share/chezmoi/run_onchange_setup-desktop-entries.sh"

# --- Restart Waybar safely ---------------------------------------------------
echo "[+] Restarting Waybar..."
pkill waybar || true
waybar > ~/.cache/waybar.log 2>&1 & disown

# --- Reboot prompt -----------------------------------------------------------
echo
echo "[i] A reboot is recommended for keyd, compositor, and desktop changes."
read -rp "Reboot now to apply all changes? [y/N]: " answer

case "$answer" in
  [yY]|[yY][eE][sS])
    echo "[+] Rebooting..."
    sudo reboot
    ;;
  *)
    echo "[i] Reboot skipped. You may need to reboot manually later."
    ;;
esac
