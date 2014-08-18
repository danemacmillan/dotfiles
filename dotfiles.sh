#!/usr/bin/env bash

# Refresh dotfiles

echo -e "\x1B[34;1mUpdating dotfiles.\x1B[0m"
cd ~/.dotfiles/ && git pull
source ~/.dotfiles/bootstrap.sh
