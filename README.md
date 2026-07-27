# Omarchy Dotfiles

Arch Linux + Hyprland dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start (Fresh System)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/limxuan/omarchydots/master/bootstrap.sh)
```

Or clone manually:
```bash
git clone https://github.com/limxuan/omarchydots.git ~/.local/share/chezmoi
bash ~/.local/share/chezmoi/bootstrap.sh
```

## What's Included

- **Hyprland** config with custom keybindings, workspace rules, monitor rotation
- **Waybar** with tailscale indicator, fullscreen indicator, battery power profile
- **Keyd** config: capslock → meh+esc, rightalt passthrough, shift oneshot
- **Helium browser** with extensions: SponsorBlock, Vimium C, Dark Reader, FoxyProxy, Bitwarden, Keyboard Shortcuts to Manage Tabs
- **Voice dictation** via Groq Cloud (whisper-large-v3) — press `Caps + E`
- **Tailscale** indicator in waybar (green `[ts]` when connected)
- **Black wallpaper** via swaybg
- **Fish shell** with zoxide, eza, fzf, ripgrep

## Updating

```bash
cd ~/.local/share/chezmoi
git pull
chezmoi apply --force
```

## Key Bindings

| Binding | Action |
|---------|--------|
| `Caps + Return` | Terminal |
| `Caps + Space` | Toggle layout (scrolling/dwindle) |
| `Caps + E` | Toggle voice dictation |
| `Caps + R` | Toggle scratchpad |
| `Caps + X` | Switch to workspace 6 |
| `Caps + 1-9` | Switch to workspace 1-9 |
| `Caps + Shift + 1-9` | Move window to workspace 1-9 |
| `Super + Space` | Toggle layout |

## Structure

```
~/.local/share/chezmoi/
├── bootstrap.sh                 # Fresh system installer
├── run_once_bootstrap.sh        # Full setup (packages, keyd, extensions)
├── run_onchange_install-packages.sh  # Package installer
├── dot_config/
│   ├── hypr/                    # Hyprland configs
│   ├── waybar/                  # Waybar config + styles
│   ├── scripts/                 # Helper scripts
│   └── omarchy/packages/        # Package lists (pacman.txt, aur.txt)
├── dot_etc/keyd/                # Keyd config
└── docs/                        # Setup guides
```

## Setup Guide

See [docs/SERVICES_SETUP_GUIDE.md](docs/SERVICES_SETUP_GUIDE.md) for detailed instructions on voice dictation, idle lock, and other services.
