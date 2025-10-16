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
readonly SPINNER=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

CURRENT_STEP=0
TOTAL_STEPS=4
UPDATED_PACKAGES=0
UPGRADED_PACKAGES=0
REMOVED_PACKAGES=0
SPINNER_PID=""

show_header() {
  clear
  local width=64
  local title="🍺 HOMEBREW MAINTENANCE"
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

start_spinner() {
  local message="$1"
  printf "%s" "$message"

  {
    local i=0
    while true; do
      printf "\r%s %s" "$message" "${SPINNER[$i]}"
      sleep 0.1
      ((i = (i + 1) % ${#SPINNER[@]}))
    done
  } &
  SPINNER_PID=$!
}

stop_spinner() {
  if [[ -n "$SPINNER_PID" ]]; then
    kill "$SPINNER_PID" 2>/dev/null || true
    wait "$SPINNER_PID" 2>/dev/null || true
    SPINNER_PID=""
    printf "\r%*s\r" 80 ""
  fi
}

show_progress() {
  local current="$1"
  local total="$2"
  local message="$3"
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

  printf "\n${CYAN}Progress:${NC} [%s] ${WHITE}%d%%${NC} ${GRAY}(%d/%d)${NC} %s\n" \
    "$bar" "$percentage" "$current" "$total" "$message"
}

log() {
  local timestamp
  timestamp=$(date +"%H:%M:%S")

  case "$1" in
  "SUCCESS")
    printf "\n${GREEN}[%s] ${CHECKMARK} %s${NC}\n" "$timestamp" "$2"
    ;;
  "ERROR")
    printf "\n${RED}[%s] ${CROSS} %s${NC}\n" "$timestamp" "$2"
    ;;
  "STEP")
    printf "\n${BLUE}[%s] ${ARROW} %s${NC}\n" "$timestamp" "$2"
    ;;
  *)
    printf "\n${BLUE}[%s]${NC} %s\n" "$timestamp" "$*"
    ;;
  esac
}

show_summary() {
  local width=64
  local title="MAINTENANCE SUMMARY"
  local title_padding=$(((width - ${#title} - 2) / 2))

  printf "\n${PURPLE}"
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
  printf "${GREEN}Packages updated:${NC} %-8d  ${CYAN}Packages upgraded:${NC} %-8d" "$UPDATED_PACKAGES" "$UPGRADED_PACKAGES"
  printf "%*s" $((width - 2 - 2 - 17 - 8 - 2 - 18 - 8)) ""
  printf "${PURPLE}║${NC}\n"

  printf "${PURPLE}║${NC}  "
  printf "${YELLOW}Dependencies removed:${NC} %-8d" "$REMOVED_PACKAGES"
  printf "%*s" $((width - 2 - 2 - 21 - 8 + 1)) ""
  printf "${PURPLE}║${NC}\n"

  printf "${PURPLE}╚"
  printf "%*s" "$width" "" | tr ' ' '═'
  printf "╝${NC}\n"

  printf "\n${GREEN}${CHECKMARK} Homebrew maintenance completed successfully!${NC}\n"
  printf "${GRAY}Your packages are now up to date and optimized.${NC}\n"
}

check_homebrew() {
  ((CURRENT_STEP++))
  show_progress "$CURRENT_STEP" "$TOTAL_STEPS" "Checking Homebrew installation..."

  if ! command -v brew &>/dev/null; then
    log "ERROR" "Homebrew not found. Please run setup.sh first."
    exit 1
  fi

  log "SUCCESS" "Homebrew found and ready"
  sleep 0.5
}

update_homebrew() {
  ((CURRENT_STEP++))
  show_progress "$CURRENT_STEP" "$TOTAL_STEPS" "Updating Homebrew..."

  start_spinner "${CYAN}Updating Homebrew repositories..."

  local update_output
  if update_output=$(brew update 2>&1); then
    stop_spinner
    UPDATED_PACKAGES=$(echo "$update_output" | grep -c "Updated " 2>/dev/null | head -1 || echo "0")
    [[ "$UPDATED_PACKAGES" =~ ^[0-9]+$ ]] || UPDATED_PACKAGES=0
    log "SUCCESS" "Homebrew updated successfully"
  else
    stop_spinner
    log "ERROR" "Failed to update Homebrew"
    exit 1
  fi

  sleep 0.5
}

upgrade_packages() {
  ((CURRENT_STEP++))
  show_progress "$CURRENT_STEP" "$TOTAL_STEPS" "Upgrading packages..."

  start_spinner "${CYAN}Upgrading installed packages..."

  local upgrade_output
  if upgrade_output=$(brew upgrade 2>&1); then
    stop_spinner
    UPGRADED_PACKAGES=$(echo "$upgrade_output" | grep -c "==> Upgrading " 2>/dev/null | head -1 || echo "0")
    [[ "$UPGRADED_PACKAGES" =~ ^[0-9]+$ ]] || UPGRADED_PACKAGES=0
    if [[ "$UPGRADED_PACKAGES" -eq 0 ]]; then
      log "SUCCESS" "All packages are already up to date"
    else
      log "SUCCESS" "Upgraded $UPGRADED_PACKAGES packages"
    fi
  else
    stop_spinner
    log "ERROR" "Failed to upgrade packages"
    exit 1
  fi

  sleep 0.5
}

cleanup_homebrew() {
  ((CURRENT_STEP++))
  show_progress "$CURRENT_STEP" "$TOTAL_STEPS" "Cleaning up..."

  start_spinner "${CYAN}Removing old versions and cleaning cache..."

  if brew cleanup -s >/dev/null 2>&1; then
    stop_spinner
    log "SUCCESS" "Cleaned up old package versions"
  else
    stop_spinner
    log "SUCCESS" "Cleanup completed (no old versions found)"
  fi

  start_spinner "${CYAN}Removing unused dependencies..."

  local autoremove_output
  if autoremove_output=$(brew autoremove -q 2>&1); then
    stop_spinner
    REMOVED_PACKAGES=$(echo "$autoremove_output" | grep -c "Uninstalling " 2>/dev/null | head -1 || echo "0")
    [[ "$REMOVED_PACKAGES" =~ ^[0-9]+$ ]] || REMOVED_PACKAGES=0
    if [[ "$REMOVED_PACKAGES" -eq 0 ]]; then
      log "SUCCESS" "No unused dependencies found"
    else
      log "SUCCESS" "Removed $REMOVED_PACKAGES unused dependencies"
    fi
  else
    stop_spinner
    log "SUCCESS" "Dependency cleanup completed"
  fi

  local cache_dir="${HOMEBREW_CACHE:-$HOME/Library/Caches/Homebrew}"
  if [[ -d "$cache_dir" ]]; then
    start_spinner "${CYAN}Clearing Homebrew cache..."
    if rm -rf "$cache_dir"/* 2>/dev/null; then
      stop_spinner
      log "SUCCESS" "Cleared Homebrew cache at $cache_dir"
    else
      stop_spinner
      log "SUCCESS" "Cache cleanup completed"
    fi
  fi

  sleep 0.5
}

cleanup_on_exit() {
  stop_spinner
  printf "\n"
}

trap cleanup_on_exit EXIT INT TERM

main() {
  show_header
  log "Starting Homebrew maintenance..."

  check_homebrew
  update_homebrew
  upgrade_packages
  cleanup_homebrew

  show_summary
}

main "$@"
