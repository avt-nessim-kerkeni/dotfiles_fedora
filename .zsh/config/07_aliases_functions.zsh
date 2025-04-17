#==============================================================================
# Aliases & Functions
#==============================================================================

# Navigation aliases
alias mkdir='mkdir -p'

# Safer rm command
alias rm='rm -i'

# Clipboard function
function clipboard() {
  if [[ -t 1 || "$INSIDE_NVIM" == "1" ]]; then
    local data=$(base64 | tr -d '\n')
    printf "\e]52;c;%s\a" "$data"
  fi
}

# Extract function - handle various archive types
function extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.tar.xz)    tar xJf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Make directory and cd into it
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Custom dotfiles git alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Man pages with bat
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
fi
