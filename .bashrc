# vim: ft=sh
source "${HOME}/.dotfiles/.dotfiles_includes"

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

# Source general configs.
source "${HOME}/.path"
source "${HOME}/.aliases"
# Source OS-specific configs.
source "${HOME}/.${OS}"

# Determine whether in an SSH session, even when su is used.
if [[ "${SSH_TTY}" ]] || [[ $(who am i) =~ \([-a-zA-Z0-9\.]+\)$ ]]; then
	export HAS_SSH=1
fi

# Verify and export package manager variables for dotfiles, and Generate MD5s.
#dpm --verify
source "${DOTFILES_DIRECTORY}/dpm" --verify

# Set default editor
export EDITOR=vim

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

# Disable MySQL history logging
export MYSQL_HISTFILE=/dev/null
export MYCLI_HISTFILE=/dev/null

# Stop less from making history file
export LESSHISTFILE=/dev/null

# Set rsync partials directory. Note that this does not imply the --partial
# flag when running rsync.
export RSYNC_PARTIAL_DIR="{HOME}/tmp/rsync-partials"

##
# Go lang
export GOPATH="${HOME}/go"

##
# PS1

# Git branch using bash-completion
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=0
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='verbose'

# In a VM, these can really slow the prompt down:
if [[ -d "/vagrant" ]]; then
	export GIT_PS1_SHOWDIRTYSTATE=
	export GIT_PS1_SHOWUNTRACKEDFILES=
fi

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

##
# Source .extra file if it exists. This file will never get added to repo.
if [[ -f "${HOME}/.extra" ]]; then
	source "${HOME}/.extra"
fi
