# ~/.zshrc - Zsh configuration file

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Enable colors
autoload -U colors && colors

# Prompt
PS1="%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$ "

# Completion system
autoload -Uz compinit
compinit

# Enable color support for ls
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    alias ls='ls --color=auto'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
fi

# Common aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Key bindings
bindkey -e  # Use emacs key bindings

# Load local customizations if present
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
