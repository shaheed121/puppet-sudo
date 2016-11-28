# - PRIVATE CLASS
class sudo::config {
  assert_private()

  file { '/usr/bin/sudo':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '4111',
  }

  file { '/etc/sudoers.d':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  file { '/etc/sudoers':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => epp('sudo/sudoers.epp', {
      'default_sudo_vars' => $::sudo::default_sudo_vars,
      'full_sudo_groups'  => $::sudo::full_sudo_groups,
    }),
  }
}
