---
title: "csFedoraDots"
aliases: "csFedoraDots"
linter-yaml-title-alias: "csFedoraDots"
date created: 2025-09-16
date modified: 2026-07-21
---

<!-- @format -->

# csFedoraDots

Agni Datta's Fedora shell and application configuration. It is arranged for management with [yadm](https://yadm.io/) and includes XDG configuration under `.config/` together with selected home-directory dotfiles.

## Status

The files encode a personal workstation configuration. Review every path, package assumption, and command before applying the repository to another account or host.

## Installation

Install `yadm`, inspect `.yadmignore`, and use yadm's normal clone or bootstrap workflow only after backing up existing configuration. The repository does not provide an unattended installer.

## Maintenance Commands

The following commands are safe inspection paths.

```bash
bash -n .config/symlink-dotfiles.sh
bash -n .config/update-dotfiles.sh
.config/update-dotfiles.sh --help
```

The symlink and update scripts can move files, stage changes, commit, or push. Read them before running any mutating path.

## License

No separate license is provided; applicable law reserves all otherwise ungranted rights.
