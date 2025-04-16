#!/bin/bash

# Catppuccin Mocha color palette
ROSEWATER='\033[38;5;222m'   # #F5D0C5
FLAMINGO='\033[38;5;217m'    # #F2CDCD
PINK='\033[38;5;213m'        # #F5A9B8
MAUVE='\033[38;5;141m'       # #C6A0F6
BLUE='\033[38;5;117m'        # #89B4FA
LAVENDER='\033[38;5;138m'    # #B4B8D3
GREEN='\033[38;5;114m'       # #A6D189
YELLOW='\033[38;5;226m'      # #F9E2AF
RED='\033[38;5;161m'         # #F38BA8
TEAL='\033[38;5;81m'         # #94E2D5
SKY='\033[38;5;110m'         # #74C7EC
NEUTRAL='\033[38;5;145m'     # #CDD6F4
RESET='\033[0m'

# Check if the file exists
if [[ ! -f "$1" ]]; then
  echo -e "${RED}❌ File does not exist!${RESET}"
  exit 1
fi

# Get terminal width
term_width=$(tput cols)

# Print file info header
echo -e "${BLUE}📁✨ File Info${RESET}"

# Get file creation and modification dates
created=$(stat --format="%w" "$1")
modified=$(stat --format="%y" "$1")

# If creation date is empty, fall back to modification date
[[ "$created" == "-" ]] && created="$modified"

# Format dates to YYYY-MM-DD HH:MM
created_fmt=$(date -d "$created" '+%Y-%m-%d %H:%M')
modified_fmt=$(date -d "$modified" '+%Y-%m-%d %H:%M')

# Get file owner
creator=$(stat --format="%U" "$1")

# Get file name with icon using eza (no long format)
filename=$(eza --icons --oneline --color=always "$1")

# Framed file info block
echo -e "${MAUVE}╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮${RESET}"
printf "${MAUVE}│${RESET} ${BLUE}📄  Name      :${RESET} %-52s \n" "$filename"
printf "${MAUVE}│${RESET} ${GREEN}👤  Owner     : %-52s \n" "${creator:-'Unknown'}"
printf "${MAUVE}│${RESET} ${PINK}📅  Created   : %-52s \n" "${created_fmt:-'Unknown'}"
printf "${MAUVE}│${RESET} ${TEAL}🕓  Modified  : %-52s \n" "${modified_fmt}"
echo -e "${MAUVE}╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯${RESET}"

echo

# Simple separator logic
separator="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${TEAL}🧾 Preview${RESET}"
echo -e "${SKY}${separator}${RESET}"
# File content header

# Get file extension
ext="${1##*.}"

# Preview based on file type
case "$ext" in
  md)
    glow --style dark --width "$term_width" "$1"
    ;;
  json)
    jq . "$1" 2>/dev/null | bat --language=json --style=plain --color=always
    ;;
  jpg|jpeg|png|gif)
    imgcat "$1" 2>/dev/null
    ;;
  *)
    bat --style=numbers --color=always --line-range=:500 "$1"
    ;;
esac
