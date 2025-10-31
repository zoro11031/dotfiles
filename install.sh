#!/usr/bin/env bash
#
# Install dotfiles using GNU Stow
#
# Usage: ./install.sh [package1] [package2] ...
# If no packages are specified, all packages will be installed.

set -e

CONFLICT_MODE=""
BACKUP_DIR=""

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$DOTFILES_DIR"
TARGET_DIR="$HOME"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

is_within_target() {
    local path=$1
    [[ $path == "$TARGET_DIR" ]] || [[ $path == "$TARGET_DIR"/* ]]
}

ensure_backup_dir() {
    if [ -z "$BACKUP_DIR" ]; then
        local timestamp
        timestamp=$(date +%Y%m%d-%H%M%S)
        BACKUP_DIR="$TARGET_DIR/.dotfiles-backups/$timestamp"
        mkdir -p "$BACKUP_DIR"
    fi
}

handle_conflict_overwrite() {
    local target=$1

    if ! is_within_target "$target"; then
        echo -e "${RED}Refusing to remove path outside of target: $target${NC}"
        return 1
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "  Removing $target"
        rm -rf "$target"
    fi
}

handle_conflict_backup() {
    local target=$1

    if ! is_within_target "$target"; then
        echo -e "${RED}Refusing to back up path outside of target: $target${NC}"
        return 1
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then
        ensure_backup_dir
        local rel_target
        rel_target="${target#$TARGET_DIR/}"
        local destination="$BACKUP_DIR/$rel_target"
        mkdir -p "$(dirname "$destination")"
        mv "$target" "$destination"
        echo "  Moved $target -> $destination"
    fi
}

resolve_conflicts() {
    local package=$1
    local output
    local conflicts=()
    local status=0
    declare -A seen=()

    output=$(cd "$STOW_DIR" && stow -n -v -t "$TARGET_DIR" "$package" 2>&1) || status=$?

    while IFS= read -r line; do
        if [[ $line == *"CONFLICT:"* ]]; then
            local conflict=${line##*: }
            conflict=${conflict#./}
            if [ -n "$conflict" ] && [ -z "${seen[$conflict]}" ]; then
                conflicts+=("$conflict")
                seen[$conflict]=1
            fi
        fi
    done <<< "$output"

    if [ ${#conflicts[@]} -eq 0 ]; then
        if [ $status -ne 0 ]; then
            echo -e "${RED}Failed to analyze package '$package':${NC}"
            echo "$output"
            return 1
        fi
        return 0
    fi

    echo -e "${YELLOW}Conflicts detected for package '$package':${NC}"
    printf '  - %s\n' "${conflicts[@]}"

    local action=$CONFLICT_MODE

    if [ -z "$action" ]; then
        if [ ! -t 0 ]; then
            echo -e "${RED}Cannot prompt for conflict resolution in non-interactive mode.${NC}"
            echo "Please rerun with --force, --backup, or --skip-on-conflict."
            return 1
        fi
        while true; do
            read -rp "Choose action: [o]verwrite/[b]ackup/[s]kip package: " response
            case ${response,,} in
                o|overwrite)
                    action="overwrite"
                    break
                    ;;
                b|backup)
                    action="backup"
                    break
                    ;;
                s|skip)
                    action="skip"
                    break
                    ;;
                *)
                    echo "Please enter 'o', 'b', or 's'."
                    ;;
            esac
        done
    fi

    case $action in
        overwrite)
            for conflict in "${conflicts[@]}"; do
                local target="$TARGET_DIR/$conflict"
                handle_conflict_overwrite "$target" || return 1
            done
            ;;
        backup)
            for conflict in "${conflicts[@]}"; do
                local target="$TARGET_DIR/$conflict"
                handle_conflict_backup "$target" || return 1
            done
            ;;
        skip)
            echo "Skipping package '$package' at user request."
            return 2
            ;;
        *)
            echo -e "${RED}Unknown conflict resolution mode '$action'${NC}"
            return 1
            ;;
    esac

    return 0
}

# Install a single package
install_package() {
    local package=$1
    echo -e "${GREEN}Installing $package...${NC}"

    if [ ! -d "$STOW_DIR/$package" ]; then
        echo -e "${RED}Error: Package '$package' does not exist${NC}"
        return 1
    fi

    local conflict_status=0
    resolve_conflicts "$package"
    conflict_status=$?
    if [ $conflict_status -ne 0 ]; then
        if [ $conflict_status -eq 2 ]; then
            echo -e "${YELLOW}⚠ Skipped $package at user request${NC}"
            return 2
        fi
        echo -e "${RED}✗ Skipping $package due to unresolved conflicts${NC}"
        return 1
    fi

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
            --force)
                CONFLICT_MODE="overwrite"
                ;;
            --backup)
                CONFLICT_MODE="backup"
                ;;
            --skip-on-conflict)
                CONFLICT_MODE="skip"
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS] [PACKAGES...]"
                echo ""
                echo "Options:"
                echo "  -u, --uninstall    Uninstall the specified packages"
                echo "  -r, --reinstall    Reinstall the specified packages"
                echo "      --force        Overwrite conflicting files without prompting"
                echo "      --backup       Move conflicting files to a backup directory"
                echo "      --skip-on-conflict"
                echo "                      Skip packages that have conflicts"
                echo "  -h, --help         Show this help message"
                echo ""
                echo "If no packages are specified, all packages will be processed."
                echo ""
                echo "Available packages:"
                get_packages | sed 's/^/  - /'
                echo ""
                echo "Conflict resolution:"
                echo "  By default the installer prompts when it finds existing files."
                echo "  Use --force to overwrite, --backup to move them aside, or"
                echo "  --skip-on-conflict to skip installing those packages automatically."
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
    local skipped=0
    for package in "${packages[@]}"; do
        local result=0
        case $mode in
            install)
                install_package "$package"
                result=$?
                ;;
            uninstall)
                uninstall_package "$package"
                result=$?
                ;;
            reinstall)
                reinstall_package "$package"
                result=$?
                ;;
        esac
        if [ $result -eq 2 ]; then
            skipped=$((skipped + 1))
        elif [ $result -ne 0 ]; then
            failed=$((failed + 1))
        fi
        echo ""
    done

    # Summary
    echo "=== Summary ==="
    if [ $failed -eq 0 ]; then
        if [ $skipped -gt 0 ]; then
            echo -e "${YELLOW}$skipped package(s) skipped due to conflicts${NC}"
            echo -e "${GREEN}All other packages processed successfully!${NC}"
        else
            echo -e "${GREEN}All packages processed successfully!${NC}"
        fi
    else
        echo -e "${RED}$failed package(s) failed to process${NC}"
        if [ $skipped -gt 0 ]; then
            echo -e "${YELLOW}$skipped package(s) skipped due to conflicts${NC}"
        fi
        exit 1
    fi
}

main "$@"
