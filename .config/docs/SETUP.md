---
title: SETUP
aliases: SETUP
linter-yaml-title-alias: SETUP
date created: Friday, March 6th 2026, 9:35:03 pm
date modified: Friday, March 6th 2026, 9:39:28 pm
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

## Setting Up YADM (Yet Another Dotfiles Manager)

YADM is a dotfiles manager that uses a bare Git repository to track configuration
files directly within the home directory, without requiring symlinks or a separate
clone step.

---

### Prerequisites

- Git must be installed.
- A remote Git repository (e.g., on GitHub) is recommended for backup and
  cross-machine synchronisation.

---

### Installation

**Fedora (primary):**

```sh
sudo dnf install yadm
```

**Other Linux distributions:**

```sh
# Debian/Ubuntu
sudo apt install yadm

# Arch
sudo pacman -S yadm
```

**macOS (Homebrew):**

```sh
brew install yadm
```

---

### Initialising a New Repository

To begin tracking dotfiles on a fresh machine:

```sh
yadm init
yadm add ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/zsh/.zshrc
yadm commit -m "Initial commit"
```

Link it to a remote repository:

```sh
yadm remote add origin https://github.com/agni-datta/csFedoraDots.git
yadm push -u origin main
```

---

### Cloning an Existing Repository

On a new machine, restore all tracked dotfiles with a single command:

```sh
yadm clone https://github.com/agni-datta/csFedoraDots.git
```

YADM will check out all tracked files into the home directory. If local files
already exist and conflict, YADM creates a stash automatically.

---

### Core Workflow

| Task                 | Command                          |
| -------------------- | -------------------------------- |
| Track a new file     | `yadm add <file>`                |
| Stop tracking a file | `yadm rm --cached <file>`        |
| View tracked changes | `yadm status`                    |
| Commit changes       | `yadm commit -m "message"`       |
| Push to remote       | `yadm push origin main`          |
| Pull latest changes  | `yadm pull --rebase --autostash` |

---

### Useful Concepts

**YADM is a thin wrapper around Git.** Every `git` subcommand works with `yadm`.
The underlying bare repository lives at `~/.local/share/yadm/repo.git`.

**Alternates:** YADM supports per-host or per-OS file variants using the
`##` suffix convention (e.g., `~/.zshrc##os.Darwin`). YADM selects the correct
variant automatically at checkout.

**Encrypt:** Sensitive files (SSH keys, tokens) can be encrypted before
committing via `yadm encrypt` and a `.config/yadm/encrypt` manifest.

---

### Restoring on a New Machine (Summary)

```sh
# 1. Install yadm (Fedora)
sudo dnf install yadm

# 2. Clone dotfiles
yadm clone https://github.com/agni-datta/csFedoraDots.git

# 3. Done — all tracked files are in place
```

---

### Troubleshooting

**Untracked files would be overwritten during pull:**
Add those files to yadm tracking first, then pull again.

```sh
yadm add ~/.bashrc
yadm pull --rebase --autostash
```

**No upstream branch set:**
Set it once after cloning or renaming a branch.

```sh
yadm branch --set-upstream-to=origin/main main
```

**Remote not configured:**
Add it manually.

```sh
yadm remote add origin https://github.com/agni-datta/csFedoraDots.git
```
