#!/usr/bin/env bash

# Install
echo -e "\e[34m;1mSymlinking dotfiles."
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
echo "\e[34m;1mInstalling dependencies."
ln -vsfn ~/.dotfiles/.dependencies ~/
source ~/.dependencies

# Update terminal
echo "\e[34m;1mUpdating terminal with new profile."
source ~/.bash_profile;
