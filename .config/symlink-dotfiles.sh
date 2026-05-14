#!/usr/bin/env bash
# symlink-dotfiles.sh — idempotent dotfile symlinker
# Backs up conflicting files, skips correct links, safe to re-run.

set -euo pipefail

# ── constants ────────────────────────────────────────────────────────────────

CONFIG="${HOME}/.config"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# ── colours ──────────────────────────────────────────────────────────────────

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; RESET='\033[0m'

log_info()   { echo -e "${BLUE}[info]${RESET}  $*"; }
log_ok()     { echo -e "${GREEN}[ok]${RESET}    $*"; }
log_warn()   { echo -e "${YELLOW}[warn]${RESET}  $*"; }
log_err()    { echo -e "${RED}[err]${RESET}   $*" >&2; }
log_header() { echo -e "\n${BOLD}── $* ──${RESET}"; }

# ── symlink helper ───────────────────────────────────────────────────────────

# link SRC DST
#   Creates a symlink at DST pointing to SRC.
#   - Skips if the correct link already exists.
#   - Removes stale symlinks.
#   - Backs up real files/dirs that are in the way.
link() {
    local src="$1" dst="$2"

    if [[ ! -e "$src" ]]; then
        log_err "Source not found, skipping: $src"
        return 1
    fi

    if [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst")" == "$src" ]]; then
            log_ok "Already linked: $(basename "$dst")"
            return 0
        fi
        log_warn "Stale symlink at $dst — relinking."
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        mkdir -p "$BACKUP_DIR"
        log_warn "Backing up: $dst"
        mv "$dst" "${BACKUP_DIR}/$(basename "$dst")"
    fi

    ln -s "$src" "$dst"
    log_ok "Linked: $dst"
}

# ── dotfile groups ───────────────────────────────────────────────────────────

link_git() {
    log_header "git"
    link "${CONFIG}/git/.gitconfig" "${HOME}/.gitconfig"
    # ~/.gitignore is kept as a plain file — not symlinked
}

link_zsh() {
    log_header "zsh"
    link "${CONFIG}/zsh/.zshrc" "${HOME}/.zshrc"
}

link_bash() {
    log_header "bash"
    local src="${CONFIG}/bash/.bashrc"
    if [[ -f "$src" ]]; then
        link "$src" "${HOME}/.bashrc"
    else
        log_info "No ${src} found — skipping."
    fi
}

# ── main ─────────────────────────────────────────────────────────────────────

main() {
    echo -e "${BOLD}dotfile symlinker${RESET}"
    log_info "config root : ${CONFIG}"
    log_info "home        : ${HOME}"

    link_git
    link_zsh
    link_bash

    echo
    log_info "Done.${BACKUP_DIR:+ Backups saved to: ${BACKUP_DIR}}"
}

main "$@"
