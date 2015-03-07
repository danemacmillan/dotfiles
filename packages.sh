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
		package_managers+=("wget")
	fi

	# Brew includes taps and casks
	if hash brew 2>/dev/null; then
		package_managers+=("brew")
	fi

	if hash rpm 2>/dev/null; then
		package_managers+=("rpm")
	fi

	if hash yum 2>/dev/null; then
		package_managers+=("yum")
	fi

	if hash apt-get 2>/dev/null; then
		package_managers+=("aptget")
	fi

	export DOTFILES_PACKAGE_MANAGERS=${package_managers[@]}
}

##
# Verify and store the MD5 hashes of all packages being used by dotfiles.
dotfiles_packages_verify()
{
	# Get packaga manager types.
	dotfiles_managers_get

	local directory_index=0
	# Loop through everything and generate relevant MD5 hashes.
	for packages_dir in ${DOTFILES_PACKAGES_DIR[@]}; do
		for package_manager in ${DOTFILES_PACKAGE_MANAGERS[@]}; do
		if [ -f "$packages_dir/$package_manager" ]; then
				# This dynamically generates variable names and assigns MD5s as array.
				export eval "DOTFILES_PACKAGES_MD5_${package_manager}_${directory_index}=$(calculate_md5_hash "$packages_dir/$package_manager")"

				# Brew handles its subpackages at the same time.
				if [[ "$package_manager" == "brew" ]]; then
					export eval "DOTFILES_PACKAGES_MD5_tap_${directory_index}=$(calculate_md5_hash "$packages_dir/tap")"
					export eval "DOTFILES_PACKAGES_MD5_cask_${directory_index}=$(calculate_md5_hash "$packages_dir/cask")"
				fi
			fi
		done
		directory_index=$((directory_index+1))
	done

	# Debug
	#echo "${!DOTFILES_*}"
}

##
# Pluggable package installer for brew/tap/cask executed by
# dotfiles_packages_installer.
# TODO: add check for user's user-defined packages in home directory.
dotfiles_packages_install_brew()
{
	local package="brew"
	local packages_dir="$1"
	local directory_index="$2"

	if [ -f $packages_dir/$package ]; then
		# Use three distinct packages for brew.
		for subpackage in "tap" "brew" "cask"; do
			local packages_file="$packages_dir/$subpackage"
			local packages_md5_new=$(calculate_md5_hash "$packages_file")
			local package_name="$package"

			if [ -f $packages_dir/$subpackage ]; then
				case "$subpackage" in
					tap)
						local packages_md5_old=$(eval echo \$DOTFILES_PACKAGES_MD5_tap_$directory_index)
						local package_manager_command="brew tap"
						local package_manager_command_list="brew tap"
						local package_name+=" $subpackage"
						;;
					brew)
						local packages_md5_old=$(eval echo \$DOTFILES_PACKAGES_MD5_brew_$directory_index)
						local package_manager_command="brew install"
						local package_manager_command_list="brew list -1"
						;;
					cask)
						local packages_md5_old=$(eval echo \$DOTFILES_PACKAGES_MD5_cask_$directory_index)
						local package_manager_command="brew cask install"
						local package_manager_command_list="brew cask list -1"
						local package_name+=" $subpackage"
						;;
				esac

				if [[ "$packages_md5_old" != "$packages_md5_new" ]]; then
					echo -e "${BLUE}${BOLD}Installing ${GREEN}${REVERSE} $package_name ${RESET}${BLUE}${BOLD} packages from $packages_dir${RESET}"
					while read line; do
						# A hash check is insufficient, as not all packages are
						# installed as an executable CLI tool. This is why check is against
						# list of packages.
						if ! $package_manager_command_list | grep -q "^${line}\$"; then
							echo -e "${GREEN}$line${RESET}"
							$package_manager_command $line
						fi
					done < $packages_dir/$subpackage
					brew cleanup 2&> /dev/null
				fi
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
	local directory_index="$2"

	if [ -f $packages_dir/$package ]; then
		local packages_file="$packages_dir/$package"
		local packages_md5_new=$(calculate_md5_hash "$packages_file")
		local packages_md5_old=$(eval echo \$DOTFILES_PACKAGES_MD5_yum_$directory_index)
		local package_manager_command="yum -y install"
		local package_manager_command_list="yum list installed"
		local package_name="$package"

		if [[ "$packages_md5_old" != "$packages_md5_new" ]]; then
			echo -e "${BLUE}${BOLD}Installing ${GREEN}${REVERSE} $package_name ${RESET}${BLUE}${BOLD} packages from $packages_dir${RESET}"
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
	# Get list of supported package manager types.
	dotfiles_managers_get

	# Always install extras first. They will contain stuff like installing
	# brew, PHP composer, and vim vundle. These are typically essential before
	# any other packages can be installed.
	dotfiles_packages_install_extras

	# Loop through hashes for each directory provided.
	local directory_index=0
	# Install packages from various defined package manager types.
	for packages_dir in ${DOTFILES_PACKAGES_DIR[@]}; do
		for package_manager in ${DOTFILES_PACKAGE_MANAGERS[@]}; do
			if [ -f $packages_dir/$package_manager ]; then
				case "$package_manager" in
					wget)
						;;

					git)
						;;

					brew)
						dotfiles_packages_install_brew "$packages_dir" $directory_index
						;;

					rpm)
						;;

					yum)
						dotfiles_packages_install_yum "$packages_dir" $directory_index
						;;

					aptget)
						;;
				esac
			fi
		done
		directory_index=$((directory_index+1))
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
