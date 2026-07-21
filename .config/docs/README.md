---
title: "csFedoraDots"
aliases: "csFedoraDots"
linter-yaml-title-alias: "csFedoraDots"
date created: Wednesday, October 8th 2025, 11:43:21 pm
date modified: 2026-07-21
---

<!-- @format -->

# csFedoraDots

## TL;DR

- `yadm` manages the Fedora dotfiles in this repository.
- Most tracked configuration lives below `.config/`; selected root dotfiles are tracked separately.
- Review local differences and back up conflicting files before checkout.

## Philosophy

- Track intentional configuration, not generated defaults or caches.
- Keep application files under XDG paths when the application supports them.
- Prefer visible `yadm` operations over an opaque bootstrap process.
- Keep enough metadata to restore a workstation without committing secrets.

## Daily Workflow

1. Edit the local configuration.
2. Review with `yadm status` and `yadm diff`.
3. Stage explicit paths and commit a descriptive message.
4. Push only after checking that no credential, key, or machine-specific state is staged.

## Bootstrap

```bash
sudo dnf install yadm
yadm clone https://github.com/agni-datta/csFedoraDots.git
yadm status
```

Resolve checkout conflicts individually. Do not overwrite an existing configuration tree without a recoverable backup.

## Layout Cheat Sheet

```text
~
├── .bashrc
└── .config/
    ├── alacritty/        terminal configuration and themes
    ├── antigravity/      editor configuration and backup helpers
    ├── bat/ btop/ eza/   command-line themes
    ├── cursor/ nvim/     editor configuration
    ├── fastfetch/ cava/  system information and visualization
    ├── fzf/ git/ gh/     shell and version-control tools
    ├── kitty/ zathura/   terminal and PDF viewer
    ├── nnn/ yazi/        file managers and plugins
    ├── yadm/             yadm configuration and encryption manifest
    ├── zellij/ zsh/      terminal multiplexer and shell
    ├── symlink-dotfiles.sh
    └── update-dotfiles.sh
```

## What Is Not Tracked

Runtime caches, cookies, session data, OAuth state, private keys, machine identifiers, binary desktop settings, monitor layouts, and generated XDG preferences are excluded. `yadm/encrypt` identifies the exceptional private files that require encrypted handling.

## Safety Notes

- The update script stages `.config/` only; stage root dotfiles explicitly.
- Read sync and symlink scripts before choosing a mutating path.
- Use a branch for experimental configuration and verify the result before merging.
- Redact hostnames, usernames, and tokens from logs shared outside the repository.

## Attribution

Themes and presets draw from Nord, LazyVim, and other upstream projects. Individual files retain the applicable upstream notices.
