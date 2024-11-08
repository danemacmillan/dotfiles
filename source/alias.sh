# vim: ft=sh

##
# alias
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

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
# Original ll without function.
alias lll="ls --color --group-directories-first ${LS_DEFAULTS}"
alias ll="lsdirfirst ${LS_DEFAULTS}"
alias kk="ll"
# Sort by newest last. Scroll up to see oldest.
alias llt="ls --color ${LS_DEFAULTS}tr ${LS_IGNORES}"
# Sort by extension.
alias llx="lsdirfirst ${LS_DEFAULTS}X"

##
# Filesystem.
alias rm='rm -rf'
# Note that -a is recursive, and, more importantly, preserves all ACLs, should
# any be set on the directory being copied.
# http://unix.stackexchange.com/a/43608
alias cp="cp -a"
# DO NOT EVER ALIAS mkdir with -p parents option. IT WILL BREAK INHERITED ACL
# PERMISSIONS.
# http://serverfault.com/questions/197263/conflicts-between-acls-and-umask
# http://savannah.gnu.org/bugs/?19546
# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=14371
#alias mkdir="mkdir -p"
alias du="du -h --time"
alias belinux="find . -type f -exec dos2unix {} \;"
# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

##
# Network.
alias listen='lsof -Pnl +M -i4'
alias nsp='netstat -tulpn'
alias ss='lsof -i'
alias ip="curl -H 'Accept: application/json' ipinfo.io/json && echo -e '\n' && ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias flushdns='sudo killall -HUP mDNSResponder'
alias networkscan="arp -a"
# Full port scan, service version, and OS scan (sudo required).
alias portscan="sudo nmap -vv -Pn -p1-65535 -sV -O --reason"

##
# Replace current shell with new shell.
#
# This ultimately refreshes all the variables, functions, settings, etc that
# were just added in current session.
alias R="echo -e '${BBLUE}Reloading shell...${RESET}'; exec -l ${SHELL}"

##
# Clear
alias c='clear'

##
# Ctags
#
# This replaces need for ~/.ctags config.
alias ctags='\ctags --recurse=yes --tag-relative=yes --exclude=.git --exclude=.svn'

##
# Dig
#
# This is better than having a ~/.digrc file to maintain, which simply passes
# the first line of that file as a string.
alias dig='\dig +nocmd any +multiline +noall +answer'

##
# exiftool and ffmpegq
alias strip_metadata_image="exiftool -all= "
#alias strip_metadata_video="ffmpeg -i IMG_4128.mov -map_metadata -1 -c:v copy -c:a copy out.mov"
## Other useful commands for exiftool
# exiftool -alldates="2023:10:18 12:00:00" .
# exiftool -UserComment="Screenshot" IMG_8555.jpeg
# exiftool -Comment="" IMG_8555.jpeg
# exiftool '-alldates<$filename' .
# exiftool '-alldates<modifydate' DSCN0012.JPG
# exiftool '-alldates<filemodifydate' DSCN0012.JPG

##
# Exit
#
# The myriad ways in which I like to exit a shell. My E-key is somewhat busted.
# Also, general typos I always make.
alias x='exit'
alias xit="exit"
alias eexit="exit"
alias eeexit="exit"
alias eit="exit"
alias exot="exit"
alias \:q='exit'

##
# Git
#
# Aliases and typos.
alias gut="git"
command_exists hub && alias git="hub"
# Just for reference. Do not rewrite history.
#alias grewritelast='GIT_COMMITTER_DATE="$(date -d \'24 hours ago\')" git commit --amend --date "$(date -d \'24 hours ago\')" && git push --force'
# Using custom loop function that will operate in eacch subdirectory,
# merge canonical branches up to either develop, stage, or master.
alias lmdevelop="ppp && loop 'git checkout develop' 'git pull'"
alias lmstage="ppp && loop 'git checkout develop' 'git pull' 'git checkout stage' 'git pull' 'git merge develop' 'git push' 'git checkout develop'"
alias lmmaster="ppp && loop 'git checkout develop' 'git pull' 'git checkout stage' 'git pull' 'git merge develop' 'git push' 'git checkout master' 'git pull' 'git merge stage' 'git push' 'git checkout develop'"
alias lbranches="ppp && loop 'git symbolic-ref --short HEAD' && cd -"
alias lstatus="ppp && loop 'git s' && cd -"
alias gitmergecurrentbranchtodevelop="git checkout develop && git pull && git checkout - && git pull && git merge develop && git checkout develop && git merge - && git push && git checkout -"
alias git_loop_pull="loop 'git pull'"
alias git_loop_repos_merge_up_canonicals_to_stage="loop 'git checkout develop' 'git pull' 'git checkout stage' 'git pull' 'git merge develop' 'git push' 'git checkout develop'"
alias git_loop_repos_merge_up_canonicals_to_master="loop 'git checkout develop' 'git pull' 'git checkout stage' 'git pull' 'git merge develop' 'git push' 'git checkout master' 'git pull' 'git merge stage' 'git push' 'git checkout develop'"


##
# Grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

##
# GCP - Google Cloud SDK
# alias gsutil="CLOUDSDK_PYTHON=$(which python3.6) gsutil"

##
# History
#
# Purge all history
alias historypurgeall='cat /dev/null > ~/.bash_history && history -c && history -w'
# Source: http://thoughtsbyclayg.blogspot.ca/2008/02/how-to-delete-last-command-from-bash.html
alias historypurgelast='history -d $((HISTCMD-2)) && history -d $((HISTCMD-1))'

##
# MyCLI
alias mycli='\mycli --myclirc="${XDG_CONFIG_HOME}/mycli/myclirc"'
#alias mysql='mycli'

##
# Npm
alias npm_list_global_installs='npm list -g --depth 0'
alias npm_global_install_path='echo $(npm root -g)'
alias npm_config_list='npm config ls -l'

##
# PHP
#
# Note: this is very specific to my standard virtual machine.
# Change the remote_host. Check it by running `netstat -r`.
# Old XDebug v2 versions.
#alias phpdebugcli='PHP_CLI_DEBUG="true" COMPOSER_ALLOW_XDEBUG=1 PHP_IDE_CONFIG="serverName=phpdebugcli" $(which php) -d "xdebug.idekey=PHPSTORM" -d "xdebug.remote_host=192.168.70.1" -d "xdebug.remote_port=9000" -d "xdebug.remote_enable=1" -d "xdebug.remote_autostart=1" -d "xdebug.remote_handler=dbgp"'
#alias phpdebugcli='PHP_CLI_DEBUG="true" COMPOSER_ALLOW_XDEBUG=1 PHP_IDE_CONFIG="serverName=phpdebugcli" $(which php) -d "xdebug.idekey=PHPSTORM" -d "xdebug.remote_port=9001" -d "xdebug.remote_enable=1" -d "xdebug.remote_autostart=1" -d "xdebug.remote_handler=dbgp"'
# XDebug v3:
alias phpdebugcli='PHP_CLI_DEBUG="true" COMPOSER_ALLOW_XDEBUG=1 XDEBUG_MODE=debug XDEBUG_SESSION=1 '
if command_exists linus \
	&& [[ -e "${XDG_BIN_HOME}/linus" ]] \
	&& php -m |grep -q xdebug \
; then
	alias linusdebug='phpdebugcli ${XDG_BIN_HOME}/linus'
fi
# Get the number of php-fpm processes, and their average size in MB.
#alias fpmstat='ps aux | grep php-fpm | wc -l ; ps --no-headers -o "rss,cmd" -C php-fpm | awk '{ sum+=$1 } END { printf ("%d%s\n", sum/NR/1024,"M") }'
alias fpmstat="ps aux | grep php-fpm | wc -l ; ps --no-headers -o \"rss,cmd\" -C php-fpm | awk '{ sum+=\$1 } END { printf (\"%d%s\n\", sum/NR/1024,\"M\") }'"

##
# Ripgrep
#
# Note that the options configured are defined in: $RIPGREP_CONFIG_PATH.
# The only reason the --ignore-file option is passed is for the environment
# variable expansion.
alias rg='\rg --ignore-file="${RIPGREP_IGNORE_PATH}"'

##
# Rsync
alias rsync='\rsync --exclude-from="${XDG_CONFIG_HOME}/rsync/excludes"'

##
# Siege
alias siege='\siege --rc="${XDG_CONFIG_HOME}/siege/siegerc"'

##
# SSH
alias copyidrsa="pbcopy < ${HOME}/.ssh/id_rsa"
alias copyidrsapub="pbcopy < ${HOME}/.ssh/id_rsa.pub"
# https://dev.to/yugabyte/ssh-and-warning-setlocale-lcctype-cannot-change-locale-utf-8-no-such-file-or-directory-5cnf
# https://stackoverflow.com/questions/29609371/how-not-to-pass-the-locale-through-an-ssh-connection-command
#alias ssh="ssh -F ${HOME}/.ssh/config "
#alias ssh="LC_ALL= ssh "
# On MacOS it would be better to add a specific rule in /etc/ssh/ssh_config.d/
# that will, when matched, not allow any ensuing configs to be used. By default,
# MacOS sends `SendEnv LANG LC_*` to all hosts.

##
# Tmux
#
# Create "default" and "other" tmux sessions.
alias t='tmux has-session -t default > /dev/null 2>&1 && tmux a -t default || tmux new -s default'
alias t0='t'
alias t1='tmux has-session -t other > /dev/null 2>&1 && tmux a -t other || tmux new -s other'

##
# Vagrant
alias vs="vagrant global-status --prune"

##
# Vim
alias vim='\vim -u "${XDG_CONFIG_HOME}/vim/vimrc"'
alias vi='vim'
alias v='vim'

################################################################################

##
# Dotfiles-related aliases.
alias d='cd "${DOTFILES_PATH}"'
alias d-local='cd "${DOTFILES_LOCAL_CONFIGS_PATH}"'

alias d-alias='${EDITOR} "${DOTFILES_PATH}/source/alias.sh"'
alias d-bashrc='${EDITOR} "${DOTFILES_PATH}/home/.bashrc"'
alias d-function='${EDITOR} "${DOTFILES_PATH}/source/function.sh"'
alias d-path='${EDITOR} "${DOTFILES_PATH}/source/path.sh"'
alias d-localshell='${EDITOR} "${DOTFILES_LOCAL_CONFIGS_PATH}/shell.local"'

alias how='${EDITOR} "${DOTFILES_PATH}/HOWDOI.md"'

alias xdg='printenv | grep XDG | sort'

alias h='cd ${HOME}'
alias p='cd ${PROJECTS_PATH}'
alias ppp='cd ${PROJECTS_PATH_POPULAR}'

################################################################################

##
# CentOS-specific Aliases
if command_exists yum ; then
	alias update="dotfiles; \
		composer selfupdate; \
		composer selfupdate --clean-backups; \
		npm install npm@latest -g; \
		yum -y update; \
		yum clean all; \
		command_exists gcloud && gcloud components update \
	"
fi

##
# MacOS-specific Aliases
if command_exists brew ; then

	##
	# Check for outdated software.
	alias outdated='brew outdated; brew outdated --cask; composer global outdated'

	# Depends on Firefox Tools Adapter: https://developer.mozilla.org/en-US/docs/Tools/Firefox_Tools_Adapter
	# TODO: Add checking.
	alias debugios='open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app; sleep 2s; ios_webkit_debug_proxy'
	alias elcapinstallercreate="sudo /Applications/Install\ OS\ X\ El\ Capitan.app/Contents/Resources/createinstallmedia --volume /Volumes/ElCapInstaller --applicationpath /Applications/Install\ OS\ X\ El\ Capitan.app --nointeraction"
	alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"
	alias flushdns="dscacheutil -flushcache"
	alias rebuildopenwithmenu='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user; killall Finder; echo "Rebuilt Open With, relaunching Finder"'
	alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

	# Used to also include in update: `npm install npm@latest -g; \`
	alias update="softwareupdate --install --all --verbose; \
		dotfiles; \
		composer selfupdate; \
		composer selfupdate --clean-backups; \
		command_exists gcloud && gcloud components update --quiet; \
		brew update; \
		brew upgrade; \
		brew doctor --verbose; \
		brew cleanup \
		brew autoremove \
	"
fi
