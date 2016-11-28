# - PRIVATE CLASS
class sudo::install {
  assert_private()

  package { 'sudo':
    ensure => present,
  }
}
