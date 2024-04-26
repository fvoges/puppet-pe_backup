# Puppet pe_backup Module

![Build status](https://github.com/fvoges/puppet-pe_backup/actions/workflows/nightly.yaml/badge.svg)

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

`pe_backup` is a wrapper around Puppet's `puppet backup` command, using a script that also backs up the keys not included in the built-in backups.

This module also configures a cron job to run the backup script every day at a specified time.

It can also encrypt backups using GPG. This is **highly recommended** for production environments.

## Module Description

The module manages two resources, a backup script and a cron job to run the script.

This release doesn't include a restore script. To do a restore, just follow the instructions from the [documentation](https://www.puppet.com/docs/pe/latest/backing_up_and_restoring_pe.html#restore_pe_infrastructure). Make sure that you also restore the keys.

## Setup

### What pe_backup affects

Using the default settings, `pe_backup` will install a backup script `/usr/local/bin/pe_backup.sh` and add a cron job to run that script every day at 3:33am.


### Beginning with pe_backup


The module should work without changing any of the default parameters and only requires specifying the destination for the backup using the `destination` parameter.

> **NOTE**: the module expects the destination directory to exist. It will not try to create it. It's better to manage that from a profile instead of trying to work out all the possible cases inside this module.

## Usage

### Getting started

The basic use case requires passing the destination directory to the `pe_backup` class:

```puppet
class { 'pe_backup':
  destination => '/vol/backups/pe_backups',
}
```

The first time that that code is applied to a node, it will create the backup script `/urs/local/bin/pe_backup.sh` and a cron job for the `root` user to run it every day at 3:33am.

The backups will be stored in the location specified with the `destination` parameter using the naming `pe_backup-YYYY-MM-DD_HH.MM_Z.tar.bz2`. Where `pe_backup` is the default prefix and `YYYY-MM-DD_HH.MM_Z` is the current time stamp at the time the script was executed.

## Reference

See [REFERENCE.md](https://github.com/fvoges/puppet-pe_backup/blob/main/REFERENCE.md) for the full reference.

## Limitations

  - This release doesn't include a restore script. To do a restore, just follow the instructions from the [documentation](https://www.puppet.com/docs/pe/latest/backing_up_and_restoring_pe.html#restore_pe_infrastructure). 
    - Make sure that you also restore the keys
  - No ability to set the backup retention policy. The script will remove backups older than 14 days
  - The script doesn't check to see if another backup is in progress
  - It can only accept a single GPG key

## Development

Feel free to send bug reports and pull requests to the project page.

