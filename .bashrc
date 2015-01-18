## .bashrc

# Make sure aliases expand in non-interactive mode. For example, when running
# ssh remote-address "ll"
shopt -s expand_aliases

# Case-insensitive globbing
# http://tldp.org/LDP/abs/html/globbingref.html
shopt -s nocaseglob;

# Add user bin if it exists.
if [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin:$PATH"
	chmod -R +x $HOME/bin
fi

# This file contains code that can be run on OSX and NIX machines.

# Detect OS so dotfiles seamlessly work across OSX and Linux.
# I only use OSX and CentOS, so additional cases will need
# to be defined for another OS.
export OS=$(uname | awk '{print tolower($0)}')
case $OS in
  darwin*) 
    OS='osx';; 
  linux*)  
    OS='nix';;
esac

# Source OS-specific configs.
source ~/.$OS

# Source various helper bash functions
source ~/.functions

# Source aliases
source ~/.aliases

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

# Source additional script for SSH / interactive sessions.
# Without login_shell check for interactive shell, software like rsync will
# connect to a server with these dotfiles, which will output content, and
# then error out a non-interactive client connection like like rsync.
#if shopt -q login_shell && [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
#	SESSION_TYPE=remote/ssh
#	source ~/.sshmotd
#fi


# Notes
# SSH keys, a la http://blog.patshead.com/2013/09/generating-new-more-secure-ssh-keys.html
# ssh-keygen -b 4096 -f ~/.ssh/id_rsa_danemacmillan_4096_2014_08 -C danemacmillan@id_rsa_4096_2014_08

# rsync. --info flag only for 3.1.*
#rsync -haz --partial --delay-updates --bwlimit=6m --info=progress2 user@domain.com:~/media ./mediarsync

#alias btop="mytop -u user -p '' -h localhost -d database"
