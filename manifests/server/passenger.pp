#
# Class puppet::server::passenger
#
# Installs and configures passenger for Puppetmaster
#
class puppet::server::passenger {
  require puppet

  include apache::ssl
  include apache::passenger

  file { ['/etc/puppet/rack',
          '/etc/puppet/rack/public',
          '/etc/puppet/rack/tmp']:
    ensure => directory,
    owner  => $puppet::process_user_server,
    group  => $puppet::process_user_server,
  }

  $passenger_file_content = $puppet::version_major ? {
    3       => template('puppet/passenger/config.ru_3'),
    default => template('puppet/passenger/config.ru_3'),
  }

  file { '/etc/puppet/rack/config.ru':
    ensure  => present,
    owner   => $puppet::process_user_server,
    group   => $puppet::process_user_server,
    mode    => '0644',
    content => $passenger_file_content,
  }

  apache::vhost { 'puppetmaster':
    port     => '8140',
    priority => '10',
    docroot  => '/etc/puppet/rack/public/',
    ssl      => true,
    template => $puppet::template_passenger,
    require  => Exec['puppetmaster-ca-generate'],
  }

}
