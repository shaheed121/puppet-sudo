# This class enables logging for sudo. See README.md for more details.
class sudo::logging(
  Boolean $enabled,
  String[1] $log_dir,
  String[1] $log_file,
  Array[String[1]] $disable_cmnd_logging,
  Array[String[1]] $disable_user_logging,
) {
  include '::sudo'

  if $enabled {
    file { '/etc/sudoers.d/logging':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
      content => epp('sudo/logging.epp', {
        'disable_user_logging' => $disable_user_logging,
        'disable_cmnd_logging' => $disable_cmnd_logging,
        'log_dir'              => $log_dir,
        'log_file'             => $log_file
      } ),
    }
  }
}
