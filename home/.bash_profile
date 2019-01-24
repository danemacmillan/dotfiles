# vim: ft=sh

if [[ -f "${HOME}/.bashrc" ]]; then
	source "${HOME}/.bashrc"
fi

__bash_logout() {
    [[ -e "${HOME}/.bash_logout" ]] && source "${HOME}/.bash_logout"
}

trap __bash_logout EXIT
