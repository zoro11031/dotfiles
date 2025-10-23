# ========================================
# OPTIMIZED ZSHRC WITH ZINIT & POWERLEVEL10K
# Fast startup with all essential features
# ========================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ========================================
# Path & Environment
# ========================================
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# Additional environment
export WINAPPS_SRC_DIR="$HOME/.local/bin/winapps-src"
export LESS='-R -X -F'
export LESSHISTFILE='-'
export MANPAGER='less -R'
export GROFF_NO_SGR=1
export CLICOLOR=1
export GREP_COLOR='1;32'
export KEYTIMEOUT=1

# Bat integration (if available) - but NOT for man pages
if command -v bat &> /dev/null; then
  export BAT_THEME="ansi"
  alias cat='bat --paging=never'
  alias less='bat --paging=always'
fi

# ========================================
# Zinit Setup
# ========================================
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [[ ! -d "$ZINIT_HOME" ]]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   if command -v git &> /dev/null; then
     git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 2>/dev/null
   else
     echo "Warning: git not found, cannot install zinit" >&2
   fi
fi

# Source/Load zinit - only if it exists
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"
else
  echo "Warning: zinit not found at ${ZINIT_HOME}" >&2
  # Define dummy zinit functions so config doesn't break
  zinit() { : }
fi

# ========================================
# Powerlevel10k Theme
# ========================================
zinit ice depth=1; zinit light romkatv/powerlevel10k

# ========================================
# Zinit Plugins - PART 1: Before compinit
# ========================================
# Core completions - Must load BEFORE compinit
zinit light zsh-users/zsh-completions

# ========================================
# Completion System
# ========================================
# Ensure cache directory exists
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

autoload -Uz compinit

# Initialize completion system with fallback for errors
# If compinit fails (e.g., due to insecure directories), retry with -C flag
# WARNING: -C bypasses security checks - use temporarily only!
# Proper fix: run 'compaudit' and fix permissions on reported directories
if compinit 2>/tmp/compinit.log; then
  # compinit succeeded; nothing to do
else
  echo "⚠️  compinit failed - running with -C (bypassing security checks)" >&2
  echo "   Check /tmp/compinit.log for details" >&2
  echo "   Run 'zsh-fix-completion' to properly fix permissions" >&2
  compinit -C
fi

# IMPORTANT: If tab completion is broken after restart:
#   1. Check errors: cat /tmp/compinit.log
#   2. Check insecure dirs: compaudit
#   3. Run the fix utility: zsh-fix-completion
# Do NOT rely on -C flag permanently - fix the root cause!

# Replay cached completions from zinit
zinit cdreplay -q

# ========================================
# Completion Styling (configure BEFORE loading fzf-tab)
# ========================================
# Basic completion settings
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Caching for better performance
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# Additional completion tweaks
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ========================================
# Zinit Plugins - PART 2: After compinit
# ========================================
# fzf-tab - MUST load AFTER compinit but BEFORE syntax highlighting
# This is critical for fzf-tab to work properly!
zinit light Aloxaf/fzf-tab 2>/dev/null || true

# fzf-tab configuration - Enable fzf-tab menu and features
# Disable default menu to let fzf-tab take over
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Syntax highlighting & autosuggestions - MUST load AFTER fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# Additional useful plugins
zinit light hlissner/zsh-autopair 2>/dev/null || true

# OMZ snippets for compatibility
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found 2>/dev/null || true

# History substring search
zinit light zsh-users/zsh-history-substring-search

# ========================================
# History Configuration
# ========================================
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# ========================================
# Shell Options
# ========================================
# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_MINUS

# Correction & globbing
setopt CORRECT
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt NO_NOMATCH

CORRECT_IGNORE='_*'
CORRECT_IGNORE_FILE='.*'

# ========================================
# Keybindings
# ========================================
bindkey -e  # Emacs mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History substring search (up/down arrows)
if (( ${+functions[_zsh_history_substring_search_up]} )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

# ========================================
# Aliases - Basic
# ========================================
alias vim='nvim'
alias please='sudo $(fc -ln -1)'
alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc'

# Grep with color
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}'

# History shortcuts
alias h='history'
alias hgrep="fc -El 0 | grep"

# Disk usage
alias dud='du -d 1 -h'
(( $+commands[duf] )) || alias duf='du -sh *'

# Directory navigation shortcuts
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias d='dirs -v | head -10'

# ========================================
# Global Aliases (for piping)
# ========================================
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

# ========================================
# Utility Functions
# ========================================

# Create directory and cd into it
unalias mkcd 2>/dev/null
mkcd() {
  [[ -z "$1" ]] && { echo "Usage: mkcd <directory>"; return 1; }
  mkdir -p "$1" && cd "$1"
}

# Find files by name (case-insensitive)
unalias ff 2>/dev/null
ff() {
  if [[ -z "$1" ]]; then
    echo "Usage: ff <pattern>"
    echo "Example: ff .zshrc"
    echo "         ff '*.py'"
    return 1
  fi
  find . -iname "*$1*" 2>/dev/null
}

# Extract any archive format
unalias extract 2>/dev/null
extract() {
  if [[ ! -f "$1" ]]; then
    echo "Error: '$1' is not a valid file"
    return 1
  fi

  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.zip)            unzip "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.7z)             7z x "$1" ;;
    *.Z)              uncompress "$1" ;;
    *)                echo "Error: '$1' cannot be extracted via extract()"; return 1 ;;
  esac
}

# Search aliases by keyword
aliases() {
  if [[ -z "$1" ]]; then
    echo "Usage: aliases <keyword>"
    echo "Example: aliases git"
    echo ""
    echo "Or use 'help-aliases' to see common/useful aliases"
    return 1
  fi

  echo "Aliases matching '$1':"
  if command -v bat &> /dev/null; then
    alias | grep -i "$1" | command bat --language=bash --paging=never
  else
    alias | grep -i "$1"
  fi
}

# Show help for common aliases and commands
help-aliases() {
  local content='# Common Aliases & Commands

## Git Shortcuts (from git plugin)
gst     = git status
ga      = git add
gaa     = git add --all
gc      = git commit -v
gcmsg   = git commit -m
gp      = git push
gl      = git pull
gco     = git checkout
gcb     = git checkout -b (create new branch)
gd      = git diff
glog    = git log --oneline --decorate --graph
gcl     = git clone
gb      = git branch
gba     = git branch -a

## File Operations
cat     = bat with syntax highlighting (if installed)
less    = bat with paging (if installed)
vim     = nvim (neovim)
ff      = Find files by name (case-insensitive)

## Directory Navigation
cd <name> = Jump to directory (with fzf/zoxide if installed)
d        = Show directory stack
..       = cd ..
...      = cd ../..
....     = cd ../../..

## System Commands
please   = Run last command with sudo
mkcd     = Create directory and cd into it
extract  = Extract any archive (tar, zip, 7z, etc.)
ff       = Find files by name pattern

## Search Functions
aliases <keyword>  = Show aliases matching keyword
help-aliases       = Show this help menu
h                  = Show command history
hgrep <term>       = Search command history

## Completion & Debugging
zsh-check-completion = Diagnose tab completion issues
zsh-fix-completion   = Fix permissions and rebuild completions
zsh-clear-cache      = Clear completion caches
zsh-rehash           = Rebuild completions

## Global Aliases (use at end of command)
H   = | head
T   = | tail
G   = | grep
L   = | less
NE  = 2> /dev/null
NUL = > /dev/null 2>&1

Example: cat file.txt G "error" H

## Keyboard Shortcuts
ESC ESC   = Add sudo to current command
Ctrl+R    = Fuzzy search command history (with fzf)
Ctrl+T    = Fuzzy file finder (with fzf)
Alt+C     = Fuzzy directory finder (with fzf)
↑/↓       = History substring search
Ctrl+P    = Previous command
Ctrl+N    = Next command

## Tips
- Use "which <alias>" to see what an alias does
- Use "man <command>" for detailed help
- Type partial command + UP arrow for history search'

  if command -v bat &> /dev/null; then
    echo "$content" | command bat --language=markdown --paging=never
  else
    echo "$content"
  fi
}

# ========================================
# Performance Benchmark Utilities
# ========================================

# Quick benchmark: measure shell startup time
alias zsh-bench='for i in {1..10}; do time zsh -i -c exit; done'

# Detailed benchmark: show what's taking time
alias zsh-profile='time zsh -i -c exit'

# Profile plugin loading
zsh-debug-startup() {
  echo "Profiling zsh startup..."
  echo "Note: You may need to restart your shell to see output"
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>/tmp/zsh-startup.$$.log
  setopt xtrace prompt_subst
  source ~/.zshrc
  unsetopt xtrace
  exec 2>&3 3>&-
  echo "Profile written to /tmp/zsh-startup.$$.log"
  echo "View with: less /tmp/zsh-startup.$$.log"
}

# Show slowest loading parts
zsh-analyze() {
  if [[ -f /tmp/zsh-startup.$$.log ]]; then
    echo "Analyzing startup profile..."
    awk '{print $1}' /tmp/zsh-startup.$$.log | sort -n | tail -20
  else
    echo "No profile found. Run 'zsh-debug-startup' first."
  fi
}

# Clear completion cache
alias zsh-clear-cache='rm -f ~/.zcompdump* && rm -rf ${XDG_CACHE_HOME:-$HOME/.cache}/zsh && echo "Cache cleared! Restart your shell."'

# Rehash completions
alias zsh-rehash='rehash && compinit'

# Diagnose completion issues
zsh-check-completion() {
  echo "=== Checking Zsh Completion System ==="
  echo ""

  echo "1. Checking compinit errors:"
  if [[ -f /tmp/compinit.log && -s /tmp/compinit.log ]]; then
    echo "   ⚠️  Errors found in /tmp/compinit.log:"
    cat /tmp/compinit.log
  else
    echo "   ✓ No errors in /tmp/compinit.log"
  fi
  echo ""

  echo "2. Checking for insecure directories:"
  local insecure_dirs=$(compaudit 2>/dev/null)
  if [[ -n "$insecure_dirs" ]]; then
    echo "   ⚠️  Insecure directories found (world/group-writable):"
    echo "$insecure_dirs" | sed 's/^/      /'
    echo ""
    echo "   Fix with: zsh-fix-completion"
  else
    echo "   ✓ No insecure directories found"
  fi
  echo ""

  echo "3. Checking cache directory:"
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  if [[ -d "$cache_dir" && -w "$cache_dir" ]]; then
    echo "   ✓ Cache directory exists and is writable: $cache_dir"
  else
    echo "   ⚠️  Cache directory missing or not writable: $cache_dir"
  fi
  echo ""

  echo "4. Checking completion functions:"
  if (( ${+functions[compinit]} )); then
    echo "   ✓ compinit is loaded"
  else
    echo "   ✗ compinit not loaded"
  fi

  if (( ${+functions[_zsh_highlight]} )) || (( ${+functions[_zsh_autosuggest_start]} )); then
    echo "   ✓ Syntax highlighting/autosuggestions loaded"
  else
    echo "   ⚠️  Syntax highlighting/autosuggestions may not be loaded"
  fi
  echo ""

  echo "5. Testing basic completion:"
  echo -n "   "
  if whence -v ls >/dev/null 2>&1; then
    echo "✓ Basic command completion works"
  else
    echo "✗ Basic command completion broken"
  fi
  echo ""

  echo "=== Quick fixes ==="
  echo "  • Clear cache:        zsh-clear-cache"
  echo "  • Fix permissions:    zsh-fix-completion"
  echo "  • Rebuild completions: zsh-rehash"
}

# Fix completion permissions and rebuild
zsh-fix-completion() {
  echo "=== Fixing Zsh Completion System ==="
  echo ""

  # Check for insecure directories
  local insecure_dirs=$(compaudit 2>/dev/null)

  if [[ -z "$insecure_dirs" ]]; then
    echo "✓ No insecure directories found"
  else
    echo "Found insecure directories:"
    echo "$insecure_dirs" | sed 's/^/  /'
    echo ""
    echo "Fixing permissions (removing group/other write)..."

    # Fix permissions on reported directories
    echo "$insecure_dirs" | while IFS= read -r dir; do
      if [[ -d "$dir" ]]; then
        chmod -R go-w "$dir" 2>/dev/null && echo "  ✓ Fixed: $dir" || echo "  ✗ Failed: $dir (try with sudo?)"
      elif [[ -f "$dir" ]]; then
        chmod go-w "$dir" 2>/dev/null && echo "  ✓ Fixed: $dir" || echo "  ✗ Failed: $dir (try with sudo?)"
      fi
    done
  fi
  echo ""

  # Clear caches
  echo "Clearing completion caches..."
  rm -f ~/.zcompdump* 2>/dev/null
  rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"* 2>/dev/null
  echo "  ✓ Caches cleared"
  echo ""

  # Ensure cache directory exists
  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

  # Rebuild completions
  echo "Rebuilding completions..."
  autoload -Uz compinit
  compinit 2>&1 | tee /tmp/compinit-rebuild.log

  if [[ -s /tmp/compinit-rebuild.log ]]; then
    echo ""
    echo "⚠️  Errors during rebuild:"
    cat /tmp/compinit-rebuild.log
  else
    echo "  ✓ Completions rebuilt successfully"
  fi
  echo ""

  echo "=== Done ==="
  echo "Restart your shell or run: exec zsh"
}

# ========================================
# FZF Integration
# ========================================
if command -v fzf &> /dev/null; then
  # Try system installation first
  if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    export FZF_BASE=/usr/share/fzf
    source /usr/share/fzf/key-bindings.zsh 2>/dev/null
    source /usr/share/fzf/completion.zsh 2>/dev/null
  else
    # Use fzf's built-in integration if available
    eval "$(fzf --zsh 2>/dev/null)" || true
  fi
fi

# ========================================
# Zoxide Integration (better cd)
# ========================================
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init --cmd cd zsh 2>/dev/null)" || true
fi

# ========================================
# Command-not-found handler
# ========================================
if [[ -f /etc/zsh_command_not_found ]]; then
  command_not_found_handler() {
    if [[ -x /usr/lib/command-not-found ]]; then
      /usr/lib/command-not-found -- "$1"
    elif [[ -x /usr/share/command-not-found/command-not-found ]]; then
      /usr/share/command-not-found/command-not-found -- "$1"
    else
      printf "zsh: command not found: %s\n" "$1" >&2
    fi
    return 127
  }
fi

# ========================================
# Powerlevel10k Configuration
# ========================================
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ========================================
# Optional Custom Configs
# ========================================
# Reduce zsh's internal watchers
WATCHFMT='%n from %M has %a tty%l at %T %W'
