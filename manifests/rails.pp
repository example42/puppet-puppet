# Class: puppet::rails
#
# Installs rails package.
# Needed for Puppetmaster with storecongis activated
#
# Usage:
# include puppet::rails
#
class puppet::rails {

  include puppet::params
  if ! defined(Package['rails']) {
    package { 'rails':
      ensure => $::operatingsystem ? {
        centos  => '2.3.5',
        redhat  => '2.3.5',
        default => 'installed',
      },
      provider => $::operatingsystem ? {
        debian  => 'apt',
        ubuntu  => 'apt',
        default => 'gem',
      },
    }
  }
}
