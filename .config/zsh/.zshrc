###############################################################################
# ~/.zshrc — Linux, organized, documented
# Goal: fast startup, sane history, fuzzier completion, minimal plugins.
# All sections self-contained. Safe to source multiple times.
###############################################################################

###############################################################################
# 0) Shell mode and baseline keymap
###############################################################################
# Use the emacs keymap as a base. Later bindkey calls extend it.
bindkey -e

###############################################################################
# 1) Environment Variables and Early Setup
###############################################################################
# Purpose: define PATH and early environment before plugins alter state.

# Windsurf (Codeium): prepend to PATH so its binaries resolve first.
export PATH="${HOME}/.codeium/windsurf/bin:${PATH}"

# Python venv: auto-activate if the specific venv exists.
# Adjust the path if your environment name changes.
[[ -f "${HOME}/PyPiP/bin/activate" ]] && source "${HOME}/PyPiP/bin/activate"

# Time reporting: print elapsed time for commands taking >1s.
REPORTTIME=1

###############################################################################
# 2) History Settings
###############################################################################
# Purpose: durable, deduplicated, shareable history across sessions.
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="${HOME}/.zsh_history"

# Dedup and sanitize history behavior.
HISTDUP=erase
setopt APPEND_HISTORY          # Append rather than overwrite.
setopt SHARE_HISTORY           # Merge history across sessions.
setopt HIST_IGNORE_ALL_DUPS    # Drop older duplicates.
setopt HIST_IGNORE_DUPS        # Ignore immediate duplicate entries.
setopt HIST_IGNORE_SPACE       # Ignore commands starting with a space.
setopt HIST_FIND_NO_DUPS       # Avoid duplicate matches in search.
setopt HIST_SAVE_NO_DUPS       # Do not write duplicates to file.

###############################################################################
# 3) fzf Setup (Fuzzy Finder Integration)
###############################################################################
# Purpose: color-consistent previews and default options.

# fzf-tab: preview files when completing `cd` and `zoxide` targets.
zstyle ':fzf-tab:complete:cd:*'           fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*'   fzf-preview 'ls --color $realpath'

# fzf default color scheme (Catppuccin-like).
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# fzf init: load user install script if fzf is present.
if command -v fzf &>/dev/null && [[ -f "${HOME}/.fzf.zsh" ]]; then
  source "${HOME}/.fzf.zsh"
fi

###############################################################################
# 4) Zinit Plugin Management (Fast Plugin Loader)
###############################################################################
# Purpose: on-demand plugin install and load with minimal overhead.

# Zinit install path.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Install zinit if missing.
if [[ ! -d "${ZINIT_HOME}" ]]; then
  mkdir -p "$(dirname "${ZINIT_HOME}")"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi

# Load zinit and core completions, then declare plugins.
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"

  # Completions framework.
  autoload -Uz compinit && compinit

  # Lightweight, commonly used plugins.
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-autosuggestions
  zinit light Aloxaf/fzf-tab
  zinit light hlissner/zsh-autopair

  # Oh-My-Zsh plugin snippets via zinit.
  zinit snippet OMZL::git.zsh
  zinit snippet OMZP::git
  zinit snippet OMZP::sudo
  zinit snippet OMZP::archlinux
  zinit snippet OMZP::aws
  zinit snippet OMZP::kubectl
  zinit snippet OMZP::kubectx
  zinit snippet OMZP::command-not-found

  # Restore working directories from previous session.
  zinit cdreplay -q
fi

###############################################################################
# 5) External Tools and Integrations
###############################################################################
# zoxide: smarter `cd` with Frecency ranking.
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# starship: fast, customizable prompt.
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

###############################################################################
# 6) Aliases and Small Helpers
###############################################################################
# Purpose: short, memorable commands for frequent actions.

# Default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Navigation
alias home='cd ~'
alias desktop='cd ~/Desktop'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Info and utilities
alias h='history'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias today='date "+%Y-%m-%d"'
alias now='date "+%H:%M:%S"'
alias getip='curl ifconfig.me'

# Monitoring
alias top='btop'
alias mem='free -h'
alias cpu='top -o %CPU'

# Listing with eza
alias l='eza -lh'
alias l2='eza -lh --tree --level=2'
alias ll='eza -alF'
alias ls='eza --color=auto'
alias lsa='eza -A'

# Quality of life
alias c='clear'
alias cat='bat'
alias cd='z'                 # Route plain cd to zoxide if available.
alias venv='source ~/PyPiP/bin/activate'
alias vi='nvim'
alias vim='nvim'
alias pdf-build='latexmk -pdf -lualatex'

# mkcd: create a directory and enter it
mkz() {
  mkdir -p -- "$1" && z -- "$1" || return
}

###############################################################################
# 7) Editing Keys for Kitty (standard escape sequences)
###############################################################################
# Purpose: interpret Kitty's raw sequences inside ZLE so line editing works.
# Baseline: Kitty sends these sequences per your kitty.conf mappings.

# Forward Delete
bindkey '^[[3~' delete-char

# Insert
bindkey '^[[2~' overwrite-mode

# Home / End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Alternates (some terminfo variants)
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# Page Up / Page Down — history search by prefix
bindkey '^[[5~' history-beginning-search-backward
bindkey '^[[6~' history-beginning-search-forward

# GPG Agent - Fix for GPG agent
export GPG_TTY=pinentry-gtk

###############################################################################
# End
###############################################################################

