#==============================================================================
# Pure Prompt Configuration
#==============================================================================
# Load Pure Prompt
if [ -d "$HOME/.zsh/pure" ]; then
  fpath+=($HOME/.zsh/pure)
  autoload -U promptinit
  promptinit
  prompt pure

  # Set base prompt symbol
  PURE_PROMPT_SYMBOL="❯"

  # Catppuccin Mocha Pure Prompt Colors
  # Execution time in yellow
  zstyle ':prompt:pure:execution_time' color '#e0af68'

  # Git styling
  zstyle ':prompt:pure:git:arrow' color '#89b4fa'         # Git arrows in cyan
  zstyle ':prompt:pure:git:stash' color '#89b4fa'         # Git stash symbol in cyan
  zstyle ':prompt:pure:git:branch' color '#a5b4fc'        # Git branch in light blue
  zstyle ':prompt:pure:git:branch:cached' color '#f38ba8' # Git branch (cached) in red
  zstyle ':prompt:pure:git:action' color '#a5b4fc'        # Git actions in light blue
  zstyle ':prompt:pure:git:dirty' color '#f38ba8'         # Git dirty symbol in pink

  # Host and user styling
  zstyle ':prompt:pure:host' color '#c8a2ff'              # Hostname in lavender
  zstyle ':prompt:pure:user' color '#ca9ee6'              # User in lavender
  zstyle ':prompt:pure:user:root' color 'red'             # Root user in red

  # Path styling
  zstyle ':prompt:pure:path' color '#94e2d5'              # Path in teal

  # Prompt status styling
  zstyle ':prompt:pure:prompt:error' color '#f38ba8'      # Error prompt in red
  zstyle ':prompt:pure:prompt:success' color '#b4befe'    # Success prompt in pink
  zstyle ':prompt:pure:prompt:continuation' color '#a5b4fc' # Continuation in light purple

  # Other elements
  zstyle ':prompt:pure:suspended_jobs' color '#f38ba8'    # Suspended jobs in red
  zstyle ':prompt:pure:virtualenv' color '#9ece6a'        # Virtualenv in green
fi
