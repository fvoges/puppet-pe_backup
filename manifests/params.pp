# == Class pe_backup::params
#
# This class is meant to be called from pe_backup.
# It sets variables according to platform.
#
class pe_backup::params {
  $user     = 'root'
  $group    = 'root'
  $umask    = '0077'
  $prefix   = 'pe_backup'
  $script   = '/usr/local/bin/pe_backup.sh'
  $hour     = '3'
  $minute   = '33'
  $weekday  = '*'
  $nodetype = 'monolithic'

  $dirs_common  = [
    '/etc/puppetlabs',
  ]
  $dirs_master  = []
  $dirs_db      = [
    '/opt/puppetlabs/server/data/postgresql/9.4/data/certs',
  ]
  $dirs_console = [
    '/opt/puppetlabs/server/data/console-services/certs',
  ]
  $dirs_extra   = []
}
