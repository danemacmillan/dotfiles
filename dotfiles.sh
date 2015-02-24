#!/usr/bin/env bash

# Refresh dotfiles

echo -e "${BBLUE}Updating dotfiles.${RESET}"
cd ~/.dotfiles/ && git pull && cd -
source ~/.dotfiles/bootstrap.sh
