#!/usr/bin/env python3
"""
Hyprland config injector.
Copies Omarchy defaults, then applies your delta customizations on top.
Run after `omarchy update` to re-sync with latest defaults + your changes.
"""
import os
import re
import sys
import shutil
from pathlib import Path

OMARCHY_DIR = Path.home() / ".local/share/omarchy/default/hypr"
DELTA_DIR = Path.home() / ".config/hypr/deltas"
MANAGED_DIR = Path.home() / ".config/hypr/managed"

INJECTABLE = ["input.conf", "looknfeel.conf", "envs.conf", "autostart.conf"]


def split_blocks(text):
    """Split config into ordered list of (type, name, content) tuples.
    type is 'block' or 'line'.
    For blocks, name is the block name and content is the inner content.
    For lines, name is None and content is the line text.
    """
    result = []
    lines = text.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        # Skip empty lines and comments
        if not stripped or stripped.startswith('#'):
            result.append(('line', None, line))
            i += 1
            continue

        # Check for block start
        m = re.match(r'^(\w[\w.]*)\s*\{', stripped)
        if m:
            block_name = m.group(1)
            block_lines = []
            depth = 1
            i += 1
            while i < len(lines) and depth > 0:
                bl = lines[i]
                depth += bl.count('{') - bl.count('}')
                if depth > 0:
                    block_lines.append(bl)
                i += 1
            result.append(('block', block_name, '\n'.join(block_lines)))
            continue

        # Free-standing line
        result.append(('line', None, line))
        i += 1

    return result


def rebuild(blocks_and_lines):
    """Rebuild config text from ordered list of (type, name, content)."""
    parts = []
    for btype, name, content in blocks_and_lines:
        if btype == 'block':
            parts.append(f"{name} {{")
            parts.append(content)
            parts.append("}")
        else:
            parts.append(content)
    return '\n'.join(parts) + '\n'


def inject(default_text, delta_text):
    """Merge delta into default. Delta blocks replace matching default blocks.
    Delta free lines are appended at the end."""
    def_items = split_blocks(default_text)
    del_items = split_blocks(delta_text)

    # Separate delta into blocks and free lines
    del_blocks = {}
    del_free = []
    for btype, name, content in del_items:
        if btype == 'block':
            del_blocks[name] = content
        else:
            if content.strip():  # skip empty
                del_free.append(content)

    # Replace matching blocks in default
    result = []
    for btype, name, content in def_items:
        if btype == 'block' and name in del_blocks:
            # Replace with delta version
            result.append(('block', name, del_blocks[name]))
            del_blocks.pop(name)  # mark as applied
        else:
            result.append((btype, name, content))

    # Append any delta blocks that didn't match a default block
    for name, content in del_blocks.items():
        result.append(('block', name, content))

    # Append delta free lines
    for line in del_free:
        result.append(('line', None, line))

    return rebuild(result)


def inject_file(name):
    default_file = OMARCHY_DIR / name
    delta_file = DELTA_DIR / name
    output_file = MANAGED_DIR / name

    if not default_file.exists():
        print(f"  SKIP  {name} (no default)")
        return

    if not delta_file.exists():
        shutil.copy2(default_file, output_file)
        print(f"  COPY  {name} (no delta)")
        return

    default_text = default_file.read_text()
    delta_text = delta_file.read_text()
    result = inject(default_text, delta_text)
    output_file.write_text(result)
    print(f"  INJECT {name}")


def main():
    MANAGED_DIR.mkdir(parents=True, exist_ok=True)
    DELTA_DIR.mkdir(parents=True, exist_ok=True)

    print(f"[*] Injecting Hyprland configs...")
    print(f"    Defaults: {OMARCHY_DIR}")
    print(f"    Deltas:   {DELTA_DIR}")
    print(f"    Output:   {MANAGED_DIR}")
    print()

    # Step 1: Copy all defaults
    print("[1] Copying defaults...")
    for f in sorted(OMARCHY_DIR.iterdir()):
        if f.is_file() and f.suffix == '.conf':
            shutil.copy2(f, MANAGED_DIR / f.name)

    # Step 2: Inject deltas
    print("[2] Applying deltas...")
    for name in INJECTABLE:
        inject_file(name)

    print()
    print("[+] Done! Run: hyprctl reload")


if __name__ == "__main__":
    main()
