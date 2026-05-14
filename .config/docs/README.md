---
title: README
linter-yaml-title-alias: README
date created: Wednesday, October 8th 2025, 11:43:21 pm
date modified: Friday, March 6th 2026, 9:39:46 pm
aliases: README
---

<!-- @format -->

```table-of-contents
title:
style: nestedList # TOC style (nestedList|nestedOrderedList|inlineFirstLevel)
minLevel: 0 # Include headings from the specified level
maxLevel: 0 # Include headings up to the specified level
include:
exclude:
includeLinks: true # Make headings clickable
hideWhenEmpty: false # Hide TOC if no headings are found
debugInConsole: false # Print debug info in Obsidian console
```

## csFedoraDots

### TL;DR

- Single source of truth for my Fedora Linux dotfiles, managed with `yadm` and stored in `https://github.com/agni-datta/csFedoraDots.git`.
- Track only what I care about: configs live under `.config`, supporting assets ride alongside.
- Keep restores painless, clone with `yadm`, resolve diffs fast, stay confident about the state of the machine.

### Philosophy

- **Stay deliberate.** Every tracked file should have a purpose; unneeded defaults stay out of version control.
- **Keep $HOME tidy.** Everything lands under `.config/` (docs included) so the root remains clutter-free.
- **Prefer transparency over magic.** No bootstrap script that hides work, `yadm` commands tell the full story.
- **Optimize for fast recovery.** A clean clone followed by `yadm checkout` must reproduce a working environment.

### Daily Workflow

1. Make changes locally.
2. `yadm status` to review the delta.
3. `yadm add <paths>` and `yadm commit -m "Meaningful message"`.
4. `yadm push origin main` (remote is `https://github.com/agni-datta/csFedoraDots.git`).

### Bootstrap

```bash
# One-time setup on a new machine (Fedora)
sudo dnf install yadm
yadm clone https://github.com/agni-datta/csFedoraDots.git
# Review conflicts before checking out over existing files
yadm status
```

### Layout Cheat Sheet

```text
~
├── .bashrc                        # Bash shell configuration
└── .config/
    ├── alacritty/                 # Alacritty terminal emulator config + 140+ themes
    ├── antigravity/               # Antigravity (Cursor-based editor) config + backup scripts
    ├── autostart/                 # XDG autostart desktop entries
    ├── bat/                       # bat (cat replacement) config
    ├── bleachbit/                 # BleachBit disk cleaner config
    ├── btop/                      # btop system monitor config
    ├── burn-my-windows/           # GNOME burn-my-windows effect profiles
    ├── cava/                      # cava audio visualiser config and shaders
    ├── cursor/                    # Cursor editor extension list
    ├── docs/                      # Documentation for this repository
    ├── eza/                       # eza (ls replacement) theme
    ├── fastfetch/                 # fastfetch system info config
    ├── forge/                     # Forge GNOME window manager config and CSS
    ├── fzf/                       # fzf fuzzy finder shell integration
    ├── gh/                        # GitHub CLI config
    ├── git/                       # Git config (XDG location)
    ├── jabref/                    # JabRef reference manager Nord theme
    ├── kitty/                     # Kitty terminal emulator config and themes
    ├── lazygit/                   # Lazygit TUI Git client config
    ├── nnn/                       # nnn file manager plugins (50+)
    ├── nvim/                      # Neovim config (LazyVim-based)
    ├── profile/                   # Profile photo asset
    ├── starship.toml              # Starship cross-shell prompt config
    ├── symlink-dotfiles.sh        # Alternative symlink-based setup script
    ├── update-dotfiles.sh         # Active sync script
    ├── yadm/                      # yadm config and encrypt manifest
    ├── yazi/                      # Yazi file manager config, keymaps, theme, plugins
    ├── zathura/                   # Zathura PDF viewer config
    ├── zellij/                    # Zellij terminal multiplexer config
    └── zsh/                       # Zsh config (XDG-compliant location)
```

### What Is Not Tracked

The following are intentionally excluded:

- `Antigravity/Cache/`, `Antigravity/Service Worker/`, `Antigravity/Session Storage/` — runtime cache
- `Antigravity/Cookies`, `Antigravity/machineid`, `Antigravity/SharedStorage` — machine-specific/sensitive state
- `gsconnect/certificate.pem`, `gsconnect/private.pem` — private keys (covered by `yadm/encrypt`)
- `goa-1.0/accounts.conf` — OAuth tokens
- `dconf/user` — binary, machine-specific GNOME settings
- `gtk-3.0/`, `gtk-4.0/` — system-generated theming state
- `monitors.xml` — machine-specific monitor layout
- `mimeapps.list`, `user-dirs.*` — machine-specific XDG settings

### Safety Notes

- Root-level dotfiles (`.bashrc`) must be staged manually with `yadm add` when changed — the sync script only stages `.config/`.
- For risky experiments, use feature branches directly in the yadm repo before merging back to `main`.

### Attribution

- Themes and presets draw on Nord, LazyVim, and the wider dotfiles community. See individual files for upstream licenses where applicable.
