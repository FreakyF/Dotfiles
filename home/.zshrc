# Optional: load zprof to profile shell startup
#zmodload zsh/zprof

# Pacman wrapper: assume Node.js 25.2 is installed for -S/--sync, forward all other calls
pacman() {
    for arg in "$@"; do
        # For sync/install operations, pretend Node.js 25.2 is already installed
        if [[ "$arg" == "-S"* || "$arg" == "--sync" ]]; then
            command pacman --assume-installed nodejs=25.2 "$@"
            return
        fi
    done
    # For all other pacman invocations, run pacman as-is
    command pacman "$@"
}

# Yay wrapper: assume Node.js 25.2 is installed for -S/--sync, forward all other calls
yay() {
    for arg in "$@"; do
        # For sync/install operations, pretend Node.js 25.2 is already installed
        if [[ "$arg" == "-S"* || "$arg" == "--sync" ]]; then
            command yay --assume-installed nodejs=25.2 "$@"
            return
        fi
    done
    # For all other yay invocations, run yay as-is
    command yay "$@"
}

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

# On low-color consoles, use a simple built-in prompt and skip Oh My Zsh initialization
if is-low-color-console.sh; then
  autoload -U promptinit
  promptinit
  prompt redhat
  return
fi

# Oh My Zsh installation directory and theme
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="gozilla"

# Disable automatic Oh My Zsh update checks
zstyle ':omz:update' mode disabled

# Lazy-load NVM to reduce shell startup time
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true

# Disable aliases from all plugins; selectively enable lazy loading
zstyle ':omz:plugins:*' aliases no

zstyle ':omz:plugins:aws'              lazy yes
zstyle ':omz:plugins:azure'            lazy yes
zstyle ':omz:plugins:docker'           lazy yes
zstyle ':omz:plugins:terraform'        lazy yes
zstyle ':omz:plugins:kubectl'          lazy yes
zstyle ':omz:plugins:helm'             lazy yes
zstyle ':omz:plugins:dotnet'           lazy yes
zstyle ':omz:plugins:npm'              lazy yes


plugins=(
  vi-mode command-not-found
  copypath copyfile
  aws azure
  docker terraform kubectl helm
  dotnet npm zsh-nvm
)

# Make vi-mode key sequences more responsive
export KEYTIMEOUT=2

# Initialize Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Enable Zsh syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Optional: list the 20 slowest startup hooks
# zprof | head -n 20

