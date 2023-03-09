### Convenience and basics
if [[ "$HOST" =~ "MB-FFM-16" ]]; then
  source $HOME/.zshenv
fi
autoload -U colors && colors
ls --color -d . &>/dev/null && alias ls='ls --color=tty' || { ls -G . &>/dev/null && alias ls='ls -G' }
# Take advantage of $LS_COLORS for completion as well.
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
setopt auto_cd
setopt autopushd
setopt PUSHD_IGNORE_DUPS
setopt prompt_subst
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git 
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' %{%G+%}'
zstyle ':vcs_info:*' unstagedstr ' %{%G●%}'
zstyle ':vcs_info:git*' formats "%F{yellow}[%b%c%u%m]"
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
     git status --porcelain | grep -m 1 '^??' &>/dev/null
  then
    hook_com[misc]=' ?'
  fi
}

precmd() {vcs_info}
NEWLINE=$'\n'
PROMPT='%B%F{magenta}%n@%m %U%F{blue}%~%u ${vcs_info_msg_0_}%{$reset_color%}%b%f${NEWLINE}$ '
# PROMPT='%B%F{#FFCCFF}%n@%m %U%F{#3399FF}%~%u ${vcs_info_msg_0_}%{$reset_color%}%b%f${NEWLINE}$ '
HISTFILE=~/.cache/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

bindkey -v
export KEYTIMEOUT=0.05

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors "di=01;34:"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' _prefix

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Edit line in vim buffer ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
# Enter vim buffer from normal mode
autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "^v" edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
      bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
      bindkey -M $m $c select-bracketed
  done
done

bindkey '^r' history-incremental-search-backward

# start typing + [Up-Arrow] - fuzzy find history forward
# start typing + [Down-Arrow] - fuzzy find history backward
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

autoload zkbd
[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd
source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE

[[ -n ${key[Backspace]} ]] && bindkey -a "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey -a "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey -a "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-beginning-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-beginning-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

bindkey ' ' magic-space                               # [Space] - do history expansion
bindkey '^[[1;5C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                       # [Ctrl-LeftArrow] - move backward one word

if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
fi

if [[ "${terminfo[kcuu1]}" != "" ]]; then
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

if [[ "${terminfo[kcud1]}" != "" ]]; then
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi

# bindkey '^i' expand-or-complete-prefix

### Aliases

# General 
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias ll="LC_COLLATE=C ls -laFh --time-style=long-iso"
alias lc='lc () { ls $1 -U | wc -l };lc'
alias -g G='| grep -i'
alias -g H='| head'
alias -g L='| less'
alias -g C='| xargs cp -t'
alias -g T='| tail'
alias -g S='| sort'
alias -g U='| uniq'
alias -g dc='dirs -v'
alias wget="wget --hsts-file $HOME/.config/wget/wget-hsts"
alias d='d () { cd $(dirname $1) };d'
alias c='c () {bc <<< "scale=3; $1"};c'

# Git
alias ga="git add"
alias gaa='git add --all'
alias gcmsg="git commit -m "
alias gst="git status"
alias gl="git pull"
alias gp="git push"

# System aliases
alias vim='vim -u $HOME/.vim/vimrc'
alias vi='vim'
alias tmux='tmux -f $HOME/.config/tmux/.tmux.conf'

# Other settings
setopt no_hist_verify

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/pdu20002/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/pdu20002/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/pdu20002/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/pdu20002/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

