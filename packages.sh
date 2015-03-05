#!/usr/bin/env bash
##
# packages.sh
#
# This file gets sourced by bootstrap.sh. It installs all packages found in
# the packages directory, dependent on the package management system available.


# Clone git repos before anything else.




# Install packages from OS' package manager.
DOTFILES_PACKAGES_DIR="$HOME/.packages"
case "$DOTFILES_PACKAGE_MANAGER" in
	brew)
		# brew tap
		DOTFILES_PACKAGES_CURRENT='tap'
		DOTFILES_PACKAGES_FILE="$DOTFILES_PACKAGES_DIR/$DOTFILES_PACKAGES_CURRENT"
		DOTFILES_PACKAGES_MD5_OLD=$DOTFILES_PACKAGES_MD5_TAP
		DOTFILES_PACKAGES_MD5_NEW=$(calculate_md5_hash "$DOTFILES_PACKAGES_FILE")
		if [[ "$DOTFILES_PACKAGES_MD5_OLD" != "$DOTFILES_PACKAGES_MD5_NEW" ]]; then

			echo -e "${BLUE}${BOLD}Installing new ${GREEN}${REVERSE} $DOTFILES_PACKAGE_MANAGER $DOTFILES_PACKAGES_CURRENT ${RESET}${BLUE}${BOLD} packages.${RESET}"
			while read line; do
				if ! hash $line ; then
					echo $line
				fi
			done < $DOTFILES_PACKAGES_DIR/$DOTFILES_PACKAGES_CURRENT
		fi

		# brew
		DOTFILES_PACKAGES_CURRENT=$DOTFILES_PACKAGE_MANAGER
		DOTFILES_PACKAGES_FILE="$DOTFILES_PACKAGES_DIR/$DOTFILES_PACKAGE_MANAGER"
		DOTFILES_PACKAGES_MD5_OLD=$DOTFILES_PACKAGES_MD5_BREW
		DOTFILES_PACKAGES_MD5_NEW=$(calculate_md5_hash "$DOTFILES_PACKAGES_FILE")
		if [[ "$DOTFILES_PACKAGES_MD5_OLD" != "$DOTFILES_PACKAGES_MD5_NEW" ]]; then

			echo -e "${BLUE}${BOLD}Installing new ${GREEN}${REVERSE} $DOTFILES_PACKAGE_MANAGER ${RESET}${BLUE}${BOLD} packages.${RESET}"
			while read line; do
				if ! hash $line ; then
					echo $line
				fi
			done < "$DOTFILES_PACKAGES_DIR/$DOTFILES_PACKAGE_MANAGER"
		fi

		# brew cask
		DOTFILES_PACKAGES_CURRENT='cask'
		DOTFILES_PACKAGES_FILE="$DOTFILES_PACKAGES_DIR/$DOTFILES_PACKAGES_CURRENT"
		DOTFILES_PACKAGES_MD5_OLD=$DOTFILES_PACKAGES_MD5_CASK
		DOTFILES_PACKAGES_MD5_NEW=$(calculate_md5_hash "$DOTFILES_PACKAGES_FILE")
		if [[ "$DOTFILES_PACKAGES_MD5_OLD" != "$DOTFILES_PACKAGES_MD5_NEW" ]]; then

			echo -e "${BLUE}${BOLD}Installing new ${GREEN}${REVERSE} $DOTFILES_PACKAGE_MANAGER $DOTFILES_PACKAGES_CURRENT ${RESET}${BLUE}${BOLD} packages.${RESET}"
			while read line; do
				if ! hash $line ; then
					echo $line
				fi
			done < "$DOTFILES_PACKAGES_DIR/$DOTFILES_PACKAGES_CURRENT"
		fi
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
