#==============================================================================
# Main zshrc Configuration
# Author: [Nessim et Claude Sonnet]
# Last Modified: April 17, 2025
#==============================================================================

# Core environment variables
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export ZDOTDIR="$HOME"
export ZSH_CONFIG="$HOME/.zsh/config"
export ZSH_CACHE="$HOME/.zsh/cache"

# Create necessary directories if they don't exist
mkdir -p "$ZSH_CONFIG" "$ZSH_CACHE"

# Path Configuration
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
export PATH=$PATH:/usr/local/go/bin
# Load Cargo environment
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"


# Oh My Zsh Plugin Configuration
plugins=(
  # zsh-vi-mode
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  fzf
#   fzf-tab
 )

# Load configuration files
for config_file in "$ZSH_CONFIG"/*.zsh; do
  source "$config_file"
done

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"

unalias ls 2>/dev/null
function ls() {
  eza --icons --color=auto -F "$@"
}
alias ll="ls -lh"
alias la="ls -la"
alias lt="ls --icons --tree --color=auto -F"
compdef ls=ls
# Load envman if available
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
