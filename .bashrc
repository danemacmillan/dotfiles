##
# .bashrc
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
#

# Make sure aliases expand in non-interactive mode. For example, when running
# ssh remote-address "ll"
shopt -s expand_aliases

# Case-insensitive globbing
# http://tldp.org/LDP/abs/html/globbingref.html
shopt -s nocaseglob;

source $HOME/.paths

# Determine whether in an SSH session, even when su is used.
if [[ "${SSH_TTY}" ]] || [[ $(who am i) =~ \([-a-zA-Z0-9\.]+\)$ ]]; then
	export HAS_SSH=1
fi

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

# Source formatting / color variables
if tty -s ; then
	source ~/.formatting
fi

# Source dotfiles config file.
source ~/.dfconfig

# Source various helper bash functions
source ~/.functions

# Source aliases
source ~/.aliases

# Source OS-specific configs.
source ~/.$OS

# Verify and export package manager variables for dotfiles, and Generate MD5s.
source ~/packages.sh --verify

# Set default editor
export EDITOR=vim

# Git branch using bash-completion
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=0
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='verbose'

# Highlight the user name when logged in as root.
USER_STYLE='\[${GREEN}\]';
USER_BANG='\[${CYAN}${BOLD}\]\$'
if [[ "${USER}" == "root" ]]; then
	USER_STYLE='\[${RED}\]';
	USER_BANG='\[${RED}\]#'
fi

# Highlight the hostname when connected via SSH.
HOST_STYLE='\[${BLUE}${BOLD}\]';
if [[ "${HAS_SSH}" ]]; then
	HOST_STYLE='\[${BLUE}${BOLD}\]://';
fi

export PS1="${USER_STYLE}\u\\[${RESET}${CYAN}\]@${HOST_STYLE}\H\\[${RESET}${CYAN}\] \w\\[${RED}\]\$(__git_ps1) ${USER_BANG}\\[${RESET}\] "

# Export PS1
if [[ -n $DOTFILES_CONFIG_TIMESTAMP ]]; then
	export PS1="$DOTFILES_CONFIG_TIMESTAMP$PS1"
fi

# Color
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

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

# rsync. --info flag only for 3.1.*
#rsync -haz --partial --delay-updates --bwlimit=6m --info=progress2 user@domain.com:~/media ./mediarsync

#alias btop="mytop -u user -p '' -h localhost -d database"
