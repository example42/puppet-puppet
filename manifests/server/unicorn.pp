#
# Class puppet::server::unicorn
#
# Installs and configures unicorn and nginx for Puppetmaster
#

class puppet::server::unicorn {

  require puppet

  include unicorn
  include nginx

  $config_ru_file_template = $puppet::version_major ? {
    3       => 'puppet/passenger/config.ru_3',
    2       => 'puppet/passenger/config.ru_2',
    default => 'puppet/passenger/config.ru_3',
  }

  unicorn::instance { 'puppetmaster':
    approot             => '/etc/puppet',
    worker_processes    => $puppet::unicorn_worker_processes,
    socket_path         => $puppet::unicorn_socket_path,
    socket_backlog      => $puppet::unicorn_socket_backlog,
    working_directory   => '/etc/puppet',
    pid_path            => $puppet::unicorn_pid_path,
    stderr_path         => $puppet::unicorn_stderr_path,
    stdout_path         => $puppet::unicorn_stdout_path,
    config_path         => '/etc/puppet/unicorn.conf',
    config_ru_path      => '/etc/puppet/config.ru',
    config_ru_template  => $config_ru_file_template,
    preload_app         => false,
    manage_service      => false,
    timeout_secs        => $puppet::unicorn_timeout_secs,
    before              => Service['puppet_server'],
  }

  nginx::resource::upstream { 'puppetmaster':
    members => [ "unix:${puppet::unicorn_socket_path} fail_timeout=0" ],
  }

  nginx::resource::vhost { 'puppetmaster':
    ssl_only            => true,
    ssl_listen_port     => '8140',
    default_server      => true,
    ssl                 => present,
    ssl_cert            => "/var/lib/puppet/ssl/certs/${puppet::manage_certname_server}.pem",
    ssl_key             => "/var/lib/puppet/ssl/private_keys/${puppet::manage_certname_server}.pem",
    ssl_client_cert     => '/var/lib/puppet/ssl/ca/ca_crt.pem',
    ssl_verify_client   => 'optional',
    proxy               => 'http://puppetmaster',
    proxy_read_timeout  => $puppet::unicorn_timeout_secs,
    proxy_set_header    => [
      'Host $host',
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'X-Client-Verify $ssl_client_verify',
      'X-Client-DN $ssl_client_s_dn',
      'X-SSL-Issuer $ssl_client_i_dn'
    ],
    proxy_redirect    => 'off',
  }

  # Make sure the certs are in place before trying to start nginx
  Exec <| title == 'puppetmaster-ca-generate' |> {
    before  +> Service['nginx']
  }
}
