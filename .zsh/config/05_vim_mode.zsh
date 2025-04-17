#==============================================================================
# Zsh Vi Mode Configuration
#==============================================================================

# Early return if plugin is not loaded or executable
if [ ! -f $ZSH/custom/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]; then
  return
fi
# zsh-vi-mode configuration
# Set cursor styles for different modes
ZVM_CURSOR_STYLE_ENABLED=true
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE

# Customize transition between modes (in seconds)
ZVM_KEYTIMEOUT=0.1

# Start in insert mode by default
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# Enable visual selection highlighting
ZVM_VISUAL_MODE_HIGHLIGHT=underline

# Use 'jk' to switch to normal mode (faster than ESC)
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# Integration with other plugins and tools after zsh-vi-mode initializes
function zvm_after_init() {
  # Rebind FZF key bindings in vi mode
  [ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
  # Fix zsh-autosuggestions with vi mode
  bindkey -M viins '^[[Z' autosuggest-accept # Shift+Tab
  bindkey -M viins '^E' autosuggest-accept   # Ctrl+E
  bindkey -M viins '^P' history-beginning-search-backward
  bindkey -M viins '^N' history-beginning-search-forward

  # Normal mode specific bindings
  zvm_bindkey normal '^[[A' history-beginning-search-backward
  zvm_bindkey normal '^[[B' history-beginning-search-forward
  zvm_bindkey normal '^R' fzf-history-widget

  # Quick movement keys
  zvm_bindkey normal 'H' beginning-of-line
  zvm_bindkey normal 'L' end-of-line

  # Surround functionality (similar to vim-surround)
  zvm_define_widget surround_quotes
  function surround_quotes() {
    BUFFER="\"$BUFFER\""
    zle end-of-line
  }
  zvm_bindkey normal 'gq' surround_quotes
}

# Modify prompt to show vi mode
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      PURE_PROMPT_SYMBOL="❮N❯"
      ;;
    $ZVM_MODE_INSERT)
      PURE_PROMPT_SYMBOL="❯"
      ;;
    $ZVM_MODE_VISUAL)
      PURE_PROMPT_SYMBOL="❮V❯"
      ;;
    $ZVM_MODE_VISUAL_LINE)
      PURE_PROMPT_SYMBOL="❮VL❯"
      ;;
    $ZVM_MODE_REPLACE)
      PURE_PROMPT_SYMBOL="❮R❯"
      ;;
  esac
  zle reset-prompt
}
