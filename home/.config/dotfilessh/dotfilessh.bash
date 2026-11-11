#!/usr/bin/env bash
set -euo pipefail

dir="${DOTFILESSH_DIR:-${XDG_CONFIG_HOME}/dotfilessh/dotfilessh.d}"

if [[ ! -d "$dir" ]]; then
	echo "dotfilessh: directory not found: $dir" >&2
	exit 1
fi

shopt -s nullglob

entries=("$dir"/*)
if [[ ${#entries[@]} -eq 0 ]]; then
	echo "dotfilessh: no tool fragments found in: $dir" >&2
	exit 1
fi

IFS=$'\n' entries=($(printf '%s\n' "${entries[@]}" | sort))
unset IFS

for entry in "${entries[@]}"; do
	if [[ ! -r "$entry" ]]; then
		echo "dotfilessh: skipping unreadable entry: $entry" >&2
		continue
	fi

	if [[ ! -f "$entry" ]]; then
		echo "dotfilessh: skipping non-file entry: $entry" >&2
		continue
	fi

	printf '# --- begin %s ---\n' "${entry##*/}"
	cat -- "$entry"
	printf '\n# --- end %s ---\n\n' "${entry##*/}"
done
