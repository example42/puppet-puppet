# Class: puppet::ubuntu
#
# Manage everything Ubuntu specific
#
# Usage:
# include puppet::ubuntu
#
class puppet::ubuntu {

  include puppet::params

  # Enable service start on Ubuntu
  if $::operatingsystem == 'Ubuntu'
  and $puppet::runmode == 'service' {
    file { 'default-puppet':
      ensure  => $puppet::manage_file,
      path    => $puppet::config_file_init,
      require => Package[puppet],
      content => template('puppet/default.init-ubuntu'),
      mode    => $puppet::config_file_mode,
      owner   => $puppet::config_file_owner,
      group   => $puppet::config_file_group,
      notify  => $puppet::manage_service_autorestart,
    }
  }

}
