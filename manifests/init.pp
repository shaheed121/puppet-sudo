# Class: sudo
# ===========================
#
# Installs and manages the Sudo package.
#
# Parameters
# ----------
#
# * `default_sudo_vars`
# Environment variables for sudoers
# ['env_reset', 'env_keep += "SSH_AUTH_SOCK"']
#
# * `full_sudo_groups`
# Groups that need full privileged Access
# ['adminusers','superdev']
#
# Examples
# --------
#
# Please check the Readme for this module.
#
# Authors
# -------
#
# Abdul Shaheed <shaheed121@gmail.com>
#
class sudo(
  Array[String[1]] $default_sudo_vars,
  Array[String[1]] $full_sudo_groups,
) {
  class { '::sudo::install': } ->
  class { '::sudo::config': }

  contain '::sudo::install'
  contain '::sudo::config'
}
