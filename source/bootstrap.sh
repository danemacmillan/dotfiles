# vim: ft=sh

##
# bootstrap
#
# The purpose of this script is to bootstrap these dotfiles by providing
# essential dependencies used throughout these dotfiles for building scripts.
# This makes it easier to develop new scripts, as there is only one file that
# needs to be sourced to gain a tonne of functionality.
#
# This is also the main file that contains essential environment variables that
# all other scripts will source in.
#
# Note that the $DOTFILES_PATH environment variable is very important, and is
# the first thing determined.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

# This should only be defined once. This script being sourced from other places,
# so this ensures no extraneous calls.
if [[ -z ${DOTFILES_PATH} ]]; then
	##
	# Get the absolute root directory path to the current script.
	#
	# Note that if MacOS had coreutils' `readlink -f` option available by default,
	# this would be reduced to:
	#
	#  export DOTFILES_ROOT=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
	#
	# Nevertheless, it does not, and the DOTFILES_PATH environment variable needs to
	# be available to everything else before files can begin getting sourced.
	#
	# I also have an alternative that will work on MacOS by default, because PHP is
	# installed by default, but this does not guarantee it will work on other
	# operating systems by default:
	#
	#  export SOURCE_DIRECTORY="$(php -r 'echo dirname(realpath($argv[1]));' -- "${BASH_SOURCE[0]}")"
	#
	# This cannot be placed in `.functions` because that depends on `.path`, and
	#
	# The original solution that this function is based on:
	#
	#   https://stackoverflow.com/a/246128/2973534
	#
	# @author Dane MacMillan <work@danemacmillan.com>
	# @link https://github.com/danemacmillan/dotfiles
	# @license MIT
	get_absolute_root_directory_from_path()
	{
		local DIR=''

		# If no value provided, the source path is the current script.
		local SOURCE="${BASH_SOURCE[0]}"
		if [[ -n "${1}" ]]; then
			SOURCE="${1}"
		fi

		# Resolve $SOURCE until the file is no longer a symlink.
		while [ -h "$SOURCE" ]; do
			DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
			SOURCE="$(readlink "$SOURCE")"
			# If $SOURCE was a relative symlink, we need to resolve it relative to the
			# path where the symlink file was located.
			[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
		done
		DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

		echo $DIR
	}

	# Assign self-discovered dotfiles path that will be used for everything.
	# This will allow dotfiles to be installed anywhere and always know how to
	# reference its install path.
	export DOTFILES_PATH="$(dirname "$(get_absolute_root_directory_from_path)")"

	# Provide environment variable to be able to quickly source this file itself.
	export DOTFILES_BOOTSTRAP_FILE="${DOTFILES_PATH}/source/$(basename "${BASH_SOURCE[0]}")"

	# Initialize XDG standard in environment.
	if [[ -e "${DOTFILES_PATH}/source/xdg_base_directory_specification.sh" ]]; then
		source "${DOTFILES_PATH}/source/xdg_base_directory_specification.sh"
	fi

	# Assign dotfiles' DPM install directory.
	export DPM_INSTALL_DIRECTORY="${XDG_RUNTIME_DIR}"

	# Get consistent hostname.
	export DOTFILES_HOSTNAME=$(hostname -f)

	# Change path for storing bash history.
	export DOTFILES_BASH_HISTORY_PATH="${XDG_DATA_HOME}/bash/${DOTFILES_HOSTNAME}.${USER}.history"

	# Old version used all domain information in hostname, and new version
	# does not. If the old, full version does not exist, use the new short
	# version. This will allow the user to upgrade when they want.
	if [[ ! -e "${DOTFILES_BASH_HISTORY_PATH}" ]]; then
		export DOTFILES_HOSTNAME=$(hostname -s)
		export DOTFILES_BASH_HISTORY_PATH="${XDG_DATA_HOME}/bash/${DOTFILES_HOSTNAME}.${USER}.history"
	fi

	# This is where all local configs are stored.
	export DOTFILES_LOCAL_CONFIGS_PATH="${XDG_DATA_HOME}/dotfiles"

  # Set up basic iCloud variables for supported systems.
  if [[ -e "${HOME}/Library/Mobile Documents/com~apple~CloudDocs" ]]; then
		export ICLOUD_DIRECTORY_LONG="${HOME}/Library/Mobile Documents/com~apple~CloudDocs"
		export ICLOUD_DIRECTORY_SHORT="${HOME}/iCloud"
		export ICLOUD_USER_HOME="${ICLOUD_DIRECTORY_LONG}/${USER}"
  fi

	# Detect OS so dotfiles seamlessly work across OSX and Linux.
	# I only use OSX and CentOS, so additional cases will need
	# to be defined for another OS.
	export OS=$(uname | awk '{print tolower($0)}')
	case $OS in
		darwin*)
			OS='osx';;
		linux*)
			OS='nix';;
	esac
fi

# Update PATH.
if [[ -e "${DOTFILES_PATH}/source/path.sh" ]]; then
	source "${DOTFILES_PATH}/source/path.sh"
fi

# Pull in base formatting templates.
if [[ -f "${DOTFILES_PATH}/source/ui_ux.sh" ]]; then
	if tty -s ; then
		source "${DOTFILES_PATH}/source/ui_ux.sh"
	fi
fi

# Pull in base functions.
if [[ -f "${DOTFILES_PATH}/source/function.sh" ]]; then
	source "${DOTFILES_PATH}/source/function.sh"
fi

# Pull in iCloud shell functionality.
if [[ -f "${DOTFILES_PATH}/source/icloud.sh" ]]; then
	source "${DOTFILES_PATH}/source/icloud.sh"
fi

##
# Nix.
if [[ -e "${DOTFILES_PATH}/source/nix.sh" ]]; then
	source "${DOTFILES_PATH}/source/nix.sh"
fi

# Create symlink from dotfiles install path into home directory.
#
# This will not occur if the .dotfiles directory itself has been cloned to
# this path, or already exists. This is only for clones to alternative locations, so that it
# is quicker to access, as the HOME directory is a popular location for them.
#
# Note that this is also necessary so that the .bashrc file can include this
# file itself. This is related to the problem of determining the DOTFILES_PATH
# variable in as clean a way as possible, without symlinking unnecessarily.
if [[ ! -e "${HOME}/.dotfiles" ]] \
	&& [[ ! -e "${ICLOUD_DIRECTORY_SHORT}/dotfiles" ]] \
; then
	ln_relative "${DOTFILES_PATH}" "${HOME}/.dotfiles"
fi
