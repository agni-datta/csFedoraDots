#!/bin/bash
# yadm-reset.sh — Hard-sync local yadm to remote after a force-push / squash.
#
# Run this whenever the remote history has been rewritten (e.g. after squashing
# all commits into one). A plain `yadm pull --rebase` will conflict; this
# script does the safe equivalent:
#   1. Abort any in-progress rebase.
#   2. Fetch remote and ensure the tracking ref exists.
#   3. Hard-reset local main to origin/main.
#
# Your working-tree dotfiles are NOT touched — only the yadm git index/history
# is updated. Untracked files are left alone.
#
# Usage:
#   chmod +x ~/.config/yadm/yadm-reset.sh
#   ~/.config/yadm/yadm-reset.sh

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC}    $*"; }
success() { echo -e "${GREEN}[OK]${NC}      $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC}    $*"; }
die() {
    echo -e "${RED}[ERROR]${NC}   $*" >&2
    exit 1
}

command -v yadm &>/dev/null || die "yadm is not installed."

# Abort any in-progress rebase so git is in a clean state.
if yadm rebase --abort 2>/dev/null; then
    warn "Aborted an in-progress rebase."
fi

info "Fetching remote..."
# Explicitly populate the remote tracking ref (yadm fetch alone may not do it).
yadm fetch origin main:refs/remotes/origin/main 2>/dev/null ||
    yadm fetch origin

# Confirm the ref now exists.
yadm rev-parse remotes/origin/main &>/dev/null ||
    die "Could not resolve remotes/origin/main after fetch. Check your remote URL."

REMOTE_SHA=$(yadm rev-parse remotes/origin/main)
LOCAL_SHA=$(yadm rev-parse HEAD)

if [[ "$LOCAL_SHA" == "$REMOTE_SHA" ]]; then
    success "Already up to date ($REMOTE_SHA)."
    exit 0
fi

info "Local:  $LOCAL_SHA"
info "Remote: $REMOTE_SHA"
info "Hard-resetting local main to origin/main..."

yadm reset --hard remotes/origin/main

success "Done. Local yadm history now matches remote:"
yadm log --oneline
