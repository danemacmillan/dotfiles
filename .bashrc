## .bashrc

# This file contains code that can be run on OSX and NIX machines.

# Detect OS so dotfiles seamlessly work across OSX and Linux.
# I only use OSX and CentOS, so additional cases will need
# to be defined for another OS.
OS=$(uname | awk '{print tolower($0)}')
case $OS in
  darwin*) 
    OS='osx';; 
  linux*)  
    OS='nix';;
esac

# Source OS-specific configs.
source ~/.$OS;

# Bring in path.
export PATH="/usr/local/bin:$PATH"

# Aliases
alias rm='rm -rf'
alias ll='ls --color -lah --group-directories-first'
alias llt='ls --color -laht --group-directories-first' # Sort by newest first.
alias ..='cd ..'
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias c='clear'
alias vi='vim'
alias nsp='netstat -tulpn'
alias ss='lsof -i'
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias vs="vagrant global-status --prune"


# Git branch using bash-completion
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=0
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='verbose'
export PS1="\[\033[0;32m\]\u\[\033[0;36m\]@\[\033[1;34m\]\h \[\033[0;36m\]\w\e[0;31m\$(__git_ps1) \[\033[1;36m\]\$\[\033[0m\] "

# Notes

# SSH keys, a la http://blog.patshead.com/2013/09/generating-new-more-secure-ssh-keys.html
# ssh-keygen -b 4096 -f ~/.ssh/id_rsa_danemacmillan_4096_2014_08 -C danemacmillan@id_rsa_4096_2014_08

#alias btop="mytop -u user -p '' -h localhost -d database"
