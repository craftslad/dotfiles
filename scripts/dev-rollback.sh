#!/usr/bin/env bash

set -euo pipefail

log() {
  printf "\n[%s] %s\n" "$(date +"%H:%M:%S")" "$*"
}

confirm() {
  log "This will REMOVE all dotfiles-macos symlinks, packages, and the repo."
  read -rp "Are you sure? (y/N): " CONFIRM
  if [[ "$CONFIRM" != "y" ]]; then
    log "Aborted."
    exit 1
  fi
}

unstow_symlinks() {
  if [[ -d "$HOME/dotfiles-macos" ]]; then
    log "Removing symlinks..."
    pushd "$HOME/dotfiles-macos" >/dev/null
    stow -D .
    popd >/dev/null
  fi
}

remove_npm_globals() {
  if command -v npm >/dev/null 2>&1; then
    log "Uninstalling global npm packages..."
    local npm_packages=(
      @olrtg/emmet-language-server
      @vtsls/language-server
      @astrojs/language-server
      svelte-language-server
      eslint_d prettier pyright
      graphql-language-service-cli
      vscode-langservers-extracted
      yaml-language-server
      typescript
    )
    for pkg in "${npm_packages[@]}"; do
      npm uninstall -g "$pkg" || true
    done
  fi
}

uninstall_brew_packages() {
  log "Uninstalling Homebrew packages..."
  local brew_packages=(
    stow node git neovim tmux
    lua-language-server marksman go python pipx
    ripgrep bat black isort codespell shfmt stylua yq
    zoxide zsh-autosuggestions delta zsh-syntax-highlighting
    powerlevel10k eza tree tlrc
  )
  for pkg in "${brew_packages[@]}"; do
    brew uninstall --ignore-dependencies "$pkg" || true
  done

  log "Uninstalling Homebrew fonts..."
  local brew_fonts=(font-lilex-nerd-font)
  for font in "${brew_fonts[@]}"; do
    brew uninstall --cask "$font" || true
  done
}

cleanup_brew() {
  log "Cleaning up Homebrew..."
  brew autoremove -q || true
  brew cleanup -q || true
}

remove_gopls() {
  if command -v go >/dev/null 2>&1; then
    log "Removing Go tools..."
    rm -f "$(go env GOPATH)/bin/gopls" || true
    rm -f "$(go env GOPATH)/bin/goimports" || true
  fi
}

remove_repo() {
  log "Deleting dotfiles-macos repository..."
  rm -rf "$HOME/dotfiles-macos"
}

main() {
  confirm
  unstow_symlinks
  remove_npm_globals
  uninstall_brew_packages
  remove_gopls
  remove_repo
  cleanup_brew
  log "craftslad dotfiles-macos rollback completed! 🌴"
}

main "$@"
