# vim: ft=sh

##
# function
#
# Contained in this file are functions that are sourced into every new
# environment by default.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT

##
# Check if command line utility exists.
#
# This is based on discussion at:
# http://stackoverflow.com/q/592620
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
#
command_exists()
{
	command -v "$1" >/dev/null 2>&1
}

##
# Loop through base paths and attempt to source with appended path.
#
# This is useful for looping through environment variables that are arrays of
# paths, and trying each of them with the appended path, which is
# tested for existence and then sourced if the concatenated full path exists.
# Note that even a single path can be provided.
#
# The first argument should be a space- or colon-separated list of paths. This
# function will support both by appending ":" to the default $IFS, which is
# usually space,tab,newline. It will only be modified within the function, as
# it leverages the local keyword.
#
# The second argument is the relative path that will be appended to the end of
# each base path. The result that is tested and possibly sourced is the
# concatenation of both strings, being a path.
#
# Example usages:
#		source_loop "${PATH}" "relative/path/to/script.sh"
#		source_loop "${NIX_PROFILES}" "relative/path/to/script.sh" -v
#
# The second example will also echo all the successfully sourced paths
# to STDOUT, which can be captured with $(). The format is space-separated.
#
# This will return exit code of 0 if at least one path was sourced.
#
# To debug IFS:
# 	printf %s "$IFS" | od -c
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
source_loop()
{
	local base_paths="${1}"
	local append_path="${2}"
	local verbose="${3}"
	local base_path
	local sourced_paths=()
	local exit_code=1
	local IFS="$IFS:"

	if [[ -n "${base_paths}" ]] \
		&& [[ -n "${append_path}" ]] \
	; then
		for base_path in ${base_paths}; do
			if [[ -e "${base_path}/${append_path}" ]]; then
				sourced_paths+=("${base_path}/${append_path}")
				exit_code=0
				source "${base_path}/${append_path}"
			fi
		done
	fi

	if [[ -n "$verbose" ]] \
		&& [[ "$verbose" == "-v" ]] \
		&& [[ ${exit_code} == 0 ]] \
	; then
		echo "${sourced_paths[@]}"
	fi

	return $exit_code
}

##
# Return a usable timestamp for filenames.
#
# Example usage:
#  local file_name="backup.$(now).sql.gz"
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
now()
{
	echo $(date +'%Y%m%d%H%M%S-%b-%d-%a-%H%M')
	#echo $(date +\%Y\%m\%d\%H\%M\%S-\%b-\%d-\%a-\%H\%M)
}

##
# Get relative path of path against current directory, or second provided path.
#
# Solution based on combination of answers from:
# - https://stackoverflow.com/q/2564634/2973534
#
# TODO:
# - Fix differences between CentOS and MacOS resolving path. On CentOS, if
# there is a specific link name provided, this will cause the returned path to
# possibly nest one more parent dir. For example,
# `relpath "${DOTFILES_PATH}" "${HOME}/.dotfiles"` will work fine on MacOS, but
# on CentOS, it will prepend an additional `../`. Removing the ".dotfiles" link
# name will then resolve the path properly, but that means link names cannot
# be different from the target name.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
relpath()
{
	local path="${1}"
	local relativeto="${2}"

	if [[ -z "${relativeto}" ]]; then
		relativeto="${PWD}"
	fi

	if command_exists realpath; then
		realpath --relative-to="${relativeto}" "${path}"
	else
		perl -e 'use File::Spec; print File::Spec->abs2rel(@ARGV) . "\n"' "${path}" "${relativeto}"
	fi
}

##
# Create a relative symlink.
#
# This will figure out the best way to create a relative symlink, given an
# absolute path (link target) and the destination path (link name).
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
ln_relative()
{
	local target="${1}"
	local link_name="${2}"

	local testfile="${XDG_RUNTIME_DIR}/ln_relative_testfile"
	local testfile2="${XDG_RUNTIME_DIR}/ln_relative_testfile2"
	touch "${testfile}"

	if ln -sr "${testfile}" "${testfile2}" &>/dev/null; then
		ln -vsfnr "${target}" "${link_name}"
	else
		local relative_path=$(relpath "${target}" "${link_name}")
		ln -vsfn "${relative_path}" "${link_name}"
	fi

	rm -f "${testfile}" "${testfile2}" &>/dev/null
}

##
# Call process with nohup, and execute using bash, so loops can work.
#
# This runs a process in the background.
#
# In order to pass chained commands, wrap entire string in double quotation
# marks. For example:
#
# background "echo "foo" && echo "bar""
#
# Note that this works well with the jobs, fg, and bg commands, as well as
# Ctrl+Z.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
background()
{
	local commands="${@}"

	nohup bash -lc "${commands}" >> "${XDG_RUNTIME_DIR}/background.nohup.log" 2>&1 &
}

##
# Calculate MD5 hashes regardless of tool, and ensure identical output.
#
# The file contents themselves are hashed when a valid file path is provided,
# but when it is determined that the path provided is not a valid file path,
# it will be treated as a string and that string is hashed. The latter operation
# is done by piping to STDIN via the "<<<" operator.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
calculate_md5_hash()
{
	local command_name="calculate_md5_hash"
	local md5tool=md5sum
	local cut_offset=1
	local file_path="${1}"

	if [[ -z "${file_path}" ]]; then
		echo -e "Calculate the MD5 hash of a file (or string if path not found)"
		echo -e "Usage:\n  ${BCYAN}${command_name}${RESET} ${GREEN}FILEPATH|STRING"
		return 1
	fi

	# OSX comes with md5 tool by default, not md5sum.
	# If space in path, cut -d "=" -f2 | cut -d " " -f2
	#if hash md5 2>/dev/null; then
	#	local md5tool=md5
	#	local cut_offset=4
	#fi

	if [[ -e "${file_path}" ]]; then
		echo $($md5tool "${file_path}" | cut -d " " -f$cut_offset)
	else
		echo $($md5tool <<< "${file_path}" | cut -d " " -f$cut_offset)
	fi
}

##
# Remotely run commands with color TTY. If passing chained commands (&&),
# remember to put them within quotation marks.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
rr()
{
	if (( $# > 1 )); then
		local remote_server="$1"
		local remote_commands="${@:2}"
		echo -e "${BLUE}${BOLD}Running '\x1B[97;1m$remote_commands${BLUE}' on '$remote_server':${RESET}"
		ssh -qtt $remote_server "$remote_commands"
	fi
}

##
# Loop through all subdirectories and run the given command."
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
loop()
{
	if [[ -z $1 ]]; then
		echo -e "Loop through all subdirectories of the current directory and run"
		echo -e "the given commands.\n"
		echo -e "Example usage:\n"
		echo '  loop "touch notes.txt"'
		echo '  loop "git pull" "git push"'
		echo ""
		return
	fi

	for subdirectory in ./*; do
		echo -e "\n${RESET}\x1B[48;5;235m${TWIRL} \x1B[97;1mRunning commands in ${BBLUE}$subdirectory${RESET}"
		for argument in "$@"; do
			echo -e "   ${BOLT} \x1B[93m$argument${RESET}\x1B[38;5;245m"
			(cd "$subdirectory" && $argument 2>&1 | sed -e 's/^/        /')
		done
	done

	echo -e ""
}

##
# Merge all canonical branches from current directory.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
choochoo()
{
	echo -e "${BLUE}${BOLD}Running a train on this repo. Hiyoooo!${RESET}"
	git checkout develop && git pull && git checkout stage && git pull && git merge develop && git push && git checkout master && git pull && git merge stage && git push && git checkout develop && echo -e "All canonical branches merged up to master."
}

##
# Get total directory and file count.
# TODO: integrate filesizes
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
tt()
{
	CHECKDIR=.
	if [[ -n "$1" ]]; then
		CHECKDIR="$1"
	fi

	# Directory listings include "." and ".."
	DIRECTORY_PADDING=1

	DIRECTORIES="`find $CHECKDIR -maxdepth 1 -type d | wc -l`"
	DIRECTORIES_WITH_LINKS="`find $CHECKDIR -follow -maxdepth 1 -type d | wc -l`"
	DIRECTORIES_LINKS="`expr $DIRECTORIES_WITH_LINKS - $DIRECTORIES`"
	FILES="`find $CHECKDIR -maxdepth 1 -type f | wc -l`"
	FILES_WITH_LINKS="`find $CHECKDIR -follow -maxdepth 1 -type f | wc -l`"
	FILES_LINKS="`expr $FILES_WITH_LINKS - $FILES`"

	local all_directories=$(find . -type d | wc -l)
	local all_files=$(find . -type f | wc -l)

	echo "Directories at root: `expr $DIRECTORIES_WITH_LINKS - $DIRECTORY_PADDING` (`expr $DIRECTORIES_LINKS`)"
	echo "Files at root: $FILES_WITH_LINKS ($FILES_LINKS)"
	echo ""
	echo "All directories recursively: $all_directories"
	echo "All files recursively: $all_files"
}

##
# Auto-generate new SSH keys with option to provide passphrase
# Note: if you want characters like "!" in your passphrase, run like this:
# newsshkey 'Long passphrase!!!! with spaces and niceties!'
# If you just have regular characters, quoting is unnecessary.
#
# Notes
# SSH keys, a la http://blog.patshead.com/2013/09/generating-new-more-secure-ssh-keys.html
# ssh-keygen -b 4096 -f ~/.ssh/id_rsa_danemacmillan_4096_2014_08 -C danemacmillan@id_rsa_4096_2014_08
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
newsshkey()
{
	KEY_USER=${USER}
	if [[ -n $1 ]]; then
		KEY_USER="$1"
	fi

	KEY_STRENGTH="4096"
	KEY_NAME_BASE=${KEY_STRENGTH}_$(date +%Y_%m_%d_%H%M%S)
	KEY_PATH=${HOME}/.ssh/${KEY_USER}_${KEY_NAME_BASE}.id_rsa
	KEY_COMMENT="${KEY_USER}@${KEY_NAME_BASE}"

	KEY_PASSPHRASE=""
	if [[ -n "$2" ]]; then
		KEY_PASSPHRASE="$2"
	fi

	ssh-keygen -b ${KEY_STRENGTH} -f ${KEY_PATH} -C ${KEY_COMMENT} -N "${KEY_PASSPHRASE}" -m PEM

	echo -e "\nUsername:" \"${KEY_USER}\"
	echo -e "\nPassphrase:" \"${KEY_PASSPHRASE}\"
	echo -e "\nProvide this public key to your devop if required:\n"
	cat ${KEY_PATH}.pub

	# Remove passphrase from appearing in bash history, if provided.
	# Source: http://thoughtsbyclayg.blogspot.ca/2008/02/how-to-delete-last-command-from-bash.html
	if [[ -n "$1" ]]; then
		history -d $((HISTCMD-2)) && history -d $((HISTCMD-1))
	fi
}

##
# Pass a filename, with archive extension, and this will figure out the rest.
#
# Usage: archive <desiredfilename>.<extension> [ directory | filename ]
#
# For example, type "archive updates.tar.gz updatesdir" and this function will run the
# necessary commands for generating an archive with .tar.gz compression.
#
# Note: bz2 exclusively requires that you just pass bz2 as the desiredfilename
# because it cannot be output into a single file, but each file will be
# individually archived with bzip2 compression.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
#
# @TODO This is incomplete and requires more testing.
archive()
{
	case $1 in
		*bz2)       bzip2 "${@:2}" ;;
		*.gz)       gzip -c "${@:2}" > $1 ;;
		*.tar)      tar -cvf $1 "${@:2}" ;;
		*.tbz)      tar -jcvf $1 "${@:2}" ;;
		*.tbz2)     tar -jcvf $1 "${@:2}" ;;
		*.tar.bz2)  tar -jcvf $1 "${@:2}" ;;
		*.tgz)      tar -zcvf $1 "${@:2}" ;;
		*.tar.gz)   tar -zcvf $1 "${@:2}" ;;
		*.zip)      zip -r $1 "${@:2}" ;;
		*.ZIP)      zip -r $1 "${@:2}" ;;
		#*.pax)      cat $1 | pax -r ;;
		#*.pax.Z)    uncompress $1 --stdout | pax -r ;;
		#*.Z)        uncompress $1 ;;
		#*.dmg)      hdiutil mount $1 ;;
		*)          echo "'${@:2}' cannot be archived via archive()" ;;
	esac
}

##
# Get IP count of standard Web server logs (Nginx/Apache)
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
log_ips()
{
	if [[ -n $1 ]]; then
		cat $1 | awk '{print $1}' | sort -n | uniq -c | sort -nr | head -30
	fi
}

##
# Check if given user agent has access to the given URL.
#
# Example usage:
#  curl -I -H 'User-agent: Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0' https://www.canadasmotorcycle.ca
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
hasaccess()
{
	curl -I -H 'User-agent: "$1"' "$2"
}

##
# Find Firefox install on OSX, so commands can be passed to it.
#
# TODO: Perform search on different platforms. Check for existence before.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
firefox()
{
	# OSX only
	$(mdfind -onlyin /Applications/ -name firefox)/Contents/MacOS/firefox "$@"
}

##
# Load specified Firefox profile.
#
# Pass a specific profile name and it will load, whether an instance of Firefox
# is already open or not.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
firefox_profile()
{
	firefox --no-remote -P "$@"
}

##
# A better cat utility.
#
# This is for lazy people who just want to cat out documents to their terminal.
# These documents can be any kind of text document, as usual, but also any
# kind of image, assuming the `imgcat` script is available, as well as iterm2.
# Additionally, this will handle remote files over HTTP and HTTPS.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
cat2()
{
	local filepath="${1}"

	if [[ "${filepath}" == *.icloud ]] \
		&& command_exists icd \
	; then
		brctl download "${filepath}"
	fi

	case "${filepath}" in
		http:*|https:*)
			local md5hashpathstring=$(calculate_md5_hash "${filepath}")
			filepath=$(wget "${filepath}" -q -O "${HOME}/tmp/${md5hashpathstring}.tmp" && echo "${HOME}/tmp/${md5hashpathstring}.tmp")
			echo -e "Remote file temporarily stored at: ${filepath}"
		;;
	esac

	if command_exists file \
		&& command_exists imgcat \
	; then
		local filetype=$(file -b "${filepath}")

		case "${filetype}" in
			*JPEG*|*PNG*|*GIF*)
				imgcat "${filepath}"
				return 0
			;;
		esac
	fi

	if [[ -n "${filepath}" ]]; then
		$(which cat) "${filepath}"
		return 0
	else
		$(which cat) --help
	fi

	return 1
}

##
# Backup user directory files to GDrive using rclone.
#
# Backup very specific things on Dane MacMillan's machines.
#
# I do not recommend others run this.
#
# @TODO Modify this now that it is a function. This used to be an alias, hence
# the chaining.
#
# Also note that there are implicit EXCLUDES for rclone defined in .bashrc.
# For example, files with the ".icloud" extension are excluded. This was
# actually copied over in case it is ever accidentally run outside this context.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
backup()
{
	local command_name="${FUNCNAME[0]}"

  export RCLONE_VERBOSE=1
  export RCLONE_EXCLUDE="{.unionfs-fuse/,.DS_Store,.localized,.CFUserTextEncoding,Icon\\r,Thumbs.db,Desktop.ini,desktop.ini,ehthumbs.db,.Spotlight-V100,.Trashes,.cache,*.icloud,com.apple.homed.plist,com.apple.homed.notbackedup.plist}"

  date
  echo 'Syncing to iCloud Drive...'
  #rclone move ~/Library/Group\ Containers/2BUA8C4S2C.com.agilebits/Library/Application\ Support/1Password/Backups/ ~/iCloud/Archives/1password/ --transfers 10 --bwlimit 0
  #if [[ -e "~/iCloud/.home/Library/Preferences" ]]; then
	#  rclone sync ~/Library/Preferences/ ~/iCloud/.home/Library/Preferences/ --transfers 10 --bwlimit 0 --copy-links
  #fi
  #rclone sync ~/Pictures/Photo\ Booth\ Library/ ~/Documents/images/photobooth/ --transfers 10 --bwlimit 0 --checksum

  date
  echo 'Backing up to Google Drive...'
  rclone sync ~/iCloud/danemacmillan/ macmillanator:/iCloud/danemacmillan/ --transfers 5 --max-size 50000M --bwlimit 0 --progress
  rclone copy ~/iCloud/Archives/ macmillanator:/Archives/ --transfers 1 --max-size 50000M --bwlimit 0 --progress
  rclone sync ~/Desktop/ macmillanator:/Desktop/ --transfers 5 --max-size 1000M --bwlimit 0 --progress
  rclone copy ~/Documents/ macmillanator:/Documents/ --transfers 5 --max-size 50000M --bwlimit 0 --progress
  rclone sync ~/Downloads/ macmillanator:/Downloads/ --transfers 5 --max-size 1000M --bwlimit 0 --progress
  #rclone sync ~/Pictures/ macmillanator:/Pictures/ --transfers 5 --checkers 20 --checksum --bwlimit 0 --progress
  date
}

##
# Get the inode number of a file.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
get_inode_number()
{
	if [[ -n $1 ]]; then
		local path="${1}"

		if [[ -e "${path}" ]]; then
			stat -c '%i' "${path}"
		fi
	fi
}

##
# Get the number of hardlinks that point to path.
#
# This is based on how many hardlinks share the same inode.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
get_hardlink_count()
{
	if [[ -n $1 ]]; then
		local path="${1}"

		if [[ -e "${path}" ]]; then
				stat -c '%h' "${path}"
		fi
	fi
}

##
# Get the path to a file based on the inode provided.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
get_paths_from_inode_number()
{
	if [[ -n $1 ]]; then
		local inode_number="${1}"
		#readlink -f $(find . -xdev -inum "${inode_number}")
		find . -xdev -inum "${inode_number}"
	fi
}

##
# Find all hardlinks and replace them with symlinks to plexdrive mount.
#
# Steps:
#
# - deluge downloads to /content/local/tmp # and SEEDS
# - sonarr hardlinks to /content/unionfs/media/tv/[show] # /content/local/media/tv/[show]
# - [There is now 1 inode and 2 links to it]
# - rclone moves to gd:media/tv/[show] # /content/plexdrive/media/tv/[show]
# - ensure uploads are complete
# - script recursively loops through seed directory /content/local/tmp and gets inode of each file
# - find every file path that matches inode numbers in /content/
# - find equivalent path in /content/plexdrive/media
# - force replace all hardlinks with symlinks to /content/plexdrive/media/tv/[show]
#
#
# File structure for this to work:
#
# /content
#   - /local (RW) [tmp items move here on complete]
#     - /media
#       - /movies
#       - /tv
#     - /tmp
#
#   - /plexdrive (RO)
#     - /media
#       - /movies
#       - /tv
#
#   - /unionfs (fuse mount) [local + plexdrive]
#     - /media
#       - /movies
#       - /tv
#     - /tmp
#
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
seed_hardlink_with_plexdrive_symlink()
{
	local basepath="~/content"
	if [[ -d "${basepath}" ]]; then
		echo -e "Searching for files from ${basepath}/local/tmp in ${basepath}/plexdrive"

		local tmpfiles=$(find "${basepath}/local/tmp" -type f)
		OIFS="$IFS"
		IFS=$'\n'
		for tmpfile in ${tmpfiles}; do
			local tmp_filename=$(basename "${tmpfile}")
			local tmp_filepath=$(readlink -s -q -f "${tmpfile}")
			if [[ -f "${tmp_filepath}" ]] \
				&& [[ ! -L "${tmp_filepath}" ]] \
			; then

				echo -e "\nSeeking: ${tmp_filepath}"
				local plexdrive_filepath=$(readlink -s -q -f "$(find ${basepath}/plexdrive/media -maxdepth 5 -type f -iname "${tmp_filename}")")
				if [[ -f "${plexdrive_filepath}" ]]; then
					#echo "${tmp_filepath}"
					#echo "${plexdrive_filepath}"

					echo -e "${tmp_filepath} will symlink to: ${plexdrive_filepath}"
					if [[ -n "${1}" ]]; then
						ln -nsfv "${plexdrive_filepath}" "${tmp_filepath}"
					fi
				fi
			fi
		done
		IFS="$OIFS"
	fi
}

create_content_structure()
{
	mkdir -v ~/content
	chmod 770 ~/content
	chmod g+s ~/content
	setfacl -R -m d:u::rwX,d:g::rwX,d:o::--X,u::rwX,g::rwX,o::--X ~/content

	mkdir -v ~/content/local
	mkdir -v ~/content/local/media
	mkdir -v ~/content/local/tmp
	mkdir -v ~/content/plexdrive
	mkdir -v ~/content/unionfs
}

##
# Set a timezone on CentOS.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @license MIT
timezone_set_est5edt()
{
	if [[ -e /usr/share/zoneinfo/EST5EDT ]]; then
		mv /etc/localtime /etc/localtime.bak \
			&& ln -nsfv /usr/share/zoneinfo/EST5EDT /etc/localtime
	fi
}


##
# Import a MySQL dump piped through pv to get progress. Pimped.
#
# This will also gunzip a *.gz dumped file, if present. Errors will be ignored
# and printed to the terminal, so import can continue (--force).
#
# @author Dane MacMillan <work@danemacmillan.com>
# @link https://github.com/danemacmillan/dotfiles
# @license MIT
pimport()
{
	local filepath=""
	if [[ -n "$1" ]]; then
		local filepath="$1"
	fi

	local database_name=""
	if [[ -n "$2" ]]; then
		local database_name="$2"
	fi

	local username=${USER}
	if [[ -n "$3" ]]; then
		local username="$3"
	fi

	if [[ -z ${filepath} || -z ${database_name} ]]; then
		echo -e "Import a MySQL dump (*.sql|*.sql.gz) with progress."
		echo -e "Usage:\n  ${BCYAN}pimport${RESET} ${GREEN}FILEPATH DATABASE ${YELLOW}[USERNAME]${RESET}"
		return 1
	fi

	if [[ ! -f ${filepath} ]]; then
		echo -e "$filepath does not exist."
		return 1
	fi

	local now=$(date +'%Y%m%d%H%M%S-%b-%d-%a-%H%M')
	echo -e "${BBLUE}Import start: ${RESET}${WHITE}$now${RESET}"

	if [[ ${filepath} == *.gz ]]; then
		pv ${filepath} | gunzip | mysql -u${username} -p -D ${database_name} --force
	else
		pv ${filepath} | mysql -u${username} -p -D ${database_name} --force
	fi

	local now=$(date +'%Y%m%d%H%M%S-%b-%d-%a-%H%M')
	echo -e "${BBLUE}Import finish: ${RESET}${WHITE}$now${RESET}"
}

##
# Rsync copy
#
# This exists so that instead of using `scp` to copy files, you can just
# invoke `rcp` with predefined arguments that are good for transfers,
# including automatic resumption of partial uploads.
#
# Note that by default the progress of the entirety of the transfer is shown
# on one line using --info=progress2. Should you want to see the transfer
# progress of each file individually, simply make the command more verbose by
# passing the option `-v` or `-vv`, which overrides the consolidated progress.
# These options are simply passed directly to `rsync`. Read the `rsync`
# documentation to learn about available options.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @license MIT
rcp()
{
	local source=''
	if [[ -n "$1" ]]; then
		local source="$1"
	fi

	local destination=''
	if [[ -n "$2" ]]; then
		local destination="$2"
	fi

	local options=''
	if [[ -n "$3" ]]; then
		local options="$3"
	fi

	if [[ -n ${source} && -n ${destination} ]]; then
		rsync -hrltDz --info=progress2 --partial --partial-dir="${RSYNC_PARTIAL_DIR}" --exclude-from="${RSYNC_EXCLUDE_FROM}" ${options} -e ssh ${source} ${destination}
	else
		echo -e "Rsync over SSH with useful defaults selected: partial file resumption, full progress."
		echo -e "\nUsage:\n  ${BCYAN}rcp${RESET} ${GREEN}[[USER@]HOST:]SOURCE [[USER@]HOST:]DESTINATION ${YELLOW}[-RSYNC_OPTIONS]${RESET}"
		echo -e "\nExamples:"
		echo -e "\n Rsync all contents of current directory to remote (defined in ~/.ssh/config as stage) directory foo in remote home directory:\n  rcp . stage:foo/ "
		echo -e "\n Same as above, but display verbose, per-file progress of transfer:\n  rcp . stage:foo/ -vv"
		echo -e "\n Rsync all contents of foo to remote bar directory, but display verbose, per-file progress of transfer:\n  rcp foo/ stage:bar -vv"
		return 1
	fi
}

##
# Set the rclone configuration password for current session.
#
# Documentation: http://rclone.org/docs/#configuration-encryption
#
# @author Dane MacMillan <work@danemacmillan.com>
# @license MIT
function rclone_set_password()
{
	read -s RCLONE_CONFIG_PASS
	export RCLONE_CONFIG_PASS
}

##
# Toggle any rclone bandwidth limits.
#
# @author Dane MacMillan <work@danemacmillan.com>
# @license MIT
rclone_toggle_bwlimit()
{
	kill -SIGUSR2 $(pidof rclone)
}


##
# Generate customer-supplied encryption key for use with GCE instance.
# https://cloud.google.com/compute/docs/disks/customer-supplied-encryption#gcloud
gcp_generate_csek()
{
	read -sp "String:" ; [[ ${#REPLY} == 32 ]] && echo "$(echo -n "$REPLY" | base64)" || (>&2 echo -e "\nERROR:Wrong Size"; false)
}

###############################################################################
# From other authors
###############################################################################

##
# Usage: extract <file>
# Description: extracts archived files / mounts disk images
# Note: .dmg/hdiutil is Mac OS X-specific.
#
# Credit: https://github.com/holman/dotfiles
extract ()
{
	if [ -f $1 ]; then
		case $1 in
			*.tar.bz2)  tar -jxvf $1 ;;
			*.tar.gz)   tar -zxvf $1 ;;
			*.bz2)      bunzip2 $1 ;;
			*.dmg)      hdiutil mount $1 ;;
			*.gz)       gunzip $1 ;;
			*.tar)      tar -xvf $1 ;;
			*.tbz2)     tar -jxvf $1 ;;
			*.tgz)      tar -zxvf $1 ;;
			*.zip)      unzip $1 ;;
			*.ZIP)      unzip $1 ;;
			*.pax)      cat $1 | pax -r ;;
			*.pax.Z)    uncompress $1 --stdout | pax -r ;;
			*.Z)        uncompress $1 ;;
			*)          echo "'$1' cannot be extracted/mounted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

##
# Determine size of a file or total size of a directory.
#
# Credit: https://github.com/mathiasbynens/dotfiles
fs()
{
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi

	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* *;
	fi
}

##
# List open ports.
#
# Credit: https://stackoverflow.com/a/30029855/2973534
listening()
{
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}
