# Class: puppet::debian
#
# Manage everything Debian specific
#
# Usage:
# include puppet::debian
#
class puppet::debian {

  include puppet::params

  # Debian assumes that puppetmaster runs under user:group puppet:puppet
  # so /var/lib/puppet and /var/log/puppet must be owned accordingly
  file { 'puppet_lib.dir':
    ensure  => directory,
    path    => $puppet::data_dir,
    owner   => $puppet::config_file_owner,
    group   => $puppet::config_file_group,
  }

  file { 'puppet_log.dir':
    ensure  => directory,
    path    => $puppet::log_dir,
    owner   => $puppet::config_file_owner,
    group   => $puppet::config_file_group,
  }

}
