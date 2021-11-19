# vim: ft=sh

##
# xdg_base_directory_specification
#
# Create XDG environment variables and directories.
#
# Note that this only implements the XDG Base Directory Specification from:
# - https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#
# For additional information about support, and partial support
# workarounds read:
# - https://wiki.archlinux.org/index.php/XDG_Base_Directory
#
# The xdg-user-dirs specification is not implemented, because the specified
# directories typically already exist on popular operating systems, though
# they don't typically create the corresponding $XDG_* environment variables.
# Regardless, to learn more about the xdg-user-dirs specification, read:
# - https://www.freedesktop.org/wiki/Software/xdg-user-dirs/
#
# Note that on some operating systems, namely MacOS, the $TMPDIR environment
# variable has a trailing forward slash. This is corrected in an ephemeral
# environment variable before its possible use.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/:${HOME}/.nix-profile/share}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
__tmpdir="${TMPDIR%/}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"${__tmpdir:-/tmp}/uid${UID}"}"
unset __tmpdir

[[ ! -e "${XDG_DATA_HOME}" ]] && mkdir -p "${XDG_DATA_HOME}"
[[ ! -e "${XDG_CONFIG_HOME}" ]] && mkdir -p "${XDG_CONFIG_HOME}"
[[ ! -e "${XDG_CACHE_HOME}" ]] && mkdir -p "${XDG_CACHE_HOME}"
[[ ! -e "${XDG_RUNTIME_DIR}" ]] && mkdir -p "${XDG_RUNTIME_DIR}" && chmod 700 "${XDG_RUNTIME_DIR}"

##
# Unofficial XDG, though should be part of it.
#
# References:
# - https://www.freedesktop.org/software/systemd/man/file-hierarchy.html#Home%20Directory
# - https://theos.kyriasis.com/~kyrias/basedir-spec.html
export XDG_BIN_HOME="${XDG_BIN_HOME:-${HOME}/.local/bin}"
export XDG_LIB_HOME="${XDG_LIB_HOME:-${HOME}/.local/lib}"

[[ ! -e "${XDG_BIN_HOME}" ]] && mkdir -p "${XDG_BIN_HOME}"
[[ ! -e "${XDG_LIB_HOME}" ]] && mkdir -p "${XDG_LIB_HOME}"

##
# Unofficial XDG.
#
# This a proposal from Debian to include a STATE directory, which would be
# useful for storing files such as logs.
#
# References:
# - https://wiki.debian.org/XDGBaseDirectorySpecification
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
[[ ! -e "${XDG_STATE_HOME}" ]] && mkdir -p "${XDG_STATE_HOME}"
