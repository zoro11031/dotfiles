# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

Each directory is a stow package. Stow creates symlinks from `~` to the files in each package.

```
dotfiles/
├── zsh/
│   └── .zshrc
├── vim/
│   └── .vimrc
└── ...
```

## Install

```bash
# Install stow
sudo dnf install stow  # Fedora
sudo apt install stow  # Debian/Ubuntu
brew install stow      # macOS

# Clone repo
git clone https://github.com/zoro11031/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow packages
stow zsh vim  # or whatever packages you want
stow */       # install everything
```

## Usage

```bash
stow package-name    # install
stow -D package-name # uninstall
stow -R package-name # reinstall
stow -n package-name # dry run
```

## License

See [LICENSE](LICENSE) file for details.
