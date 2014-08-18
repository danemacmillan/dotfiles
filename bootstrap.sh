#!/usr/bin/env bash

# Install
echo -e "\x1B[34;1mSymlinking dotfiles.\x1B[0m"
ln -vsfn ~/.dotfiles/.bash_profile ~/
ln -vsfn ~/.dotfiles/.bashrc ~/
ln -vsfn ~/.dotfiles/.gitignore ~/
ln -vsfn ~/.dotfiles/.tmux.conf ~/
ln -vsfn ~/.dotfiles/.nix ~/
ln -vsfn ~/.dotfiles/.osx ~/
rm -rf ~/.vim && ln -vsfn ~/.dotfiles/.vim ~/
ln -vsfn ~/.dotfiles/.vimrc ~/
ln -vsfn ~/.dotfiles/dotfiles.sh ~/


# Install dependencies
echo "\x1B[34;1mInstalling dependencies.\x1B[0m"
ln -vsfn ~/.dotfiles/.dependencies ~/
source ~/.dependencies

# Update terminal
echo "\x1B[34;1mUpdating terminal with new profile.\x1B[0m"
source ~/.bash_profile;
