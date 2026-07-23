# lx dotfiles (Clean Native Version)

Arch Linux + Hyprland dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Highlights of this repo (`~/chez-2`)

- **Native Hyprland `source =` Includes**: Uses standard Hyprland `source =` directives instead of complex `inject.py` python merge scripts.
- **Solid Black Wallpaper**: Managed automatically via `run_onchange_set-black-wallpaper.sh`.
- **Zero Middleman Build Steps**: `chezmoi apply` immediately updates active config files.

## How to use this repository with chezmoi

### 1. Preview changes (Dry run)
```bash
chezmoi diff --source ~/chez-2
```

### 2. Apply configuration
```bash
chezmoi apply --source ~/chez-2
```

### 3. Switch your primary chezmoi directory to `~/chez-2` (Optional)
If you want chezmoi to default to this repository instead of `~/.local/share/chezmoi`:
```bash
rm -rf ~/.local/share/chezmoi
cp -r ~/chez-2 ~/.local/share/chezmoi
```

## Structure

```
~/chez-2/
├── dot_config/hypr/
│   ├── hyprland.conf          # Main Hyprland config (sources Omarchy defaults + your custom files)
│   ├── custom_envs.conf       # Environment overrides
│   ├── custom_looknfeel.conf  # Layout & visual overrides
│   ├── custom_autostart.conf  # Autostart overrides
│   ├── bindings.conf          # Custom keybindings
│   ├── monitors.conf          # Monitor configuration
│   └── windowrules.conf       # Window rules
├── dot_config/waybar/         # Waybar config + styles
├── dot_config/scripts/        # Helper scripts
├── dot_config/omarchy/        # Omarchy package lists
├── run_once_bootstrap.sh      # Master installer
└── run_onchange_set-black-wallpaper.sh # Black wallpaper generator & symlink manager
```
