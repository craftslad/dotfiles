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

install_apps() {
  local brew_apps=(
    arc
    keycastr
    microsoft-teams
    raycast
    spotify
    wezterm
    zoom
  )

  log "Installing GUI apps..."
  for app in "${brew_apps[@]}"; do
    if brew list --cask "$app" &>/dev/null; then
      log "[SKIP] $app already installed."
    else
      log "[INSTALL] $app..."
      brew install --cask "$app"
    fi
  done
  log "GUI apps installation complete."
}

main() {
  log "Checking Homebrew..."
  check_homebrew

  log "Updating Homebrew..."
  brew update

  install_apps

  log "craftslad dotfiles-macos GUI apps setup completed! 🌴"
}

main "$@"
