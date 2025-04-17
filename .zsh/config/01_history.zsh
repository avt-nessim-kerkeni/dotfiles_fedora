#==============================================================================
# History Configuration
#==============================================================================

# History file configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# History options
setopt SHARE_HISTORY         # Share history between all sessions
setopt EXTENDED_HISTORY      # Save timestamp and duration
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first
setopt HIST_IGNORE_DUPS      # Don't record an entry that was just recorded
setopt HIST_IGNORE_ALL_DUPS  # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS     # Do not display a line previously found
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS     # Don't write duplicate entries in history file
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks before recording
setopt HIST_VERIFY           # Show command with history expansion before running it
setopt INC_APPEND_HISTORY    # Add commands as they are typed
setopt APPEND_HISTORY        # Append to history file
