# Desktop Services & Setup Guide

This document contains step-by-step instructions for all desktop services, hotkeys, and configurations managed by this **chezmoi** dotfiles repository.

---

## 1. 🎤 Groq Cloud Voice Dictation (`whisper-large-v3`)

### Overview
Uses OpenAI's flagship `whisper-large-v3` model hosted on Groq's Cloud LPU API for **sub-100ms** (near-instantaneous) 99.9% accurate voice dictation with zero CPU/battery load.

### Setup Instructions on a New Laptop:
1. **Get Free Groq API Key**:
   - Visit [console.groq.com/keys](https://console.groq.com/keys) and click **Create API Key**.
2. **Save API Key to Disk**:
   ```bash
   mkdir -p ~/.config/groq
   echo "gsk_YOUR_GROQ_API_KEY_HERE" > ~/.config/groq/api_key
   ```
3. **How to Use**:
   - Press **`Caps Lock + E`**: Start recording (Notification: `󰍬 Recording (Groq AI)...`).
   - Speak your sentence.
   - Press **`Caps Lock + E`** again: Transcribes in <0.1s and types text at your active cursor.
4. **Script Location**:
   - `~/.config/scripts/groq-dictate.sh` (tracked in chezmoi as `dot_config/scripts/executable_groq-dictate.sh`).

---

## 2. ☕ Caffeinated / Idle Lock Toggle (`hypridle`)

### Overview
Prevents your system from locking or going to sleep during long tasks, presentations, or video playback.

### How to Toggle:
- **Keyboard Shortcut**: Press **`SUPER + SHIFT + I`**.
- **Waybar Icon**: Click the **󱫖** idle icon on your top status bar.
- **Status Indicator**: When idle lock is turned off (caffeinated), a `󱫖` icon appears next to the clock in Waybar.

---

## 3. 🖱️ MacBook-Style Natural Touchpad Scrolling

### Overview
Configured in Hyprland to match macOS two-finger touchpad scrolling direction.

### Configuration Location:
- Tracked in `~/.config/hypr/hyprland.conf`:
  ```ini
  input {
      touchpad {
          natural_scroll = true
      }
  }
  ```

---

## 4. 🔤 System Font (`JetBrainsMono Nerd Font`)

### Overview
System-wide monospace font for terminal (Kitty), status bar (Waybar), lock screen (Hyprlock), and UI.

### Managed By:
- Package: `ttf-jetbrains-mono-nerd` in `dot_config/omarchy/packages/pacman.txt`.
- Fontconfig: `~/.config/fontconfig/fonts.conf`.
- Terminal: `~/.config/kitty/kitty.conf`.

---

## 5. 🌐 Helium Browser & Extension Setup

### Setup Instructions:
1. **Desktop Launcher**: Helium is launched via wrapper script `~/.local/bin/helium-browser` configured in `run_once_bootstrap.sh`.
2. **Permanent Extension Install**:
   - Open Helium -> go to `chrome://extensions/` -> enable **Developer Mode**.
   - Click **Load Unpacked** and select extension folders from `~/.config/net.imput.helium/unpacked-extensions/` (SponsorBlock, Vimium C, Dark Reader, FoxyProxy, Bitwarden).

---

## 6. 🚀 Bootstrapping a New Laptop with Chezmoi

```bash
# 1. Initialize Chezmoi Dotfiles
chezmoi init <your-repo-url>

# 2. Apply All Dotfiles & Packages
chezmoi apply

# 3. Set Up Groq API Key
mkdir -p ~/.config/groq
echo "gsk_..." > ~/.config/groq/api_key
```
