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
    $rails_package_version = $::operatingsystem ? {
      centos  => '2.3.5',
      redhat  => '2.3.5',
      default => 'installed',
    }
    $rails_package_provider = $::operatingsystem ? {
      debian  => 'apt',
      ubuntu  => 'apt',
      default => 'gem',
    }
    package { 'rails':
      ensure   => $rails_package_version,
      provider => $rails_package_provider,
    }
  }
}
