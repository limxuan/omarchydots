#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/limxuan/omarchydots.git"
CHEZMOI_DIR="$HOME/.local/share/chezmoi"

echo "╔══════════════════════════════════════╗"
echo "║   Omarchy Dotfiles Bootstrap        ║"
echo "╚══════════════════════════════════════╝"
echo

# --- Install base dependencies ---
echo "[1/4] Installing base dependencies..."
if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm git chezmoi curl python
elif command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y git curl python3
    if ! command -v chezmoi &>/dev/null; then
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
        export PATH="$HOME/.local/bin:$PATH"
    fi
elif command -v dnf &>/dev/null; then
    sudo dnf install -y git chezmoi curl python3
else
    if ! command -v git &>/dev/null; then
        echo "[!] Git is required. Please install git and retry."
        exit 1
    fi
    if ! command -v chezmoi &>/dev/null; then
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
        export PATH="$HOME/.local/bin:$PATH"
    fi
fi

echo "[2/4] Initializing dotfiles via HTTPS..."
if [ -d "$CHEZMOI_DIR/.git" ]; then
    echo "    chezmoi dir already exists, pulling latest..."
    git -C "$CHEZMOI_DIR" pull --ff-only || true
else
    chezmoi init --apply "$REPO_URL"
fi

echo "[3/4] Applying dotfiles & setup hooks..."
chezmoi apply --force

echo "[4/4] Done!"
echo "┌────────────────────────────────────────────────────────────┐"
echo "│  Dotfiles applied successfully!                            │"
echo "│  Theme: tokyo-night                                        │"
echo "│  Wallpaper: Solid Black                                    │"
echo "└────────────────────────────────────────────────────────────┘"
