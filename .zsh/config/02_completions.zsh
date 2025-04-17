#==============================================================================
# Completion Configuration
#==============================================================================

# Initialize completion system
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qN.mh+24) ]]; then
  compinit -d "$ZSH_CACHE/zcompdump"
else
  compinit -C -d "$ZSH_CACHE/zcompdump"
fi

# Basic completion options
setopt COMPLETE_IN_WORD      # Complete from both ends of a word
setopt ALWAYS_TO_END         # Move cursor to end of word when completing
setopt AUTO_LIST             # Automatically list choices on an ambiguous completion
setopt AUTO_MENU             # Show completion menu on second tab press
setopt AUTO_PARAM_SLASH      # Add a trailing slash for completed directories
setopt NO_COMPLETE_ALIASES   # Complete the aliased command, not the alias
setopt LIST_PACKED           # Make completion lists more densely packed
setopt MENU_COMPLETE         # Automatically select the first match

# Completion styling with fat separators
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' verbose true

# Enhanced completion formatting with fat separators
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}%B━━━━━━ %d ━━━━━━%b%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}%B━━━━━━ %d (errors: %e) ━━━━━━%b%f'
zstyle ':completion:*:*:*:*:warnings' format '%F{red}%B━━━━━━ no matches found ━━━━━━%b%f'
zstyle ':completion:*:*:*:*:messages' format '%F{purple}%B━━━━━━ %d ━━━━━━%b%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Group completions by category
zstyle ':completion:*' group-name ''

# Cache completions for speed
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$ZSH_CACHE/zcompcache"

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# History completion
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# SSH/SCP/SFTP hostname completion
zstyle ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ })'

# Speed up completion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' use-ip true
zstyle ':completion:*' completer _extensions _complete _approximate

# Make approximate matching more helpful
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' squeeze-slashes true

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

#==============================================================================
# ZSH Autosuggestions Configuration
#==============================================================================

# Install zsh-autosuggestions if not already installed
if [[ ! -d ${ZDOTDIR:-$HOME}/.zsh/zsh-autosuggestions ]]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZDOTDIR:-$HOME}/.zsh/zsh-autosuggestions
fi

# Source zsh-autosuggestions
source ${ZDOTDIR:-$HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Configure autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8a8a,bold"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=true
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *|ls *|exit"

# Navigation keybindings for completion menu
bindkey '^[[A' up-line-or-search                  # Up arrow - search history backwards
bindkey '^[[B' down-line-or-search                # Down arrow - search history forwards
bindkey '^[[1;5A' up-line-or-beginning-search     # Ctrl+Up - smarter history search backwards
bindkey '^[[1;5B' down-line-or-beginning-search   # Ctrl+Down - smarter history search forwards
bindkey '^[[Z' reverse-menu-complete              # Shift+Tab - go backwards in menu

# Menu completion navigation
bindkey '^N' menu-complete                        # Ctrl+N - next completion
bindkey '^P' reverse-menu-complete                # Ctrl+P - previous completion

# Autosuggestion key bindings
bindkey '^ ' autosuggest-accept                   # Ctrl+Space - accept suggestion
bindkey '^F' autosuggest-accept                   # Ctrl+F - accept suggestion
bindkey '^E' autosuggest-execute                  # Ctrl+E - execute suggestion
