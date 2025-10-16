# Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Environment Variables
export EDITOR="nvim"
export BAT_THEME="vague"

# PATH Configuration
export PATH="$PATH:$HOME/go/bin"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Powerlevel10k Theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Zoxide
eval "$(zoxide init --cmd=cd zsh)"

# Aliases
alias ls='eza --long --all --git --icons --time-style=iso --group --classify'
alias tree="eza --all --tree --icons"
alias brew-maint="$HOME/dotfiles-macos/scripts/brew-maintenance.sh"
alias cleanup="$HOME/dotfiles-macos/scripts/system-cleanup.sh"
alias tmux-s="$HOME/dotfiles-macos/scripts/tmux-setup.sh"

# Zsh Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
