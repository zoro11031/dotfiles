function emacs --wraps='emacsclient --create-frame --alternate-editor=' --wraps='emacsclient -t --create-frame --alternate-editor=' --description 'alias emacs=emacsclient --create-frame --alternate-editor='
  emacsclient --create-frame --alternate-editor= $argv; 
end
