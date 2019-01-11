# vim: ft=sh
source "${HOME}/.dotfiles_includes"

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
if [[ $- == *i* ]] \
	&& command_exists tput \
	&& [[ $(tput colors) -ge 256 ]] \
	&& [[ -e "${HOME}/.dir_colors" ]] \
; then
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
# Disable various history logging.
export MYSQL_HISTFILE=/dev/null
export MYCLI_HISTFILE=/dev/null
export LESSHISTFILE=/dev/null

##
# Set rsync partials directory. Note that this does not imply the --partial
# flag when running rsync.
export RSYNC_PARTIAL_DIR="${XDG_RUNTIME_DIR}/rsync-partials"

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
# https://github.com/tmux/tmux/issues/475
export EVENT_NOKQUEUE=1

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
# Add tab completion for many Bash commands.
#
# It should be noted that loading all the completions adds significant overhead
# to the overall load time of a new shell. Every other operation is at most a
# a few ms, but completions are always slow.
#
# Add `time` to beginning of source line to see real time.
#
# MacOS using homebrew's `bash-completion@2` package, which is significantly
# faster than original `bash-completion` package.
# Read: https://superuser.com/a/1393343/496301
if [[ -f "${HOMEBREW_INSTALL_PATH}/share/bash-completion/bash_completion" ]]; then
	time source "${HOMEBREW_INSTALL_PATH}/share/bash-completion/bash_completion"
elif [[ -e "/etc/bash_completion" ]]; then
	source "/etc/bash_completion"
fi

##
# __git_ps1 for MacOS or other systems
if [[ -e "${HOMEBREW_FORMULA_PATH}/git/etc/bash_completion.d/git-prompt.sh" ]]; then
	source "${HOMEBREW_FORMULA_PATH}/git/etc/bash_completion.d/git-prompt.sh"
elif [[ -e "/usr/share/git-core/contrib/completion/git-prompt.sh" ]]; then
	source "/usr/share/git-core/contrib/completion/git-prompt.sh"
fi

##
# Verify and export package manager variables for dotfiles, and Generate MD5s.
# Only source this, because executing it will not add hashes to current shell.
source "${DOTFILES_PATH}/bin/dpm" --verify

##
# Aliases
if [[ -e "${DOTFILES_PATH}/.aliases" ]]; then
	source "${DOTFILES_PATH}/.aliases"
fi

##
# Bash prompt, like PS1
if [[ -e "${DOTFILES_PATH}/.bash_prompt" ]]; then
	source "${DOTFILES_PATH}/.bash_prompt"
fi

##
# Source .extra file if it exists. This file will never get added to repo.
if [[ -e "${HOME}/.extra" ]]; then
	source "${HOME}/.extra"
fi
