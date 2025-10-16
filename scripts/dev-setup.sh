#!/usr/bin/env bash

set -euo pipefail

log() {
  printf "\n[%s] %s\n" "$(date +"%H:%M:%S")" "$*"
}

install_xcode_cli() {
  log "Checking Xcode CLI tools..."
  if ! xcode-select -p &>/dev/null; then
    log "Installing Xcode CLI tools..."
    xcode-select --install || true
    until xcode-select -p &>/dev/null; do sleep 10; done
  fi
}

install_homebrew() {
  local arch prefix
  arch="$(uname -m)"
  prefix="/opt/homebrew"
  [ "$arch" != "arm64" ] && prefix="/usr/local"

  log "Checking Homebrew..."
  if ! command -v brew &>/dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  log "Configuring shell environment..."
  if ! grep -q "brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
    echo "eval \"\$($prefix/bin/brew shellenv)\"" >>"$HOME/.zprofile"
  fi
  eval "$($prefix/bin/brew shellenv)"

  log "Disabling Homebrew analytics and updating..."
  brew analytics off
  brew update
  brew upgrade

  local packages=(
    stow node git neovim tmux
    lua-language-server marksman go python pipx
    ripgrep bat black ruff isort codespell shfmt stylua yq
    zoxide zsh-autosuggestions delta zsh-syntax-highlighting
    powerlevel10k eza tree tlrc
  )

  log "Installing CLI packages..."
  for pkg in "${packages[@]}"; do
    brew list "$pkg" >/dev/null || brew install "$pkg"
  done

  local fonts=(font-lilex-nerd-font)
  log "Installing fonts..."
  for font in "${fonts[@]}"; do
    brew list --cask "$font" >/dev/null || brew install --cask "$font"
  done
}

install_languages() {
  log "Installing Go tools..."
  go list -m golang.org/x/tools/gopls >/dev/null 2>&1 ||
    go install golang.org/x/tools/gopls@latest

  if ! command -v goimports &>/dev/null; then
    go install golang.org/x/tools/cmd/goimports@latest
  fi

  log "Installing global npm packages..."
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
    npm list -g --depth=0 "$pkg" >/dev/null 2>&1 || npm install -g "$pkg"
  done
}

setup_dotfiles() {
  local dotfiles="$HOME/dotfiles-macos"
  local repo_url="${DOTFILES_REPO:-https://github.com/ryanjayleyva/dotfiles-macos.git}"

  if [ ! -d "$dotfiles" ]; then
    log "Cloning dotfiles repository from $repo_url..."
    git clone "$repo_url" "$dotfiles"
  fi

  if [ ! -d "$dotfiles" ]; then
    log "ERROR: Could not clone dotfiles repository!"
    exit 1
  fi

  log "Linking dotfiles..."
  pushd "$dotfiles" >/dev/null
  stow .
  popd >/dev/null

  if command -v bat &>/dev/null; then
    log "Rebuilding bat cache..."
    bat cache --build
  fi
}

make_scripts_executable() {
  local scripts_dir="$HOME/dotfiles-macos/scripts"
  if [ -d "$scripts_dir" ]; then
    log "Making all scripts executable in $scripts_dir..."
    chmod +x "$scripts_dir"/*.sh
  fi
}

setup_neovim() {
  log "Neovim is ready. Launch it to install plugins using lazy.nvim."
}

main() {
  install_xcode_cli
  install_homebrew
  install_languages
  setup_dotfiles
  make_scripts_executable
  setup_neovim
  log "craftslad dotfiles-macos setup completed! 🌴"
}

main "$@"
