#!/usr/bin/env bash


#
# External dependencies
#

# Homebrew
echo -e "${BLUE}${BOLD}Downloading external dependencies, if any.${RESET}"
# Get homebrew and some niceties.
if ! hash brew; then
	echo "${GREEN}Installing homebrew.${RESET}"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Vundle
echo -e "${GREEN}Installing Vim Vundle and plugins. This will take a few seconds.${RESET}"
#git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> /dev/null
# Install Vim plugins defined in .vimrc file.
# Depending on the location that Vundler installs a plugin, there
# may be an authentication prompt for username and password.
#vim +PluginInstall +qall 2&> /dev/null


#
# Packages
#

# Install packages from OS package manager.
DOTFILES_PACKAGES_DIR="$HOME/.packages"
case "$DOTFILES_PACKAGE_MANAGER" in
	brew)
		# Use three distinct packages for brew.
		for package_name in "tap" "brew" "cask"; do
			DOTFILES_PACKAGES_FILE="$DOTFILES_PACKAGES_DIR/$package_name"
			DOTFILES_PACKAGES_MD5_NEW=$(calculate_md5_hash "$DOTFILES_PACKAGES_FILE")

			case "$package_name" in
				tap)
					DOTFILES_PACKAGES_MD5_OLD=$DOTFILES_PACKAGES_MD5_TAP
					DOTFILES_PACKAGE_MANAGER_COMMAND="brew tap"
					DOTFILES_PACKAGE_MANAGER_COMMAND_LIST="brew tap"
					;;
				brew)
					DOTFILES_PACKAGES_MD5_OLD=$DOTFILES_PACKAGES_MD5_BREW
					DOTFILES_PACKAGE_MANAGER_COMMAND="brew install"
					DOTFILES_PACKAGE_MANAGER_COMMAND_LIST="brew list -1"
					;;
				cask)
					DOTFILES_PACKAGES_MD5_OLD=$DOTFILES_PACKAGES_MD5_CASK
					DOTFILES_PACKAGE_MANAGER_COMMAND="brew cask install"
					DOTFILES_PACKAGE_MANAGER_COMMAND_LIST="brew cask list -1"
			esac

			if [[ "$DOTFILES_PACKAGES_MD5_OLD" != "$DOTFILES_PACKAGES_MD5_NEW" ]]; then
				echo -e "${BLUE}${BOLD}Installing new ${GREEN}${REVERSE} $DOTFILES_PACKAGE_MANAGER $package_name ${RESET}${BLUE}${BOLD} packages.${RESET}"
				while read line; do
					# Note: using a hash check is insufficient, as not all packages
					# are installed as an executable CLI tool.
					if ! $DOTFILES_PACKAGE_MANAGER_COMMAND_LIST | grep -q "^${line}\$"; then
						$DOTFILES_PACKAGE_MANAGER_COMMAND $line
					fi
				done < $DOTFILES_PACKAGES_DIR/$package_name
			fi
		done
		;;

	yum)
		DOTFILES_PACKAGES_FILE="$DOTFILES_PACKAGES_DIR/$DOTFILES_PACKAGE_MANAGER"
		DOTFILES_PACKAGES_MD5_NEW=$(calculate_md5_hash "$DOTFILES_PACKAGES_FILE")
		DOTFILES_PACKAGES_MD5_OLD=$DOTFILES_PACKAGES_MD5_YUM
		DOTFILES_PACKAGE_MANAGER_COMMAND="yum -y install"
		DOTFILES_PACKAGE_MANAGER_COMMAND_LIST="yum list installed"

		if [[ "$DOTFILES_PACKAGES_MD5_OLD" != "$DOTFILES_PACKAGES_MD5_NEW" ]]; then
			echo -e "${BLUE}${BOLD}Installing new ${GREEN}${REVERSE} $DOTFILES_PACKAGE_MANAGER ${RESET}${BLUE}${BOLD} packages.${RESET}"
			while read line; do
				if ! $DOTFILES_PACKAGE_MANAGER_COMMAND_LIST $line | grep -q "^${line}\$"; then
					$DOTFILES_PACKAGE_MANAGER_COMMAND $line
				fi
			done < $DOTFILES_PACKAGES_DIR/$DOTFILES_PACKAGE_MANAGER
		fi
		;;

	apt-get)
		;;
esac

