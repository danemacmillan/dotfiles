# vim: ft=sh

##
# Custom completion for dotfiles command.
#
# Read: https://github.com/scop/bash-completion#faq
#
# @author Dane MacMillan <work@danemacmillan.com>
_dotfiles()
{
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="stow unstow restow skippackages"

	if [[ ${cur} == * ]] ; then
		COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
		return 0
	fi
} &&
complete -F _dotfiles dotfiles
