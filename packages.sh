#!/usr/bin/env bash

##
# Packages
#
# dotfiles_packageinstall is the main function that executes all the
# individual pluggable package installers.
#

# Determine paths for installing packages.
DOTFILES_PACKAGES_DIR=("$HOME/.dotfiles/.dfpackages")
if [ -d "$HOME/.dfpackages" ]; then
	DOTFILES_PACKAGES_DIR+=("$HOME/.dfpackages")
fi
export DOTFILES_PACKAGES_DIR

##
# Get list of available package manager types, which the installer will
# operate against.
dotfiles_managers_get()
{
	local package_managers=()

	if hash git 2>/dev/null; then
		package_managers+=("git")
	fi

	if hash wget 2>/dev/null; then
		package_managers+=("brew")
	fi

	if hash brew 2>/dev/null; then
		package_managers+=("brew")
	fi

	if hash yum 2>/dev/null; then
		package_managers+=("yum")
	fi

	if hash apt-get 2>/dev/null; then
		package_managers+=("apt-get")
	fi

	export DOTFILES_PACKAGER_MANAGERS=$package_managers
}

##
# Verify and store the MD5 hashes of all packages being used by dotfiles.
dotfiles_packages_verify()
{
	for packages_dir in ${DOTFILES_PACKAGES_DIR[@]}; do
		if [ -d $packages_dir ]; then
			if hash brew 2>/dev/null; then
				export DOTFILES_PACKAGES_MD5_TAP=$(calculate_md5_hash "$packages_dir/tap")
				export DOTFILES_PACKAGES_MD5_BREW=$(calculate_md5_hash "$packages_dir/$DOTFILES_PACKAGE_MANAGER")
				export DOTFILES_PACKAGES_MD5_CASK=$(calculate_md5_hash "$packages_dir/cask")
			elif hash yum 2>/dev/null; then
				export DOTFILES_PACKAGES_MD5_YUM=$(calculate_md5_hash "$packages_dir/$DOTFILES_PACKAGE_MANAGER")
			elif hash apt-get 2>/dev/null; then
				export DOTFILES_PACKAGES_MD5_APTGET=$(calculate_md5_hash "$packages_dir/$DOTFILES_PACKAGE_MANAGER")
			fi
		fi
	done
}

##
# Pluggable package installer for brew/tap/cask executed by
# dotfiles_packages_installer.
# TODO: add check for user's user-defined packages in home directory.
dotfiles_packages_install_brew()
{
	local package="brew"
	local packages_dir="$1"

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
					# A hash check is insufficient, as not all packages are
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
# Pluggable package installer for yum executed by dotfiles_packages_installer.
dotfiles_packages_install_yum()
{
	local package="yum"
	local packages_dir="$1"

	if [ -d $packages_dir ]; then
		local packages_file="$packages_dir/$subpackage"
		local packages_md5_new=$(calculate_md5_hash "$packages_file")
		local packages_md5_old=$DOTFILES_PACKAGES_MD5_YUM
		local package_manager_command="yum -y install"
		local package_manager_command_list="yum list installed"
		local package_name="$package"

		if [[ "$packages_md5_old" != "$packages_md5_new" ]]; then
			echo -e "${BLUE}${BOLD}Installing new ${GREEN}${REVERSE} $package_name ${RESET}${BLUE}${BOLD} packages.${RESET}"
			while read line; do
				# A hash check is insufficient, as not all packages are
				# installed as an executable CLI tool. This is why check is against
				# list of packages.
				if ! $package_manager_command_list | grep -q "^${line}\$"; then
					$package_manager_command $line
				fi
			done < $packages_dir/$package
			yum clean all 2&> /dev/null
		fi
}

##
# Extras are for packages that are not easily abstracted away due to their
# need for varying steps. Possibly create an extras file in .dfpackages for
# blindly running code instead of including it in packages.sh, where there
# are no hard-coded dependencies--just abstraction to handle package
# installment through the dotfiles framework.
# TODO: Add md5 checks to prevent unnecessary downloads.
dotfiles_packages_install_extras()
{
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
}

##
# Install packages from files, irregardless of OS.
#
# This function depends on the existence of package files in the `.packages`
# directory. Ensure that the name will correspond with the cases here.
dotfiles_packages_install()
{
	# Always install extras first. They will contain stuff like installing
	# brew, PHP composer, and vim vundle. These are typically essential before
	# any other packages can be installed.
	dotfiles_packages_install_extras

	# Install packages from varyious defined package managers.
	for package_manager in ${DOTFILES_PACKAGE_MANAGERS[@]}; do
		for packages_dir in ${DOTFILES_PACKAGES_DIR[@]}; do
			if [ -d $packages_dir ]; then
				case "$package_manager" in
					wget)
						;;

					git)
						;;

					brew)
						dotfiles_packages_install_brew "$packages_dir"
						;;

					yum)
						dotfiles_packages_install_yum "$packages_dir"
						;;

					apt-get)
						;;
				esac
			fi
		done
	done

}

# Install package depencencies only if install flag passed
if [[ "$1" == "--install" ]]; then
	dotfiles_packages_install
fi

# Run package verification when flag passed. .bashrc does this every time so
# that md5s of packages can be monitored.
if [[ "$1" == "--verify" ]]; then
	dotfiles_packages_verify
fi
