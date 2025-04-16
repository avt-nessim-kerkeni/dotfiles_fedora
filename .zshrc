# Oh My Zsh Configuration
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
export ZSH="$HOME/.oh-my-zsh"
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
function clipboard() {
  if [[ -t 1 || "$INSIDE_NVIM" == "1" ]]; then
    local data=$(base64 | tr -d '\n')
    printf "\e]52;c;%s\a" "$data"
  fi
}
# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  fzf
)
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
. "$HOME/.cargo/env"
export LS_COLORS="$(vivid generate catppuccin-mocha | \
  sed -e 's/ex=[^:]*/ex=38;2;243;139;168/' \
      -e 's/fi=[^:]*/fi=38;2;205;214;244/' \
      -e 's/\*.md=[^:]*/*.md=38;2;205;214;244/' \
      -e 's/\*.php=[^:]*/*.php=38;2;205;214;244/' \
      -e 's/\*.py=[^:]*/*.py=38;2;205;214;244/' \
      -e 's/\*.json=[^:]*/*.json=38;2;205;214;244/' \
      -e 's/\*.yml=[^:]*/*.yml=38;2;205;214;244/' \
      -e 's/\*.yaml=[^:]*/*.yaml=38;2;205;214;244/' \
      -e 's/\*.env=[^:]*/*.env=38;2;205;214;244/' \
      -e 's/\*.gitignore=[^:]*/*.gitignore=38;2;205;214;244/' \
      -e 's/\*.lock=[^:]*/*.lock=38;2;205;214;244/' \
      -e 's/\*.png=[^:]*/*.png=38;2;243;139;168/' \
      -e 's/\*.jpg=[^:]*/*.jpg=38;2;243;139;168/' \
      -e 's/\*.jpeg=[^:]*/*.jpeg=38;2;243;139;168/' \
      -e 's/\*.exe=[^:]*/*.exe=38;2;243;139;168/' \
      -e 's/\*.sh=[^:]*/*.sh=38;2;243;139;168/' \
      -e 's/\*.Makefile=[^:]*/*.Makefile=38;2;243;139;168/' \
  )"
EDITOR="nvim"
# Enable Pure Prompt
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
# Minimal Catppuccin Mocha FZF Theme (no background)
# FZF Key Bindings
export FZF_DEFAULT_OPTS="
--height=40%
--layout=reverse
--inline-info
--border=sharp
--border-label=' ☉__☉  '
--info='right'
--pointer='▶'
--marker='✓'
--prompt='❯ '
--preview='echo {} && bat --style=numbers --color=always --line-range=:500 {}'
--preview-window='right:50%:wrap:border-double'
--color=fg:#cdd6f4,hl:#f38ba8
--color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8
--color=info:#74c7ec,prompt:#cba6f7,pointer:#94e2d5
--color=marker:#f2cdcd,spinner:#a6e3a1,header:#b4befe
--color=border:#b4befe,label:#f5c2e7
--bind='ctrl-/:toggle-preview'
--bind='ctrl-d:preview-page-down'
--bind='ctrl-u:preview-page-up'
--bind='ctrl-y:execute-silent(echo {} | clipboard)'
--bind='ctrl-space:toggle+up'
--bind='alt-j:preview-down'
--bind='alt-k:preview-up'
--bind='alt-v:toggle-all'
--bind='tab:down,shift-tab:up'
--bind='ctrl-f:half-page-down'
--bind='ctrl-b:half-page-up'
--bind='ctrl-g:top'
--bind='ctrl-q:abort'
--bind='alt-e:execute(echo {} | xargs -r $EDITOR)'
"
# Use ripgrep for fast file finding
export FZF_DEFAULT_COMMAND='
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -n "$git_root" ]; then
    rg --files --hidden --follow --glob "!.git/*" "$git_root" | while read -r file; do
      realpath --relative-to="." "$file"
    done
  else
    rg --files --hidden --follow --glob "!.git/*"
  fi
'
# CTRL-T → trigger file search (with preview)
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
--preview='
  bash ~/.fzf_ctrl_t_opts.sh {}
'
--preview-window='right:50%:wrap:border-double'
--border-label=' (◕‿◕) Find Files 📂 '
--prompt='Files ❯ '
--bind='ctrl-/:toggle-preview'
--bind='ctrl-o:execute(xdg-open {} &>/dev/null &)'
"
# AL-C Settings
export FZF_ALT_C_COMMAND="eza --color=always --all --only-dirs --sort=modified --icons"
export FZF_ALT_C_OPTS="
--ansi
--preview 'eza --tree --level=2 --color=always --icons -- {}'
--preview-window right:50%:wrap:border-rounded
--border-label=' Directories '
--prompt 'Dirs ❯ '
--bind 'ctrl-/:toggle-preview'
"
# CTRL-R → search shell history without preview
export FZF_CTRL_R_OPTS="
--no-preview
--border-label=' History '
--prompt='Shell Hist ❯ '
"
# Bind Ctrl+G to open the fzf content search
bindkey -s '^G' 'fzf_content_search\n'
# Custom completion function for cd, ssh, and nvim
# Set fzf completion trigger to '~~'
export FZF_COMPLETION_TRIGGER='**'

source /usr/share/fzf/shell/key-bindings.zsh

# Enhanced History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Aliases for FZF Enhanced Workflow
alias fcd='cd $(fd -t d | fzf)'
alias fkill='kill $(ps aux | fzf | awk "{print \$2}")'
alias fvim='vim $(fzf)'

# Large History Browser
function fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

function z() {
  zoxide "$@"
}
# Auto-complete and suggestions
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
bindkey '^ ' autosuggest-accept

eval "$(zoxide init zsh)"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

unalias ls 2>/dev/null
function ls() {
  eza --icons --color=auto -F "$@"
}
alias lt="ls --icons --tree --color=auto -F"
compdef ls=ls

# Catppuccin Mocha Pure Prompt Colors
PURE_PROMPT_SYMBOL="❯"
# Execution time in yellow (when it exceeds PURE_CMD_MAX_EXEC_TIME)
zstyle ':prompt:pure:execution_time' color '#e0af68'

# Git arrow in cyan (Pure_Git_Up_Arrow, Pure_Git_Down_Arrow)
zstyle ':prompt:pure:git:arrow' color '#89b4fa'

# Git stash symbol in cyan
zstyle ':prompt:pure:git:stash' color '#89b4fa'

# Git branch color (light blue/frost)
zstyle ':prompt:pure:git:branch' color '#a5b4fc'

# Git branch (cached) in red
zstyle ':prompt:pure:git:branch:cached' color '#f38ba8'

# Git action (cherry-pick, rebase) in light blue/frost
zstyle ':prompt:pure:git:action' color '#a5b4fc'

# Git dirty symbol in soft pink
zstyle ':prompt:pure:git:dirty' color '#f38ba8'

# Hostname in lavender (remote machine)
zstyle ':prompt:pure:host' color '#c8a2ff'

# Path color (teal)
zstyle ':prompt:pure:path' color '#94e2d5'

# Prompt symbol when error occurs (red)
zstyle ':prompt:pure:prompt:error' color '#f38ba8'

# Prompt symbol when success occurs (pink)
zstyle ':prompt:pure:prompt:success' color '#b4befe'

# Continuation prompt color (light purple/frost)
zstyle ':prompt:pure:prompt:continuation' color '#a5b4fc'

# Suspended jobs symbol in red
zstyle ':prompt:pure:suspended_jobs' color '#f38ba8'

# User color on remote machine (lavender)
zstyle ':prompt:pure:user' color '#ca9ee6'

# User root color (default)
zstyle ':prompt:pure:user:root' color 'default'

# Virtualenv color (green)
zstyle ':prompt:pure:virtualenv' color '#9ece6a'

export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
