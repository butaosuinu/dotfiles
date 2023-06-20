# paths
export GOPATH=$HOME/gocode
export GOBIN=$GOPATH/bin
export PATH=$HOME/.nodebrew/current/bin:$HOME/.node_global/bin:/$HOME/.nodenv/shims:usr/local/opt/gettext/bin:$GOPATH/bin:$HOME/.pyenv/shims:/usr/local/opt/php@7.3/bin:$HOME/.composer/vendor/bin:/usr/local/bin:/usr/bin:$PATH
export GO15VENDOREXPERIMENT=1
export LANG=ja_JP.UTF-8
export TERM=xterm-256color
export LSCOLORS=Exfxcxdxbxegedabagacad
# export NVM_DIR="$HOME/.nvm"
# . "/usr/local/opt/nvm/nvm.sh"
# syntax-highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] || [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=white
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=white
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
fi

# history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# color
autoload -Uz colors
colors

# PROMPT
PROMPT='%F{026}%B[%D{%a %m/%d %T}]%b %F{123}%m@%n: %~ 
%(?.%B%F{green}.%B%F{red})%(?!(๑・ᴗ・๑)!(#^ω^%) < noob!)%f%b ${vcs_info_msg_0_}
%f$ '
RPROMPT=''

# vcs info (git branch)
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{yellow}%c%u(%b)%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }

# Setup ssh-agent
if [ -e ~/.ssh-agent ]; then
    source ~/.ssh-agent
fi
ssh-add -l >& /dev/null
if [ $? = 2 ]; then
    ssh-agent > ~/.ssh-agent
    source ~/.ssh-agent
fi
if ssh-add -l >&/dev/null ; then
    echo "ssh-agent: Identity is already stored."
else
    ssh-add
fi

# Auto start tmux
#if [[ ! -n $TMUX ]]; then
#    tmux new-session
#fi

# Completion
autoload -Uz compinit
compinit -u

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                              /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# zsh options
setopt print_eight_bit
setopt auto_cd

# key bindinig
bindkey "^[[3~" delete-char

# alias
alias updatedb='sudo /usr/libexec/locate.updatedb'
alias g='git'
alias grep='grep -n --color=auto'
alias la='ls -al'
alias ll='ls -l'
alias v='vim'
alias sb='subl'
alias sudo='sudo '

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff'
fi

if [[ -x `which tree` ]]; then
    alias tree='tree -C'
fi

# OS
case ${OSTYPE} in
    darwin*)
        export LSCOLORS=Exfxcxdxbxegedabagacad
        export CLICOLOR=1
        alias ls='ls -F -G'
        brew-cask-upgrade(){ for app in $(brew cask list); do local latest="$(brew cask info "${app}" | awk 'NR==1{print $2}')"; local versions=($(ls -1 "/usr/local/Caskroom/${app}/.metadata/")); local current=$(echo ${versions} | awk '{print $NF}'); if [[ "${latest}" = "latest" ]]; then echo "[!] ${app}: ${current} == ${latest}"; [[ "$1" = "-f" ]] && brew cask install "${app}" --force; continue; elif [[ "${current}" = "${latest}" ]]; then continue; fi; echo "[+] ${app}: ${current} -> ${latest}"; brew cask uninstall "${app}" --force; brew cask install "${app}"; done; }
        ;;
    linux*)
        alias ls='ls -F --color=auto'
        ;;
esac

# local config
if [ -f $HOME/.zsh/.zshrc_local ]; then
    . $HOME/.zsh/.zshrc_local
fi

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
