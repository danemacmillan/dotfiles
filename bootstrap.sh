#!/usr/bin/env bash

# Install
#ln -vs ~/dotfiles/.??* ~/

ln -vsf ~/.dotfiles/.bash_profile ~/
ln -vsf ~/.dotfiles/.bashrc ~/
ln -vsf ~/.dotfiles/.gitignore ~/
ln -vsf ~/.dotfiles/.tmux.conf ~/
ln -vsf ~/.dotfiles/.nix ~/
ln -vsf ~/.dotfiles/.osx ~/
ln -vsf ~/.dotfiles/.vimrc ~/

# Uninstall
#find ~/ -maxdepth 2 -type l -exec rm -v "{}" \;

source ~/.bash_profile;
