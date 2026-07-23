#!/usr/bin/env bash
set -euo pipefail

echo "[+] Configuring Bitwarden..."

# --- Create autostart entry (start automatically on login) ---
echo "  Creating autostart entry..."
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/bitwarden.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Bitwarden
Comment=Bitwarden Password Manager
Exec=/usr/bin/bitwarden --autostart
Icon=bitwarden
Terminal=false
Categories=Utility;
X-GNOME-Autostart-enabled=true
EOF

# --- Set SSH_AUTH_SOCK for Bitwarden SSH Agent ---
echo "  Configuring SSH agent socket..."
FISH_CONFIG="$HOME/.config/fish/config.fish"
SSH_SOCK_LINE='set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"'

if [ -f "$FISH_CONFIG" ]; then
    if ! grep -q "bitwarden-ssh-agent" "$FISH_CONFIG" 2>/dev/null; then
        echo "" >> "$FISH_CONFIG"
        echo "# Bitwarden SSH Agent" >> "$FISH_CONFIG"
        echo "$SSH_SOCK_LINE" >> "$FISH_CONFIG"
        echo "    Added SSH_AUTH_SOCK to fish config"
    else
        echo "    SSH_AUTH_SOCK already configured"
    fi
else
    mkdir -p "$(dirname "$FISH_CONFIG")"
    echo "$SSH_SOCK_LINE" > "$FISH_CONFIG"
    echo "    Created fish config with SSH_AUTH_SOCK"
fi

echo ""
echo "[+] Bitwarden configuration complete!"
echo "    - Autostart: ~/.config/autostart/bitwarden.desktop"
echo "    - SSH Agent: SSH_AUTH_SOCK set in fish config"
echo ""
echo "    NOTE: Enable SSH agent and tray icon manually in Bitwarden Settings."
echo "          These cannot be set programmatically (stored in system keyring)."
