# This class manages the scirpt and cron job to backup Puppet Enterprise
#
# @param [Stdlib::Absolutepath] destination
#   The path to the backup destination.
#
# @param [Optional[String]] gpg_key_id
#   if specified, the backup will be encrypted usingthis GPG public key.
#
# @param [String] gpg_key_server
#   When usin GPG, this is the keyserver used to retrieve the GPG public key.
#
# @param [String] script_user
#   The user to run the backup script as.
#
# @param [String] script_group
#   The group to run the backup script as.
#
# @param [String] umask
#   The umask to run the backup script as.
#
# @param [Stdlib::Absolutepath] script_path
#   Absolute path and filename for the bacup script
#
# @param [String] cron_hour
#   Backup cronjob hour
#
# @param [String] cron_minute
#   Backup cronjob minute
#
# @param [String] cron_weekday
#   Backup cronjob weekday
#
class pe_backup (
  Stdlib::Absolutepath $destination,
  String               $script_user,
  String               $script_group,
  String               $umask,
  Stdlib::Absolutepath $script_path,
  String               $cron_hour,
  String               $cron_minute,
  String               $cron_weekday,
  String               $gpg_key_server,
  Optional[String]     $gpg_key_id = undef,
) {
  contain pe_backup::install
  contain pe_backup::service

  Class['pe_backup::install'] -> Class['pe_backup::service']
}
