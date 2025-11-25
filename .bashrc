# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Dotfiles location
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# User specific aliases and functions
alias restow='(cd "$DOTFILES" && ./install.sh -r)'
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Check if running interactively and if zsh exists in PATH
if [ ! -z "$PS1" ] && command -v zsh >/dev/null 2>&1; then
    exec zsh
fi
