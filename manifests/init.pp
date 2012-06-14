# = Class: puppet
#
# This is the main puppet class
#
#
# == Parameters
#
# Module specific parameters
#
# [*mode*]
#
# [*server*]
#
# [*environment*]
#
# [*allow*]
#
# [*bindaddress*]
#
# [*listen*]
#
# [*port_listen*]
#
# [*nodetool*]
#
# [*runmode*]
#
# [*runinterval*]
#
# [*croninterval*]
#
# [*croncommand*]
#
# [*postrun_command*]
#
# [*externalnodes*]
#
# [*passenger*]
#
# [*autosign*]
#
# [*storeconfigs*]
#
# [*storeconfigs_thin*]
#
# [*db*]
#   
# [*db_name*]
#
# [*db_server*]
#
# [*db_port*]
#   DB port to connet to (Used only for puppetdb)
#
# [*db_user*]
#
# [*db_password*]
#
# [*inventoryserver*]
#
# [*package_server*]
#
# [*service_server*]
#
# [*process_server*]
#
# [*pid_file_server*]
#
# [*process_args_server*]
#
# [*process_user_server*]
#
# [*version_server*]
#
# [*service_server_autorestart*]
#
# [*basedir*]
#
# [*template_namespaceauth*]
#
# [*template_auth*]
#
# [*template_fileserver*]
#
# [*template_passenger*]
#
# [*run_dir*]
#
# [*reporturl*]
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, puppet class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $puppet_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, puppet main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $puppet_source
#
# [*source_dir*]
#   If defined, the whole puppet configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $puppet_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $puppet_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, puppet main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $puppet_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $puppet_options
#
# [*service_autorestart*]
#   Automatically restarts the puppet service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $puppet_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $puppet_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $puppet_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $puppet_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for puppet checks
#   Can be defined also by the (top scope) variables $puppet_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $puppet_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $puppet_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $puppet_puppi_helper
#   and $puppi_helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#   Can be defined also by the (top scope) variables $puppet_firewall
#   and $firewall
#
# [*firewall_tool*]
#   Define which firewall tool(s) (ad defined in Example42 firewall module)
#   you want to use to open firewall for puppet port(s)
#   Can be defined also by the (top scope) variables $puppet_firewall_tool
#   and $firewall_tool
#
# [*firewall_src*]
#   Define which source ip/net allow for firewalling puppet. Default: 0.0.0.0/0
#   Can be defined also by the (top scope) variables $puppet_firewall_src
#   and $firewall_src
#
# [*firewall_dst*]
#   Define which destination ip to use for firewalling. Default: $ipaddress
#   Can be defined also by the (top scope) variables $puppet_firewall_dst
#   and $firewall_dst
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $puppet_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $puppet_audit_only
#   and $audit_only
#
# Default class params - As defined in puppet::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of puppet package
#
# [*service*]
#   The name of puppet service
#
# [*service_status*]
#   If the puppet service init script supports status argument
#
# [*process*]
#   The name of puppet process
#
# [*process_args*]
#   The name of puppet arguments. Used by puppi and monitor.
#   Used only in case the puppet process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user puppet runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $puppet_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $puppet_protocol
#
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include puppet"
# - Call puppet as a parametrized class
#
# See README for details.
#
#
# == Author
#   Alessandro Franceschi <al@lab42.it/>
#
class puppet (
  $mode                = params_lookup( 'mode' ),
  $server              = params_lookup( 'server' ),
  $environment         = params_lookup( 'environment' ),
  $allow               = params_lookup( 'allow' ),
  $bindaddress         = params_lookup( 'bindaddress' ),
  $listen              = params_lookup( 'listen' ),
  $port_listen         = params_lookup( 'port_listen' ),
  $nodetool            = params_lookup( 'nodetool' ),
  $runmode             = params_lookup( 'runmode' ),
  $runinterval         = params_lookup( 'runinterval' ),
  $croninterval        = params_lookup( 'croninterval' ),
  $croncommand         = params_lookup( 'croncommand' ),
  $postrun_command     = params_lookup( 'postrun_command' ),
  $externalnodes       = params_lookup( 'externalnodes' ),
  $passenger           = params_lookup( 'passenger' ),
  $autosign            = params_lookup( 'autosign' ),
  $storeconfigs        = params_lookup( 'storeconfigs' ),
  $storeconfigs_thin   = params_lookup( 'storeconfigs_thin' ),
  $db                  = params_lookup( 'db' ),
  $db_name             = params_lookup( 'db_name' ),
  $db_server           = params_lookup( 'db_server' ),
  $db_port             = params_lookup( 'db_port' ),
  $db_user             = params_lookup( 'db_user' ),
  $db_password         = params_lookup( 'db_password' ),
  $inventoryserver     = params_lookup( 'inventoryserver'),
  $package_server      = params_lookup( 'package_server' ),
  $service_server      = params_lookup( 'service_server' ),
  $process_server      = params_lookup( 'process_server' ),
  $pid_file_server     = params_lookup( 'pid_file_server' ),
  $process_args_server = params_lookup( 'process_args_server' ),
  $process_user_server = params_lookup( 'process_user_server' ),
  $version_server      = params_lookup( 'version_server' ),
  $service_server_autorestart = params_lookup( 'service_server_autorestart' ),
  $basedir             = params_lookup( 'basedir' ),
  $template_namespaceauth = params_lookup( 'template_namespaceauth' ),
  $template_auth       = params_lookup( 'template_auth' ),
  $template_fileserver = params_lookup( 'template_fileserver' ),
  $template_passenger  = params_lookup( 'template_passenger' ),
  $run_dir             = params_lookup( 'run_dir' ),
  $reporturl           = params_lookup( 'reporturl' ),
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $service_autorestart = params_lookup( 'service_autorestart' , 'global' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $disable             = params_lookup( 'disable' ),
  $disableboot         = params_lookup( 'disableboot' ),
  $monitor             = params_lookup( 'monitor' , 'global' ),
  $monitor_tool        = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target      = params_lookup( 'monitor_target' , 'global' ),
  $puppi               = params_lookup( 'puppi' , 'global' ),
  $puppi_helper        = params_lookup( 'puppi_helper' , 'global' ),
  $firewall            = params_lookup( 'firewall' , 'global' ),
  $firewall_tool       = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src        = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst        = params_lookup( 'firewall_dst' , 'global' ),
  $debug               = params_lookup( 'debug' , 'global' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $package             = params_lookup( 'package' ),
  $service             = params_lookup( 'service' ),
  $service_status      = params_lookup( 'service_status' ),
  $process             = params_lookup( 'process' ),
  $process_args        = params_lookup( 'process_args' ),
  $process_user        = params_lookup( 'process_user' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $config_file_init    = params_lookup( 'config_file_init' ),
  $pid_file            = params_lookup( 'pid_file' ),
  $data_dir            = params_lookup( 'data_dir' ),
  $log_dir             = params_lookup( 'log_dir' ),
  $log_file            = params_lookup( 'log_file' ),
  $port                = params_lookup( 'port' ),
  $protocol            = params_lookup( 'protocol' )
  ) inherits puppet::params {

  $bool_listen=any2bool($listen)
  $bool_externalnodes=any2bool($externalnodes)
  $bool_passenger=any2bool($passenger)
  $bool_autosign=any2bool($autosign)
  $bool_storeconfigs=any2bool($storeconfigs)
  $bool_storeconfigs_thin=any2bool($storeconfigs_thin)
  $bool_service_server_autorestart=any2bool($service_server_autorestart)
  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_package = $puppet::bool_absent ? {
    true  => 'absent',
    false => $puppet::version,
  }

  $manage_package_server = $puppet::bool_absent ? {
    true  => 'absent',
    false => $puppet::version_server,
  }

  $manage_service_enable = $puppet::bool_disableboot ? {
    true    => false,
    default => $puppet::bool_disable ? {
      true    => false,
      default => $puppet::bool_absent ? {
        true  => false,
        false => $puppet::runmode ? {
          cron    => false,
          service => true,
        },
      },
    },
  }

  $manage_service_server_enable = $puppet::bool_disableboot ? {
    true    => false,
    default => $puppet::bool_disable ? {
      true    => false,
      default => $puppet::bool_absent ? {
        true  => false,
        false => $puppet::bool_passenger ? {
          true  => false,
          false => true,
        },
      },
    },
  }

  $manage_service_ensure = $puppet::bool_disable ? {
    true    => 'stopped',
    default =>  $puppet::bool_absent ? {
      true    => 'stopped',
      default => $puppet::runmode ? {
        cron    => undef,
        service => 'running',
      },
    },
  }

  $manage_service_server_ensure = $puppet::bool_disable ? {
    true    => 'stopped',
    default =>  $puppet::bool_absent ? {
      true    => 'stopped',
      default => $puppet::bool_passenger ? {
        true  => undef,
        false => 'running',
      },
    },
  }

  $manage_service_autorestart = $puppet::bool_service_autorestart ? {
    true    => 'Service[puppet]',
    false   => undef,
  }

  $manage_service_server_autorestart = $puppet::bool_service_server_autorestart ? {
    true    => 'Service[puppet_server]',
    false   => undef,
  }

  $manage_file = $puppet::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $puppet::bool_absent == true
  or $puppet::bool_disable == true
  or $puppet::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $puppet::bool_absent == true
  or $puppet::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $puppet::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $puppet::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $puppet::source ? {
    ''        => undef,
    default   => $puppet::source,
  }

  $manage_file_content = $puppet::template ? {
    ''        => $puppet::mode ? {
      client => template('puppet/client/puppet.conf.erb'),
      server => template('puppet/server/puppet.conf.erb'),
    },
    default   => template($puppet::template),
  }

  $manage_file_namespaceauth_content = $puppet::template_namespaceauth ? {
    ''        => $puppet::mode ? {
      client => template('puppet/client/namespaceauth.conf.erb'),
      server => template('puppet/server/namespaceauth.conf.erb'),
    },
    default   => template($puppet::template_namespaceauth),
  }

  $manage_file_auth_content = $puppet::template_auth ? {
    ''        => $puppet::mode ? {
      client => template('puppet/client/auth.conf.erb'),
      server => template('puppet/server/auth.conf.erb'),
    },
    default   => template($puppet::template_auth),
  }

  $manage_file_fileserver_content = $puppet::template_fileserver ? {
    ''        => $puppet::mode ? {
      client => template('puppet/client/fileserver.conf.erb'),
      server => template('puppet/server/fileserver.conf.erb'),
    },
    default   => template($puppet::template_fileserver),
  }

  ### Managed resources
  package { 'puppet':
    ensure => $puppet::manage_package,
    name   => $puppet::package,
  }

  service { 'puppet':
    ensure     => $puppet::manage_service_ensure,
    name       => $puppet::service,
    enable     => $puppet::manage_service_enable,
    hasstatus  => $puppet::service_status,
    pattern    => $puppet::process,
    require    => Package['puppet'],
  }

  # Enable service start on Ubuntu
  if ($::operatingsystem == 'Ubuntu'
  or $::operatingsystem == 'Debian')
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

  file { 'puppet.conf':
    ensure  => $puppet::manage_file,
    path    => $puppet::config_file,
    mode    => $puppet::config_file_mode,
    owner   => $puppet::config_file_owner,
    group   => $puppet::config_file_group,
    require => Package['puppet'],
    notify  => $puppet::manage_service_autorestart,
    source  => $puppet::manage_file_source,
    content => $puppet::manage_file_content,
    replace => $puppet::manage_file_replace,
    audit   => $puppet::manage_audit,
  }

  file { 'namespaceauth.conf':
    ensure  => $puppet::manage_file,
    path    => "${puppet::config_dir}/namespaceauth.conf",
    mode    => $puppet::config_file_mode,
    owner   => $puppet::config_file_owner,
    group   => $puppet::config_file_group,
    require => Package['puppet'],
    notify  => $puppet::manage_service_autorestart,
    content => $puppet::manage_file_namespaceauth_content,
    replace => $puppet::manage_file_replace,
    audit   => $puppet::manage_audit,
  }

  file { 'auth.conf':
    ensure  => $puppet::manage_file,
    path    => "${puppet::config_dir}/auth.conf",
    mode    => $puppet::config_file_mode,
    owner   => $puppet::config_file_owner,
    group   => $puppet::config_file_group,
    require => Package['puppet'],
    notify  => $puppet::manage_service_autorestart,
    content => $puppet::manage_file_auth_content,
    replace => $puppet::manage_file_replace,
    audit   => $puppet::manage_audit,
  }

  # The whole puppet configuration directory can be recursively overriden
  if $puppet::source_dir {
    file { 'puppet.dir':
      ensure  => directory,
      path    => $puppet::config_dir,
      require => Package['puppet'],
      notify  => $puppet::manage_service_autorestart,
      source  => $puppet::source_dir,
      recurse => true,
      purge   => $puppet::source_dir_purge,
      replace => $puppet::manage_file_replace,
      audit   => $puppet::manage_audit,
    }
  }


  ### Include custom class if $my_class is set
  if $puppet::my_class {
    include $puppet::my_class
  }


  ### Provide puppi data, if enabled ( puppi => true )
  if $puppet::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'puppet':
      ensure    => $puppet::manage_file,
      variables => $classvars,
      helper    => $puppet::puppi_helper,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $puppet::bool_monitor == true and $puppet::runmode == 'service' {
    if $puppet::bool_listen == true {
      monitor::port { "puppet_${puppet::protocol}_${puppet::port_listen}":
        protocol => $puppet::protocol,
        port     => $puppet::port_listen,
        target   => $puppet::monitor_target,
        tool     => $puppet::monitor_tool,
        enable   => $puppet::manage_monitor,
      }
    }
    monitor::process { 'puppet_process':
      process  => $puppet::process,
      service  => $puppet::service,
      pidfile  => $puppet::pid_file,
      user     => $puppet::process_user,
      argument => $puppet::process_args,
      tool     => $puppet::monitor_tool,
      enable   => $puppet::manage_monitor,
    }
  }


  ### Firewall management, if enabled ( firewall => true )
  if $puppet::bool_firewall == true 
  and $puppet::bool_listen == true {
    firewall { "puppet_${puppet::protocol}_${puppet::port_listen}":
      source      => $puppet::firewall_src,
      destination => $puppet::firewall_dst,
      protocol    => $puppet::protocol,
      port        => $puppet::port_listen,
      action      => 'allow',
      direction   => 'input',
      tool        => $puppet::firewall_tool,
      enable      => $puppet::manage_firewall,
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $puppet::bool_debug == true {
    file { 'debug_puppet':
      ensure  => $puppet::manage_file,
      path    => "${settings::vardir}/debug-puppet",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
    }
  }

  ### PuppetMaster configuration
  if $puppet::mode == 'server' {
    include puppet::server
  }

  ### Cron configuration if run_mode = cron
  if $puppet::runmode == 'cron' {
    file { 'puppet_cron':
      ensure  => $puppet::manage_file,
      path    => '/etc/cron.d/puppet',
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('puppet/client/puppet.cron.erb'),
    }
  }

}
