# Dotfiles

Dotfiles that work seamlessly between OSX and NIX environments.

See the `dpm.d` directory to view what packages are installed.

## Installation

If you just built the machine and *at least* have the RSA key from the machine 
on GitHub:

If you have an SSH key installed on the destination:

`curl -sL https://raw.githubusercontent.com/danemacmillan/dotfiles/master/install | bash -`

If you do not have an SSH key installed on the destination:

`curl -sL https://raw.githubusercontent.com/danemacmillan/dotfiles/master/install | bash -s -- nossh`

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

