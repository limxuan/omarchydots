#!/usr/bin/env bash
# packages/apps.sh — Declarative application definitions
# Sourced by setup-desktop-entries.sh
#
# Fields are pipe-separated so values with spaces are easy to read/edit.
# Optional fields can be left empty (but the pipe separators stay).

# =============================================================================
# Web Apps — installed via: omarchy-webapp-install <name> <url> <icon> [exec] [mime]
# The icon field is a favicon URL — omarchy-webapp-install auto-downloads it.
# =============================================================================
webapps=(
  "Calendar|https://calendar.google.com/|https://www.google.com/s2/favicons?domain=calendar.google.com&sz=128"
  "ChatGPT|https://chatgpt.com/|https://www.google.com/s2/favicons?domain=chatgpt.com&sz=128"
  "Claude|https://claude.ai/new|https://www.google.com/s2/favicons?domain=claude.ai&sz=128"
  "Gemini|https://gemini.google.com/app|https://www.google.com/s2/favicons?domain=gemini.google.com&sz=128"
  "Discord|https://discord.com/app|https://www.google.com/s2/favicons?domain=discord.com&sz=128"
  "GitHub|https://github.com/|https://www.google.com/s2/favicons?domain=github.com&sz=128"
  "Teams|https://teams.microsoft.com/v2/|https://www.google.com/s2/favicons?domain=teams.microsoft.com&sz=128"
  "WhatsApp|https://web.whatsapp.com/|https://www.google.com/s2/favicons?domain=web.whatsapp.com&sz=128"
  "OneNote|https://onenote.cloud.microsoft/|https://www.google.com/s2/favicons?domain=onenote.cloud.microsoft&sz=128"
)

# =============================================================================
# TUI Apps — launched in a floating/tiling terminal
# Format: name|command|icon|terminal_class
# =============================================================================
tui_apps=(
  "Disk Usage|dust -r; read -n 1 -s|Disk Usage.png|TUI.float"
  "Docker|lazydocker|Docker.png|TUI.tile"
)

# =============================================================================
# Omarchy Built-in Shortcuts — calls omarchy CLI commands
# Format: filename|name|exec|icon|categories
# =============================================================================
omarchy_shortcuts=(
  "bluetooth|bluetooth|omarchy-launch-bluetooth||Settings;Hardware;"
  "sound|sound|omarchy-launch-or-focus-tui wiremix||Settings;"
  "wifi|wifi|omarchy-launch-wifi||Network;"
)

# =============================================================================
# Custom Desktop Entries — generic .desktop file generation
# Format: filename|name|exec|icon|categories|mime_types|comment|nodisplay
# =============================================================================
custom_entries=(
  # "vm|vm-manager|/usr/bin/python3.13 /usr/bin/virt-manager||System;Virtualization;"
  # "windows-vm|Windows|uwsm app -- omarchy-windows-vm launch|/home/limxuan/.local/share/applications/icons/windows.png|System;Virtualization;"
  # "zen-browser|Zen Browser|/usr/local/bin/zen-browser %U|zen-browser|Network;WebBrowser;"
)
