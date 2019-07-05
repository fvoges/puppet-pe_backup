# Class: pe_backup
# ===========================
#
# Full description of class pe_backup here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class pe_backup (
  Stdlib::Absolutepath $destination,
  String                                     $user          = $::pe_backup::params::user,
  String                                     $group         = $::pe_backup::params::group,
  String                                     $umask         = $::pe_backup::params::umask,
  String                                     $prefix        = $::pe_backup::params::prefix,
  Stdlib::Absolutepath                       $script        = $::pe_backup::params::script,
  String                                     $hour          = $::pe_backup::params::hour,
  String                                     $minute        = $::pe_backup::params::minute,
  String                                     $weekday       = $::pe_backup::params::weekday,
  Array                                      $dirs_common   = $::pe_backup::params::dirs_common,
  Array                                      $dirs_master   = $::pe_backup::params::dirs_master,
  Array                                      $dirs_db       = $::pe_backup::params::dirs_db,
  Array                                      $dirs_console  = $::pe_backup::params::dirs_console,
  Array                                      $dirs_extra    = $::pe_backup::params::dirs_extra,
  Enum['monolithic','master','db','console'] $nodetype      = $::pe_backup::params::nodetype,
) inherits pe_backup::params {

  contain pe_backup::install
  contain pe_backup::service

  Class['pe_backup::install'] -> Class['pe_backup::service']
}
