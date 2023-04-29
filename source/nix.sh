# vim: ft=sh

##
# nix.sh
#
# Integrate Nix and Home Manager with dotfiles.
#
# When the relevant paths exist, Nix and Home Manager will be integrated
# with the shell.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

# Set custom environment variable to reference only the user's Nix profile path.
#
# Note that this should only be used when the path specific to the user should
# be used, otherwise reference the $NIX_PROFILES array of paths. Also, only
# set this variable when $NIX_PROFILES exists.
if [[ -n "${NIX_PROFILES}" ]] \
	&& [[ -z "${NIX_PROFILE_USER_PATH}" ]] \
; then
	export NIX_PROFILE_USER_PATH="${HOME}/.nix-profile"
else
		# Temporarily set this until the Nix integration is complete. The dotfiles have leveraged this variable in a few
		# places, so if the above condition is not true, then this variable will be retrofitted for the usual paths
		# expected by brew.
		#@TODO
		if [[ -e "/opt/homebrew/bin" ]]; then
					export NIX_PROFILE_USER_PATH="/opt/homebrew"
		elif [[ -e "/usr/local/bin" ]]; then
					export NIX_PROFILE_USER_PATH="/usr/local"
		fi
fi

# Set NIX_PATH.
#
# See https://nix-community.github.io/home-manager/index.html#ch-usage
# for original NIX_PATH value. It is a bit strange, so if duplicates appear,
# use the commented out path instead.
if [[ -z "${NIX_PATH}" ]]; then
	export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
	#export NIX_PATH="${NIX_PATH:-${HOME}/.nix-defexpr/channels}"
fi

# Set home-manager session variables.
#
# Do not let nix home-manager manage Bash, see 1.1.4:
# https://nix-community.github.io/home-manager/index.html#sec-install-standalone
if [[ -e "${NIX_PROFILE_USER_PATH}/etc/profile.d/hm-session-vars.sh" ]]; then
	source "${NIX_PROFILE_USER_PATH}/etc/profile.d/hm-session-vars.sh"
fi

# Read: https://nixos.wiki/wiki/FAQ/How_can_I_install_a_proprietary_or_unfree_package%3F
#NIXPKGS_ALLOW_UNFREE=1

# https://github.com/NixOS/nix/pull/3988
#NIX_SHELL_PRESERVE_PROMPT=1

# Packages marked as insecure or outdated can be overridden. Also see the config
# to allow specific package overrides.
#export NIXPKGS_ALLOW_INSECURE=1
