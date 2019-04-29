# vim: ft=sh
source "${HOME}/.dotfiles/source/bootstrap"

##
# .bashrc
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

##
# Modify Bash shell behaviour using shopt built-in.
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html#The-Shopt-Builtin
#
# Output is piped to dev/null to prevent old versions of bash complaining.

# Make sure aliases expand in non-interactive mode. For example, when running
# ssh remote-address "ll"
shopt -s expand_aliases 2&>/dev/null
#
# Case-insensitive globbing
shopt -s nocaseglob 2&>/dev/null
#
# Attempt to fix spellng.
shopt -s cdspell 2&>/dev/null
shopt -s dirspell 2&>/dev/null
#
# Change directory without typing `cd` built-in.
shopt -s autocd 2&>/dev/null

##
# Set default editor
export EDITOR=vim

##
# Use custom XDG directory for vim.
export VIMINIT=":source $XDG_CONFIG_HOME/vim/vimrc"

##
# Location of projects. The `p` alias changes to this path.
#
# This path is also added to CDPATH for subdirectory completion from anywhere.
#
# This can be modified in the $XDG_DATA_HOME/dotfiles/shell.local file.
export PROJECTS_PATH="${HOME}/projects"

##
# Location of most popular project path. The `ppp` alias changes to this path.
#
# This path is also added to CDPATH for subdirectory completion from anywhere.
#
# This can be modified in the $XDG_DATA_HOME/dotfiles/shell.local file.
export PROJECTS_PATH_POPULAR=""

##
# Color
# BSD LSCOLORS for MacOS.
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
# GNU LS_COLORS for other flavours, like CentOS.
# Note that these dotfiles install GNU's `ls`, so the below will work on MacOS,
# and ignore the CLICOLOR and LSCOLORS variables above.
export DIRCOLORS_DATABASE_PATH="${XDG_CONFIG_HOME}/dircolors/dircolors"
if [[ $- == *i* ]] \
	&& command_exists dircolors \
	&& command_exists tput \
	&& [[ $(tput colors) -ge 256 ]] \
	&& [[ -e "${DIRCOLORS_DATABASE_PATH}" ]] \
; then
	eval $(dircolors -b "${DIRCOLORS_DATABASE_PATH}")
fi

##
# GNUPG
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"

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
if [[ -e "${DOTFILES_BASH_HISTORY_PATH}" ]]; then
	export HISTFILE="${DOTFILES_BASH_HISTORY_PATH}"
fi

##
# Disable various history logging.
export MYSQL_HISTFILE=/dev/null
export MYCLI_HISTFILE=/dev/null
export LESSHISTFILE=/dev/null

##
# RubyGems
export GEM_HOME="${XDG_DATA_HOME}/gem"
export GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"

##
# Readline
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"

##
# Set rsync partials directory. Note that this does not imply the --partial
# flag when running rsync.
# https://download.samba.org/pub/rsync/rsync.html
export RSYNC_PARTIAL_DIR="${XDG_RUNTIME_DIR}/rsync-partials"
# This is an unofficial Rsync environment variable.
export RSYNC_EXCLUDE_FROM="${XDG_CONFIG_HOME}/rsync/excludes"

##
# Tmux
export TMUX_TMPDIR="${XDG_RUNTIME_DIR}"
export TMUX_PLUGIN_MANAGER_PATH="${XDG_DATA_HOME}/tmux/plugins"

##
# Vagrant
if [[ ! -e "${HOME}/.vagrant.d" ]]; then
	export VAGRANT_HOME="${XDG_DATA_HOME}/vagrant"
	export VAGRANT_ALIAS_FILE="{$VAGRANT_HOME}/aliases"
fi

##
# Weechat
export WEECHAT_HOME="${XDG_CONFIG_HOME}/weechat"

##
# Set common rclone options as environment variables.
# @see https://github.com/ncw/rclone/blob/master/MANUAL.md#environment-variables
export RCLONE_BWLIMIT="07:00,512 17:00,1M 21:00,1M 23:00,1.5M 01:00,2.5M"
export RCLONE_CHECKERS=8
export RCLONE_DRIVE_CHUNK_SIZE=64M
export RCLONE_DRIVE_USE_TRASH=true
export RCLONE_EXCLUDE="{.unionfs-fuse/,.DS_Store,.localized,.CFUserTextEncoding,Icon\\r,Thumbs.db,Desktop.ini,desktop.ini,ehthumbs.db,.Spotlight-V100,.Trashes,.cache,*.icloud,com.apple.homed.plist,com.apple.homed.notbackedup.plist}"
export RCLONE_SKIP_LINKS=true
export RCLONE_STATS=1s
export RCLONE_TRANSFERS=1
#export RCLONE_VERBOSE=1

##
# NPM
#
# To see all directories in use: `npm config ls -l | grep /`
#
# Full discussion about XDG support for NPM:
# - https://github.com/npm/npm/issues/6675
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export NPM_CONFIG_TMP="${XDG_RUNTIME_DIR}/npm"

##
# Since gcloud 132.0.0, Python 2.6 is deprecated. On CentOS this is a problem.
# This variable points the gcloud tool to a supported version without breaking
# CentOS' yum utility, which depends on 2.6.x.
# https://cloud.google.com/sdk/docs/release-notes#13200_2016-10-26
export CLOUDSDK_PYTHON=""

##
# Allow specifying the auth credentials file. Having this set will override
# any account set with gcloud. Note that this is commonly used for Service
# Accounts within the iam+ section, which can also be passed to most utilities
# with a `-credential_file=` flag.
# https://developers.google.com/identity/protocols/application-default-credentials
export GOOGLE_APPLICATION_CREDENTIALS=""

##
# Verify and export package manager variables for dotfiles, and Generate MD5s.
# Only source this, because executing it will not add hashes to current shell.
#source "${DOTFILES_PATH}/bin/dpm" --verify

##
# Aliases
if [[ -e "${DOTFILES_PATH}/source/alias" ]]; then
	source "${DOTFILES_PATH}/source/alias"
fi

##
# Bash prompt, like PS1
if [[ -e "${DOTFILES_PATH}/source/prompt_string" ]]; then
	source "${DOTFILES_PATH}/source/prompt_string"
fi

##
# Add tab completion for many Bash commands.
#
# Note that these dotfiles install `bash_completion@2`, and fully leverages
# non-eager completion loading from the core library, as well as by using the
# user path at ${XDG_DATA_HOME}/bash-completion/completions. That path can be
# used to override any non-eager completion by simply creating a file that
# matches the utility's name.
#
# Read: https://github.com/scop/bash-completion#faq
#
# Add `time` to beginning of source line to see real time.
#
# MacOS using homebrew's `bash-completion@2` package, which is significantly
# faster than original `bash-completion` package.
# Read: https://superuser.com/a/1393343/496301
#
# Note that brew recommends sourcing /usr/local/etc/profile.d/bash_completion.sh
# for either version of bash-completion. These dotfiles have chosen to
# explicitly look for version 2, and if found, assign a backwards-compatible
# directory to look for old-style, eagerly-loaded bash completion files, then
# source the new, faster ones that are non-eager. Doing so allows the old
# bash-completion files to be picked up, of which there are several, including
# those for git completion and vagrant completion. This works because
# version 2 of bash completion checks for a `$BASH_COMPLETION_COMPAT_DIR`
# variable, and if found, will immediately source all the files found under it.
#
# Additionally, the $BASH_COMPLETION_USER_FILE environment variable is set,
# which by default points to `~/.bash_completion`, but instead has been moved to
# an XDG directory. Note that this user file is sourced eagerly as well, so
# should not be used, except in cases where a popular tool does not offer a
# better alternative. For the purpose of distinguishing old-style eager
# completions from modern non-eager completions, this user completion file
# has been added to a path under $XDG_CONFIG_HOME. Non-eager user completions
# are available under the new path, under $XDG_DATA_HOME.
export BASH_COMPLETION_USER_FILE="${XDG_CONFIG_HOME}/bash-completion/bash_completion"
if [[ -e "/usr/local/share/bash-completion/bash_completion" ]]; then
	export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
	source "/usr/local/share/bash-completion/bash_completion"
elif [[ -e "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
	source "/usr/local/etc/profile.d/bash_completion.sh"
elif [[ -e "/etc/bash_completion" ]]; then
	# This is in all certainty NOT version 2 bash completion, so pull them in
	# eagerly. Note that this requires sudo privileges to add a user's completion
	# file to /etc/bash_completion. This is really a last-ditch effort to get
	# v1 completion compatibility on old systems. A simple
	# ${HOME}/.bash_completion can also just be created, but the goal of thee
	# dotfiles is to follow the XDG spec as closely as possible, in an effort to
	# clean up the home directory.
	#if [[ "${BASH_COMPLETION_VERSINFO}" != "2" ]] \
	#	&& [[ ! -e "/etc/bash_completion.d/bash_completion.${USER}" ]] \
	#; then
	#	sudo ln -s "${BASH_COMPLETION_USER_FILE}" "/etc/bash_completion.d/bash_completion.${USER}"
	#fi

	source "/etc/bash_completion"
fi

##
# Source extra file if it exists. This file will never get added to repo.
if [[ -e "${DOTFILES_LOCAL_CONFIGS_PATH}/shell.local" ]]; then
	source "${DOTFILES_LOCAL_CONFIGS_PATH}/shell.local"
fi

##
# Source a host-specific configuration file if it exists.
#
# This allows multiple host-specific configurations to exist, but only become
# active if the dot-prefixed file name matches the hostname of the machine.
#
# Note that the full hostname is added for backwards-compatibility. The new
# version called in DOTFILES_HOSTNAME uses the short hostname.
if [[ -e "${DOTFILES_LOCAL_CONFIGS_PATH}/${DOTFILES_HOSTNAME}.shell.local" ]]; then
	source "${DOTFILES_LOCAL_CONFIGS_PATH}/${DOTFILES_HOSTNAME}.shell.local"
elif [[ -e "${DOTFILES_LOCAL_CONFIGS_PATH}/$(hostname -f).shell.local" ]]; then
	source "${DOTFILES_LOCAL_CONFIGS_PATH}/$(hostname -f).shell.local"
fi

##
# Set the CD paths to search when providing tab completion.
#
# Note that this is deliberately NOT exported, because the value of this
# environment variable is really only important on interactive shells, but can
# critically break scripts that do not expect the $CDPATH to be anything other
# than the present working directory. Also, this always ensures that the
# present working directory is first, regardless of anything else being set.
CDPATH=":.:${HOME}:${PROJECTS_PATH}:${PROJECTS_PATH_POPULAR}:${CDPATH}:"

