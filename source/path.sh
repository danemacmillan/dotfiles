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
# Note that Homebrew for Intel machines also use this.
pathmunge "/usr/local/bin"

##
# New Homebrew paths for Apple Silicon.
pathmunge "/opt/homebrew/sbin"
pathmunge "/opt/homebrew/bin"

##
# Set no-unset-safe variable boundaries.
# There could be subtle export issues evaluating Homebrew shellenv before this.
: "${MANPATH:=}"
: "${INFOPATH:=}"
# Export Homebrew environment variables, including some paths like sbin.
if [[ -z ${HOMEBREW_PREFIX} ]]; then
	command -v brew >/dev/null 2>&1 && eval "$(brew shellenv)"
fi

##
# Store package manager install path, if available.
#
# TODO:
# Rename these two custom environment variables so they are not mentioning
# "homebrew" in them. Perhaps something like "package" would be more general
# fit.
if [[ -z ${HOMEBREW_INSTALL_PATH} ]]; then
	export HOMEBREW_INSTALL_PATH="${HOMEBREW_PREFIX}"
	export HOMEBREW_FORMULA_PATH="${HOMEBREW_INSTALL_PATH}/opt"
fi

##
# On MacOS, add GNU coreutils and other GNU tools to the path, instead of
# using the BSD ones that come with the distribution. Note that this may
# cause issues with some native applications. I've not experienced it, but
# it could happen. Also, this just assumes that if the coreutils package is
# installed, so are the other ones listed inside the conditional block.
if [[ -e "${HOMEBREW_FORMULA_PATH}/coreutils" ]] ; then
	pathmunge "${HOMEBREW_FORMULA_PATH}/coreutils/libexec/gnubin"
	pathmunge "${HOMEBREW_FORMULA_PATH}/curl/bin"
	pathmunge "${HOMEBREW_FORMULA_PATH}/findutils/libexec/gnubin"
	pathmunge "${HOMEBREW_FORMULA_PATH}/gnu-getopt/libexec/gnubin"
	pathmunge "${HOMEBREW_FORMULA_PATH}/grep/libexec/gnubin"
	pathmunge "${HOMEBREW_FORMULA_PATH}/gnu-indent/libexec/gnubin"
	pathmunge "${HOMEBREW_FORMULA_PATH}/gnu-sed/libexec/gnubin"
	pathmunge "${HOMEBREW_FORMULA_PATH}/gnu-tar/libexec/gnubin"

  export MANPATH="${HOMEBREW_FORMULA_PATH}/grep/libexec/gnuman:$MANPATH"
  export MANPATH="${HOMEBREW_FORMULA_PATH}/coreutils/libexec/gnuman:$MANPATH"
fi

##
# fzf
pathmunge "${HOMEBREW_FORMULA_PATH}/fzf/bin"

##
# PHP
pathmunge "${HOMEBREW_FORMULA_PATH}/php@7.4/bin"
pathmunge "${HOMEBREW_FORMULA_PATH}/php@7.4/sbin"

##
# Python version 3.6.
pathmunge "${HOMEBREW_FORMULA_PATH}/python@3.6/bin"

##
# Pyenv
# https://github.com/pyenv/pyenv?tab=readme-ov-file#bash
export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
if command -v pyenv >/dev/null 2>&1; then
	pathmunge "$PYENV_ROOT/bin"
	eval "$(pyenv init - bash)"
fi

##
# MySQL 5.7 daemon and client binaries.
#pathmunge "${HOMEBREW_FORMULA_PATH}/mysql@5.7/bin"

# Only client for command line.
pathmunge "${HOMEBREW_FORMULA_PATH}/mysql-client/bin"
pathmunge "${HOMEBREW_FORMULA_PATH}/mysql-client@8.0/bin"

##
# Go lang binaries.
pathmunge "${HOME}/go/bin"
if [[ -d "${HOME}/go" ]]; then
	export GOPATH="${HOME}/go"
fi

##
# Ruby/RubyGems.
pathmunge "${HOMEBREW_FORMULA_PATH}/ruby/bin"
pathmunge "/usr/local/lib/ruby/gems/2.6.0/bin"
pathmunge "${XDG_DATA_HOME}/gem/bin"

##
# Rust.
pathmunge "${HOME}/.cargo/bin"

##
# Node.
pathmunge "${HOMEBREW_FORMULA_PATH}/node@8/bin"
pathmunge "${HOMEBREW_FORMULA_PATH}/node@10/bin"
pathmunge "${HOMEBREW_FORMULA_PATH}/node@16/bin"

##
# Redis
pathmunge "${HOMEBREW_FORMULA_PATH}/redis@6.2/bin"

#PostgreSQL
pathmunge "${HOMEBREW_FORMULA_PATH}/postgresql@9.6/bin"

##
# Composer global installs.
pathmunge "${HOME}/.composer/vendor/bin"
pathmunge "${XDG_CONFIG_HOME}/composer/vendor/bin"

## Google Cloud SDK: add its installed components to path.
if [[ -e "${HOMEBREW_INSTALL_PATH}/share/google-cloud-sdk/path.bash.inc" ]]; then
	source "${HOMEBREW_INSTALL_PATH}/share/google-cloud-sdk/path.bash.inc"
fi

##
# Argc completions
#
# To install:
#  cd ${XDG_LIB_HOME}
#  git clone https://github.com/sigoden/argc-completions.git
#  cd argc-completions
#  ./scripts/download-tools.sh
#  ./scripts/setup-shell.sh bash
#
export ARGC_COMPLETIONS_ROOT="${XDG_LIB_HOME}/argc-completions"
if command -v argc >/dev/null 2>&1 \
	&& [ -d "${ARGC_COMPLETIONS_ROOT}" ] \
; then
	export ARGC_COMPLETIONS_PATH="$ARGC_COMPLETIONS_ROOT/completions/macos:$ARGC_COMPLETIONS_ROOT/completions"
	export PATH="$ARGC_COMPLETIONS_ROOT/bin:$PATH"
	# To add completions for only the specified command, modify next line e.g. argc_scripts=( cargo git )
	argc_scripts=( $(ls -p -1 "$ARGC_COMPLETIONS_ROOT/completions/macos" "$ARGC_COMPLETIONS_ROOT/completions" | sed -n 's/\.sh$//p') )
	source <(argc --argc-completions bash "${argc_scripts[@]}")
fi

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
