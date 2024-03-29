# vim: ft=sh

##
# Custom completion for etc command.
#
# The etc command is part of the .config/etc location for server configs.
#
# Read: https://github.com/scop/bash-completion#faq
#
# @author Dane MacMillan <work@danemacmillan.com>
_etc()
{
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="help map restart xdebug dnsmasq"

	if [[ ${cur} == * ]] ; then
		COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
		return 0
	fi
} &&
complete -F _etc etc
