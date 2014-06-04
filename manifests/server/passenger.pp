#
# Class puppet::server::passenger
#
# Installs and configures passenger for Puppetmaster
#
class puppet::server::passenger {
  require puppet

  case $puppet::passenger_type {
    apache: {
      include apache::ssl
      include apache::passenger
    }
    nginx: { }
    default: { }
  }

  file { [$puppet::passenger_approot,
          "${puppet::passenger_approot}/public",
          "${puppet::passenger_approot}/tmp"]:
    ensure => directory,
    owner  => $puppet::process_user_server,
    group  => $puppet::process_user_server,
  }

  file { "${puppet::passenger_approot}/config.ru":
    ensure  => present,
    owner   => $puppet::process_user_server,
    group   => $puppet::process_user_server,
    mode    => '0644',
    content => template($puppet::template_rack_config),
  }

  $vhost_priority = 10
  $rack_location = "${puppet::passenger_approot}/public/"

  case $puppet::passenger_type {
    apache: {
      apache::vhost { 'puppetmaster':
        port     => $puppet::port,
        priority => $vhost_priority,
        docroot  => $rack_location,
        ssl      => true,
        template => $puppet::real_template_passenger,
        require  => Exec['puppetmaster-ca-generate'],
      }
    }
    nginx: {
      nginx::vhost { $puppet::server:
        port           => $puppet::port,
        priority       => $vhost_priority,
        docroot        => $rack_location,
        create_docroot => false,
        template       => $puppet::real_template_passenger,
        require        => Exec['puppetmaster-ca-generate'],
      }
    }
    default: { }
  }
}
