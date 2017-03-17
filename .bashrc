# vim: ft=sh
source "${HOME}/.dotfiles/.dotfiles_includes"

##
# .bashrc
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

##
# Make sure aliases expand in non-interactive mode. For example, when running
# ssh remote-address "ll"
shopt -s expand_aliases

##
# Case-insensitive globbing
# http://tldp.org/LDP/abs/html/globbingref.html
shopt -s nocaseglob;

##
# Source general configs.
source "${HOME}/.path"
source "${HOME}/.aliases"

##
# Add tab completion for many Bash commands, including the
# ability to add extended Git info in PS1.
# Note that this will work on both MacOS and CentOS. On the latter, the path
# will simply be "/etc/bash_completion" as brew will return nothing.
if [[ -f "$(command_exists brew && brew --prefix)/etc/bash_completion" ]]; then
	source "$(command_exists brew && brew --prefix)/etc/bash_completion"
fi

##
# If the above does not work on CentOS, then __git_ps1 will not be available.
# On CentOS it should also be available through this path.
if ! command_exists __git_ps1 \
	&& [[ -f "/usr/share/git-core/contrib/completion/git-prompt.sh" ]] \
; then
	source "/usr/share/git-core/contrib/completion/git-prompt.sh"
fi

##
# Source google-cloud-sdk gcloud utilities
# https://cloud.google.com/sdk/docs/quickstarts
if [[ -f "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc" ]]; then
	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
fi
if [[ -f "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ]]; then
	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
fi

##
# Verify and export package manager variables for dotfiles, and Generate MD5s.
#dpm --verify
source "${DOTFILES_DIRECTORY}/dpm" --verify

##
# Set default editor
export EDITOR=vim

##
# Color
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

##
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

##
# Disable MySQL history logging
export MYSQL_HISTFILE=/dev/null
export MYCLI_HISTFILE=/dev/null

##
# Stop less from making history file
export LESSHISTFILE=/dev/null

##
# Set rsync partials directory. Note that this does not imply the --partial
# flag when running rsync.
export RSYNC_PARTIAL_DIR="{HOME}/tmp/rsync-partials"

##
# Go lang
export GOPATH="${HOME}/go"

##
# Bash prompt, like PS1
if [[ -f "${HOME}/.bash_prompt" ]]; then
	source "${HOME}/.bash_prompt"
fi

##
# Source .extra file if it exists. This file will never get added to repo.
if [[ -f "${HOME}/.extra" ]]; then
	source "${HOME}/.extra"
fi
