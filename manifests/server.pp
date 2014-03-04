# = Class: puppet::server
#
# This class manages Puppet server components
#
#
# == Parameters
#
# The parameters used in this class are defined for the main puppet class
#
class puppet::server inherits puppet {
  ### Managed resources
  package { 'puppet_server':
    ensure   => $puppet::manage_package_server,
    name     => $puppet::package_server,
    notify   => $puppet::manage_service_server_autorestart,
    provider => $puppet::package_provider,
  }

  service { 'puppet_server':
    ensure     => $puppet::manage_service_server_ensure,
    name       => $puppet::service_server,
    enable     => $puppet::manage_service_server_enable,
    hasstatus  => $puppet::service_status,
    pattern    => $puppet::process_server,
    require    => Package['puppet_server'],
  }

  file { 'fileserver.conf':
    ensure  => $puppet::manage_file,
    path    => "${puppet::config_dir}/fileserver.conf",
    mode    => $puppet::config_file_mode,
    owner   => $puppet::config_file_owner,
    group   => $puppet::config_file_group,
    require => Package['puppet'],
    notify  => $puppet::manage_service_server_autorestart,
    content => $puppet::manage_file_fileserver_content,
    replace => $puppet::manage_file_replace,
    audit   => $puppet::manage_audit,
  }

  $ca_generate_command = $puppet::dns_alt_names ? {
    undef => "/usr/bin/puppet ca generate ${puppet::server}",
    ''    => "/usr/bin/puppet ca generate ${puppet::server}",
    default => "/usr/bin/puppet ca generate --dns-alt-names ${puppet::dns_alt_names} ${puppet::server}",
  }

  exec { 'puppetmaster-ca-generate':
    creates => "${puppet::ssl_dir}/private_keys/${puppet::server}.pem",
    command => $ca_generate_command,
    require => [ Package['puppet'] , File['puppet.conf'] ],
  }

  ### Service monitoring, if enabled ( monitor => true )
  if $puppet::bool_monitor == true {
    monitor::port { "puppet_${puppet::protocol}_${puppet::port}":
      protocol => $puppet::protocol,
      port     => $puppet::port,
      target   => $puppet::monitor_target,
      tool     => $puppet::monitor_tool,
      enable   => $puppet::manage_monitor,
    }
    if $puppet::bool_passenger == false {
      monitor::process { 'puppet_process_server':
        process  => $puppet::process_server,
        service  => $puppet::service_server,
        pidfile  => $puppet::pid_file_server,
        user     => $puppet::process_user_server,
        argument => $puppet::process_args_server,
        tool     => $puppet::monitor_tool,
        enable   => $puppet::manage_monitor,
      }
    }
  }


  ### Firewall management, if enabled ( firewall => true )
  if $puppet::bool_firewall == true {
    firewall { "puppet_${puppet::protocol}_${puppet::port}":
      source      => $puppet::firewall_src,
      destination => $puppet::firewall_dst,
      protocol    => $puppet::protocol,
      port        => $puppet::port,
      action      => 'allow',
      direction   => 'input',
      tool        => $puppet::firewall_tool,
      enable      => $puppet::manage_firewall,
    }
  }

  ### Rails required when storeconfigs activated
  if $puppet::bool_storeconfigs == true { include puppet::rails }

  ### Manage database for storeconfigs
  case $puppet::db {
    mysql: { include puppet::server::mysql }
    puppetdb: { include puppet::server::puppetdb }
    default: { include puppet::server::sqlite }
  }

  ### Manage Passenger
  if $puppet::bool_passenger == true { include puppet::server::passenger }

}
