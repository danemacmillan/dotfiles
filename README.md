# Dane MacMillan's `dotfiles`

These are all the settings you will incrementally set and ultimately forget. 
`dotfiles` attempts to work seamlessly between MacOS and most GNU/Linux 
environments.

`dotfiles` strictly adheres to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) ("XDG" or "XDG spec" or "XDG specification").
This is good for anyone who wants a *clean* `${HOME}`, especially MacOS users
who do not natively benefit from the XDG spec.

## Setup

### Install

> :warning: **Note**: The installation will unforgivingly replace all the files 
> in your home directory that match the files in this repo. Back them up if you 
> do not want to lose them.

The install command to use depends on whether the host machine's SSH key has
been [added to GitHub](https://github.com/settings/keys). If it is a new 
machine that does not have a key, or this distinction is confusing, go 
with "No."

| SSH Key on GitHub | Install Command |
| :---------------- | :-------------- |
| Yes               | `cd ~ && curl -sL https://raw.githubusercontent.com/danemacmillan/dotfiles/master/bin/__dotfiles_install \| bash -` |
| No                | `cd ~ && curl -sL https://raw.githubusercontent.com/danemacmillan/dotfiles/master/bin/__dotfiles_install \| bash -s -- nossh` |

### Update

Just run `dotfiles` from anywhere. It is in the `$PATH`.

## Customize

Add documentation.

## Technical Details

These are some features or configuration choices worth highlighting.

### :zap: XDG Base Directory Specification

The [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
is created for operating systems that do not support it by default. This is 
done by creating all the `$XDG_*` environment variables and their corresponding
directories. Strict adherence to the specification has been observed.

Tools that natively support the specification will leverage these environment
variables and directories without additional work. If the variables and
directories were already available, `dotfiles` will respect them.

Read [the source](xdg_base_directory_specification) to see how the XDG spec 
environment variables and directories are created.

##### Partial Support

A number of tools do not natively support the specification, so in those
instances `dotfiles` have modified environment variables, aliases, and 
configurations so that they can emulate support. For the purpose of distinction, 
these tools will be referred to as having [partial](https://wiki.archlinux.org/index.php/XDG_Base_Directory#Partial)
support.

To see all of the tools adhering to the XDG spec, both with official support 
and partial workarounds, look in `home/.config` and `home/.local`.

### Repository Organization

`dotfiles` is organized into a very deliberate, tidy structure.

```
dotfiles
├── /bin          -> Essential executable scripts for dotfiles. Available in $PATH.
├── /dpm          -> Dotfiles package manager ("dpm"): TODO EXPLAIN
├── /home         -> Canonical dot files that mirror ${HOME}.
│   ├── /.config  -> ${XDG_CONFIG_HOME}
│   ├── /.local   -> ${XDG_DATA_HOME}
│   └── /bin      -> Miscellaneous executable scripts. Available in $PATH.
├── /source       -> Core scripts sourced by dotfiles.
└── bootstap      -> Core bootstrap file that connects everything.
```

#### `dotfiles/home`

These are the files that contain all of the configurations for a new
environment, from all variety of tools and utilities.

The contents of this directory are what appears in a user's `${HOME}` directory.
Note that there are very few files at the root. That means that the `${HOME}`
directory itself will also be kept clean, aside from a few culprits that have 
not been able to be coerced into adhering to the XDG spec. The contents of this 
directory and its subdirectories are symlinked into `${HOME}`.

Traditionally, and by most dotfiles' standards, these files are the ones at the 
root of a repository, as they are also traditionally at the root of a user's 
`${HOME}` directory. `dotfiles` tidies things up and places them in their own 
directory, in order to serve as a clean reference to what actually symlinks 
into `${HOME}`. This is achieved because of `dotfiles`'s strict adherence to 
the XDG spec. This is the only directory that will have contents symlinked. All
other files are either sourced internally, or available in the `${PATH}`. 

### :zap: Packages (dpm)

`dotfiles` include a package management-like script for handling
dependencies from a wide array of package manager types. This is what enables
it to create environments across a variety of MacOS and GNU/Linux operating 
systems. `bin/dpm` is the tool used for this. It will eventually become its own
repository.

TODO: explain how this works.

## Local Customizations

Local customizations can be made to `dotfiles` without actually touching the
code. It generates several local config templates at `${XDG_DATA_HOME}/doftiles`.
That typically expands to `${HOME}/.local/shared/dotfiles`.

#### `${XDG_DATA_HOME}/doftiles/shell.local`

This is the second-to-last file sourced by `${HOME}/.bashrc`. Write in any local
configuration and environment changes here. 

#### `${XDG_DATA_HOME}/doftiles/${DOTFILES_HOSTNAME}.shell.local`

This is the last file sourced by `${HOME}/.bashrc`. This one is even more
specific than the previous one, as it includes the hostname of the machine. This
is useful when sharing environments across machines, and each machine requires
slight changes.

For example, my machine generates a file called `macmillanator.local.shell.local`.
I have a virtual machine that shares the same `${HOME}`, so on that machine,
`dotfiles` also generates a `vagrant.test.shell.local` file. Both of these files
co-exist, and do not interfere with each other's respective environments.
Putting all local configuration changes in `shell.local` would mean both
environments share the same changes, which is not desired.

#### `${XDG_DATA_HOME}/doftiles/gitconfig.local`

This file is included at the bottom of the global git config. It is typically
used to store personal credentials.

## Nods

- https://github.com/mathiasbynens/dotfiles (for many of his excellent OSX configs)
- https://github.com/kenorb/dotfiles

## Author

[Dane MacMillan](https://danemacmillan.com)

