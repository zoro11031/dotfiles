# dotfiles

My personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) for easy synchronization across laptop and desktop.

## What is GNU Stow?

GNU Stow is a symlink farm manager which makes it easy to manage dotfiles. Instead of copying configuration files around, Stow creates symlinks from your home directory to the files in this repository. This approach allows you to:

- Version control your configurations with git
- Easily sync configurations across multiple machines
- Keep your dotfiles organized in one place
- Selectively install only the configurations you need

## Repository Structure

The repository is organized into packages, where each directory represents a package that can be independently installed:

```
dotfiles/
├── package1/
│   └── .config/
│       └── app1/
│           └── config
├── package2/
│   └── .bashrc
└── README.md
```

When you stow a package, Stow will create symlinks in your home directory that point to the files in the package directory.

## Prerequisites

Install GNU Stow:

### Fedora/RHEL
```bash
sudo dnf install stow
```

### Debian/Ubuntu
```bash
sudo apt install stow
```

### Arch Linux
```bash
sudo pacman -S stow
```

### macOS
```bash
brew install stow
```

## Installation

1. Clone this repository to your home directory:
```bash
git clone https://github.com/zoro11031/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Use GNU Stow to symlink configurations:

```bash
# Install all packages
stow */

# Install a specific package
stow package-name

# Install multiple packages
stow package1 package2 package3
```

3. To remove/uninstall a package:
```bash
stow -D package-name
```

4. To re-stow (useful after making changes):
```bash
stow -R package-name
```

## Usage Examples

```bash
# Install all dotfiles
cd ~/dotfiles
stow */

# Install only zsh configuration
stow zsh

# Install both zsh and vim configurations
stow zsh vim

# Remove vim configuration
stow -D vim

# Restow (update) zsh configuration after making changes
stow -R zsh
```

## Tips

- **Backup First**: Before stowing, backup any existing configuration files that might conflict
- **Test First**: Use `stow -n <package>` to simulate the operation without making changes (dry-run)
- **Conflicts**: If Stow encounters existing files, it will abort. Move or remove conflicting files first
- **Selective Installation**: You don't have to install all packages - choose only what you need

## Adding New Configurations

1. Create a new directory for your package:
```bash
mkdir -p new-package/.config/app-name
```

2. Add your configuration files:
```bash
cp ~/.config/app-name/config new-package/.config/app-name/
```

3. Remove the original (after backing up!):
```bash
rm ~/.config/app-name/config
```

4. Stow the package:
```bash
stow new-package
```

5. Commit your changes:
```bash
git add new-package
git commit -m "Add new-package configuration"
git push
```

## License

See [LICENSE](LICENSE) file for details.
