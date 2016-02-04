export GOPATH=$HOME/gocode
export GOBIN=$GOPATH/bin
export PATH=$GOPATH/bin:$HOME/.nodebrew/current/bin:$PATH
source ~/.git-completion.bash
source ~/git-prompt.sh
PS1="\[\033[0;32m\][\d \t]\[\033[36m\] \h@\u: \W\[\033[36m\]\[\033[33m\]\$(__git_ps1)\[\033[37m\] $ "

alias ls='ls -G'
alias updatedb='sudo /usr/libexec/locate.updatedb'
