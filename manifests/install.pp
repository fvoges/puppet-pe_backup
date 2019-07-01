# == Class pe_backup::install
#
# This class is called from pe_backup for install.
#
class pe_backup::install {
  $destination  = $::pe_backup::destination
  $dirs_common  = $::pe_backup::dirs_common
  $dirs_console = $::pe_backup::dirs_console
  $dirs_db      = $::pe_backup::dirs_db
  $dirs_extra   = $::pe_backup::dirs_extra
  $dirs_master  = $::pe_backup::dirs_master
  $nodetype     = $::pe_backup::nodetype
  $prefix       = $::pe_backup::prefix
  $script       = $::pe_backup::script
  $umask        = $::pe_backup::umask

  case $nodetype {
    'monolithic': {
      $dir_list = $dirs_common + $dirs_master + $dirs_db + $dirs_console + $dirs_extra
    }
    'master': {
      $dir_list = $dirs_common + $dirs_master + $dirs_extra
    }
    'db': {
      $dir_list = $dirs_common + $dirs_db + $dirs_extra
    }
    'console': {
      $dir_list = $dirs_common + $dirs_console + $dirs_extra
    }
    default: {
      # We should never reach this point, but...
      fail("Invalid node type: ${nodetype}")
    }
  }

  $template_params = {
    'destination' => $destination,
    'dir_list'    => $dir_list,
    'prefix'      => $prefix,
    'umask'       => $umask,
  }

  file { $script:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => epp("${module_name}/pe_backup.sh.epp", $template_params),
  }
}
