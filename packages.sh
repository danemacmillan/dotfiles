#!/usr/bin/env bash

##
# Dotfiles package manager (DPM) - dotfiles_packages
#
# The purpose of this script is to scan the flat text files located in the
# `dotfiles_packages.d` directory and auto-install the packages listed.
#
# dotfiles_package_install is the main function that executes all the
# individual pluggable package installers.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
#
# @TODO further abstract indivual managers, as they are very similar in
# functionality. Possibly create a list of verification and install commands
# that get passed to a single function.
#

# Determine paths for installing packages.
DOTFILES_PACKAGES_DIR=("$HOME/.dotfiles/.dfpackages")
if [ -d "$HOME/.dfpackages" ]; then
	DOTFILES_PACKAGES_DIR+=("$HOME/.dfpackages")
fi
export DOTFILES_PACKAGES_DIR

# Create .dotfiles-packages directory to store various downloaded packages.
if [[ ! -d "$HOME/.dotfiles-packages" ]]; then
	mkdir "$HOME/.dotfiles-packages"
fi

##
# Get list of available package manager types.
#
# The installers will operate against this.
dotfiles_managers_get()
{
	local package_managers=()

	# Brew includes taps and casks
	if hash brew 2>/dev/null; then
		package_managers+=("brew")
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
	# Get package manager types.
	dotfiles_managers_get

	local directory_index=0
	# Loop through everything and generate relevant MD5 hashes.
	for packages_dir in ${DOTFILES_PACKAGES_DIR[@]}; do
		for package_manager in ${DOTFILES_PACKAGE_MANAGERS[@]}; do
			if [ -f "$packages_dir/$package_manager" ]; then
				# This dynamically generates variable names and assigns MD5s.
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
# Delegate the install command for each dotfiles_packages_install_* function.
#
# This abstraction provides the ability to create an override for each package
# name listed in the standard one-item-per-line package files directly under
# the `packages.d` directory. If a matching script for the package manager
# package is discovered, that script will override the default install behaviour
# of the native package manager. For example, on CentOS, the `weechat` yum
# package exists, but it is very outdated. This function will search for the
# name of the package it is about to install with the `yum` command inside of an
# optional `yum.d` directory for a script called `weechat_install`, and if
# found, will run the script instead of simply passing the `weechat` string to
# `yum -y install`. This allows for very powerful customizations, while still
# maintaining the simplicity of a basic newline-separated text file listing
# of desired packages.
#
# Note that the package name itself does not even need to exist in the native
# package manager's DB/RPM, so if some random package name like `foobarbaz` is
# passed to the simple text file list, it will check to see if a
# `foobarbaz_install` script exists for the given package manager.
dotfiles_packages_delegate_install_command()
{
	local install_string_suffix="_install"

	local package_manager="$1"
	local package_manager_command="$2"
	local package_manager_package="$3"
	local package_manager_override_directory="${HOME}/.dotfiles/.dfpackages/${package_manager}.d"
	local package_manager_package_override="${package_manager_override_directory}/${package_manager_package}${install_string_suffix}"

	if [[ -f "${package_manager_package_override}" ]]; then
		echo -e "  --> Executing install override for ${GREEN}${package_manager_package}${RESET} from '${package_manager_package_override}'"
		# Note that the script MUST be executable in order for this to work. There
		# is no point in sourcing a script and keeping it in memory when it will
		# be run infrequently. There is no desire for the script to affect the
		# running context. Executing it ensures a new process is used, and it also
		# also ensures intent.
		${package_manager_package_override}
	else
		# Install the package using standard package manager utility.
		${package_manager_command} ${package_manager_package}
	fi
}

##
# Pluggable package installer for yum executed by dotfiles_packages_installer.
dotfiles_packages_install_aptget()
{
	local package="aptget"
	local packages_dir="$1"
	local directory_index="$2"

	if [ -f $packages_dir/$package ]; then
		local packages_file="$packages_dir/$package"
		local packages_md5_new=$(calculate_md5_hash "$packages_file")
		local packages_md5_old=$(eval echo \$DOTFILES_PACKAGES_MD5_aptget_$directory_index)
		local package_manager_command="sudo apt-get install"
		local package_manager_command_list="dpkg --get-selections | grep "
		local package_name="$package"

		if [[ "$packages_md5_old" != "$packages_md5_new" ]]; then
			echo -e "${BLUE}${BOLD}Installing ${GREEN}${REVERSE} $package_name ${RESET}${BLUE}${BOLD} packages from $packages_dir${RESET}"
			while read line; do
				if [ -n "$line" ] && [[ ${line:0:1} != '#' ]] && ! $package_manager_command_list '^${line}\W' &> /dev/null ; then
					echo -e "${GREEN}${line}${RESET}"
					dotfiles_packages_delegate_install_command "$package" "$package_manager_command" "$line"
				fi
			done < $packages_dir/$package
		fi
	fi
}

##
# Pluggable package installer for brew/tap/cask executed by
# dotfiles_packages_installer.
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
						if [ -n "$line" ] && [[ ${line:0:1} != '#' ]] && ! $package_manager_command_list | grep -q "^${line}\$"; then
							echo -e "${GREEN}${line}${RESET}"
							dotfiles_packages_delegate_install_command "$subpackage" "$package_manager_command" "$line"
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
		local package_manager_command_list="rpm -q --nodigest --nosignature"
		local package_name="$package"

		if [[ "$packages_md5_old" != "$packages_md5_new" ]]; then
			echo -e "${BLUE}${BOLD}Installing ${GREEN}${REVERSE} $package_name ${RESET}${BLUE}${BOLD} packages from $packages_dir${RESET}"
			while read line; do
				if [ -n "$line" ] && [[ ${line:0:1} != '#' ]] && ! $package_manager_command_list "${line}" &> /dev/null ; then
					echo -e "${GREEN}${line}${RESET}"
					dotfiles_packages_delegate_install_command "$package" "$package_manager_command" "$line"
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
# TODO: Move this into external process. Run Git updates also.
dotfiles_packages_install_extras()
{
	echo -e "${BLUE}${BOLD}Downloading external dependencies, if any.${RESET}"

	# Get homebrew and some niceties.
	if ! hash brew 2>/dev/null && [[ $OS == 'osx' ]]; then
		echo "${GREEN}homebrew${RESET}"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# Composer
	if ! hash composer 2>/dev/null && [[ ! -f composer.phar ]]; then
		echo -e "${GREEN}composer${RESET}"
		if [ ! -f "$HOME/bin/composer" ]; then
			(cd "$HOME/bin" && curl -sS https://getcomposer.org/installer | php -- --filename=composer)
		fi
	fi

	# Vundle
	echo -e "${GREEN}Updating Vim Vundle and plugins. This will take a few seconds.${RESET}"
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> /dev/null
	# Install Vim plugins defined in .vimrc file.
	# Depending on the location that Vundler installs a plugin, there
	# may be an authentication prompt for username and password.
	vim +PluginInstall +qall 2&> /dev/null

	# Vimperator color scheme on Git: fxdevtools-dark
	# TODO turn path into variable.
	echo -e "${GREEN}Updating Vimperator theme: fxdevtools-dark.${RESET}"
	if [[ ! -d "$HOME/.dotfiles-packages/vimperator-theme-fxdevtools-dark" ]]; then
		git clone https://github.com/danemacmillan/vimperator-theme-fxdevtools-dark.git "$HOME/.dotfiles-packages/vimperator-theme-fxdevtools-dark"
	else
		(cd "$HOME/.dotfiles-packages/vimperator-theme-fxdevtools-dark" && git pull)
	fi

	if [[ -d "$HOME/.vimperator/colors" ]]; then
		ln -nsfv "$HOME/.dotfiles-packages/vimperator-theme-fxdevtools-dark/colors/fxdevtools-dark.vimp" "$HOME/.vimperator/colors/fxdevtools-dark.vimp"
	fi
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
				# TODO possibly use single installer, with modular checkers for each
				# manager type, so case is no longer needed.
				case "$package_manager" in
					brew)
						dotfiles_packages_install_brew "$packages_dir" $directory_index
						;;

					yum)
						dotfiles_packages_install_yum "$packages_dir" $directory_index
						;;

					aptget)
						dotfiles_packages_install_aptget "$packages_dir" $directory_index
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
