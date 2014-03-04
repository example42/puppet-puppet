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
#   Define if to install just the client (mode = client) or both server
#   and client (mode = server ). Default: client
#
# [*server*]
#   FQDN of the puppet server. Default: puppet.$domain or just puppet
#   if $domain fact is blank
#
# [*environment*]
#   The default environment set in puppet.conf. Default: production
#
# [*master_environment*]
#   The default environment set in puppet.conf in the agent section for the master. Default: production
#
# [*allow*]
#   The allow directive in the server file namespaceauth.conf.
#   Default: *.$domain and localhost
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
#   One of 'cron', 'manual', or 'service'.
#
# [*runinterval*]
#   How much time should pass between two puppet runs. In seconds.
#
# [*croninterval*]
#   Cron interval specification when the puppet agent should run.
#   If defined must be in cron like syntax (ie: 4 5 * * *)
#
# [*croncommand*]
#
# [*postrun_command*]
#
# [*reports*]
#   Value of 'reports' config option, or leave blank to auto-determine
#
# [*externalnodes*]
#
# [*passenger*]
#
# [*passenger_type*]
#   The type of server that runs passenger (Default: apache)
#   Can be one of: apache, nginx, ""
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
#   Location of the db-server. Defaults to $::fqdn.
#
# [*db_port*]
#   DB port to connect to (Used only for puppetdb).
#   Defaults to 8081 (by default used for ssl connections)
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
# [*version_puppetdb_terminus*]
#
# [*service_server_autorestart*]
#
# [*dns_alt_names*]
#   The comma-separated list of alternative DNS names to use for the local
#   host. When the node generates a CSR for itself, these are added to the
#   request as the desired subjectAltName in the certificate: additional DNS
#   labels that the certificate is also valid answering as. This is generally
#   required if you use a non-hostname certname, or if you want to use puppet
#   kick or puppet resource -H and the primary certname does not match the DNS
#   name you use to communicate with the host. This is unnecessary for agents,
#   unless you intend to use them as a server for puppet kick or remote puppet
#   resource management. It is rarely necessary for servers; it is usually
#   helpful only if you need to have a pool of multiple load balanced masters,
#   or for the same master to respond on two physically separate networks under
#   different names
#
# [*client_daemon_opts*]
#   If $operatingsystem is Debian or Ubuntu, these options will be passed to
#   the puppetd on startup
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
# [*template_rack_config*]
#
# [*run_dir*]
#
# [*ssl_dir*]
#
# [*reporturl*]
#
# Extra Database settings
#
# [*mysql_conn_package*]
# MySQL ruby database connector
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
# [*package_provider*]
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
# [*http_proxy_host*]
#   The HTTP proxy port, if any, required to perform HTTP requests.
#   This is used by the agent component.
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $puppet_port
#
# [*http_proxy_port*]
#   The HTTP proxy port, if any, required to perform HTTP requests.
#   This is used by the agent component.
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $puppet_protocol
#
# [*manifest_path*]
#   Path to the manifests
#
# [*module_path*]
#   Location of the modules
#
# [*template_dir*]
#   Location of the templates
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
  $master_environment  = params_lookup( 'master_environment' ),
  $allow               = params_lookup( 'allow' ),
  $bindaddress         = params_lookup( 'bindaddress' ),
  $listen              = params_lookup( 'listen' ),
  $port_listen         = params_lookup( 'port_listen' ),
  $nodetool            = params_lookup( 'nodetool' ),
  $reports             = params_lookup( 'reports' ),
  $runmode             = params_lookup( 'runmode' ),
  $runinterval         = params_lookup( 'runinterval' ),
  $croninterval        = params_lookup( 'croninterval' ),
  $croncommand         = params_lookup( 'croncommand' ),
  $prerun_command      = params_lookup( 'prerun_command' ),
  $postrun_command     = params_lookup( 'postrun_command' ),
  $externalnodes       = params_lookup( 'externalnodes' ),
  $passenger           = params_lookup( 'passenger' ),
  $passenger_type      = params_lookup( 'passenger_type' ),
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
  $version_puppetdb_terminus  = params_lookup( 'version_puppetdb_terminus' ),
  $service_server_autorestart = params_lookup( 'service_server_autorestart' ),
  $dns_alt_names       = params_lookup( 'dns_alt_names' ),
  $certname            = params_lookup( 'certname' ),
  $client_daemon_opts  = params_lookup( 'client_daemon_opts' ),
  $mysql_conn_package  = params_lookup( 'mysql_conn_package' ),
  $basedir             = params_lookup( 'basedir' ),
  $template_namespaceauth = params_lookup( 'template_namespaceauth' ),
  $template_auth       = params_lookup( 'template_auth' ),
  $template_fileserver = params_lookup( 'template_fileserver' ),
  $template_passenger  = params_lookup( 'template_passenger' ),
  $template_rack_config = params_lookup( 'template_rack_config' ),
  $template_cron       = params_lookup( 'template_cron' ),
  $run_dir             = params_lookup( 'run_dir' ),
  $ssl_dir             = params_lookup( 'ssl_dir' ),
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
  $package_provider    = params_lookup( 'package_provider' ),
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
  $http_proxy_host     = params_lookup( 'http_proxy_host' , 'global' ),
  $http_proxy_port     = params_lookup( 'http_proxy_port' , 'global' ),
  $protocol            = params_lookup( 'protocol' ),
  $manifest_path       = params_lookup( 'manifest_path' ),
  $module_path         = params_lookup( 'module_path' ),
  $template_dir        = params_lookup( 'template_dir' )
  ) inherits puppet::params {

  $bool_listen=any2bool($listen)
  $bool_externalnodes=any2bool($externalnodes)
  $bool_passenger=any2bool($passenger)
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

  $reports_value = $puppet::reports ? {
    '' => $puppet::nodetool ? {
      'foreman'   => 'store,foreman',
      'dashboard' => 'store,http',
      default     => 'log',
    },
    default => $puppet::reports,
  }

  $real_template_passenger = $puppet::template_passenger ? {
    '' => $puppet::passenger_type ? {
      'nginx'  => 'puppet/passenger/puppet-passenger-nginx.conf.erb',
      default  => 'puppet/passenger/puppet-passenger.conf.erb',
    },
    default => $puppet::template_passenger,
  }

  ### Definition of some variables used in the module
  $manage_package = $puppet::bool_absent ? {
    true  => 'absent',
    false => $puppet::version,
  }

  $manage_package_server = $puppet::bool_absent ? {
    true  => 'absent',
    false => $puppet::version_server,
  }

  $manage_package_puppetdb_terminus = $puppet::bool_absent ? {
    true  => 'absent',
    false => $puppet::version_puppetdb_terminus,
  }

  $manage_service_enable = $puppet::bool_disableboot ? {
    true    => false,
    default => $puppet::bool_disable ? {
      true    => false,
      default => $puppet::bool_absent ? {
        true  => false,
        false => $puppet::runmode ? {
          cron    => false,
          manual  => false,
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
        cron    => 'stopped',
        manual  => 'stopped',
        service => 'running',
      },
    },
  }

  $manage_service_server_ensure = $puppet::bool_disable ? {
    true    => 'stopped',
    default =>  $puppet::bool_absent ? {
      true    => 'stopped',
      default => $puppet::bool_passenger ? {
        true  => 'stopped',
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

  $manage_directory = $puppet::bool_absent ? {
    true    => 'absent',
    default => 'directory',
  }

  $manage_file_cron = $puppet::runmode ? {
    'cron'  => 'present',
    default => 'absent',
  }

  if $puppet::bool_absent == true
  or $puppet::bool_disable == true
  or $puppet::bool_monitor == false
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
    'absent'  => undef,
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

  $manage_log_dir_owner = $puppet::mode ? {
    server => $puppet::process_user_server,
    client => $puppet::process_user,
  }

  $version_puppet = split($::puppetversion, '[.]')
  $version_major = $version_puppet[0]

  ### Managed resources
  package { 'puppet':
    ensure   => $puppet::manage_package,
    name     => $puppet::package,
    provider => $puppet::package_provider,
  }

  service { 'puppet':
    ensure     => $puppet::manage_service_ensure,
    name       => $puppet::service,
    enable     => $puppet::manage_service_enable,
    hasstatus  => $puppet::service_status,
    pattern    => $puppet::process,
    require    => Package['puppet'],
  }

  if ($::operatingsystem == 'Ubuntu'
  or $::operatingsystem == 'Debian') {
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

  file { 'puppet.log.dir':
    ensure  => $puppet::manage_directory,
    path    => $puppet::log_dir,
    mode    => '0750',
    owner   => $puppet::manage_log_dir_owner,
    group   => $puppet::manage_log_dir_owner,
    require => Package['puppet'],
    audit   => $puppet::manage_audit,
  }

  # The whole puppet configuration directory can be recursively overriden
  if $puppet::source_dir {
    file { 'puppet.dir':
      ensure  => $puppet::manage_directory,
      path    => $puppet::config_dir,
      require => Package['puppet'],
      notify  => $puppet::manage_service_autorestart,
      source  => $puppet::source_dir,
      recurse => true,
      purge   => $puppet::bool_source_dir_purge,
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
  if $puppet::monitor_tool and $puppet::runmode == 'service' {
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
  # Quick patch for BSD support and backwards compatibility
  # Skip configuration on Windows because of scheduled_task limitations

  case $::operatingsystem {
    /(?i:OpenBSD|FreeBSD)/: {
      cron { 'puppet_cron':
        ensure   => $puppet::manage_file_cron,
        command  => $puppet::croncommand,
        user     => $puppet::process_user,
        minute   => [ $puppet::tmp_cronminute , $puppet::tmp_cronminute2 ],
      }
    }
    /(?i:Windows)/: { }
    default: {
      file { 'puppet_cron':
        ensure  => $puppet::manage_file_cron,
        path    => '/etc/cron.d/puppet',
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template($puppet::template_cron),
      }
    }
  }

}
