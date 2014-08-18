# Dotfiles

Dotfiles that work seamlessly between OSX and NIX environments.

This is the first iteration. It is messy.

## Installation

If you have an SSH key installed on the destination:

`git clone git@github.com:danemacmillan/dotfiles.git .dotfiles && cd .dotfiles && source bootstrap.sh`

If you do not have an SSH key installed on the destination:

`git clone https://github.com/danemacmillan/dotfiles.git .dotfiles && cd .dotfiles && source bootstrap.sh`

### Notes

The installation will unforgivingly replace all the files in your home directory that match the files in this repo. Back them up if you do not want to lose them.

## Updating

`source ~/dotfiles.sh`

## TODO

- Standardize file formatting.
- Include package management.
- Abstract package management between OSX and Nix.

## Nods

- https://github.com/mathiasbynens/dotfiles
- https://github.com/kenorb/dotfiles

## Author

[Dane MacMillan](https://danemacmillan.com)

