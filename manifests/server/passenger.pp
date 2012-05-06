#
# Class puppet::server::passenger 
# 
# Installs and configures passenger for Puppetmaster
#
class puppet::server::passenger {
  require puppet

  case $::operatingsystem {
    centos: { require yum::repo::passenger }
    redhat: { require yum::repo::passenger }
  }

  include apache

  file { ['/etc/puppet/rack', '/etc/puppet/rack/public', '/etc/puppet/rack/tmp']:
    ensure => directory,
    owner  => $puppet::process_user_server,
    group  => $puppet::process_user_server,
  }

  file { '/etc/puppet/rack/config.ru':
    ensure  => present,
    owner   => $puppet::process_user_server,
    group   => $puppet::process_user_server,
    mode    => 0644,
    content => template('puppet/passenger/config.ru'),
  }

  apache::vhost { 'puppetmaster':
    port     => '8140',
    priority => '10',
    docroot  => '/etc/puppet/rack/public/',
    ssl      => true,
    template => 'puppet/passenger/puppet-passenger.conf.erb',
  }

  case $::operatingsystem {
    ubuntu,debian,mint: { 
      package { 'libapache2-mod-passenger':
        ensure => present;
      }     
    }

    centos,redhat,scientific,fedora: {
      package { 'mod_passenger':
        ensure => present;
      }
    }
  }

}
