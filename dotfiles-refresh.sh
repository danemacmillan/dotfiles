#!/usr/bin/env bash

# Refresh dotfiles

cd ~/.dotfiles/ && git pull
source ~/.dotfiles/bootstrap.sh
