# Aliases for CentOS
alias update="dotfiles; composer selfupdate; yum -y update"

# Add tab completion for many Bash commands, including the
# ability to add extended Git info in PS1.
if [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# If the above does not work, then __git_ps1 will not be available. On CentOS
# it should also be available through this path.
if ! command -v __git_ps1 > /dev/null 2>&1 && [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
	source /usr/share/git-core/contrib/completion/git-prompt.sh;
fi;