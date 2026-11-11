# Simple convenience aliases
alias x='exit'
alias danemacmillan="echo 'nicessss!!!!'"

##
# Change directories.
alias ,,='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'

##
# Directory listing.
LS_IGNORES="--ignore=.DS_Store --ignore='Icon'$'\r' --ignore=.CFUserTextEncoding --ignore=.localized --ignore=.Trash --ignore=.Trashes --ignore=.Spotlight-V100 --ignore=.fseventsd"
LS_DEFAULTS="-lAhviNp"
# List symlinked directories alongside regular directories.
# Modified from https://unix.stackexchange.com/a/412041/103243
lsdirfirst()
{
	local lsoptions="${LS_DEFAULTS}"
	if [[ -n "${1}" ]]; then
		local lsoptions="${1}"
	fi

	ls --color ${LS_IGNORES} ${lsoptions} -q "$@" |
		awk '{if(/^total [0-9\.]+[a-zA-Z]*?$/ || /\/$/) n=1; else n=2; print n, $0}' |
		sort -sk1,1 | cut -d' ' -f2-
}
alias ll="lsdirfirst ${LS_DEFAULTS}"
