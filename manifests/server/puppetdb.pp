# Class puppet::server::puppetdb
#
# Manages PuppetDB configuration on Puppet Master.
#
class puppet::server::puppetdb {

  require puppet

  package { 'puppetdb_terminus':
    ensure => $::puppet::manage_package_puppetdb_terminus,
    name   => 'puppetdb-terminus',
  }

  file { 'puppet-puppetdb.conf':
    ensure  => $::puppet::manage_file,
    path    => "${::puppet::config_dir}/puppetdb.conf",
    mode    => $::puppet::config_file_mode,
    owner   => $::puppet::config_file_owner,
    group   => $::puppet::config_file_group,
    require => Package['puppet'],
    notify  => $::puppet::manage_service_server_autorestart,
    content => template('puppet/server/puppetdb.conf.erb'),
    replace => $::puppet::manage_file_replace,
    audit   => $::puppet::manage_audit,
  }

  file { 'puppet-routes.yaml':
    ensure  => $::puppet::manage_file,
    path    => "${::puppet::config_dir}/routes.yaml",
    mode    => $::puppet::config_file_mode,
    owner   => $::puppet::config_file_owner,
    group   => $::puppet::config_file_group,
    require => Package['puppet'],
    notify  => $::puppet::manage_service_server_autorestart,
    content => template('puppet/server/routes.yaml.erb'),
    replace => $::puppet::manage_file_replace,
    audit   => $::puppet::manage_audit,
  }

}
