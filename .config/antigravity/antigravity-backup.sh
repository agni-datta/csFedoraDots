#!/bin/bash

######################################################################
# Configuration
######################################################################

# Source directories
CONFIG_DIR="$HOME/Library/Application Support/Antigravity/User"
EXTENSIONS_DIR="$HOME/.antigravity/extensions"

# Source files
SETTINGS_FILE="$CONFIG_DIR/settings.json"
KEYBINDINGS_FILE="$CONFIG_DIR/keybindings.json"
EXTENSIONS_JSON="$EXTENSIONS_DIR/extensions.json"

# Destination
BACKUP_DIR="$HOME/.config/antigravity/backup"
EXT_SCRIPT_FILE="$BACKUP_DIR/install_extensions.sh"

######################################################################
# Utility Functions
######################################################################

log() {
    echo "==> $1"
}

setup_backup_dir() {
    log "Ensuring backup directory exists at $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
}

backup_file() {
    local src_file="$1"
    local dest_file="$2"
    local filename="${src_file##*/}"

    if [[ -f "$src_file" ]]; then
        cp "$src_file" "$dest_file" 2>/dev/null
        log "Copied $filename."
    else
        log "Warning: $filename not found at $src_file"
    fi
}

######################################################################
# Core Functions
######################################################################

backup_configs() {
    log "Backing up editor configurations..."
    local files=("$SETTINGS_FILE" "$KEYBINDINGS_FILE")

    for src in "${files[@]}"; do
        backup_file "$src" "$BACKUP_DIR/${src##*/}"
    done
}

backup_extensions() {
    log "Generating install_extensions.sh..."

    if [[ -f "$EXTENSIONS_JSON" ]]; then
        # Group output to perform a single file write operation
        {
            echo '#!/bin/bash'
            echo ''
            echo '# This script reinstalls all previously installed extensions.'
            echo '# Simply run this script to install all extensions in one go.'
            echo ''

            # Optimize python execution using list comprehension and string joining
            python3 -c "
import json
try:
    with open('$EXTENSIONS_JSON', 'r') as f:
        print('\n'.join(f'antigravity --install-extension {e.get(\"identifier\", {}).get(\"id\")}' for e in json.load(f) if e.get(\"identifier\", {}).get(\"id\")))
except Exception:
    pass
"
        } >"$EXT_SCRIPT_FILE"

        chmod +x "$EXT_SCRIPT_FILE"
        log "Extension install script generated."
    else
        log "extensions.json not found. Skipping extension backup."
    fi
}

main() {
    log "Starting Antigravity backup..."
    setup_backup_dir
    backup_configs
    backup_extensions
    log "Backup completed successfully! Saved to: $BACKUP_DIR"
}

main
