#!/usr/bin/env bash

##
# packages.sh
#
# This file gets sourced by bootstrap.sh. It installs all packages found in
# the packages directory, dependent on the package management system available.
echo -e "${BLUE}${BOLD}Installing / updating ${GREEN}${REVERSE} $PKG_MNGR ${RESET}${BLUE}${BOLD} packages, if any.${RESET}"

# Clone git repos before anything else.

case "$DOTFILES_PACKAGE_MANAGER" in
	brew)
		;;

	yum)
		;;

	apt-get)
		;;

esac































##
# Git repos


# Install Vundler for Vim.
#echo -e "Installing Vim Vundler and plugins. This may take a few seconds."
#git clone git@github.com:gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> /dev/null
#git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> /dev/null
# Install Vim plugins defined in .vimrc file.
# Depending on the location that Vundler installs a plugin, there
# may be an authentication prompt for username and password.
#vim +PluginInstall +qall 2&> /dev/null
#vim +PluginInstall +qall 2&>/dev/null
