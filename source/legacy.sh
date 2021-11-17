# vim: ft=sh

##
# legacy
#
# Manage or clean up any legacy operations that these dotfiles have used and
# eventually deprecated. Everything in here can eventually be removed, and
# ultimately depends on how long the need to maintain these will exist.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

# Cleanup any legacy associations from older versions of this dotfiles repo.
echo -e "${BLUE}${BOLD}Cleaning up any legacy dotfiles data.${RESET}"
unalias dotfiles 2&>/dev/null
symlinks -d "${HOME}" 2&>/dev/null
symlinks -d "${HOME}/bin" 2&>/dev/null
[[ -d "${HOME}/.dotfiles-packages" ]] && rm -rf "${HOME}/.dotfiles-packages"
[[ -L "${HOME}/.gitconfig" ]] && unlink "${HOME}/.gitconfig"
[[ -L "${HOME}/.gitignore" ]] && unlink "${HOME}/.gitignore"
[[ -f "${HOME}/.hgrc.local" ]] && rm "${HOME}/.hgrc.local"
[[ -e "${XDG_CONFIG_HOME}/alacritty" ]] && rm -rf "${XDG_CONFIG_HOME}/alacritty"
[[ -e "${XDG_CONFIG_HOME}/htop" ]] && rm -rf "${XDG_CONFIG_HOME}/htop"
