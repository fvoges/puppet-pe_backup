# Class that manages the backup script. Should not be used directly.
#
# @author <NAME>
# @license Apache 2.0
#
# @api private
#
#
# @author Federico Voges
# @api private
#
class pe_backup::install {
  $destination    = $pe_backup::destination
  $script         = $pe_backup::script_path
  $umask          = $pe_backup::umask
  $gpg_key_id     = $pe_backup::gpg_key_id
  $gpg_key_server = $pe_backup::gpg_key_server

  $template_params = {
    'destination'    => $destination,
    'umask'          => $umask,
    'gpg_key_id'     => $gpg_key_id,
    'gpg_key_server' => $gpg_key_server,
  }

  file { 'pe_backup':
    ensure  => 'file',
    path    => $script,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => epp("${module_name}/pe_backup.sh.epp", $template_params),
  }
}
