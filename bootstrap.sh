#!/usr/bin/env bash

# Check if local .dfconfig exists. If not, copy the master .dfconfig.
if [ ! -f ~/.dfconfig ]; then
	cp ~/.dotfiles/.dfconfig ~/
fi
source ~/.dfconfig

# Pull in formatting templates
if [ -f ~/.dotfiles/.formatting ]; then
	source ~/.dotfiles/.formatting
fi

# Install
echo -e "${RESET}${BLUE}${BOLD}Symlinking dotfiles.${RESET}${GREEN}${DIM}"
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
ln -vsfn ~/.dotfiles/packages.sh ~/
rm -rf ~/.packages && ln -vsfn ~/.dotfiles/.packages ~/
ln -vsfn ~/.dotfiles/.sshmotd ~/
rm -rf ~/.vim && ln -vsfn ~/.dotfiles/.vim ~/
ln -vsfn ~/.dotfiles/.vimrc ~/
ln -vsfn ~/.dotfiles/dotfiles.sh ~/
ln -vsfn ~/.dotfiles/.dfmodules ~/
rm -rf ~/.weechat && ln -vsfn ~/.dotfiles/.weechat ~/

# Create user bin if it doesn't exist.
if [ ! -d "$HOME/bin" ]; then
	echo -e "${RESET}${BLUE}${BOLD}Creating user bin directory for extra PATH.${RESET}"
	mkdir $HOME/bin
fi

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

# Install packages from given package management
source ~/.functions
source ~/packages.sh

# Install dfmodules
source ~/.dfmodules

# Update terminal
echo -e "${BLUE}${BOLD}Updating terminal with new profile.${RESET}"
source ~/.bash_profile;

echo -e "${WHITE}${BOLD}Done!${RESET}"
