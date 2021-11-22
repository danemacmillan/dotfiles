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

# Add Nix's share path to XDG_DATA_DIRS, which are checked by bash_completion2.
#
# Add additional path to XDG_DATA_DIRS for autocompletion provided by Nix.
# Bash completion will check the paths it finds here as well, and this is how
# Nix can manage its own completions alongside the ones provided by dotfiles.
if [[ -e "${HOME}/.nix-profile/share" ]]; then
	export XDG_DATA_DIRS="${XDG_DATA_DIRS}:${HOME}/.nix-profile/share"
fi

# Set NIX_PATH.
#
# See https://nix-community.github.io/home-manager/index.html#ch-usage
# for original NIX_PATH value. These dotfiles change it so the value is not
# duplicated.
#export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
if [[ -e "${HOME}/.nix-defexpr/channels" ]]; then
	export NIX_PATH="${NIX_PATH:-${HOME}/.nix-defexpr/channels}"
fi

# Set home-manager session variables.
#
# Do not let nix home-manager manage Bash, see 1.1.4:
# https://nix-community.github.io/home-manager/index.html#sec-install-standalone
if [[ -e "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh" ]]; then
	source "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
