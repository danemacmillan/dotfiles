#!/usr/bin/env bash

##
# Compile latest weechat version for CentOS 6.x.
#
# Note that all of weechat's dependencies have been declared in ../yum, along
# with a variety of other utilities that should be installed. This script,
# therefore, assumes that weechat's dependencies are already installed.
#
# Read for build instructions:
# https://weechat.org/files/doc/stable/weechat_user.en.html#source_package
#

function build()
{
	local directory_dotfiles_packages="${HOME}/.dotfiles-packages"

	if [[ ! -d "${directory_dotfiles_packages}" ]]; then
		mkdir -pv "${directory_dotfiles_packages}"
	fi

	git clone git@github.com:weechat/weechat.git

}
