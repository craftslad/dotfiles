#!/usr/bin/env bash

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly GRAY='\033[0;37m'
readonly NC='\033[0m'

readonly CHECKMARK="✓"
readonly CROSS="✗"
readonly ARROW="→"

CLEANED_COUNT=0
SKIPPED_COUNT=0

show_header() {
  clear
  local width=64
  local title="🌴 SYSTEM CLEANUP TOOL"
  local author="by RJ Leyva (craftslad)"
  local title_padding=$(((width - ${#title} - 2 - 1) / 2))
  local author_padding=$(((width - ${#author} - 2) / 2))

  printf "${PURPLE}"
  printf "╔"
  printf "%*s" "$width" "" | tr ' ' '═'
  printf "╗\n"

  printf "║"
  printf "%*s" "$title_padding" ""
  printf "%s" "$title"
  printf "%*s" $((width - title_padding - ${#title} - 1)) ""
  printf "║\n"

  printf "║"
  printf "%*s" "$author_padding" ""
  printf "%s" "$author"
  printf "%*s" $((width - author_padding - ${#author})) ""
  printf "║\n"

  printf "╚"
  printf "%*s" "$width" "" | tr ' ' '═'
  printf "╝\n"
  printf "${NC}\n"
}

show_progress() {
  local current="$1"
  local total="$2"
  local width=50

  if [[ "$total" -eq 0 ]]; then
    return
  fi

  local percentage=$((current * 100 / total))
  local filled=$((current * width / total))
  local empty=$((width - filled))

  local bar=""
  for ((i = 0; i < filled; i++)); do
    bar+="█"
  done
  for ((i = 0; i < empty; i++)); do
    bar+="░"
  done

  printf "\r${CYAN}Progress:${NC} [%s] ${WHITE}%d%%${NC} ${GRAY}(%d/%d)${NC}" \
    "$bar" "$percentage" "$current" "$total"
}

log() {
  local timestamp
  timestamp=$(date +"%H:%M:%S")

  case "$1" in
  "REMOVED")
    printf "\n${GREEN}[%s] ${CHECKMARK} %s${NC}\n" "$timestamp" "$2"
    ;;
  "SKIP")
    printf "\n${YELLOW}[%s] ${ARROW} %s${NC}\n" "$timestamp" "$2"
    ;;
  *)
    printf "\n${BLUE}[%s]${NC} %s\n" "$timestamp" "$*"
    ;;
  esac
}

show_summary() {
  local width=64
  local title="CLEANUP SUMMARY"
  local title_padding=$(((width - ${#title} - 2) / 2))

  printf "\n\n${PURPLE}"
  printf "╔"
  printf "%*s" "$width" "" | tr ' ' '═'
  printf "╗\n"

  printf "║"
  printf "%*s" "$title_padding" ""
  printf "${WHITE}%s${PURPLE}" "$title"
  printf "%*s" $((width - title_padding - ${#title})) ""
  printf "║${NC}\n"

  printf "${PURPLE}╠"
  printf "%*s" "$width" "" | tr ' ' '═'
  printf "╣${NC}\n"

  printf "${PURPLE}║${NC}  "
  printf "${GREEN}Items cleaned:${NC} %-10d  ${YELLOW}Items skipped:${NC} %-10d" "$CLEANED_COUNT" "$SKIPPED_COUNT"
  printf "%*s" $((width - 2 - 2 - 15 - 10 - 2 - 15 - 10 + 2)) ""
  printf "${PURPLE}║${NC}\n"

  printf "${PURPLE}╚"
  printf "%*s" "$width" "" | tr ' ' '═'
  printf "╝${NC}\n"

  if [[ "$CLEANED_COUNT" -gt 0 ]]; then
    printf "\n${GREEN}${CHECKMARK} Cleanup completed successfully! Your system is now cleaner.${NC}\n"
  else
    printf "\n${YELLOW}${ARROW} No items needed cleaning. Your system is already clean!${NC}\n"
  fi
}

cleanup_system() {
  log "Removing common cache, logs, and history files..."

  local targets=(
    "$HOME/.cache"
    "$HOME/.DS_Store"
    "$HOME/.zsh_history"
    "$HOME/.bash_history"
    "$HOME/.python_history"
    "$HOME/.mysql_history"
    "$HOME/.psql_history"
    "$HOME/.lesshst"
    "$HOME/.viminfo"
    "$HOME/.vim/swap"
    "$HOME/.vim/backup"
    "$HOME/.npm"
    "$HOME/.pnpm"
    "$HOME/.yarn"
    "$HOME/.bun"
    "$HOME/Library/Caches/Homebrew"
    "$HOME/Library/Logs/Homebrew"
  )

  local total=${#targets[@]}
  local current=0

  printf "\n${BLUE}${ARROW} Processing %d cleanup targets...${NC}\n\n" "$total"

  for target in "${targets[@]}"; do
    ((current++))
    show_progress "$current" "$total"

    if [[ -e "$target" ]]; then
      rm -rf "$target"
      ((CLEANED_COUNT++))
      log "REMOVED" "$target"
    else
      ((SKIPPED_COUNT++))
      log "SKIP" "$target not found."
    fi

    sleep 0.1
  done

  show_progress "$total" "$total"
  printf "\n"
}

main() {
  show_header
  log "Starting system cleanup..."
  cleanup_system
  show_summary
}

main "$@"
