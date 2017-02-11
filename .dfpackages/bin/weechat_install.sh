#!/usr/bin/env bash

##
# Clone, compile, and install WeeChat.
#
# Note that all of WeeChat's dependencies have been declared in ../yum, along
# with a variety of other utilities that should be installed. This script,
# therefore, assumes that WeeChat's dependencies are already installed.
#
# This was created and works on CentOS 6.x. It has also been tested on MacOS.
#
# Read for build instructions:
# https://weechat.org/files/doc/stable/weechat_user.en.html#source_package
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
#

# Pull in base formatting templates.
if [[ -f "${HOME}/.dotfiles/.formatting" ]]; then
	source "${HOME}/.dotfiles/.formatting"
fi

# Pull in base functions.
if [[ -f "${HOME}/.dotfiles/.functions" ]]; then
	source "${HOME}/.dotfiles/.functions"
fi

directory_dotfiles_packages="${HOME}/.dotfiles-packages"
weechat_directory="${directory_dotfiles_packages}/weechat"

weechat_version="v1.7"
if [[ -n "$1" ]]; then
	weechat_version="$1"
fi

echo -e "${BBLUE}Cloning, compiling, and installing WeeChat ${GREEN}${weechat_version}${RESET}"

if [[ ! -d "${directory_dotfiles_packages}" ]]; then
	mkdir -pv "${directory_dotfiles_packages}"
fi

rm -rf "${weechat_directory}" \
&& git clone git@github.com:weechat/weechat.git "${weechat_directory}"
cd "${weechat_directory}" \
&& git checkout "${weechat_version}" \
&& mkdir build \
&& cd build \
&& cmake .. \
&& make \
&& sudo make install \
&& echo -e "${GREEN}Weechat installed.${RESET}"
