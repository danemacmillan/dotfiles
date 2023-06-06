# vim: ft=sh

##
# iCloud.sh
#
# This file contains iCloud-oriented functions that ease interaction from a
# a shell. Eventually it will also contain the various environment variables
# that are defined for these dotfiles and are specific to iCloud.
#
# This is all mostly experimental until I am ready to publish something.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT


# Experimental sparsebundle sync.
icloud_bundle_sync()
{
	"rsync" -aP --delete "${HOME}/projects.sparsebundle/" "${HOME}/iCloud/Disks/projects.sparsebundle.dir"
}

icloud_disk_mount_projects()
{
	#local ICLOUD_DISK_PROJECTS="${ICLOUD_DIRECTORY_LONG}/Disks/projects.sparsebundle.dir"
	local ICLOUD_DISK_PROJECTS="${HOME}/Disks/projects.sparsebundle.dir"

	brctl download "${ICLOUD_DISK_PROJECTS}"

	read -p "Ready to mount ${ICLOUD_DISK_PROJECTS}? Ensure it has been completely downloaded before mounting."

	hdiutil attach "${ICLOUD_DISK_PROJECTS}"
}

icloud_reset_sync()
{
	echo "Resetting iCloud's bird daemon."
	pkill bird
}







#misc__icould()
#{
	#!/usr/bin/env bash

#APP_NAME="$(basename "$0")"
#dotfiles_dir="$(cd "$(dirname "$0")"; pwd)"
#dotfiles_dir="$(cd $(dirname "$(readlink "$0")"); pwd)"

#VERSION="0.0.1"

#function showUsage() {
#        echo "Usage:"
#        echo "  $APP_NAME [OPTION]... FILE..."
#}

#echo $APP_NAME
#echo $dotfiles_dir


#echo -e "${BBLUE}Will download:${RESET} ${1}"
#brctl download "${1}"
#wait
#echo "Download complete!"




#echo "abs icould"
#abs_script_dir_path

#echo "ROOTOTOTOTO:"
#echo $DOTFILES_ROOT

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

#echo "DIR: $DIR"



#export myplace="$(php -r 'echo dirname(realpath($argv[1]));' -- "${BASH_SOURCE[0]}")"
#echo $myplace



#get_absolute_root_directory_to_self


#echo $DOTFILES_PATH

#}


