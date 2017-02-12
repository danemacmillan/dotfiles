#!/usr/bin/env bash

##
# Download, compile, and install latest version of tmux.
#
# Note that all of the dependencies have been declared in ../yum, along
# with a variety of other utilities that should be installed. This script,
# therefore, assumes that its dependencies are already installed.
#
# This was created and works on CentOS 6.x.
#
# Read for build instructions:
# - https://github.com/tmux/tmux
# - https://gist.github.com/rothgar/cecfbd74597cc35a6018#gistcomment-1801422
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
if [[ ! -d "${directory_dotfiles_packages}" ]]; then
	mkdir -pv "${directory_dotfiles_packages}"
fi

name="tmux"
version="2.3"
if [[ -n "$1" ]]; then
	version="$1"
fi

echo -e "${BBLUE}Downloading, compiling, and installing ${name} ${GREEN}${version}${RESET}"
cd "${directory_dotfiles_packages}" \
&& wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz \
&& tar -xf libevent-2.1.8-stable.tar.gz \
&& cd libevent-2.1.8-stable \
&& ./configure --prefix=/usr/local \
&& make \
&& sudo make install \
&& cd "${directory_dotfiles_packages}" \
&& wget "https://github.com/tmux/tmux/releases/download/${version}/tmux-${version}.tar.gz" \
&& tar -xf "tmux-${version}.tar.gz" \
&& cd "tmux-${version}" \
&& LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local \
&& make \
&& sudo make install \
&& echo -e "${GREEN}${name} installed.${RESET}"
