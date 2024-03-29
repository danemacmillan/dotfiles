# vim: ft=sh

##
# prompt_string
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

##
# PS1

##
# Determine whether in an SSH session, even when su is used.
if [[ "${SSH_TTY}" ]] \
	|| [[ $(who am i) =~ \([-a-zA-Z0-9\.]+\)$ ]] \
; then
	export HAS_SSH=1
fi

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

PS1_BACKGROUND=''
USER_STYLE='\[${GREEN}\]';
USER_BANG='\[${CYAN}${BOLD}\]\$'
HOST_STYLE='\[${BLUE}${BOLD}\]';
PS1_PATH=''

# Highlight the hostname when connected via SSH.
if [[ "${HAS_SSH}" ]]; then
	PS1_BACKGROUND='\[${BG_VERYDARKGREY}\]'
	USER_STYLE='\[${RED}\]ssh://\[${WHITEISHGREY}\]';
	USER_BANG='\[${WHITE}\]#'
	HOST_STYLE='\[${UNDERLINE}${BBLUE}\]';
fi

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	USER_STYLE='\[${RED}\]';
	USER_BANG='\[${RED}\]#'
fi

##
# __git_ps1 for Nix.
# @TODO Restore for Nix eventually.
##source_loop "${NIX_PROFILES:-${NIX_PROFILE_USER_PATH}}" "share/git/contrib/completion/git-prompt.sh"
# __git_ps1 for MacOS or other systems
if [[ -e "${HOMEBREW_FORMULA_PATH}/git/etc/bash_completion.d/git-prompt.sh" ]]; then
	source "${HOMEBREW_FORMULA_PATH}/git/etc/bash_completion.d/git-prompt.sh"
elif [[ -e "/usr/share/git-core/contrib/completion/git-prompt.sh" ]]; then
	source "/usr/share/git-core/contrib/completion/git-prompt.sh"
fi

if command_exists __git_ps1 ; then
	export PS1="${PS1_BACKGROUND}${USER_STYLE}\u\\[${CYAN}\]@${HOST_STYLE}\H\[${RESET}\]\\[${CYAN}\] \w\\[${RED}\]\$(__git_ps1) ${USER_BANG}\\[${RESET}\] "
fi

# https://superuser.com/a/517110

#function prompt_right() {
#  echo -e "${LIGHTGREY}\D{%H:%M}${DARKGREY}:\D{%S}"
#}

#function prompt_left() {
#  #echo -e "\033[0;35m${RANDOM}\033[0m"
#	echo -e "${USER_STYLE}\u\\[${RESET}${CYAN}\]@${HOST_STYLE}\H\\[${RESET}${CYAN}\] \w\\[${RED}\]\$(__git_ps1) ${USER_BANG}\\[${RESET}\] "
#}

#function prompt() {
#    compensate=30
#    PS1=$(printf "%*s\r%s\n\$ " "$(($(tput cols)+${compensate}))" "$(prompt_right)" "$(prompt_left)")
#}
#PROMPT_COMMAND=prompt
