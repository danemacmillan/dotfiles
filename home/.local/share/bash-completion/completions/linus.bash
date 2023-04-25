# vim: ft=sh

##
# Completion for proprietary Linus Shops CLI tool.
#
# Read: https://github.com/scop/bash-completion#faq
#
# @author Dane MacMillan <work@danemacmillan.com>
if command -v "linus" >/dev/null 2>&1; then
	eval "$($XDG_BIN_HOME/linus completion bash)"
	#eval $(linus _completion -g -p linus)
	#eval $(linus _completion -g -p linusdebug)
fi
