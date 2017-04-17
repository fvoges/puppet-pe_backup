# == Class pe_backup::service
#
# This class is meant to be called from pe_backup.
# It ensure the service is running.
#
class pe_backup::service {
  $script  = $::pe_backup::script
  $hour    = $::pe_backup::hour
  $minute  = $::pe_backup::minute
  $weekday = $::pe_backup::weekday

  cron { 'pe_backup':
    command => $script,
    hour    => $hour,
    minute  => $minute,
    weekday => $weekday,
  }
}
