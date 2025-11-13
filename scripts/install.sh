#!/bin/bash
# GTA San Andreas Mod Pack Installer (Bash)
# Linux/Mac installation script - Automatically detects GTA SA and applies mods

set -e

# Script configuration
MOD_PACK_VERSION="2.0"
REQUIRED_SPACE_GB=3
BACKUP_SUFFIX="backup_$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Functions
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

show_help() {
    print_color "$CYAN" "GTA San Andreas Mod Pack Installer v$MOD_PACK_VERSION"
    echo ""
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --path PATH     Custom path to GTA San Andreas installation"
    echo "  -s, --skip-backup   Skip creating backup of original files"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./install.sh"
    echo "  ./install.sh -p ~/Games/gtasa"
    echo "  ./install.sh --skip-backup"
}

find_gta_san_andreas() {
    print_color "$CYAN" "🔍 Searching for GTA San Andreas installation..."
    
    # Common installation paths for Linux
    local common_paths=(
        "$HOME/.steam/steam/steamapps/common/Grand Theft Auto San Andreas"
        "$HOME/.local/share/Steam/steamapps/common/Grand Theft Auto San Andreas"
        "$HOME/Games/GTA San Andreas"
        "$HOME/gtasa"
        "/opt/gtasa"
        # Wine/Proton paths
        "$HOME/.wine/drive_c/Program Files (x86)/Rockstar Games/GTA San Andreas"
        "$HOME/.wine/drive_c/Program Files/Rockstar Games/GTA San Andreas"
    )
    
    # macOS paths
    if [[ "$OSTYPE" == "darwin"* ]]; then
        common_paths+=(
            "$HOME/Library/Application Support/Steam/steamapps/common/Grand Theft Auto San Andreas"
            "/Applications/Grand Theft Auto San Andreas"
        )
    fi
    
    for path in "${common_paths[@]}"; do
        if [[ -f "$path/gta_sa.exe" ]] || [[ -f "$path/gta-sa" ]]; then
            print_color "$GREEN" "✓ Found GTA San Andreas at: $path"
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

check_disk_space() {
    local path=$1
    local available_space=$(df -BG "$path" | awk 'NR==2 {print $4}' | sed 's/G//')
    
    if (( available_space < REQUIRED_SPACE_GB )); then
        print_color "$YELLOW" "⚠ Warning: Low disk space. Required: ${REQUIRED_SPACE_GB}GB, Available: ${available_space}GB"
        return 1
    fi
    return 0
}

backup_original_files() {
    local game_path=$1
    
    print_color "$CYAN" "📦 Creating backup of original files..."
    
    local backup_path="$game_path/$BACKUP_SUFFIX"
    mkdir -p "$backup_path"
    
    # Files to backup
    local files_to_backup=(
        "gta_sa.exe"
        "gta-sa"
        "models/gta3.img"
        "data/vehicles.ide"
        "data/handling.cfg"
    )
    
    for file in "${files_to_backup[@]}"; do
        local source_path="$game_path/$file"
        if [[ -f "$source_path" ]]; then
            local dest_path="$backup_path/$file"
            local dest_dir=$(dirname "$dest_path")
            
            mkdir -p "$dest_dir"
            cp "$source_path" "$dest_path"
            echo "  ✓ Backed up: $file"
        fi
    done
    
    print_color "$GREEN" "✓ Backup created at: $backup_path"
    print_color "$YELLOW" "  To restore, copy files from this folder back to the game directory."
}

install_mod_pack() {
    local game_path=$1
    
    print_color "$CYAN" "📥 Installing mod pack..."
    
    # Check if mod pack exists
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local mod_pack_path="$script_dir/modpack"
    
    if [[ ! -d "$mod_pack_path" ]]; then
        print_color "$RED" "✗ Mod pack folder not found at: $mod_pack_path"
        print_color "$YELLOW" "  Please extract the mod pack files first!"
        return 1
    fi
    
    # Copy mod files
    echo "  Copying mod files..."
    
    local mod_folders=("models" "data" "textures" "scripts")
    for folder in "${mod_folders[@]}"; do
        local source_path="$mod_pack_path/$folder"
        if [[ -d "$source_path" ]]; then
            local dest_path="$game_path/$folder"
            mkdir -p "$dest_path"
            cp -r "$source_path"/* "$dest_path/"
            echo "  ✓ Installed: $folder"
        fi
    done
    
    print_color "$GREEN" "✓ Mod pack installed successfully!"
}

verify_installation() {
    local game_path=$1
    
    print_color "$CYAN" "🔎 Verifying installation..."
    
    local critical_files=(
        "gta_sa.exe"
        "gta-sa"
        "models/gta3.img"
    )
    
    local all_files_exist=true
    for file in "${critical_files[@]}"; do
        local file_path="$game_path/$file"
        if [[ ! -f "$file_path" ]]; then
            # Only report error if it's not an OS-specific file
            if [[ "$file" != "gta_sa.exe" ]] || [[ "$OSTYPE" != "darwin"* && "$OSTYPE" != "linux-gnu"* ]]; then
                if [[ "$file" != "gta-sa" ]] || [[ "$OSTYPE" == "darwin"* || "$OSTYPE" == "linux-gnu"* ]]; then
                    continue
                fi
                print_color "$RED" "✗ Missing file: $file"
                all_files_exist=false
            fi
        fi
    done
    
    if [[ "$all_files_exist" == true ]]; then
        print_color "$GREEN" "✓ All critical files present"
        return 0
    fi
    
    return 1
}

show_completion_message() {
    local game_path=$1
    
    echo ""
    print_color "$GREEN" "═══════════════════════════════════════════════════════"
    print_color "$GREEN" "  🎉 Installation Complete!"
    print_color "$GREEN" "═══════════════════════════════════════════════════════"
    echo ""
    print_color "$NC" "✓ GTA San Andreas Mod Pack v$MOD_PACK_VERSION has been installed."
    echo ""
    print_color "$CYAN" "Next steps:"
    echo "  1. Launch GTA San Andreas from your game library or:"
    echo "     $game_path"
    echo "  2. Adjust graphics settings if needed for your hardware"
    echo "  3. Enjoy the enhanced San Andreas experience!"
    echo ""
    print_color "$YELLOW" "Troubleshooting:"
    echo "  - If the game crashes, check file permissions"
    echo "  - For performance issues, lower graphics settings in-game"
    echo "  - To restore original game, copy files from the backup folder"
    echo ""
    print_color "$CYAN" "Need help? Visit: https://gta-san-andreas.in/tutorials"
    echo ""
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

# Parse arguments
GAME_PATH=""
SKIP_BACKUP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--path)
            GAME_PATH="$2"
            shift 2
            ;;
        -s|--skip-backup)
            SKIP_BACKUP=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Display banner
clear
print_color "$CYAN" "═══════════════════════════════════════════════════════"
print_color "$CYAN" "  GTA San Andreas Mod Pack Installer"
print_color "$CYAN" "  Version $MOD_PACK_VERSION"
print_color "$CYAN" "═══════════════════════════════════════════════════════"
echo ""

# Check if running as root (not recommended)
if [[ $EUID -eq 0 ]]; then
    print_color "$YELLOW" "⚠ Warning: Running as root is not recommended"
    echo ""
fi

# Find or validate game path
if [[ -z "$GAME_PATH" ]]; then
    if ! GAME_PATH=$(find_gta_san_andreas); then
        print_color "$RED" "✗ GTA San Andreas not found automatically."
        echo ""
        print_color "$YELLOW" "Please specify the game path manually:"
        echo "  ./install.sh -p /path/to/gtasa"
        echo ""
        exit 1
    fi
else
    if [[ ! -f "$GAME_PATH/gta_sa.exe" ]] && [[ ! -f "$GAME_PATH/gta-sa" ]]; then
        print_color "$RED" "✗ GTA San Andreas executable not found at: $GAME_PATH"
        print_color "$YELLOW" "  Please check the path and try again."
        exit 1
    fi
    print_color "$GREEN" "✓ Using custom game path: $GAME_PATH"
fi

echo ""

# Check disk space
if ! check_disk_space "$GAME_PATH"; then
    read -p "Continue anyway? (y/N): " continue
    if [[ "$continue" != "y" ]] && [[ "$continue" != "Y" ]]; then
        print_color "$YELLOW" "Installation cancelled."
        exit 0
    fi
fi

echo ""

# Create backup
if [[ "$SKIP_BACKUP" == false ]]; then
    if ! backup_original_files "$GAME_PATH"; then
        read -p "Backup failed. Continue without backup? (y/N): " continue
        if [[ "$continue" != "y" ]] && [[ "$continue" != "Y" ]]; then
            print_color "$YELLOW" "Installation cancelled."
            exit 0
        fi
    fi
    echo ""
fi

# Install mod pack
if ! install_mod_pack "$GAME_PATH"; then
    print_color "$RED" "✗ Installation failed. Please check the errors above."
    exit 1
fi

echo ""

# Verify installation
if ! verify_installation "$GAME_PATH"; then
    print_color "$YELLOW" "⚠ Verification found issues. The game may not work correctly."
fi

# Show completion message
show_completion_message "$GAME_PATH"

# Pause before exit
read -p "Press Enter to exit"
