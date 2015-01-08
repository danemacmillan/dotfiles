## .bashrc

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

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

# Source various helper bash functions
source ~/.functions;

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
alias mkdir="mkdir -pv"
alias cp="cp -r"
alias du="du -h --time"
alias tt="total"

# Update dotfiles
alias dotfiles="cd ~ && . dotfiles.sh"

# See http://ipinfo.io/developers for more info.
alias ipgeo="curl ipinfo.io"

# Mitigate fat-fingering and other retardations.
alias gut="git"
alias kk="ll"

# Purge all history
alias historypurgeall='cat /dev/null > ~/.bash_history && history -c && history -w'

# Source: http://thoughtsbyclayg.blogspot.ca/2008/02/how-to-delete-last-command-from-bash.html
alias historypurgelast='history -d $((HISTCMD-2)) && history -d $((HISTCMD-1))'

# Git branch using bash-completion
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=0
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='verbose'
export PS1="\\[\033[0;32m\]\u\\[\033[0;36m\]@\\[\033[1;34m\]\h \\[\033[0;36m\]\w\\[\e[0;31m\]\$(__git_ps1) \\[\033[1;36m\]\$\\[\033[0m\] "

# Set bash history configs
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTCONTROL=ignorespace:ignoredups
export HISTIGNORE='c'
export HISTTIMEFORMAT='%F %T '
shopt -s cmdhist
shopt -s histappend
#export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Set rsync partials directory. Note that this does not imply the --partial
# flag when running rsync.
#export RSYNC_PARTIAL_DIR="~/.rsync-partial"

# Source .extra file if it exists. This file will never get added to repo.
if [ -f ~/.extra ]; then
	source ~/.extra
fi;

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	SESSION_TYPE=remote/ssh
	source ~/.sshmotd
fi


# Notes
# SSH keys, a la http://blog.patshead.com/2013/09/generating-new-more-secure-ssh-keys.html
# ssh-keygen -b 4096 -f ~/.ssh/id_rsa_danemacmillan_4096_2014_08 -C danemacmillan@id_rsa_4096_2014_08

# rsync. --info flag only for 3.1.*
#rsync -haz --partial --delay-updates --bwlimit=6m --info=progress2 user@domain.com:~/media ./mediarsync

#alias btop="mytop -u user -p '' -h localhost -d database"
