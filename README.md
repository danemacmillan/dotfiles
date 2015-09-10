# Dotfiles

Dotfiles that work seamlessly between OSX and NIX environments.

See the `.packages` directory to view what packages are installed.

## Installation

If you have an SSH key installed on the destination:

`cd ~ && git clone git@github.com:danemacmillan/dotfiles.git .dotfiles && cd .dotfiles && source dotfiles`

If you do not have an SSH key installed on the destination:

`cd ~ && git clone https://github.com/danemacmillan/dotfiles.git .dotfiles && cd .dotfiles && source dotfiles`

### Notes

The installation will unforgivingly replace all the files in your home directory that match the files in this repo. Back them up if you do not want to lose them.

## Updating

Just run `dotfiles` from anywhere.

## Packages

These dotfiles include a package management-like script for handling
dependencies from a wide array of package manager types. This is what enables
these dotfiles to create environments across a variety of Unix/Linux platforms.

TODO: explain how these work.

## Nods

- https://github.com/mathiasbynens/dotfiles (for many of his excellent OSX configs)
- https://github.com/kenorb/dotfiles

## Author

[Dane MacMillan](https://danemacmillan.com)

