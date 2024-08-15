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

##
# iCloud Disk
#
# This is a utility for generating an "iCloud Disk," which is a technique for
# leveraging iCloud Drive to store disks created on MacOS as sparse bundles,
# which are more efficient on cloud storage, as they are represented as many
# small files instead of one large one. For example, a disk that is 500GB and
# mounted to the filesystem, which then has some of its contained files modified
# would not result in a 500GB file transfer to iCloud Drive, but only the
# "bands" that represent the area of the sparse bundle that were edited.
#
# The size of a bundle can be customized. By default they are 8MB. The best
# size of a band depends on what kind of content will be stored on the disk. A
# disk that will contain many small files (tens or hundreds of thousands) will
# benefit from a larger band size, as there is a balance that needs to be found
# between having too many files in iCloud Drive, which will not handle hundreds
# of thousands of files very gracefully, especially not ones that are constantly
# changing, as in the use case of writing software, and the need to reduce the
# overall bandwidth requirements of transferring too much based on relatively
# small file edits.
#
# This utility also by default encrypts the sparse bundle.
#
# Valid values for SPARSEBUNDLE range from 2048 to 16777216 sectors (1 MB
# to 8 GB). These are the size of a sparse band (sparse-band-size), so:
#
#  - 1MB band = 2048
#  - 8MB band = 2048*8 = 16,384 (this is the 8MB default of Disk Utility)
#  - 200MB band = 2048*200 = 409,600
#  - 512MB band = 2048*512 = 1,048,576
#  - 1GB band = 2048*1000 = 2,048,000
#
# How many files at most would be uploaded to iCloud Drive in a scenario where
# the disk is 500GB and the bands are 100MB? 500,000MB/100MB = 5,000 files.
# Considering this 5000 files could realistically mean 1M+ files, that
# significantly reduces the overall strain on iCloud Drive, while still making
# it useful for development. An example from current usage: I currently
# have 1,966,783 files in an iCloud Disk that is only 464 files in iCloud Drive,
# with an disk configured as 300GB with 1GB bands; of course, bands are not the
# only files that make up a sparse bundle disk, but it is generally safe to
# say that the bands make up the majority of the file count. The main
# calculation, then, comes down to how large should the bands be and how much
# tolerance does the current Internet connection have for uploading a band for
# even the smallest change to a file; a 500Mbps connection woudl then mean that
# it can upload (500/8)=62.5MB per second. Of course, this is wildly
# inefficient, but when dealing with a highly dynamic base of files and you have
# both the iCloud storage and bandwidth available, in addition to a need to keep
# a live copy of all work in sync, this is actually a pretty decent solution.
#
# In order for this to work with iCloud Drive, the generated disk name cannot
# end with the usual ".sparsebundle" extension, as iCloud Drive will interpret
# this as a single file and thus ignore the whole benefit of having a sparse
# bundle. By simply renaming it to have another file extension, this lets iCloud
# Drive see this sparse bundle as just a bunch of gibberish files that need to
# be individually transferred. Disk Utility does not care if the disk name has
# a random other name, as it can detect what type of disk it is when attempting
# to mount it.
#
# TODO:
#  - add validation
#  - create within the ~/iCloud/Disks/ path ($ICLOUD_DIRECTORY_LONG)
#  - tie into mounting
#
# @author Dane MacMillan <work@danemacmillan.com>
icloud_disk()
{
	local command_name="icloud_disk"

	local disk_name="${1}"

	local disk_size_gb="1"
	if [[ -n "${2}" ]]; then
  	local disk_size_gb="${2}"
  fi

	local band_size_mb=$((2048 * 8))
	if [[ -n "${3}" ]]; then
		local band_size_mb=$((2048 * "${3}"))
	fi

	if [[ -n ${disk_name} ]]; then
		#hdiutil create -encryption AES-128 -type SPARSEBUNDLE -size 300g -fs "APFS" projects -imagekey sparse-band-size=2097152 -volname projects
		echo -e "Creating encrypted sparsebundle for iCloud Disk with following command:"
		local command="hdiutil create -encryption AES-128 -type SPARSEBUNDLE -size "${disk_size_gb}"g -fs "APFS" "${disk_name}" -imagekey sparse-band-size="${band_size_mb}" -volname "${disk_name}""
		echo -e "  ${GREEN}${command}${RESET}"
		${command}
		echo -e "Converting sparsebundle package to iCloud Disk directory..."
		mkdir "${disk_name}.sparsebundle.iCloudDisk"
		mv "${disk_name}.sparsebundle"/* "${disk_name}.sparsebundle.iCloudDisk"/ && rm -rf "${disk_name}.sparsebundle"
		echo -e "Created iCloud Disk: ${disk_name}.sparsebundle.iCloudDisk"
		echo -e "Mount command: hdiutil attach ${disk_name}.sparsebundle.iCloudDisk"
		echo -e "Unmount command: hdiutil detach /Volumes/${disk_name}"
	else
		echo -e "Create iCloud Disk compatible for iCloud Drive"
		echo ""
		echo -e "Usage:"
		echo -e "  ${BCYAN}${command_name}${RESET} ${GREEN}DISK_NAME DISK_SIZE_GB BAND_SIZE_MB"
		echo ""
		echo -e "${RESET}Example usages:"
		echo "  ${BCYAN}icloud_disk ${GREEN}foobar${RESET}  (create a disk named 'foobar' with a 1GB sparse bundle disk size and 8MB band size)"
		echo "  ${BCYAN}icloud_disk ${GREEN}projects 500 200${RESET}  (create a disk named 'projects' with a 500GB sparse bundle disk size and 200MB band size)"
		echo ""
		echo -e "Mounting instructions:"
		echo -e "  Mount command: hdiutil attach [DISK_NAME].sparsebundle.iCloudDisk"
		echo -e "  Unmount command: hdiutil detach /Volumes/[DISK_NAME]"
		return 1
	fi
}

# Experimental sparsebundle sync.
icloud_bundle_sync()
{
	"rsync" -aP --delete "${HOME}/projects.sparsebundle/" "${HOME}/iCloud/Disks/projects.sparsebundle.iCloudDisk"
}

icloud_disk_mount_projects()
{
	local ICLOUD_DISK_PROJECTS="${ICLOUD_DIRECTORY_LONG}/Disks/projects.sparsebundle.iCloudDisk"
	#local ICLOUD_DISK_PROJECTS="${HOME}/Disks/projects.sparsebundle.dir"

	brctl download "${ICLOUD_DISK_PROJECTS}"

	read -p "Ready to mount ${ICLOUD_DISK_PROJECTS}? Ensure it has been completely downloaded before mounting."

	echo "Compacting any unused space within sparse bundle."
	hdiutil compact "${ICLOUD_DISK_PROJECTS}" -batteryallowed

	echo "Mounting."
	hdiutil attach "${ICLOUD_DISK_PROJECTS}"
}

icloud_reset_sync()
{
	echo "Resetting iCloud's bird daemon."
	pkill bird
}

##
# Very rough function to ensure some content always local.
icloud_pin()
{
	echo "Manually ensuring given pinned directories are locally available."

	/usr/bin/brctl download "${HOME}/iCloud/danemacmillan"
	/usr/bin/brctl download "${HOME}/iCloud/dotfiles"

	/usr/bin/brctl download "${HOME}/Desktop/"
	/usr/bin/brctl download "${HOME}"/Documents/avatars/*

	/usr/bin/brctl download "${HOME}/iCloud/Disks"
	/usr/bin/brctl download "${HOME}/iCloud/Downloads"
}

##
# Figure out what is constantly syncing in iCloud Drive.
#
# For a while I noticed that iCloud Drive in Finder was always syncing. After
# watching the filesystem it was noted that it was my `dotfiles` repo whenever
# it was opened in a PhpStorm project. The IDE had a copilot plugin that was
# constantly syncing.
#
# Source: https://discussions.apple.com/thread/255157739?answerId=255157739021&sortBy=rank#255157739021
#
icloud_debug_sync()
{
	echo "This will help debug endless iCloud Drive syncing."
	echo "It is best to run this after a restart."
	echo "This will list all filesystem changes in iCloud Drive."
	echo "Use these paths to help debug what is constantly syncing."

	fswatch --event-flags ~/Library/Mobile\ Documents/
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


