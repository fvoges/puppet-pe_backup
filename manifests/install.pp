# == Class pe_backup::install
#
# This class is called from pe_backup for install.
#
class pe_backup::install {
  $script = $::pe_backup::script

  $template_params = {
    'destination' => $::pe_backup::destination,
    'dir_list'    => $::pe_backup::dir_list,
    'prefix'      => $::pe_backup::prefix,
    'umask'       => $::pe_backup::umask,
  }

  file { $script:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => epp("${module_name}/pe_backup.sh.epp", $template_params),
  }

}
