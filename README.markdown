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

This release doesn't include a restore script.

## Setup

### What pe_backup affects

Using the default settings, `pe_backup` will install a backup script `/usr/local/bin/pe_backup.sh` and add a cron job to run that script every day at 3:33am.


### Beginning with pe_backup


The module should work without changing any of the default parameters and only requires specifying the destination for the backup using the `destination`parameter. 

**NOTE**: the module expects the destination directory to exist. It will not try to create it. It's better to manage that from a profile instead of trying to work out all the possible cases inside this module.


## Usage

```puppet
class { 'pe_backup':
  destination => '/vol/backups/pe_backups',
}
```

Example profile working together with [npwalker/pe_databases](https://forge.puppet.com/npwalker/pe_databases).

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
    prefix      => $::trusted['certname']
    # include the database dumps fron pe_databases::backup too
    dirs_extra  => [ $pe_databases::backup::backup_directory, ],
  }
}
```


## Reference

TBD

## Limitations

TBD

## Development

Feel free to send bug reports and pull requests to the project page.

