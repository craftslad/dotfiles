#!/usr/bin/env bash

set -euo pipefail

log() {
  printf "\n[%s] %s\n" "$(date +"%H:%M:%S")" "$*"
}

check_homebrew() {
  if ! command -v brew &>/dev/null; then
    log "ERROR: Homebrew not found. Please run setup.sh first."
    exit 1
  fi
}

uninstall_apps() {
  local brew_apps=(
    arc
    keycastr
    microsoft-teams
    raycast
    spotify
    wezterm
    zoom
  )

  log "Uninstalling GUI apps..."
  for app in "${brew_apps[@]}"; do
    if brew list --cask "$app" &>/dev/null; then
      log "[REMOVE] $app..."
      brew uninstall --cask "$app" || true
    else
      log "[SKIP] $app not found."
    fi
  done
  log "GUI apps uninstall complete."
}

cleanup_brew() {
  log "Cleaning up Homebrew..."
  brew autoremove -q || true
  brew cleanup -q || true
}

main() {
  log "Checking Homebrew..."
  check_homebrew

  uninstall_apps
  cleanup_brew

  log "craftslad dotfiles-macos GUI apps rollback completed! 🌴"
}

main "$@"
