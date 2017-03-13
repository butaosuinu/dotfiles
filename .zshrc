# paths
export GOPATH=$HOME/gocode
export GOBIN=$GOPATH/bin
export PATH=$GOPATH/bin:$HOME/.nodebrew/current/bin:$PATH
export GO15VENDOREXPERIMENT=1
export LANG=ja_JP.UTF-8

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
PROMPT='%F{047}%B[%D{%a %m/%d %T}]%b %F{123}%m@%n: %~ %(?.%B%F{green}.%B%F{red})%(?!(๑・ᴗ・๑)!(#^ω^%) < noob!)%f%b ${vcs_info_msg_0_}
%F{255}$ '
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

# alias
alias updatedb='sudo /usr/libexec/locate.updatedb'
alias g='git'
alias grep='grep -n --color=auto'
alias la='ls -al'
alias ll='ls -l'
alias v='vim'
alias sb='subl'

case ${OSTYPE} in
    darwin*)
        export CLICOLOR=1
        alias ls='ls -F -G'
        ;;
    linux*)
        alias ls='ls -F --color=auto'
        ;;
esac
