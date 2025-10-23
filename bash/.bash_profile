# ~/.bash_profile - Bash login configuration

# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
