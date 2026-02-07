# PATH maintenance (Zsh-specific)
typeset -U path PATH                # keep PATH unique

# User-local scripts
export PATH="$HOME/.local/bin:$PATH"

# Editors
export VISUAL="nvim"         # preferred editor for interactive use
export EDITOR="nvim"         # default editor for command-line tools
export SUDO_EDITOR="nvim"    # editor used by sudoedit/visudo
export SYSTEMD_EDITOR="nvim" # editor used by systemctl edit

export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts" # add JetBrains Toolbox helper scripts

# Fastfetch shortcut
alias ff=fastfetch

# OMZ copyfile/copypath shortcuts
alias cfile=copyfile
alias cpath=copypath

# Points the Docker CLI to the rootless socket for the current user
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# Mise version manager
if [ -f "$HOME/.local/bin/mise" ] || command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi
