################################################################################
# ~/.zshrc — Linux (Fedora), Nord theme throughout
################################################################################

################################################################################
# Environment & PATH
################################################################################

# Prevent duplicate PATH entries
typeset -U path PATH fpath FPATH

# Windsurf (Codeium): prepend so its binaries resolve first.
path=("${HOME}/.codeium/windsurf/bin" $path)

# User-installed CLI tools.
path=("${HOME}/.local/bin" $path)

export PATH

# Editors
export EDITOR="nvim"
export VISUAL="nvim"

# eza
export EZA_CONFIG_DIR="${HOME}/.config/eza"

# GPG
export GPG_TTY="$(tty)"

# Better colors via vivid (Nord)
if command -v vivid &>/dev/null; then
  export LS_COLORS="$(vivid generate nord)"
fi

################################################################################
# Shell Behavior
################################################################################

bindkey -e
zmodload zsh/complist

# Report commands taking >1s
REPORTTIME=1

# Better shell behavior
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB
setopt NO_BEEP

################################################################################
# History
################################################################################

HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt \
  APPEND_HISTORY \
  SHARE_HISTORY \
  HIST_IGNORE_ALL_DUPS \
  HIST_IGNORE_DUPS \
  HIST_IGNORE_SPACE \
  HIST_FIND_NO_DUPS \
  HIST_SAVE_NO_DUPS \
  HIST_REDUCE_BLANKS \
  HIST_VERIFY \
  HIST_EXPIRE_DUPS_FIRST \
  INC_APPEND_HISTORY

################################################################################
# Completion Settings
################################################################################

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${HOME}/.zcompcache"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' group-name ''

################################################################################
# fzf
################################################################################

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

export FZF_DEFAULT_OPTS="
--height=40%
--layout=reverse
--border
--preview 'bat --color=always --style=numbers --line-range=:500 {}'
--color=bg+:#3B4252,bg:#2E3440,spinner:#8FBCBB,hl:#81A1C1
--color=fg:#ECEFF4,header:#8FBCBB,info:#A3BE8C,pointer:#BF616A
--color=marker:#EBCB8B,fg+:#ECEFF4,prompt:#88C0D0,hl+:#B48EAD
--color=selected-bg:#434C5E
--color=border:#4C566A,label:#D8DEE9
"

[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"

################################################################################
# Zinit Plugin Management
################################################################################

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "${ZINIT_HOME}" ]]; then
  mkdir -p "${ZINIT_HOME:h}"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi

if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"

  zinit light zsh-users/zsh-completions

  autoload -Uz compinit

  _zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ ! -f "$_zcompdump" || -n "$(find "$_zcompdump" -mmin +1440 2>/dev/null)" ]]; then
    compinit
    zcompile "$_zcompdump"
  else
    compinit -C
  fi
  unset _zcompdump

  # fzf-tab
  zinit light Aloxaf/fzf-tab

  # Git helpers
  zinit snippet OMZL::git.zsh

  # Autosuggestions
  zinit light zsh-users/zsh-autosuggestions

  # Autopair
  zinit light hlissner/zsh-autopair

  # Fast syntax highlighting (lighter than zsh-syntax-highlighting)
  zinit light zdharma-continuum/fast-syntax-highlighting

  # OMZ plugins
  zinit snippet OMZP::colored-man-pages
  zinit snippet OMZP::colorize
  zinit snippet OMZP::command-not-found
  zinit snippet OMZP::dnf
  zinit snippet OMZP::eza
  zinit snippet OMZP::git
  zinit snippet OMZP::kitty
  zinit snippet OMZP::pip
  zinit snippet OMZP::python
  zinit snippet OMZP::rsync
  zinit snippet OMZP::sudo

  zinit cdreplay -q
fi

################################################################################
# Prompt (Lazy Loaded)
################################################################################

starship_precmd() {
  eval "$(starship init zsh)"
  add-zsh-hook -d precmd starship_precmd
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd starship_precmd

################################################################################
# zoxide (Lazy Loaded)
################################################################################

if command -v zoxide &>/dev/null; then
  function cd() {
    unfunction cd
    eval "$(zoxide init zsh --cmd cd)"
    cd "$@"
  }
fi

################################################################################
# bat
################################################################################

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

################################################################################
# Python venv
################################################################################

[[ -f "${HOME}/PyPiP/bin/activate" ]] && source "${HOME}/PyPiP/bin/activate"

################################################################################
# fzf-tab
################################################################################

zstyle ':fzf-tab:complete:cd:*' \
  fzf-preview 'eza --color=always --icons=always "$realpath"'

zstyle ':fzf-tab:complete:__zoxide_z:*' \
  fzf-preview 'eza --color=always --icons=always "$realpath"'

zstyle ':fzf-tab:*' switch-group ',' '.'

################################################################################
# Aliases
################################################################################

# Navigation
alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias desktop='cd ~/Desktop'
alias home='cd ~'

# Utilities
alias c='clear'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias getip='curl -s ifconfig.me'
alias h='history'
alias now='date "+%H:%M:%S"'
alias today='date "+%Y-%m-%d"'

# Editors
alias vi='nvim'
alias vim='nvim'

# Monitoring
alias cpu='btop'
alias mem='free -h'
alias top='btop'

# eza
alias l2='eza -lh --tree --level=2 --icons=auto'
alias l='eza -lh --icons=auto'
alias la='eza -a --icons=auto'
alias ll='eza -alF --icons=auto'
alias ls='eza --color=auto --icons=auto'
alias lsa='eza -A --icons=auto'
alias tree='eza --tree --icons=auto'

# Misc
alias cat='bat'
alias grep='rg'
alias pdf-build='latexmk -pdf -lualatex'
alias venv='source ~/PyPiP/bin/activate'

################################################################################
# Functions
################################################################################

mkz() {
  [[ -z "$1" ]] && return 1
  mkdir -p -- "$1" && cd -- "$1"
}

extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
    *.7z) 7z x "$1" ;;
    *.Z) uncompress "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.gz) gunzip "$1" ;;
    *.rar) unrar x "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *) echo "Cannot extract $1" ;;
    esac
  else
    echo "$1 is not a valid file"
  fi
}

################################################################################
# Key Bindings (Kitty escape sequences)
################################################################################

bindkey '^[[3~' delete-char
bindkey '^[[2~' overwrite-mode
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[5~' history-beginning-search-backward
bindkey '^[[6~' history-beginning-search-forward

################################################################################
# End of ~/.zshrc (Fedora)
################################################################################
