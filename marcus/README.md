# Marcus zsh template

This folder contains a portable `zsh` starter config based on your current
setup, with the machine-specific deployment aliases removed.

## Files

- `.zshrc_template`: copy or template this to `~/.zshrc`
- `.zshrc_template_minimal`: lighter variant without Powerlevel10k, zinit, or
  custom keybinding overrides

## Required dependencies

These are the minimum dependencies needed for the template to work cleanly:

- `zsh`
- `git`

The template bootstraps `zinit` on first shell startup if it is missing and
`git` is available.

## Recommended dependencies

Install these if Marcus should get the same experience as your config:

- `neovim`: default `EDITOR` and `VISUAL`
- `fzf`: enables `eval "$(fzf --zsh)"`
- `zoxide`: enables smart directory jumping
- `eza`: prettier `ls`
- `bat` or `batcat`: prettier `cat`
- `duf`: disk usage alias
- `unzip`, `p7zip`, `unrar`, `zstd`: used by the `extract()` helper
- a Nerd Font such as `MesloLGS NF`: recommended for Powerlevel10k glyphs

## Notes

- The template only adds `~/.npm-global/bin` and `~/.local/bin` to `PATH` if
  those directories already exist.
- `fzf` and `zoxide` are guarded, so the shell still loads if they are not
  installed yet.
- Host-specific Ansible aliases, SSH shortcuts, and hardcoded playbook paths
  were intentionally removed.
- Use `.zshrc_template_minimal` if Marcus should keep your aliases and shell
  helpers but avoid prompt/font assumptions and opinionated key remaps.

## Suggested Claude Code prompt

Use this prompt in Claude Code from the root of Marcus's Ansible repo:

```text
Add the zsh template at marcus/.zshrc_template to this Ansible playbook in a
way that is safe and idempotent.

Requirements:
1. Install all required dependencies for the shell config to work:
   - required: zsh, git
   - recommended: neovim, fzf, zoxide, eza, bat or batcat, duf, unzip, p7zip,
     unrar, zstd
2. Set the target user's login shell to zsh if it is not already.
3. Copy or template marcus/.zshrc_template to the target user's ~/.zshrc with
   correct ownership and permissions.
4. Keep the playbook distro-aware. If package names differ between Debian/Ubuntu
   and Fedora, handle both cleanly.
5. Do not hardcode my username. Use the playbook's target user variables or add
   them if missing.
6. Keep changes minimal and explain any assumptions.
7. After editing, show the exact Ansible tasks or role files changed and any
   variables that Marcus still needs to set.

If the repo already has a shell/bootstrap role, integrate there instead of
creating a duplicate role.
```

## Suggested package mapping

If Claude needs explicit package names, this mapping is a good default:

- Debian/Ubuntu: `zsh git neovim fzf zoxide eza bat duf unzip p7zip-full unrar zstd`
- Fedora: `zsh git neovim fzf zoxide eza bat duf unzip p7zip p7zip-plugins unrar zstd`
