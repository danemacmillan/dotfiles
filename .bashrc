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
# Verify and export package manager variables for dotfiles, and Generate MD5s.
#dpm --verify
source "${DOTFILES_DIRECTORY}/dpm" --verify

##
# Set default editor
export EDITOR=vim

##
# Color
export CLICOLOR=1
# BSD LSCOLORS for MacOS.
export LSCOLORS=GxFxCxDxBxegedabagaced
# Linux LS_COLORS for other flavours, like CentOS.
export LS_COLORS="rs=0:di=38;5;27:ln=38;5;51:mh=44;38;5;15:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lz=38;5;9:*.xz=38;5;9:*.bz2=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.bz=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.rar=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.axa=38;5;45:*.oga=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:"

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

##
# Aliases
if [[ -f "${HOME}/.aliases" ]]; then
	source "${HOME}/.aliases"
fi

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
