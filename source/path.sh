# vim: ft=sh

##
# path
#
# Central location for defining additional paths.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

##
# Pathmunge function copied from CentOS 7, with modification.
#
# The modifications are a verification for path existence, and syntax.
pathmunge()
{
  if [[ -e "${1}" ]]; then
    case ":${PATH}:" in
      *:"${1}":*)
        ;;
      *)
        if [[ "${2}" = "after" ]] ; then
          PATH="${PATH}:${1}"
        else
          PATH="${1}:${PATH}"
        fi
    esac
  fi
}

##
# Store homebrew install path, if available.
if [[ -z ${HOMEBREW_INSTALL_PATH} ]]; then
	export HOMEBREW_INSTALL_PATH="$(command -v brew >/dev/null 2>&1 && brew --prefix)"
	export HOMEBREW_FORMULA_PATH="$([[ ! -z ${HOMEBREW_INSTALL_PATH} ]] && echo ${HOMEBREW_INSTALL_PATH}/opt)"
fi

##
# Reset base path if on MacOS, so nothing unusual finds its way into it.
#
# Note that another reason for wanting to do this is that for users of tmux,
# the PATH gets rebuilt every time, because tmux opens in login mode, which
# causes MacOS' `path_helper` function to add paths to the end of the list
# redundantly. Additionally, JetBrains' IDEs have a "Shell Integration" feature
# that disables login_shell, which causes paths to be rebuilt in another way,
# so doing this on MacOS will allow the PATH to be identical under every
# context.
#
# This essentially restores much earlier behaviour that was causing problems
# with Nix integration. The only difference now is the call to source the
# system profile right after, which allows system paths to get included.
#
# Read https://superuser.com/a/583502/496301 for more information.
#
# Note that in addition to blowing up PATH, the decision was made to modify
# how tmux starts its shell; read the first line of the tmux.conf file to see
# it being changed to ${SHELL}.
if [[ -e "/etc/profile" ]]; then
 PATH=""

 # Unset this variable so `/etc/bashrc`'s `PATH` is rebuilt every time.
 # This sequence is how Nix gets into `PATH`:
 # - source `/etc/profile`;
 # - that sources `/etc/bashrc`;
 # - that sources a Nix script to add its own `PATH` data.
 unset __ETC_PROFILE_NIX_SOURCED

 source /etc/profile
fi

##
# For whatever reason MacOS does not include this in its path, and some
# utilities that are installed via HomeBrew need it. Unfortunately, it does
# not insert itself where it should, as noted in the commented out section
# above, so as a compromise, this will just add the path to the end, which
# will make it less important, which is fine, but should still come after the
# other sbin paths.
pathmunge "/usr/local/sbin" "after"

##
# Common path, if not already included, and it exists.
pathmunge "/usr/local/bin"

##
# fzf
pathmunge "/usr/local/opt/fzf/bin"

##
# PHP 7.1, if it is installed, or 7.2.
pathmunge "/usr/local/opt/php@7.1/bin"
pathmunge "/usr/local/opt/php@7.1/sbin"
pathmunge "/usr/local/opt/php@7.2/bin"
pathmunge "/usr/local/opt/php@7.2/sbin"
pathmunge "/usr/local/opt/php@7.3/bin"
pathmunge "/usr/local/opt/php@7.3/sbin"

##
# Python version 3.6.
pathmunge "/usr/local/opt/python@3.6/bin"

##
# MySQL 5.7 daemon and client binaries.
pathmunge "/usr/local/opt/mysql@5.7/bin"

##
# Go lang binaries.
pathmunge "${HOME}/go/bin"
if [[ -d "${HOME}/go" ]]; then
	export GOPATH="${HOME}/go"
fi

##
# Ruby/RubyGems.
pathmunge "/usr/local/opt/ruby/bin"
pathmunge "/usr/local/lib/ruby/gems/2.6.0/bin"
pathmunge "${XDG_DATA_HOME}/gem/bin"

##
# Rust.
pathmunge "${HOME}/.cargo/bin"

##
# Node.
pathmunge "/usr/local/opt/node@8/bin"
pathmunge "/usr/local/opt/node@10/bin"

##
# Redis 3.2
pathmunge "/usr/local/opt/redis@3.2/bin"

#PostgreSQL
pathmunge "/usr/local/opt/postgresql@9.6/bin"

##
# Composer global installs.
pathmunge "${HOME}/.composer/vendor/bin"
pathmunge "${XDG_CONFIG_HOME}/composer/vendor/bin"

##
# Add primary dotfiles' repo's bin to path.
pathmunge "${DOTFILES_PATH}/bin"

##
# Add user bins.
#
# These should always be last, as they should be able to overwrite everything.
pathmunge "${XDG_BIN_HOME}"
pathmunge "${HOME}/bin"

##
# EXPORT PATH TO ENVIRONMENT.
export PATH
# Do not unset, so the function is still available.
#unset -f pathmunge
