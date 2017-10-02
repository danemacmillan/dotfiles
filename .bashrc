# vim: ft=sh
source "${HOME}/.dotfiles/.dotfiles_includes"

##
# .bashrc
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

##
# Update PATH
source "${HOME}/.path"

##
# Make sure aliases expand in non-interactive mode. For example, when running
# ssh remote-address "ll"
shopt -s expand_aliases

##
# Case-insensitive globbing
# http://tldp.org/LDP/abs/html/globbingref.html
shopt -s nocaseglob;

##
# Add tab completion for many Bash commands.
#
# Note that this will work on both MacOS and CentOS. On the latter, the path
# will simply be "/etc/bash_completion" as brew will return nothing.
export DOTFILES_BASHCOMPLETION="$(command_exists brew && brew --prefix)"
if [[ -e "${DOTFILES_BASHCOMPLETION}/etc/bash_completion" ]]; then
	source "${DOTFILES_BASHCOMPLETION}/etc/bash_completion"
fi

##
# __git_ps1 for MacOS
export DOTFILES_GITPS1="$(command_exists brew && brew --prefix git)"
if [[ -e "${DOTFILES_GITPS1}/etc/bash_completion.d/git-prompt.sh" ]]; then
	source "${DOTFILES_GITPS1}/etc/bash_completion.d/git-prompt.sh"
fi

##
# __git_ps1 for CentOS
if ! command_exists __git_ps1 \
	&& [[ -e "/usr/share/git-core/contrib/completion/git-prompt.sh" ]] \
; then
	source "/usr/share/git-core/contrib/completion/git-prompt.sh"
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
# BSD LSCOLORS for MacOS.
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
# GNU LS_COLORS for other flavours, like CentOS.
# Note that these dotfiles install GNU's `ls`, so the below will work on MacOS,
# and ignore the CLICOLOR and LSCOLORS variables above.
if [[ -e ~/.dir_colors ]]; then
	eval $(dircolors -b "${HOME}/.dir_colors")
fi

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

# Don't use kqueue. Tmux will choke on MacOS Sierra with it enabled.
export EVENT_NOKQUEUE=1

# Since gcloud 132.0.0, Python 2.6 is deprecated. On CentOS this is a problem.
# This variable points the gcloud tool to a supported version without breaking
# CentOS' yum utility, which depends on 2.6.x.
# https://cloud.google.com/sdk/docs/release-notes#13200_2016-10-26
export CLOUDSDK_PYTHON=""

# Allow specifying the auth credentials file. Having this set will override
# any account set with gcloud. Note that this is commonly used for Service
# Accounts within the iam+ section, which can also be passed to most utilities
# with a `-credential_file=` flag.
# https://developers.google.com/identity/protocols/application-default-credentials
export GOOGLE_APPLICATION_CREDENTIALS=""

##
# Aliases
if [[ -e "${HOME}/.aliases" ]]; then
	source "${HOME}/.aliases"
fi

##
# Bash prompt, like PS1
if [[ -e "${HOME}/.bash_prompt" ]]; then
	source "${HOME}/.bash_prompt"
fi

if command_exists gcloud \
	&& [[ -e "${HOME}/.gcp" ]] \
; then
	source "${HOME}/.gcp"
fi

##
# Source .extra file if it exists. This file will never get added to repo.
if [[ -f "${HOME}/.extra" ]]; then
	source "${HOME}/.extra"
fi
