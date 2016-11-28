# Define: sudo::rule
# ===========================
#
# Adds a sudoers snippet to sudoers.d that grants or denies a
# single to run commands with sudo.
#
# Parameters
# ----------
#
# * `commands`
# Sudo commands to allow for the group.
#
# * `defaults`
# Sudo defaults to set for the group.
#
# * `group`
# Name of the group sudo will be enabled for.
#
# * `target`
# Target users. These are the users to allow running commands as.
#
# * `template`
# Template to be used for the file. (Optional)
#
# === Examples
#
#   sudo::rule { 'someGroup':
#     commands => ['/bin/something', '/usr/bin/anotherthing'],
#   }
#
define sudo::rule(
  String[1]        $commands = 'ALL',
  Array[String[1]] $defaults = [],
  String[1]        $group    = $name,
  String[1]        $target   = 'ALL',
  String[1]        $template = 'sudo/sudo_rule.erb',
) {

  file { "/etc/sudoers.d/${name}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => template($template),
  }
}
