#!/usr/bin/env bash

# Install external dependencies
DF_PKG_MNGR="none"
echo "Detecting package manager..."
if hash yum 2>/dev/null; then
	DF_PKG_MNGR="yum"
elif hash brew 2>/dev/null; then
	DF_PKG_MNGR="brew"
elif hash apt-get @>/dev/null; then
	DF_PKG_MNGR="apt-get"
else
	echo "No compatible package manager detected, skipping externals."
fi

echo "$DF_PKG_MNGR detected"

if hash ctags 2>/dev/null; then
	echo "${GREEN}ctags is installed.${RESET}"
else
	echo "${RED}Installing ctags${RESET}"
	case $DF_PKG_MNGR in
		brew)
			brew install ctags-exuberant
			;;
		yum)
			yum install ctags-etags
			;;
		apt-get)
			apt-get install exuberant-ctags
		esac
fi

# Pull in formatting templates
if [ -f ~/.dotfiles/.formatting ]; then
	source ~/.dotfiles/.formatting
fi

# Install
echo -e "${BLUE}${BOLD}Symlinking dotfiles.${RESET}"
ln -vsfn ~/.dotfiles/.aliases ~/
ln -vsfn ~/.dotfiles/.agignore ~/
ln -vsfn ~/.dotfiles/.bash_completion ~/
ln -vsfn ~/.dotfiles/.bash_profile ~/
ln -vsfn ~/.dotfiles/.bashrc ~/
ln -vsfn ~/.dotfiles/.ctags ~/
ln -vsfn ~/.dotfiles/.digrc ~/
ln -vsfn ~/.dotfiles/.formatting ~/
ln -vsfn ~/.dotfiles/.functions ~/
ln -vsfn ~/.dotfiles/.gitconfig ~/
ln -vsfn ~/.dotfiles/.gitignore ~/
ln -vsfn ~/.dotfiles/.inputrc ~/
ln -vsfn ~/.dotfiles/.siegerc ~/
ln -vsfn ~/.dotfiles/.tmux.conf ~/
ln -vsfn ~/.dotfiles/.npmrc ~/
ln -vsfn ~/.dotfiles/.nix ~/
ln -vsfn ~/.dotfiles/.osx ~/
ln -vsfn ~/.dotfiles/.sshmotd ~/
rm -rf ~/.vim && ln -vsfn ~/.dotfiles/.vim ~/
ln -vsfn ~/.dotfiles/.vimrc ~/
ln -vsfn ~/.dotfiles/dotfiles.sh ~/
rm -rf ~/.weechat && ln -vsfn ~/.dotfiles/.weechat ~/

# Create user bin if it doesn't exist.
if [ ! -d "$HOME/bin" ]; then
	echo -e "${BLUE}${BOLD}Creating user bin directory for extra PATH.${RESET}"
	mkdir $HOME/bin
fi

# Install dependencies
echo -e "${BLUE}${BOLD}Installing dependencies.${RESET}"
ln -vsfn ~/.dotfiles/.dependencies ~/
source ~/.dependencies

# Create optional .extra file to be sourced along repo content.
if [ ! -f ~/.extra ]; then
	echo -e "${BLUE}${BOLD}Generating .extra file.${RESET}"
	touch ~/.extra
fi

# Create .gitconfig.local file to hold user credentials for Git.
if [ ! -f ~/.gitconfig.local ]; then
	echo -e "${BLUE}${BOLD}Generating .gitconfig.local file for custom changes. Add your Git credentials here.${RESET}"
	#touch ~/.gitconfig.local
	cat >>~/.gitconfig.local <<EOL
[user]
	name =
	email =
EOL
fi

# Generate .ssh/config file if none.
if [ ! -f "$HOME/.ssh/config" ]; then
	# Create directory regardless, just to be sure.
	mkdir -pv $HOME/.ssh
	# Default content
	cat >>$HOME/.ssh/config <<EOL
# See for reference:
# https://www.freebsd.org/cgi/man.cgi?query=ssh_config&sektion=5
# http://www.openssh.com/faq.html#3.14

Host *
	TCPKeepAlive yes
	ServerAliveInterval 120
	PreferredAuthentications publickey,password
	Protocol 2
	Compression yes
	LogLevel VERBOSE
	ForwardX11 yes
	#Hostname
	#Port
	#User
	#IdentityFile
EOL
fi

# Update terminal
echo -e "${BLUE}${BOLD}Updating terminal with new profile.${RESET}"
source ~/.bash_profile;

echo -e "${WHITE}${BOLD}Done!${RESET}"
