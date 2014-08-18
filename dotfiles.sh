#!/usr/bin/env bash

# Refresh dotfiles

echo -e "\e[34m;1mUpdating dotfiles."
cd ~/.dotfiles/ && git pull
source ~/.dotfiles/bootstrap.sh
