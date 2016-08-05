HOWDOI
======

The purpose of this document is to write down commands or sequences of commands
that I execute just infrequently enough to always forget. This file can be
summoned by running the `how` command provided by these dotfiles, or by simply
opening it in a text editor. Note that unless specified, these are steps for
`CentOS`, or other things I personally use, regardless of OS. Ensure the
title for each heading reads like, "How do I... Do this thing."

# Turn off line numbers and invisibles in Vim

- These dotfiles provide an `<F4>` key shortcut to toggle them.

# Find, format, mount, and auto-mount an attached disk

- `ll /dev/disk/by-id`
- `mkfs.ext4 -F -E lazy_itable_init=0,discard /dev/disk/by-id/[DISK_NAME]`
- `mkdir -p /[MNT_DIR]`
- `mount -o discard,defaults /dev/disk/by-id/[DISK_NAME] /[MNT_DIR]`
- `vi /etc/fstab`, then paste, `/dev/disk/by-id/[DISK_NAME] /[MNT_DIR] ext4 discard,defaults 1 1`

# Resize a disk that has changed in size

- Ensure the disk is mounted and note its size: `df -h`
- `resize2fs /dev/disk/by-id/[DISK_NAME]`
- Note the new size of the mounted disk

# Rsync stuff

- `rsync -hrltD --info=progress2 --exclude=catalog/product/cache --exclude=css --exclude=css_secure --exclude=js -e ssh [REMOTE_ADDR]:/media /web/sites/`
- `rsync -hrltD --info=progress2 -e ssh [REMOTE_ADDR]:/db/dev-latest.sql.gz ./`

# Generate an `RSA` key and `CSR` for an `SSL` certificate

- `openssl genrsa -out server.2048.key 2048`
- `openssl req -new -sha256 -key server.2048.key -out server.2048.csr`

# Generate a new `SSH` keypair

Note that it's probably best to just keep the filename as `id_rsa`, unless
you also want to manage a bunch of special `.ssh/config` entries that
explicitly reference the custom path. A nice solution would be to just use the
`newsshkey` function, then symlink its generated keys to `id_rsa` and
`id_rsa.pub`.

It's always good to use your username in the comment, as some automation
systems read that and generate a user based on it. Adding the bit strength
(4096) and generation date are a good way of noting the type of key and when
it was generated. Do not use old keys.

- Custom dotfiles function: `newsshkey` or `newsshkey [username]`
- Manually: `ssh-keygen -b 4096 -f ~/.ssh/[username].id_rsa -C "[username]@4096_$(date +%Y_%m_%d_%H%M%S)"`

# Safely replace a native yum package with one from another RPM

The `yum-plugin-replace` package is installed with these dotfiles.

- `yum -y replace git --replace-with git2u`

# Index relevant Magento indexes with N98

- `date && ./n98-magerun.phar -vvv index:reindex catalog_product_attribute,catalog_product_price,catalog_url,catalog_category_flat,catalog_category_product,cataloginventory_stock,catalog_product_flat && date`

# Format a crontab

```
SHELL=/bin/bash
PATH=$HOME:$HOME/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
MAILTO="[EMAIL]"
MAILFROM="[EMAIL]"

LWEBROOT="/[PATH]"

# Minute  Hour    DayMnth  Month        DayWeek      Command                   #
# (0-59)  (0-23)  (1-31)   ([jan]1-12)  ([sun]0-6)                             #
#-------  ------  -------  -----------  -----------  --------------------------#
08        20      *        *            *            date && cd $LWEBROOT && ./n98-magerun -vvv index:reindex cataloginventory_stock,catalog_product_attribute,catalog_product_price && date
08        20      *        *            *            date && cd $LWEBROOT && ./n98-magerun -vvv index:reindex catalog_category_flat && date
08        20      *        *            *            date && cd $LWEBROOT && ./n98-magerun -vvv index:reindex catalog_category_product && date
08        20      *        *            *            date && cd $LWEBROOT && ./n98-magerun -vvv index:reindex catalog_url && date
08        20      *        *            *            date && cd $LWEBROOT && ./n98-magerun -vvv index:reindex catalog_product_flat && date
```

# Mount a remote filesystem with SSHFS on OSX

Note that if an `.ssh/config` file with a `home` rule, as in the example, does
not exist, the regular syntax will need to be used. Use `-p###` for port.

- `mkdir -p /Volumes/[MOUNT_NAME]`
- `sshfs home:/home/danemacmillan/ /Volumes/home -o auto_cache,reconnect,defer_permissions,noappledouble,negative_vncache,volname=UbuntuHome`

# Create a new group and add a new user to it

- `groupadd linus`
- `useradd -G wheel,linus -c "Dane MacMillan" danemacmillan`
- `passwd danemacmillan`
- Add group after: `usermod -a -G linus danemacmillan`

