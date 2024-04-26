# Class that manages the cron job to run the backup script. Should not be used directly.
#
# @author Federico Voges
# @api private
#
class pe_backup::service {
  $script  = $pe_backup::script_path
  $hour    = $pe_backup::cron_hour
  $minute  = $pe_backup::cron_minute
  $weekday = $pe_backup::cron_weekday

  cron { 'pe_backup':
    command => $script,
    hour    => $hour,
    minute  => $minute,
    weekday => $weekday,
  }
}
