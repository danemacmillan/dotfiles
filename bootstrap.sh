#!/usr/bin/env bash

# Install
#ln -vs ~/dotfiles/.??* ~/

ln -vsfn ~/.dotfiles/.bash_profile ~/
ln -vsfn ~/.dotfiles/.bashrc ~/
ln -vsfn ~/.dotfiles/.gitignore ~/
ln -vsfn ~/.dotfiles/.tmux.conf ~/
ln -vsfn ~/.dotfiles/.nix ~/
ln -vsfn ~/.dotfiles/.osx ~/
rm -rf ~/.vim && ln -vsfn ~/.dotfiles/.vim ~/
ln -vsfn ~/.dotfiles/.vimrc ~/

# Install dependencies
ln -vsfn ~/.dotfiles/.dependencies ~/
source ~/.dependencies

# Uninstall
#find ~/ -maxdepth 2 -type l -exec rm -v "{}" \;

source ~/.bash_profile;
