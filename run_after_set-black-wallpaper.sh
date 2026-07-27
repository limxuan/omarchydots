#!/usr/bin/env bash
set -euo pipefail

# 1. Ensure Omarchy theme is initialized (prevents line 13 hyprland.conf missing file errors)
if [[ ! -f "$HOME/.config/omarchy/current/theme/hyprland.conf" ]]; then
    omarchy-theme-set tokyo-night
fi

BG_DIR="$HOME/.config/omarchy/current/theme/backgrounds"
BG_LINK="$HOME/.config/omarchy/current/background"

mkdir -p "$BG_DIR"

# 2. Generate 1x1 solid black PNG wallpaper
python3 -c "
import struct, zlib

width, height = 1, 1
raw_data = b'\x00\x00\x00\x00'
def chunk(two_type, data):
    return struct.pack('>I', len(data)) + two_type + data + struct.pack('>I', zlib.crc32(two_type + data) & 0xffffffff)

header = b'\x89PNG\r\n\x1a\n'
ihdr = chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0))
idat = chunk(b'IDAT', zlib.compress(raw_data))
iend = chunk(b'IEND', b'')
png_data = header + ihdr + idat + iend

with open('$BG_DIR/black.png', 'wb') as f:
    f.write(png_data)
"

# Remove all other default wallpapers from omarchy theme background folder
find "$BG_DIR" -type f ! -name "black.png" -delete

# Force symlink omarchy background to black.png
rm -f "$BG_LINK"
ln -sf "$BG_DIR/black.png" "$BG_LINK"

# Reload background if active
if command -v omarchy-theme-bg-set &>/dev/null; then
    omarchy-theme-bg-set "$BG_LINK" 2>/dev/null || true
fi

echo "[+] Theme verified (tokyo-night) and black wallpaper set by chezmoi."
