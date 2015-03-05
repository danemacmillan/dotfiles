#!/usr/bin/env bash

# Refresh dotfiles

echo -e "${BBLUE}Updating dotfiles.${RESET}${GREEN}"
cd ~/.dotfiles/ && git pull && cd -
source ~/.dotfiles/bootstrap.sh
