#!/usr/bin/env bash
set -euo pipefail

REPO_URL="git@github.com:limxuan/omarchydots.git"
CHEZMOI_DIR="$HOME/.local/share/chezmoi"

echo "╔══════════════════════════════════════╗"
echo "║   Omarchy Dotfiles Bootstrap        ║"
echo "╚══════════════════════════════════════╝"
echo

# --- Install base dependencies ---
echo "[1/4] Installing base dependencies..."
if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm git chezmoi
elif command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y git curl
    # Install chezmoi via official script on Debian/Ubuntu
    if ! command -v chezmoi &>/dev/null; then
        sh -c "$(curl -fsLS get.chezmoi.io)"
    fi
elif command -v dnf &>/dev/null; then
    sudo dnf install -y git chezmoi
else
    echo "[!] Unknown package manager. Install git and chezmoi manually."
    exit 1
fi

echo "[2/4] Cloning dotfiles..."
if [ -d "$CHEZMOI_DIR" ]; then
    echo "    chezmoi dir already exists, pulling latest..."
    git -C "$CHEZMOI_DIR" pull --ff-only || true
else
    chezmoi init --apply "$REPO_URL"
fi

echo "[3/4] Applying dotfiles..."
chezmoi apply --force

echo "[4/4] Done!"
echo
echo "┌──────────────────────────────────────┐"
echo "│  Dotfiles applied successfully!      │"
echo "│                                      │"
echo "│  You may want to:                    │"
echo "│  - Reboot for keyd changes           │"
echo "│  - Set up Groq API key for dictation │"
echo "│    (see docs/SERVICES_SETUP_GUIDE.md)│"
echo "└──────────────────────────────────────┘"
