#!/usr/bin/env bash
set -e

REPO="$HOME/.dotfiles"
TARGET_HOME="$HOME"

cd "$REPO" || exit 1

for f in .bash_logout .bash_profile .bashrc .zshrc .p10k.zsh .tmux.conf .vimrc .vim .config; do
  [ -e "$f" ] || continue
  ln -sf "$REPO/$f" "$TARGET_HOME/$f"
done

[ -d "$TARGET_HOME/.ssh" ] && chmod 700 "$TARGET_HOME/.ssh" && chmod 600 "$TARGET_HOME/.ssh/"* 2>/dev/null || true

echo "Dotfiles linked."

