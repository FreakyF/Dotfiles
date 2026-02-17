# Optional: load zprof to profile shell startup
#zmodload zsh/zprof

# Fastfetch wrapper: select config based on is-low-color-console.sh
fastfetch() {
  local arg

  # If -c/--config is explicitly provided, respect the user-specified config
  for arg in "$@"; do
    case "$arg" in
      -c|--config)
        command fastfetch "$@"
        return
        ;;
    esac
  done

  # Otherwise, pick a config depending on the terminal capabilities
  if is-low-color-console.sh; then
    # In low-color consoles, use a simplified/low-color config
    command fastfetch --config "$HOME/.config/fastfetch/config-lowcolor.jsonc" "$@"
  else
    # In normal terminals, use the default Fastfetch behavior
    command fastfetch "$@"
  fi
}

# Detect low-color console once for theme/prompt logic
if is-low-color-console.sh; then
  IS_LOW_COLOR_CONSOLE=1
else
  IS_LOW_COLOR_CONSOLE=0
fi

# Oh My Zsh installation directory and theme
export ZSH="/usr/share/oh-my-zsh"

# Use a minimal theme (or none) on low-color consoles, full theme otherwise
if (( IS_LOW_COLOR_CONSOLE )); then
  ZSH_THEME=""
else
  ZSH_THEME="gozilla"
fi

# Disable automatic Oh My Zsh update checks
zstyle ':omz:update' mode disabled

# Disable aliases from all plugins; selectively enable lazy loading
zstyle ':omz:plugins:*' aliases no

zstyle ':omz:plugins:docker'           lazy yes
zstyle ':omz:plugins:terraform'        lazy yes
zstyle ':omz:plugins:kubectl'          lazy yes
zstyle ':omz:plugins:helm'             lazy yes
zstyle ':omz:plugins:dotnet'           lazy yes
zstyle ':omz:plugins:npm'              lazy yes
zstyle ':omz:plugins:azure'            lazy yes
zstyle ':omz:plugins:golang'           lazy yes
zstyle ':omz:plugins:python'           lazy yes
zstyle ':omz:plugins:rust'             lazy yes

plugins=(
  vi-mode command-not-found
  copypath copyfile
  docker docker-compose terraform kubectl helm
  azure
  dotnet npm golang python rust
)

# Make vi-mode key sequences more responsive
export KEYTIMEOUT=2

# Initialize Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Enable Zsh syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# For low-color consoles, switch to the simple built-in redhat prompt
if (( IS_LOW_COLOR_CONSOLE )); then
  autoload -U promptinit
  promptinit
  prompt redhat
fi

# Optional: list the 20 slowest startup hooks
# zprof | head -n 20
#
