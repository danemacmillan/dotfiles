# Dane MacMillan's `dotfiles`

These are all the settings you will incrementally set and ultimately forget. 
`dotfiles` attempts to work seamlessly between MacOS and most GNU/Linux 
environments.

## Setup

### Install

> :warning: **Note**
>
> The installation will unforgivingly replace all the files in your home 
> directory that match the files in this repo. Back them up if you do not want 
> to lose them.

If you just built the machine and *at least* have the RSA key from the machine 
on GitHub:

If you have an SSH key installed on the destination:

`cd ~ && curl -sL https://raw.githubusercontent.com/danemacmillan/dotfiles/master/install | bash -`

If you do not have an SSH key installed on the destination:

`cd ~ && curl -sL https://raw.githubusercontent.com/danemacmillan/dotfiles/master/install | bash -s -- nossh`

### Update

Just run `dotfiles` from anywhere. It is in the `$PATH`.

## Customize

Add documentation.

## Technical Details

It is worth highlighting some of the features available in these `dotfiles`.

### :zap: XDG Base Directory Specification

The [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
is created for operating systems that do not support it by default. This is 
done by creating all the `$XDG_*` environment variables and their corresponding
directories. Strict adherence to the specification has been observed.

Tools that natively support the specification will leverage these environment
variables and directories without additional work. If the variables and
directories were already available, `dotfiles` will respect them.

##### Partial Support

A number of tools do not natively support the specification, so in some
instances `dotfiles` have modified environment variables and configurations
so that they can emulate support. For the purpose of distinction, these
tools will be referred to as having [partial](https://wiki.archlinux.org/index.php/XDG_Base_Directory#Partial)
support. This section highlights all of the tools with partial support.

###### Bash

- `.bash_history`: `export HISTFILE="${XDG_DATA_HOME}/bash/${DOTFILES_HOSTNAME}.${USER}.history"`.

###### Tmux

- TODO

###### Weechat

- TODO

### :zap: Packages

`dotfiles` include a package management-like script for handling
dependencies from a wide array of package manager types. This is what enables
it to create environments across a variety of MacOS and GNU/Linux operating 
systems. `bin/dpm` is the tool used for this. It will eventually become its own
repository.

TODO: explain how this works.

## Nods

- https://github.com/mathiasbynens/dotfiles (for many of his excellent OSX configs)
- https://github.com/kenorb/dotfiles

## Author

[Dane MacMillan](https://danemacmillan.com)

