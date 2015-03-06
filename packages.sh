#!/usr/bin/env bash


#
# External dependencies
#

# Homebrew
echo -e "${BLUE}${BOLD}Downloading external dependencies, if any.${RESET}"
# Get homebrew and some niceties.
if ! hash brew 2>/dev/null && [[ $OS == 'osx' ]]; then
	echo "${GREEN}Installing homebrew.${RESET}"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Vundle
echo -e "${GREEN}Updating Vim Vundle and plugins. This will take a few seconds.${RESET}"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> /dev/null
# Install Vim plugins defined in .vimrc file.
# Depending on the location that Vundler installs a plugin, there
# may be an authentication prompt for username and password.
vim +PluginInstall +qall 2&> /dev/null


#
# Packages
#

##
# Pluggable package installer for brew/tap/cask executed by
# dotfiles_packages_installer.
# TODO: add check for user's user-defined packages in home directory.
dotfiles_package_installer_brew()
{
	local package="$1"
	local packages_dir="$HOME/.dotfiles/.dfpackages"

	if [ -d $packages_dir ]; then
		# Use three distinct packages for brew.
		for subpackage in "tap" "brew" "cask"; do
			local packages_file="$packages_dir/$subpackage"
			local packages_md5_new=$(calculate_md5_hash "$packages_file")
			local package_name="$package"

			case "$subpackage" in
				tap)
					local packages_md5_old=$DOTFILES_PACKAGES_MD5_TAP
					local package_manager_command="brew tap"
					local package_manager_command_list="brew tap"
					local package_name+=" $subpackage"
					;;
				brew)
					local packages_md5_old=$DOTFILES_PACKAGES_MD5_BREW
					local package_manager_command="brew install"
					local package_manager_command_list="brew list -1"
					;;
				cask)
					local packages_md5_old=$DOTFILES_PACKAGES_MD5_CASK
					local package_manager_command="brew cask install"
					local package_manager_command_list="brew cask list -1"
					local package_name+=" $subpackage"
					;;
			esac

			if [[ "$packages_md5_old" != "$packages_md5_new" ]]; then
				echo -e "${BLUE}${BOLD}Installing new ${GREEN}${REVERSE} $package_name ${RESET}${BLUE}${BOLD} packages.${RESET}"
				while read line; do
					# Ssing a hash check is insufficient, as not all packages are
					# installed as an executable CLI tool. This is why check is against
					# list of packages.
					if ! $package_manager_command_list | grep -q "^${line}\$"; then
						$package_manager_command $line
					fi
				done < $packages_dir/$subpackage
				brew cleanup 2&> /dev/null
			fi
		done
	fi
}


##
# Install packages from files, irregardless of OS.
#
# This function depends on the existence of package files in the `.packages`
# directory. Ensure that the name will correspond with the cases here.
dotfiles_package_installer()
{
	# Install packages from OS package manager.
	# TODO: configure so variable can include git, wget, rpm. This means the
	# case statement will need to be changed to individual if conditions to
	# handle multiple systems.
	case "$DOTFILES_PACKAGE_MANAGER" in
		brew)
			dotfiles_package_installer_brew "$DOTFILES_PACKAGE_MANAGER"
			;;

		# TODO: add RPM installs as well. Ensure these subpackages are available
		# before yum installer is called.
		yum)
			DOTFILES_PACKAGES_DIR="$HOME/.dotfiles/.dfpackages"
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
				yum clean all 2&> /dev/null
			fi
			;;

		apt-get)
			;;
	esac
}

# Install package depencencies.
dotfiles_package_installer
