export GOPATH=$HOME/gocode
export GOBIN=$GOPATH/bin
export PATH=$GOPATH/bin:$HOME/.nodebrew/current/bin:$PATH
export GO15VENDOREXPERIMENT=1
export LANG=ja_JP.UTF-8
source ~/git-completion.bash
source ~/git-prompt.sh
PS1="\[\033[1;32m\][\d \t]\[\033[0;36m\] \h @\u: \w\[\033[36m\]\[\033[33m\]\$(__git_ps1)\n\[\033[37m\]$ "

shopt -s autocd

if [ "$(uname)" = 'Darwin' ]; then
    alias ls='ls -F -G'
else
    alias ls='ls -F --color=auto'
fi

alias updatedb='sudo /usr/libexec/locate.updatedb'
alias g='git'
alias grep='grep -n --color=auto'
alias la='ls -al'
alias ll='ls -l'
alias v='vim'
alias sb='subl'
