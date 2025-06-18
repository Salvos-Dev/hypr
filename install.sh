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

# !!! IMPORTANT !!!
# Please verify these variables match your setup.
readonly GIT_REPO_URL="https://github.com/Salvos-Dev/hypr.git" # Change this to your repo URL
readonly CLONE_DIR="$HOME/config" # Cloning to ~/config as per your README structure

# List of packages from your README.
# The script will prefer to use 'pkglist.txt' from your repo if it exists.
readonly PACKAGES=(
    hyprland
    foot
    rofi
    neovim
    zsh
    starship
    thunar
    firefox
    hyprpaper
    hyprshot
    polkit-kde-agent
    xdg-desktop-portal-hyprland
    waybar
    # Add any other base dependencies here
    git
    base-devel
)

# Define symbolic links based on your README.
# The key is the source file/directory in your repo (relative to $CLONE_DIR).
# The value is the destination on your system.
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
    echo -e "${color}[SETUP]${C_RESET} ${message}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

die() {
    log "$C_RED" "ERROR: $1" >&2
    exit 1
}

# ---
# Main Installation Logic
# ---

main() {
    # 1. Pre-flight Checks
    log "$C_BLUE" "Performing pre-flight checks..."
    if [[ $EUID -eq 0 ]]; then
       die "This script must NOT be run as root. It will use 'sudo' for package installation when needed."
    fi
    if ! command_exists "pacman"; then
        die "This script is for Arch Linux ONLY. Pacman not found."
    fi

    # 2. Welcome Message & Confirmation
    echo
    log "$C_GREEN" "Welcome to your personal Hyprland Dotfiles Installer!"
    log "$C_YELLOW" "This script is designed for Arch Linux and will:"
    echo -e "  - Install all required packages."
    echo -e "  - Clone your dotfiles from: ${C_BLUE}${GIT_REPO_URL}${C_RESET}"
    echo -e "  - Create symbolic links for all your configuration files."
    echo -e "  - ${C_RED}Any existing configuration files will be safely backed up.${C_RESET}"
    echo

    read -p "Do you want to proceed with the installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        die "Installation aborted by user."
    fi

    # 3. Clone Git Repository (or update if it exists)
    if [ -d "$CLONE_DIR" ]; then
        log "$C_YELLOW" "Dotfiles directory already exists at ${CLONE_DIR}. Pulling latest changes."
        (cd "$CLONE_DIR" && git pull) || die "Failed to pull updates for git repository."
    else
        log "$C_BLUE" "Cloning dotfiles repository to ${CLONE_DIR}..."
        git clone "$GIT_REPO_URL" "$CLONE_DIR" || die "Failed to clone git repository."
    fi
    log "$C_GREEN" "Repository ready."

    # 4. Install Packages
    log "$C_BLUE" "Installing required packages..."
    local pkglist_path="${CLONE_DIR}/pkglist.txt"
    if [ -f "$pkglist_path" ]; then
        log "$C_GREEN" "Found 'pkglist.txt' in repository. Using it to install packages."
        sudo pacman -Syu --needed --noconfirm - < "$pkglist_path"
    else
        log "$C_YELLOW" "No 'pkglist.txt' found. Using package list defined in the script."
        sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"
    fi
    log "$C_GREEN" "Packages installed successfully."


    # 5. Create Symbolic Links
    log "$C_BLUE" "Creating symbolic links..."
    for src in "${!SYMLINKS[@]}"; do
        local source_path="${CLONE_DIR}/${src}"
        local dest_path="${SYMLINKS[$src]}"
        local dest_dir
        dest_dir=$(dirname "$dest_path")

        # Ensure source file exists
        if [ ! -e "$source_path" ]; then
            log "$C_YELLOW" "Source file not found: ${source_path}. Skipping."
            continue
        fi

        # Ensure destination directory exists
        mkdir -p "$dest_dir"

        # Backup existing file/directory if it exists and is not already a symlink
        if [ -e "$dest_path" ] && [ ! -L "$dest_path" ]; then
            local backup_path="${dest_path}.bak.$(date +%Y%m%d-%H%M%S)"
            log "$C_YELLOW" "Backing up existing ${dest_path} to ${backup_path}"
            mv "$dest_path" "$backup_path" || die "Failed to back up ${dest_path}"
        fi

        # Remove existing symlink if it's broken or points elsewhere
        if [ -L "$dest_path" ]; then
            rm -f "$dest_path"
        fi

        # Create the new symlink
        log "$C_GREEN" "Linking ${source_path} -> ${dest_path}"
        ln -s "$source_path" "$dest_path" || die "Failed to create symlink for ${dest_path}"
    done

    # Finalization
    echo
    log "$C_GREEN" "======================================================"
    log "$C_GREEN" "      Installation Complete!                        "
    log "$C_GREEN" "======================================================"
    echo
    log "$C_BLUE" "Please log out and log back in to start your new Hyprland session."
    log "$C_BLUE" "You may also need to change your default shell to Zsh with: chsh -s /bin/zsh"
    echo
}

# ---
# Script Execution
# ---
main "$@"
