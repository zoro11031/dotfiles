if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
    set PATH $HOME/.emacs.d/bin $PATH
    alias vim="nvim"
    zoxide init fish | source
    starship init fish | source

end
