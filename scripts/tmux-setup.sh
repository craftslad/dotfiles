#!/usr/bin/env bash

set -euo pipefail

log() { printf "\n[%s] %s\n" "$(date +"%H:%M:%S")" "$*"; }

SESSION="dev"

check_tmux() {
  if ! command -v tmux >/dev/null 2>&1; then
    log "ERROR: tmux is not installed. Please run setup.sh first."
    exit 1
  fi
}

create_session() {
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    log "[SKIP] tmux session '$SESSION' already exists."
    return
  fi

  log "Creating tmux session '$SESSION'..."
  tmux new-session -d -s "$SESSION" -n main

  local top_left=0

  tmux split-window -h -p 10 -t "$top_left"

  tmux select-pane -t "$top_left"
  tmux split-window -v -p 10 -t "$top_left"

  tmux select-pane -t "$top_left"

  log "Session '$SESSION' created."
}

attach_session() {
  log "Attaching to tmux session '$SESSION'..."
  tmux attach-session -t "$SESSION"
}

main() {
  log "Checking tmux..."
  check_tmux

  create_session
  attach_session
}

main "$@"
