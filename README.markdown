# Puppet pe_backup Module

[![Build Status](https://travis-ci.org/fvoges/puppet-pe_backup.svg)](https://travis-ci.org/fvoges/puppet-pe_backup)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What pe_backup affects](#what-pe_backup-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pe_backup](#beginning-with-pe_backup)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

`pe_backup` is a minimal implementation of a Puppet Enterprise backup. It only takes a backup of the directories recommended by the [documentation](https://docs.puppet.com/pe/latest/maintain_backup_restore.html).

This module doesn't backup the databases, you might want to check [npwalker/pe_databases](https://forge.puppet.com/npwalker/pe_databases) for that.

## Module Description

The module manages two resources, a backup script and a cron job to run the script.

This release doesn't include a restore script. To do a restore, just follow the instructions from the [documentation](https://docs.puppet.com/pe/latest/maintain_backup_restore.html).

## Setup

### What pe_backup affects

Using the default settings, `pe_backup` will install a backup script `/usr/local/bin/pe_backup.sh` and add a cron job to run that script every day at 3:33am.


### Beginning with pe_backup


The module should work without changing any of the default parameters and only requires specifying the destination for the backup using the `destination`parameter.

**NOTE**: the module expects the destination directory to exist. It will not try to create it. It's better to manage that from a profile instead of trying to work out all the possible cases inside this module.


## Usage

### Getting started

The basic use case requires passing the destination directory to the `pe_backup` class:

```puppet
class { 'pe_backup':
  destination => '/vol/backups/pe_backups',
}
```

The first time that that code is applied to a node, it will create the backup script `/urs/local/bin/pe_backup.sh` and a cron job for the `root` user to run it every day at 3:33am.

The backups will be stored in the location specified with the `destination` parameter using the naming `pe_backup-YYYYMMDDHHMM.tar.bz2`. Where `pe_backup` is the default prefix and `YYYYMMDDHHMM` is the current time stamp at the time the script was executed.

### Specify a file name prefix for the backup

By default, the backups created will use the default prefix (`pe_backup`). The prefix can be altered to use something else by specifying the `prefix` parameter.

The following example uses the [trusted fact](https://docs.puppet.com/puppet/4.10/lang_facts_and_builtin_vars.html#trusted-facts) `certname` as the file prefix.

```puppet
class { '::pe_backup':
  destination => $destination,
  prefix      => $::trusted['certname'],
}
```

### Specify extra directory to backup

Example profile working together with [npwalker/pe_databases](https://forge.puppet.com/npwalker/pe_databases).

This example uses the

```puppet
# Profile profile::puppet::backup
class profile::puppet::backup {
  $destination = hiera('profile::puppet::backup::destination')

  include ::pe_databases::backup

  file { $destination:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

  class { '::pe_backup':
    destination => $destination,
    prefix      => $::trusted['certname'],
    # include the database dumps fron pe_databases::backup too
    dirs_extra  => [ $pe_databases::backup::backup_directory, ],
  }
}
```


## Reference

### Classes

### Public Classes

  * [`pe_backup`](#pe_backup): Installs and configures the PE backup script

### Private Classes

  * [`pe_backup::install`](#pe_backup__install): Installs the script
  * [`pe_backup::service`](#pe_backup__service): Manages the cronjob

### Parameters

#### pe_backup

##### `destination` (`Stdlib::Absolutepath`)

Destination directory for the backups.

Valid values are any valid UNIX absolute path.

Mandatory.

##### `user` (`String`)

Backup script owner user.

Defaults to `root`.

##### `group` (`String`)

Backup script owner group.

Defaults to `root`.

##### `umask` (`String`)

Sets the `umask` inside the backup script.

Defaults to `0077`.

##### `prefix` (`String`)

Backup file name prefix.

Defaults to `pe_backup`.

##### `script` (`Stdlib::Absolutepath`)

Backup script name including absolute path.

Valid values are any valid UNIX absolute path including file name.

Defaults to `/usr/local/bin/pe_backup.sh`.

##### `hour` (`String`)

Crontab hour for the backup.

Valid values are the ones for the [cron type](https://docs.puppet.com/puppet/latest/type.html#cron).

Defaults to `3`.

##### `minute` (`String`)

Crontab minute for the backup.

Valid values are the ones for the [cron type](https://docs.puppet.com/puppet/latest/type.html#cron).

Defaults to `33`.

##### `weekday` (`String`)

Crontab weekday for the backup.

Valid values are the ones for the [cron type](https://docs.puppet.com/puppet/latest/type.html#cron).

Defaults to `*` (everyday).


##### `nodetype` (`Enum`)

Puppet node type. Allows to customize the backed up directories based for different types of Puppet servers (Master, PuppetDB, Console, etc.).

Valid values are `monolithic`, `master`, `db`, or `console`.

Defaults to `monolithic`.

##### `dirs_common` (`Array`)

List of directories that need to be backed up on all node types. This shouldn't need changing in most cases.

Valid values are any `Array` containing a list of absolute paths. Use `dirs_extra` to specify additional directories.

Defaults to '/etc/puppetlabs'.

##### `dirs_master` (`Array`)

List of directories that need to be backed up on a Puppet Master node. This shouldn't need changing in most cases. Use `dirs_extra` to specify additional directories.

Valid values are any `Array` containing a list of absolute paths.

Defaults to `[]` (empty array).

##### `dirs_db` (`Array`)

List of directories that need to be backed up on a PuppetDB node. This shouldn't need changing in most cases. Use `dirs_extra` to specify additional directories.

Valid values are any `Array` containing a list of absolute paths.

Defaults to `[ '/opt/puppetlabs/server/data/postgresql/9.4/data/certs', ]`.

##### `dirs_console` (`Array`)

List of directories that need to be backed up on a Puppet Console node. This shouldn't need changing in most cases. Use `dirs_extra` to specify additional directories.

Valid values are any `Array` containing a list of absolute paths.

Defaults to `[ '/opt/puppetlabs/server/data/console-services/certs', ]`.

##### `dirs_extra` (`Array`)

List of additional directories that need to be backed up on a node. Most likely to be used to backup the database dumps.

Valid values are any `Array` containing a list of absolute paths.

Defaults to `[]` (empty array).

## Limitations

  * No restore functionality yet.
    * Work around: Use the manual steps from the [documentation](https://docs.puppet.com/pe/latest/maintain_backup_restore.html)
  * No ability to set the backup retention policy. yet.
    * Work around: Use a cron job to delete the old backups.
  * The script doesn't check to see if another backup is in progress.

## Development

Feel free to send bug reports and pull requests to the project page.

