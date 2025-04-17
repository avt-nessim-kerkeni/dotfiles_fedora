#==============================================================================
# Terminal Colors & Styling
#==============================================================================

# Load Catppuccin theme for zsh syntax highlighting if available
[ -f ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh ] && 
  source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Set LS_COLORS with vivid if available
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi
