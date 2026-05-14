---
title: WORKFLOW
aliases: WORKFLOW
linter-yaml-title-alias: WORKFLOW
date created: Friday, March 6th 2026, 9:35:11 pm
date modified: Friday, March 6th 2026, 9:39:07 pm
---

<!-- @format -->

## csFedoraDots: Configuration Layout and Sync Workflow

This document describes the structure of the csFedoraDots dotfiles repository and
the operation of the `update-dotfiles.sh` synchronisation script.

---

### Repository Overview

The repository is managed by YADM and mirrors the structure of `$HOME`. All
paths below are relative to the home directory.

```text
~
├── .bashrc                        # Bash shell configuration
└── .config/
    ├── alacritty/                 # Alacritty terminal emulator config + 140+ themes
    ├── antigravity/               # Antigravity editor config + backup scripts
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
    ├── update-dotfiles.sh         # Active sync script (canonical location)
    ├── yadm/                      # yadm config and encrypt manifest
    ├── yazi/                      # Yazi file manager config, keymaps, theme, plugins
    ├── zathura/                   # Zathura PDF viewer config
    ├── zellij/                    # Zellij terminal multiplexer config
    └── zsh/                       # Zsh config (XDG-compliant location)
```

---

### The Sync Script: `update-dotfiles.sh`

**Canonical path:** `~/.config/update-dotfiles.sh`

The script automates the full pull → stage → commit → push cycle for YADM.

It is intended to be run manually whenever `.config` changes should be

committed and pushed.

#### Default Behaviour

When called with no arguments, the script:

1. Pulls the latest remote changes using `yadm pull --rebase --autostash`.
2. Displays the current `yadm status`.
3. Stages all changes under `.config` using `yadm add --all.config`.
4. Commits with an auto-generated timestamp message:
   `tldr: sync dotfiles (YYYY-MM-DDTHH:MMZ)`
5. Pushes to `origin main`.

#### Usage

```sh
# Default: pull, stage, commit, push
bash ~/.config/update-dotfiles.sh

# Custom commit message
bash ~/.config/update-dotfiles.sh "tweak kitty theme"

# Show status only, no changes
bash ~/.config/update-dotfiles.sh --status

# Pull only, skip commit and push
bash ~/.config/update-dotfiles.sh --pull-only

# Stage and commit but do not push
bash ~/.config/update-dotfiles.sh --no-push

# Preview commands without executing mutating steps
bash ~/.config/update-dotfiles.sh --dry-run
```

#### All Options

| Flag                    | Description                                   |
| ----------------------- | --------------------------------------------- |
| `-h`, `--help`          | Show help text                                |
| `-s`, `--status`        | Show status and exit                          |
| `-P`, `--pull-only`     | Pull with rebase then exit                    |
| `-n`, `--no-push`       | Skip the push step                            |
| `-b`, `--branch <name>` | Target branch for push (default: `main`)      |
| `-m`, `--message <msg>` | Explicit commit message                       |
| `-q`, `--quiet`         | Suppress informational output                 |
| `--dry-run`             | Print commands without running mutating steps |
| `--no-status`           | Skip the pre-commit status display            |

#### Environment Variable

The default push branch can be overridden without touching the script:

```sh
YADM_SYNC_BRANCH=feature-branch bash ~/.config/update-dotfiles.sh
```

---

### Important Notes

- The script stages **only files under `.config`**. Root-level dotfiles
  (`.bashrc`) must be staged manually with `yadm add` when changed.
- `.zshrc` lives at `.config/zsh/.zshrc` (XDG-compliant) and is staged by the script.
- The remote is `https://github.com/agni-datta/csFedoraDots.git`, branch `main`.
- Neovim configuration at `~/.config/nvim` is tracked as individual files,
  not as a submodule.
