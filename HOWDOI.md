HOWDOI.md
=========

The purpose of this document is to write down commands or sequences of commands
that I execute just infrequently enough to always forget. This file can be
summoned by running the `how` alias provided by these dotfiles, or by simply
opening it in a text editor. Note that unless specified, these are steps for
`CentOS`, or other things I personally use, regardless of OS. Ensure the
title for each heading reads like, "How do I... Do this thing."

## Turn off line numbers and invisibles in Vim

- These dotfiles provide an `<F4>` key shortcut to toggle them.

## Find, format, mount, and auto-mount an attached disk

- `ll /dev/disk/by-id`
- `mkfs.ext4 -F -E lazy_itable_init=0,discard /dev/disk/by-id/[DISK_NAME]`
- `mkdir -p /[MNT_DIR]`
- `mount -o discard,defaults /dev/disk/by-id/[DISK_NAME] /[MNT_DIR]`
- `vi /etc/fstab`, then paste, `/dev/disk/by-id/[DISK_NAME] /[MNT_DIR] ext4 discard,defaults 1 1`

## Remount a current mount without downtime

This example remounts whatever is mounted to the root.

- `mount -o remount /`

## Resize a disk that has changed in size

- Ensure the disk is mounted and note its size: `df -h`
- `resize2fs /dev/disk/by-id/[DISK_NAME]`
- Note the new size of the mounted disk

## Mount a Google Cloud Storage bucket as disk on filesystem

Be sure to read:

- https://github.com/GoogleCloudPlatform/gcsfuse
- http://serverfault.com/a/750719

Instructions:

- `yum install fuse`
- Grab latest rpm from https://github.com/GoogleCloudPlatform/gcsfuse/releases
- `yum install https://github.com/GoogleCloudPlatform/gcsfuse/releases/download/v0.20.1/gcsfuse-0.20.1-1.x86_64.rpm`
- Regular mount: `gcsfuse -o allow_other -file-mode=777 -dir-mode=777 bucket-name /mnt/bucket-name`
- Persist mount in `/etc/fstab`: `bucket-name /mnt/bucket-name gcsfuse rw,allow_other,file_mode=777,dir_mode=777`

## Update, query, and delete kernels on CentOS

- `yum update kernel`
- `rpm -q kernel`
- Delete kernels that are not the current or latest: `yum erase kernel-2.6.32-642.3.1.el6.x86_64`

## Rsync stuff

- `rsync -hrltD --info=progress2 --exclude=catalog/product/cache --exclude=css --exclude=css_secure --exclude=js -e ssh [REMOTE_ADDR]:/media /web/sites/`
- `rsync -hrltD --info=progress2 -e ssh [REMOTE_ADDR]:/db/dev-latest.sql.gz ./`

## Generate an `RSA` key and `CSR` for an `SSL` certificate

- `openssl genrsa -out server.2048.key 2048`
- `openssl req -new -sha256 -key server.2048.key -out server.2048.csr`

### Generate a self-signed SSL certificate

- `openssl req -new -x509 -nodes -sha256 -days 3650 -key server.2048.key > server.2048.crt`

## Generate a new `SSH` keypair

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

## Safely replace a native yum package with one from another RPM

The `yum-plugin-replace` package is installed with these dotfiles.

- `yum -y replace git --replace-with git2u`

## List all versions of a yum repo from a specific repository

- `yum --enablerepo ius-archive list --showduplicates php70u-pecl-redis`

## Show yum history and get more info about an entry

- `yum history`
- `yum history info {id}`

## Index relevant Magento indexes with N98

- `date && ./n98-magerun.phar -vvv index:reindex catalog_product_attribute,catalog_product_price,catalog_url,catalog_category_flat,catalog_category_product,cataloginventory_stock,catalog_product_flat && date`

## Format a crontab

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

## Mount a remote filesystem with SSHFS on OSX

Note that if an `.ssh/config` file with a `home` rule, as in the example, does
not exist, the regular syntax will need to be used. Use `-p###` for port.

- `mkdir -p /Volumes/[MOUNT_NAME]`
- `sshfs home:/home/danemacmillan/ /Volumes/home -o auto_cache,reconnect,defer_permissions,noappledouble,negative_vncache,volname=UbuntuHome`

## Create a new group and add a new user to it

- `groupadd linus`
- `useradd -G wheel,linus -c "Dane MacMillan" danemacmillan`
- `passwd danemacmillan`
- Add group after: `usermod -a -G linus danemacmillan`
- Disable logins: `usermod -s /sbin/nologin danemacmillan`

## Change a git repository's remote URL

- `git remote set-url origin git@github.com:USERNAME/OTHERREPOSITORY.git`

## Create an email SPF record

- Example: `IN TXT "v=spf1 mx a ptr a:email.kayako.com include:_spf.google.com include:servers.mcsv.net include:spf.mandrillapp.com ~all"`
- Really good generator: [http://www.spfwizard.net/](http://www.spfwizard.net/)

## Make a directory shared among multiple users with `setgid` bit and `ACL`s

- Ensure the parent directory has the desired owners and permissions.
- Read current ACLs with `getfacl parentdir`
- Run `chmod g+s parentdir` to set `setgid` bit. This ensures all files and
directories are created with the same group owner as the parent.
- Run `setfacl -m d:u::rwX,d:g::rwX,d:o::---,u::rwX,g::rwX,o::--- parentdir` to
ensure that permissions are defined for all new files and directories based on
this ACL rule.
- Recursively remove all ACLs: `setfacl -R -b parentdir`

## Interact with Redis

Note that any changes made to a live Redis instance's config will also need to
be copied into its config file in order for it to persist after restart.

- Access to Redis CLI: `redis-cli`
- List general info once in CLI mode: `info`
- Select a DB: `select 0`
- List all keys in a DB: `keys *`
- Get configuration: `config get maxmemory`
- Set configuration maxmemory to 18GB: `config set maxmemory 18000000000`
- Set instance as slave of master: `SLAVEOF host port`
- Set instance as master again: `SLAVEOF NO ONE`
- Flush DB 0 from host: `redis-cli -h instance-name-or-ip -n 0 flushdb`

## Remotely access a fresh PMS install

https://support.plex.tv/hc/en-us/articles/200288586-Installation

- `ssh ip.address.of.server -L 8888:localhost:32400`
- `http://localhost:8888/web`

## Quickly debug a PHP problem in production that evades all logging

Place this snippet around where the problem occurs. This is not a substitute
for proper logging, but sometimes it helps when in a bind and there is no
adequate logging in place.

- `@file_put_contents('debuglive.txt', var_export($client, true), FILE_APPEND);`

## See MySQL configuration variable values

- `SHOW VARIABLES LIKE '%timeout%';`
- `SHOW VARIABLES LIKE '%size%';`

## Grant permissions in MySQL

## Manage and tune NFS

- Ensure it starts at boot: `chkconfig nfs on && service rpcbind start && service nfs start`
- Add new export as specific user and id: `/data 10.0.0.0/8(rw,sync,no_subtree_check,all_squash,anonuid=503,anongid=504)`
- Re-export NFS `/etc/exports`: `exportfs -a`
- Mount all from `/etc/fstab`: `mount -a`
- Check how many threads: 'cat /proc/fs/nfsd/threads' or `ps aux |grep nfs`
- Configure number of threads for reboot: `/etc/sysconfig/nfs` then `RPCNFSDCOUNT`
- Update number of threads without reboot: `rpc.nfsd [threads]` or edit `/proc/fs/nfsd/threads`
- Check stats: `nfsstat`

