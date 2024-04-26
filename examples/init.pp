# Defaults with GPG encryption using my public key
#
class { 'pe_backup':
  destination => '/vol/data/pe-backups',
  gpg_key_id  => '5DF1986A10CC1EDEA8C06024AEB80856AB5AE3FF',
}
