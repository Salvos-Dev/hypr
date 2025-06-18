#!/bin/bash

# ---
# Safety & Configuration
# ---
set -e
set -o pipefail

# ---
# Color Definitions
# ---
readonly C_RESET='\033[0m'
readonly C_RED='\033[0;31m'
readonly C_GREEN='\033[0;32m'
readonly C_BLUE='\033[0;34m'
readonly C_YELLOW='\033[0;33m'

# ---
# Script Variables & User Configuration
# ---
readonly CLONE_DIR="$HOME/config" # The directory where the repo was cloned

# This list MUST match the one in the install.sh script to ensure all links are targeted.
declare -A SYMLINKS=(
    ["hypr/foot/foot.ini"]="$HOME/.config/foot/foot.ini"
    ["hypr/nvim/init.lua"]="$HOME/.config/nvim/init.lua"
    ["hypr/nvim/lua"]="$HOME/.config/nvim/lua"
    ["hypr/rofi/config.rasi"]="$HOME/.config/rofi/config.rasi"
    ["hypr/waybar/style.css"]="$HOME/.config/waybar/style.css"
    ["hypr/waybar/config.jsonc"]="$HOME/.config/waybar/config.jsonc"
    ["hypr/zshrc"]="$HOME/.zshrc"
)

# ---
# Helper Functions
# ---
log() {
    local color=$1
    local message=$2
    echo -e "${color}[UNINSTALL]${C_RESET} ${message}"
}

die() {
    log "$C_RED" "ERROR: $1" >&2
    exit 1
}

# ---
# Main Uninstallation Logic
# ---
main() {
    # 1. Pre-flight Checks
    log "$C_BLUE" "Performing pre-flight checks..."
    if [[ $EUID -eq 0 ]]; then
       die "This script must NOT be run as root."
    fi

    # 2. Welcome Message & Confirmation
    echo
    log "$C_GREEN" "Welcome to the Hyprland Dotfiles Uninstaller!"
    log "$C_YELLOW" "This script will perform the following actions:"
    echo -e "  - Remove the symbolic links created by the installer."
    echo -e "  - Offer to restore any backed-up configuration files."
    echo -e "  - ${C_BLUE}It will NOT uninstall any packages or delete your git repository.${C_RESET}"
    echo

    read -p "Do you want to proceed with the uninstallation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        die "Uninstallation aborted by user."
    fi

    # 3. Remove Symbolic Links and Restore Backups
    log "$C_BLUE" "Removing symbolic links and checking for backups..."
    for src in "${!SYMLINKS[@]}"; do
        local source_path="${CLONE_DIR}/${src}"
        local dest_path="${SYMLINKS[$src]}"
        local dest_dir
        dest_dir=$(dirname "$dest_path")

        # Check if the destination is a symlink pointing to our repo
        if [ -L "$dest_path" ] && [ "$(readlink "$dest_path")" == "$source_path" ]; then
            log "$C_GREEN" "Removing symlink: ${dest_path}"
            rm "$dest_path"

            # Check for a backup file to restore
            # We use a wildcard to find any .bak file for that config
            local backup_pattern="${dest_path}.bak.*"
            # Use find to handle cases where no backup exists gracefully
            local backup_file
            backup_file=$(find "$dest_dir" -maxdepth 1 -name "$(basename "${dest_path}").bak.*" -print -quit)

            if [ -n "$backup_file" ] && [ -e "$backup_file" ]; then
                echo
                log "$C_YELLOW" "Found a backup: ${backup_file}"
                read -p "      Would you like to restore it? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    log "$C_GREEN" "      Restoring ${backup_file} -> ${dest_path}"
                    mv "$backup_file" "$dest_path" || log "$C_RED" "Could not restore backup."
                else
                    log "$C_YELLOW" "      Skipping backup restoration."
                fi
            fi
        else
            log "$C_YELLOW" "Skipping ${dest_path} (not a symlink to our dotfiles)."
        fi
    done

    # Finalization
    echo
    log "$C_GREEN" "======================================================"
    log "$C_GREEN" "      Uninstallation Complete!                      "
    log "$C_GREEN" "======================================================"
    echo
    log "$C_BLUE" "All managed symbolic links have been removed."
    log "$C_BLUE" "Your packages and the '${CLONE_DIR}' repository have not been touched."
    echo
}

# ---
# Script Execution
# ---
main "$@"
