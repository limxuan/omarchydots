#!/usr/bin/env bash
set -euo pipefail

# Always run from repo root
cd "$(dirname "$(realpath "$0")")"

DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$DESKTOP_DIR/icons"
mkdir -p "$ICON_DIR"

# Declare defaults so set -u is happy if an array is missing from apps.sh
declare -a webapps=() tui_apps=() omarchy_shortcuts=() custom_entries=()
source packages/apps.sh

# =============================================================================
# 1. Web Apps
# =============================================================================
if (( ${#webapps[@]} > 0 )); then
  echo "[+] Installing web app desktop entries..."

  if ! command -v omarchy-webapp-install &>/dev/null; then
    echo "[!] omarchy-webapp-install not found — skipping web apps"
  else
    for entry in "${webapps[@]}"; do
      IFS='|' read -r name url icon_url custom_exec mime_types <<< "$entry"
      echo "    $name"

      # Download favicon to local cache (non-fatal on failure)
      local_icon="$ICON_DIR/$name.png"
      curl -fsSL -o "$local_icon" "$icon_url" 2>/dev/null || true

      if [[ -s $local_icon ]]; then
        omarchy-webapp-install "$name" "$url" "$name.png" \
          "${custom_exec:+$custom_exec}" \
          "${mime_types:+$mime_types}"
      else
        omarchy-webapp-install "$name" "$url" "" \
          "${custom_exec:+$custom_exec}" \
          "${mime_types:+$mime_types}" 2>/dev/null || {
          # Fallback: generate minimal desktop entry without icon
          exec_cmd="${custom_exec:-omarchy-launch-webapp $url}"
          desktop_file="$DESKTOP_DIR/$name.desktop"
          cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Name=$name
Exec=$exec_cmd
Terminal=false
Type=Application
StartupNotify=true
EOF
          chmod +x "$desktop_file"
        }
      fi
    done
  fi
fi

# =============================================================================
# 2. TUI Apps (launched in a terminal)
# =============================================================================
if (( ${#tui_apps[@]} > 0 )); then
  echo "[+] Installing TUI desktop entries..."

  for entry in "${tui_apps[@]}"; do
    IFS='|' read -r name command icon terminal_class <<< "$entry"

    # If the command needs multi-statement handling, wrap in bash -c
    if [[ $command == *";"* || $command == *"&&"* || $command == *"||"* ]]; then
      exec_cmd='$TERMINAL --class='"$terminal_class"' -e bash -c '"'$command'"
    else
      exec_cmd='$TERMINAL --class='"$terminal_class"' -e '"$command"
    fi

    desktop_file="$DESKTOP_DIR/$name.desktop"
    cat > "$desktop_file" << DESKTOP_EOF
[Desktop Entry]
Version=1.0
Name=$name
Exec=$exec_cmd
Terminal=false
Type=Application
Icon=$ICON_DIR/$icon
StartupNotify=true
DESKTOP_EOF
    chmod +x "$desktop_file"
    echo "    $name"
  done
fi

# =============================================================================
# 3. Omarchy Built-in Shortcuts
# =============================================================================
if (( ${#omarchy_shortcuts[@]} > 0 )); then
  echo "[+] Installing omarchy shortcut desktop entries..."

  for entry in "${omarchy_shortcuts[@]}"; do
    IFS='|' read -r filename name exec_cmd icon categories <<< "$entry"

    desktop_file="$DESKTOP_DIR/$filename.desktop"
    cat > "$desktop_file" << DESKTOP_EOF
[Desktop Entry]
Version=1.0
Name=$name
Exec=$exec_cmd
Terminal=false
Type=Application
DESKTOP_EOF

    if [[ -n $icon ]]; then
      echo "Icon=$ICON_DIR/$icon" >> "$desktop_file"
    fi

    if [[ -n $categories ]]; then
      echo "Categories=$categories" >> "$desktop_file"
    fi

    chmod +x "$desktop_file"
    echo "    $name"
  done
fi

# =============================================================================
# 4. Custom Desktop Entries
# =============================================================================
if (( ${#custom_entries[@]} > 0 )); then
  echo "[+] Installing custom desktop entries..."

  for entry in "${custom_entries[@]}"; do
    IFS='|' read -r filename name exec_cmd icon categories mime_types comment nodisplay <<< "$entry"

    desktop_file="$DESKTOP_DIR/$filename.desktop"
    cat > "$desktop_file" << DESKTOP_EOF
[Desktop Entry]
Version=1.0
Name=$name
Exec=$exec_cmd
Terminal=false
Type=Application
DESKTOP_EOF

    if [[ -n $icon ]]; then
      echo "Icon=$icon" >> "$desktop_file"
    fi

    if [[ -n $categories ]]; then
      echo "Categories=$categories" >> "$desktop_file"
    fi

    if [[ -n $mime_types ]]; then
      echo "MimeType=$mime_types" >> "$desktop_file"
    fi

    if [[ -n $comment ]]; then
      echo "Comment=$comment" >> "$desktop_file"
    fi

    if [[ $nodisplay == "true" ]]; then
      echo "NoDisplay=true" >> "$desktop_file"
    fi

    chmod +x "$desktop_file"
    echo "    $name"
  done
fi

# =============================================================================
# 5. Clean up desktop database
# =============================================================================
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$DESKTOP_DIR" &>/dev/null || true
fi

echo "[+] Done"
