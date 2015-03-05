## .bashrc

# Make sure aliases expand in non-interactive mode. For example, when running
# ssh remote-address "ll"
shopt -s expand_aliases

# Case-insensitive globbing
# http://tldp.org/LDP/abs/html/globbingref.html
shopt -s nocaseglob;

if [ -d "/usr/local/sbin" ]; then
	export PATH="/usr/local/sbin:$PATH"
fi

if [ -d "/usr/local/bin" ]; then
	export PATH="/usr/local/bin:$PATH"
fi

if [ -d "$HOME/.composer/vendor/bin" ]; then
	export PATH="$HOME/.composer/vendor/bin:$PATH"
fi

# Add user bin if it exists.
if [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin:$PATH"
	chmod -R +x $HOME/bin
fi

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
source ~/.formatting

# Source various helper bash functions
source ~/.functions

# Source aliases
source ~/.aliases

# Source OS-specific configs.
source ~/.$OS

# Verify and export package manager variables for dotfiles.
check_package_managers

# Set default editor
export EDITOR=vim

# Git branch using bash-completion
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=0
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='verbose'

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	USER_STYLE="${RED}";
	USER_BANG="\\[${RED}\]#"
else
	USER_STYLE="${GREEN}";
	USER_BANG="\\[${CYAN}${BOLD}\]\$"
fi;

# Highlight the hostname when connected via SSH.
if [[ "${HAS_SSH}" ]]; then
	HOST_STYLE="${BLUE}${BOLD}://";
else
	HOST_STYLE="${BLUE}${BOLD}";
fi;

# Export PS1
export PS1="\\[${USER_STYLE}\]\u\\[${RESET}${CYAN}\]@\\[${HOST_STYLE}\]\H\\[${RESET}${CYAN}\] \w\\[${RED}\]\$(__git_ps1) ${USER_BANG}\\[${RESET}\] "

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
