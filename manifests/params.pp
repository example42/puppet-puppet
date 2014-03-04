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

  $win_basedir = $::kernelmajversion ? {
    '5.2' => 'C:/Documents and Settings/All Users/Application Data/PuppetLabs/puppet',
    default => 'C:/ProgramData/PuppetLabs/puppet',
  }

  $mode = 'client'

  ### Check if TheForeman ENC is present
  if $::puppetmaster {
    $server = $::puppetmaster
  } else {
    $server = $::domain ? {
      ''      => 'puppet',
      default => "puppet.${::domain}",
    }
  }

  if $::foreman_env {
    $environment = $::foreman_env
  } else {
    $environment = 'production'
  }
  $master_environment = 'production'

  $allow = $::domain ? {
    ''      => [ '127.0.0.1' ],
    default => [ "*.${::domain}" , '127.0.0.1' ],
  }
  $bindaddress = '0.0.0.0'
  $listen = false
  $port_listen = '8139'
  $nodetool = ''
  $reports = ''
  $runmode = 'service'
  $runinterval = '1800'
  $tmp_cronminute = fqdn_rand(30)
  $tmp_cronminute2 = $tmp_cronminute + 30
  $template_cron = 'puppet/client/puppet.cron.erb'
  $croninterval = "${tmp_cronminute},${tmp_cronminute2} * * * *"
  $croncommand = $major_version ? {
    '0.2' => $::operatingsystem ? {
      /(?i:OpenBSD)/ => '/usr/local/bin/puppetd --onetime --pidfile /var/run/puppet-cron.pid >/dev/null 2>&1',
      default        => '/usr/bin/puppetd --onetime --pidfile /var/run/puppet-cron.pid',
    },
    '2.x' => $::operatingsystem ? {
      /(?i:OpenBSD)/ => '/usr/local/bin/puppet agent --onetime --pidfile /var/run/puppet-cron.pid >/dev/null 2>&1',
      default        => '/usr/bin/puppet agent --onetime --pidfile /var/run/puppet-cron.pid',
    }
  }
  $prerun_command = ''
  $postrun_command = ''
  $externalnodes = false
  $passenger = false
  $passenger_type = 'apache'
  $autosign = false
  $storeconfigs = true
  $storeconfigs_thin = true
  $db = 'sqlite'
  $db_name = 'puppet'
  $db_server = $::fqdn
  $db_port = '8081'
  $db_user = 'root'
  $db_password = ''
  $inventoryserver = 'localhost'
  $reporturl = 'http://localhost:3000/reports'

  $package_server = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'puppetmaster',
    /(?i:Solaris)/            => 'puppetmaster',
    default                   => 'puppet-server',
  }

  $service_server = $::operatingsystem ? {
    /(?i:Solaris)/ => 'cswpuppetmasterd',
    default        => 'puppetmaster',
  }

  $process_server = $::operatingsystem ? {
    /(?i:Debian|Mint)/ => 'ruby',
    /(?i:Ubuntu)/      => 'puppet',
    /(?i:Solaris)/     => 'puppetmasterd',
    default            => 'puppet',
  }

  $pid_file_server = $major_version ? {
    '0.2' => '/var/run/puppet/puppetmasterd.pid',
    '2.x' => '/var/run/puppet/master.pid',
  }

  $process_args_server = $::operatingsystem ? {
    /(?i:Debian|Mint)/ => 'puppet',
    /(?i:Ubuntu)/      => 'master',
    default            => 'master',
  }

  $process_user_server = $::operatingsystem ? {
    default => 'puppet',
  }

  $version_server = 'present'
  $version_puppetdb_terminus = 'present'

  $service_server_autorestart = false

  $basedir = $::operatingsystem ? {
    /(?i:RedHat|Centos|Scientific|Fedora|Linux)/ => '/usr/lib/ruby/site_ruby/1.8/puppet',
    /(?i:Solaris)/                               => '/opt/csw/lib/ruby/site_ruby/1.8/puppet',
    default                                      => '/usr/lib/ruby/1.8/puppet',
  }

  $run_dir = $::operatingsystem ? {
    /(?i:OpenBSD)/ => '/var/puppet/run',
    /(?i:Windows)/ => "${win_basedir}/var/run",
    default        => '/var/run/puppet',
  }

  $ssl_dir = $::operatingsystem ? {
    /(?i:OpenBSD)/ => '/etc/puppet/ssl',
    /(?i:Windows)/ => "${win_basedir}/etc/ssl",
    default        => '/var/lib/puppet/ssl',
  }

  $template_namespaceauth = ''
  $template_auth = ''
  $template_fileserver = ''
  $template_passenger = ''

  $version_puppet = split($::puppetversion, '[.]')
  $version_major = $version_puppet[0]
  $template_rack_config = $version_major ? {
    3       => 'puppet/passenger/config.ru_3',
    default => 'puppet/passenger/config.ru_3',
  }

  ### Application related parameters

  $package = $::operatingsystem ? {
    /(?i:OpenBSD)/ => $::operatingsystemrelease ? {
      '5.4'   => 'puppet',
      default => 'ruby-puppet',
    },
    /(?i:Windows)/ => 'Puppet',
    default        => 'puppet',
  }

  $package_provider = $::operatingsystem ? {
    /(?i:Solaris)/ => 'pkgutil',
    default        => undef,
  }

  $service = $::operatingsystem ? {
    /(?i:OpenBSD)/ => 'puppetd',
    /(?i:Solaris)/ => 'cswpuppetd',
    default        => 'puppet',
  }

  $service_status = $::operatingsystem ? {
    debian  => $::lsbmajdistrelease ? {
      5       => false,
      default => true,
    },
    default => true,
  }

  $process = $major_version ? {
    '0.2' => 'puppetd',
    '2.x' => $::operatingsystem ? {
      /(?i:RedHat|Centos|Scientific|Fedora|Linux)/ => 'puppetd',
      /(?i:Solaris)/                               => 'ruby18',
      default                                      => 'puppet',
    }
  }

  if $::osfamily == 'Solaris' and versioncmp($::puppetversion,'2.7.21') >= 0 {
    $solaris_process_args = '/opt/csw/bin/puppet'
  } else {
    $solaris_process_args = '/opt/csw/sbin/puppetd'
  }

  $process_args = $::operatingsystem ? {
    /(?i:Solaris)/ => $solaris_process_args,
    default        => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'root',
  }

  $process_group = $::operatingsystem ? {
    /(?i:OpenBSD)/ => 'wheel',
    default        => 'root',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Windows)/ => "${win_basedir}/etc",
    default        => '/etc/puppet',
  }

  $config_file = $::operatingsystem ? {
    /(?i:Windows)/ => "${win_basedir}/etc/puppet.conf",
    default        => '/etc/puppet/puppet.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    /(?i:Windows)/ => '0770',
    default        => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    /(?i:Windows)/ => 'S-1-5-32-544',
    default        => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    /(?i:OpenBSD)/ => 'wheel',
    /(?i:Windows)/ => 'S-1-5-18',
    default        => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/puppet',
    /(?i:Solaris)/            => '',
    default                   => '/etc/sysconfig/puppet',
  }

  $pid_file = $major_version ? {
    '0.2' => $::operatingsystem ? {
      /(?i:OpenBSD)/ => '/var/puppet/run/puppet.pid',
      default        => '/var/run/puppet/puppet.pid',
    },
    '2.x' => $::operatingsystme ? {
      /(?i:OpenBSD)/ => '/var/puppet/run/agent.pid',
      default        => '/var/run/puppet/agent.pid',
    }
  }

  $data_dir = $::operatingsystem ? {
    /(?i:OpenBSD)/ => '/var/puppet',
    /(?i:Windows)/ => "${win_basedir}/var/lib",
    default        => '/var/lib/puppet',
  }

  $log_dir = $::operatingsystem ? {
    /(?i:OpenBSD)/ => '/var/puppet/log',
    /(?i:Windows)/ => "${win_basedir}/var/log",
    default        => '/var/log/puppet',
  }

  $log_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/var/log/syslog',
    /(?i:Windows)/            => "${win_basedir}/var/log/windows.log",
    /(?i:Solaris)/            => '/var/adm/messages',
    default                   => '/var/log/messages',
  }

  $port = '8140'
  $protocol = 'tcp'

  $http_proxy_host = ''
  $http_proxy_port = ''

  $client_daemon_opts = ''

  $manifest_path = '$confdir/manifests/site.pp'
  $module_path   = '/etc/puppet/modules:/usr/share/puppet/modules'
  $template_dir  = '/var/lib/puppet/templates'


  # DB package resources
  $mysql_conn_package = $::operatingsystem ? {
    /(?i:RedHat|Centos|Scientific|Fedora|Linux)/  => 'ruby-mysql',
    /(?i:Solaris)/                                => 'rb18_mysql_2_8_1',
    default                                       => 'libmysql-ruby',
  }

  $sqlite_package = $::osfamily ? {
    /(?i:RedHat)/ => 'rubygem-sqlite3-ruby',
    /Debian/      => $::lsbmajdistrelease ? {
      6       => 'libsqlite3-ruby',
      default => 'ruby-sqlite3',
    },
    /Gentoo/      => 'dev-ruby/sqlite3',
    /(?i:SuSE)/   => $::operatingsystem ? {
        /(?:OpenSuSE)/ => 'rubygem-sqlite3',
        default        => 'sqlite3-ruby',
    },
    # older Facter versions don't report a Gentoo OS family
    /Linux/        => $::operatingsystem ? {
        /Gentoo/ => 'dev-ruby/sqlite3',
        default  => 'sqlite3-ruby',
    },
    /(?i:Solaris)/ => '',
    default        => 'sqlite3-ruby',
  }

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

  ### Enable setting of dns_alt_names
  $dns_alt_names = ''
  $certname = $clientcert

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

}
