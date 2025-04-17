#==============================================================================
# FZF Configuration
#==============================================================================

# Check if FZF is available
if ! command -v fzf >/dev/null 2>&1; then
  return
fi
# Load FZF key bindings if available
[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh

# Catppuccin Mocha theme for FZF
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

# FZF completion trigger
# CTRL-R → search shell history without preview
export FZF_CTRL_R_OPTS="
--no-preview
--border-label=' History '
--prompt='Shell Hist ❯ '
"
# Use ripgrep for file finding
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

# CTRL-T: File search with preview
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

# ALT-C: Directory search
export FZF_ALT_C_COMMAND="eza --color=always --all --only-dirs --sort=modified --icons"
export FZF_ALT_C_OPTS="
--ansi
--preview 'eza --tree --level=2 --color=always --icons -- {}'
--preview-window right:50%:wrap:border-rounded
--border-label=' Directories '
--prompt 'Dirs ❯ '
--bind 'ctrl-/:toggle-preview'
"

# Interactive process killer with FZF
function fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m --header="Select process to kill" | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m --header="Select process to kill" | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Search for text in files
function fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  local file
  file=$(rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2>/dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}")
  if [[ -n "$file" ]]; then
    $EDITOR "$file"
  fi
}

# Enhanced man page search
function fman() {
  man -k . | fzf --prompt='Man> ' \
      --preview "echo {1} | sed 's/(.*//' | xargs -r man" \
      --preview-window=right:70% | 
      awk '{print $1}' | sed 's/(.*//' | xargs -r man
}

# Enhanced Git log viewer with FZF
function fzf_git_log() {
  local selections=$(
    git log --graph --format="%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)" --all --color=always |
    fzf --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
        --header 'Press CTRL-S to toggle sort' \
        --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' \
        --preview-window right:60%
  )
  if [[ -n "$selections" ]]; then
    local commit=$(echo "$selections" | grep -o "[a-f0-9]\{7,\}" | head -n 1)
    if [[ -n "$commit" ]]; then
      echo "$commit" | xclip -selection clipboard
      git show "$commit"
    fi
  fi
}
alias glf='fzf_git_log'

