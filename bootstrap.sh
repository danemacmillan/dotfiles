#!/usr/bin/env bash

# Install
echo -e "Symlinking dotfiles."
ln -vsfn ~/.dotfiles/.bash_profile ~/
ln -vsfn ~/.dotfiles/.bashrc ~/
ln -vsfn ~/.dotfiles/.gitignore ~/
ln -vsfn ~/.dotfiles/.tmux.conf ~/
ln -vsfn ~/.dotfiles/.nix ~/
ln -vsfn ~/.dotfiles/.osx ~/
rm -rf ~/.vim && ln -vsfn ~/.dotfiles/.vim ~/
ln -vsfn ~/.dotfiles/.vimrc ~/
ln -vsfn ~/.dotfiles/dotfiles-refresh.sh ~/


# Install dependencies
echo "Installing dependencies."
ln -vsfn ~/.dotfiles/.dependencies ~/
source ~/.dependencies

# Update terminal
echo "Updating terminal with new profile."
source ~/.bash_profile;
