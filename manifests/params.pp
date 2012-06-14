# Class: puppet::params
#
# This class defines default parameters used by the main module class puppet
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to puppet class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class puppet::params {

  ### Module's specific variables
  $major_version = $::puppetversion ? {
    /(^0.)/   => '0.2',
    default   => '2.x',
  }

  $mode = 'client'
  $server = $::domain ? {
    ''      => 'puppet',
    default => "puppet.$::domain",
  }
  $environment = 'production'
  $allow = $::domain ? {
    ''      => [ '127.0.0.1' ],
    default => [ "*.$::domain" , '127.0.0.1' ],
  }
  $bindaddress = '0.0.0.0'
  $listen = false
  $port_listen = '8139'
  $nodetool = ''
  $runmode = 'service'
  $runinterval = '1800'
  $croninterval = '0 * * * *'
  $croncommand = $major_version ? {
    '0.2' => '/usr/bin/puppetd --onetime',
    '2.x' => '/usr/bin/puppet agent --onetime',
  }
  $postrun_command = ''
  $externalnodes = false
  $passenger = false
  $autosign = false
  $storeconfigs = true
  $storeconfigs_thin = true
  $db = 'sqlite'
  $db_name = 'puppet'
  $db_server = 'localhost'
  $db_port = '8080'
  $db_user = 'root'
  $db_password = ''
  $inventoryserver = 'localhost'
  $reporturl = 'http://localhost:3000/reports'

  $package_server = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'puppetmaster',
    default                   => 'puppet-server',
  }

  $service_server = $::operatingsystem ? {
    default => 'puppetmaster',
  }

  $process_server = $::operatingsystem ? {
    default => 'ruby',
  }

  $pid_file_server = $major_version ? {
    '0.2' => '/var/run/puppet/puppetmasterd.pid',
    '2.x' => '/var/run/puppet/master.pid',
  }

  $process_args_server = $::operatingsystem ? {
    default => 'puppet master',
  }

  $process_user_server = $::operatingsystem ? {
    default => 'puppet',
  }

  $version_server = 'present'

  $service_server_autorestart = false

  $basedir = $::operatingsystem ? {
      /(?i:RedHat|Centos|Scientific|Fedora)/ => '/usr/lib/ruby/site_ruby/1.8/puppet',
      default                                => '/usr/lib/ruby/1.8/puppet',
  }

  $run_dir = $::operatingsystem ? {
    default => '/var/run/puppet',
  }

  $template_namespaceauth = ''
  $template_auth = ''
  $template_fileserver = ''
  $template_passenger = 'puppet/passenger/puppet-passenger.conf.erb'

  ### Application related parameters

  $package = $::operatingsystem ? {
    default => 'puppet',
  }

  $service = $::operatingsystem ? {
    default => 'puppet',
  }

  $service_status = $::operatingsystem ? {
    debian  => false,
    default => true,
  }

  $process = $major_version ? {
    '0.2' => 'puppetd',
    '2.x' => $::operatingsystem ? {
      /(?i:RedHat|Centos|Scientific|Fedora)/ => 'puppetd',
      default                                => 'puppet',
    }
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'root',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/puppet',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/puppet/puppet.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/puppet',
    default                   => '/etc/sysconfig/puppet',
  }

  $pid_file = $major_version ? {
    '0.2' => '/var/run/puppet/puppet.pid',
    '2.x' => '/var/run/puppet/agent.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '/var/lib/puppet',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/puppet',
  }

  $log_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/var/log/syslog',
    default                   => '/var/log/messages',
  }

  $port = '8140'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $service_autorestart = false
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

  ### FILE SERVING SOURCE
  # Sets the correct source for static files - Needed for backwards compatibility
  case $base_source {
    '': { $general_base_source = $puppetversion ? {
      /(^0.25)/ => "puppet:///modules",
      /(^0.)/   => "puppet://$servername",
      default   => "puppet:///modules",
    }
  }
    default: { $general_base_source=$base_source }
  }

}
