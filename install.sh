#!/usr/bin/env bash
#
# Install dotfiles using GNU Stow
#
# Usage: ./install.sh [package1] [package2] ...
# If no packages are specified, all packages will be installed.

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$DOTFILES_DIR"
TARGET_DIR="$HOME"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track if backups were created
BACKUPS_CREATED=false

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${RED}Error: GNU Stow is not installed.${NC}"
    echo "Please install it using your package manager:"
    echo "  - Ubuntu/Debian: sudo apt-get install stow"
    echo "  - macOS: brew install stow"
    echo "  - Arch: sudo pacman -S stow"
    exit 1
fi

# Get all package directories (directories that don't start with .)
get_packages() {
    find "$STOW_DIR" -maxdepth 1 -type d ! -path "$STOW_DIR" ! -name ".*" -exec basename {} \;
}

# Detect conflicts for a package
# Returns list of files/dirs that would conflict
detect_conflicts() {
    local package=$1
    local conflicts=()

    # Find all files and directories in the package (relative to package root)
    while IFS= read -r -d '' file; do
        # Get path relative to package directory
        local rel_path="${file#$STOW_DIR/$package/}"
        local target_path="$TARGET_DIR/$rel_path"

        # Check if target exists and is not a symlink managed by stow
        if [ -e "$target_path" ] || [ -L "$target_path" ]; then
            # If it's a symlink pointing to our dotfiles, it's not a conflict
            if [ -L "$target_path" ]; then
                # Resolve the symlink to absolute path
                local link_target=$(readlink -f "$target_path")
                local expected_target="$STOW_DIR/$package/$rel_path"
                if [ "$link_target" = "$expected_target" ]; then
                    continue
                fi
            fi
            conflicts+=("$target_path")
        fi
    done < <(find "$STOW_DIR/$package" -type f -print0)

    # Only print conflicts if there are any (avoid empty string in array)
    if [ ${#conflicts[@]} -gt 0 ]; then
        printf '%s\n' "${conflicts[@]}"
    fi
}

# Backup conflicting files/directories
backup_conflicts() {
    local package=$1
    shift
    local conflicts=("$@")

    if [ ${#conflicts[@]} -eq 0 ]; then
        return 0
    fi

    echo -e "${YELLOW}⚠ Found ${#conflicts[@]} conflicting file(s) for $package${NC}"

    # Create backup directory if it doesn't exist
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        BACKUPS_CREATED=true
        echo -e "${BLUE}Created backup directory: $BACKUP_DIR${NC}"
    fi

    # Create package-specific backup directory
    local package_backup="$BACKUP_DIR/$package"
    mkdir -p "$package_backup"

    # Backup each conflicting file
    for conflict in "${conflicts[@]}"; do
        if [ -e "$conflict" ] || [ -L "$conflict" ]; then
            # Calculate relative path from TARGET_DIR
            local rel_path="${conflict#$TARGET_DIR/}"
            local backup_path="$package_backup/$rel_path"
            local backup_dir=$(dirname "$backup_path")

            # Create parent directory in backup location
            mkdir -p "$backup_dir"

            echo -e "${BLUE}  Backing up: $rel_path${NC}"
            mv "$conflict" "$backup_path"
        fi
    done

    echo -e "${GREEN}✓ Backed up conflicts to: $package_backup${NC}"
}

# Install a single package
install_package() {
    local package=$1
    echo -e "${GREEN}Installing $package...${NC}"

    if [ ! -d "$STOW_DIR/$package" ]; then
        echo -e "${RED}Error: Package '$package' does not exist${NC}"
        return 1
    fi

    # Detect and handle conflicts
    local conflicts=()
    mapfile -t conflicts < <(detect_conflicts "$package")

    if [ ${#conflicts[@]} -gt 0 ]; then
        backup_conflicts "$package" "${conflicts[@]}"
        echo ""
    fi

    # Run stow
    cd "$STOW_DIR"
    stow -v -t "$TARGET_DIR" "$package"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $package installed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to install $package${NC}"
        return 1
    fi
}

# Uninstall a single package
uninstall_package() {
    local package=$1
    echo -e "${YELLOW}Uninstalling $package...${NC}"
    
    cd "$STOW_DIR"
    stow -v -D -t "$TARGET_DIR" "$package"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $package uninstalled successfully${NC}"
    else
        echo -e "${RED}✗ Failed to uninstall $package${NC}"
        return 1
    fi
}

# Reinstall a single package
reinstall_package() {
    local package=$1
    echo -e "${YELLOW}Reinstalling $package...${NC}"
    uninstall_package "$package" 2>/dev/null || true
    install_package "$package"
}

# Main installation logic
main() {
    echo "=== Dotfiles Installation ==="
    echo "Directory: $DOTFILES_DIR"
    echo "Target: $TARGET_DIR"
    echo ""
    
    # Parse command line arguments
    local mode="install"
    local packages=()
    
    for arg in "$@"; do
        case $arg in
            -u|--uninstall)
                mode="uninstall"
                ;;
            -r|--reinstall)
                mode="reinstall"
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS] [PACKAGES...]"
                echo ""
                echo "Options:"
                echo "  -u, --uninstall    Uninstall the specified packages"
                echo "  -r, --reinstall    Reinstall the specified packages"
                echo "  -h, --help         Show this help message"
                echo ""
                echo "If no packages are specified, all packages will be processed."
                echo ""
                echo "Available packages:"
                get_packages | sed 's/^/  - /'
                exit 0
                ;;
            *)
                packages+=("$arg")
                ;;
        esac
    done
    
    # If no packages specified, use all packages
    if [ ${#packages[@]} -eq 0 ]; then
        echo "No packages specified, processing all packages..."
        mapfile -t packages < <(get_packages)
    fi
    
    echo "Packages to $mode:"
    printf '  - %s\n' "${packages[@]}"
    echo ""
    
    # Process each package
    local failed=0
    for package in "${packages[@]}"; do
        case $mode in
            install)
                install_package "$package" || failed=$((failed + 1))
                ;;
            uninstall)
                uninstall_package "$package" || failed=$((failed + 1))
                ;;
            reinstall)
                reinstall_package "$package" || failed=$((failed + 1))
                ;;
        esac
        echo ""
    done
    
    # Summary
    echo "=== Summary ==="
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}All packages processed successfully!${NC}"
    else
        echo -e "${RED}$failed package(s) failed to process${NC}"
        exit 1
    fi

    # Prompt user to review backups if any were created
    if [ "$BACKUPS_CREATED" = true ] && [ -d "$BACKUP_DIR" ]; then
        echo ""
        echo "=== Backup Review ==="
        echo -e "${YELLOW}Your old dotfiles have been backed up to:${NC}"
        echo -e "${BLUE}$BACKUP_DIR${NC}"
        echo ""
        echo "Please review the backed up files:"
        echo "  ls -la $BACKUP_DIR"
        echo ""
        echo "If you no longer need them, you can delete the backup directory:"
        echo "  rm -rf $BACKUP_DIR"
        echo ""
        echo -e "${YELLOW}⚠ Make sure to review before deleting!${NC}"
    fi
}

main "$@"
