# csFedoraDots

`csFedoraDots` provides a single, self-contained script for maintaining a Fedora dotfiles repository managed with [yadm](https://yadm.io/). The script is designed to run from the machine where the dotfiles are tracked and automates the standard pull/add/commit/push cycle while offering status-only and quiet modes for routine checks.

## Prerequisites
- Fedora system with `bash` and the standard GNU userland
- `yadm` (includes Git) configured to track your dotfiles repository
- Valid credentials for the remote backing the `yadm` repository

## Script Workflow
- Verifies that `yadm` is available before continuing.
- Supports status-only and pull-only execution paths for diagnostic checks.
- Default execution performs `yadm pull`, `yadm add -u`, `yadm commit`, and `yadm push` in sequence.
- Generates timestamped commit messages of the form `Update dotfiles - <YYYY-MM-DD HH:MM:SS>`.
- Emits color-coded log messages and stops on the first failing command (`set -e`).

## Command-Line Options
| Option | Description |
| --- | --- |
| `-h`, `--help` | Print usage instructions. |
| `-s`, `--status` | Show `yadm status` and exit without making changes. |
| `-p`, `--pull` | Fetch the latest dotfiles from the remote and exit. |
| `-n`, `--no-push` | Skip the push step after committing local updates. |
| `-q`, `--quiet` | Suppress status output before and after the update cycle. |

## Usage Examples
```bash
# Run the full pull/add/commit/push workflow
./update-dotfiles.sh

# Inspect repository status without modifying anything
./update-dotfiles.sh --status

# Synchronize from remote without committing local work
./update-dotfiles.sh --pull

# Commit locally but postpone pushing to the remote
./update-dotfiles.sh --no-push
```

## Typical Setup on a New Host
1. Install `yadm`:
   ```bash
   sudo dnf install yadm
   ```
2. Clone your dotfiles repository (replace the URL with your remote as required):
   ```bash
   yadm clone https://github.com/agni-datta/csFedoraDots
   ```
3. Ensure the update script is executable wherever you keep your maintenance tooling:
   ```bash
   chmod +x ~/csFedoraDots/update-dotfiles.sh
   ```
4. Run the script whenever you need to synchronize changes.

## Repository Layout
```
csFedoraDots/
├── README.md
└── update-dotfiles.sh
```

## Maintenance
- Maintainer: agnid
- Last Updated: 2025-09-21
