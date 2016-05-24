class puppet::profile::agent (

  Variant[Boolean,String]  $ensure              = present,
  Hash                     $settings            = { },
  Hash                     $options             = { },
  Variant[Undef,String[1]] $config_template     = undef,
  Variant[Undef,String[1]] $init_template       = undef,
  Boolean                  $service_autorestart = true,
  Boolean                  $create_symlinks  = true,

) {

  include ::puppet

  $tp_settings = tp_lookup('puppet-agent','settings',$::puppet::data_module,'merge')
  $module_settings = $tp_settings + $settings

  $tp_config_options=tp_lookup('puppet-agent','options::puppet-agent::config',$::puppet::data_module,merge)
  $tp_init_options=tp_lookup('puppet-agent','options::puppet-agent::init',$::puppet::data_module,merge)
  $real_config_options=$tp_config_options + $options
  $real_init_options=$tp_init_options + $options

  if $module_settings['service_name'] and $service_autorestart {
    $service_notify = "Service[${module_settings['service_name']}]"
  } else {
    $service_notify = undef
  } 

  $real_config_template = $config_template ? {
    undef   => $::puppet::server_class ? {
      ''      => 'puppet/profile/agent/puppet.conf.erb',
      default => 'puppet/profile/server/puppet.conf.erb',
    },
    default => $template,
  }

  ::tp::install { 'puppet-agent':
    ensure        => $ensure,
    settings_hash => $module_settings,
    data_module   => $::puppet::data_module,
    auto_conf     => false,
  }

  if $config_template {
    ::tp::conf { 'puppet-agent':
      ensure             => $ensure,
      template           => $config_template,
      options_hash       => $real_config_options,
      settings_hash      => $module_settings,
      config_file_notify => $service_autorestart,
      data_module        => $::puppet::data_module,
    }
  }

  if $init_template {
    ::tp::conf { 'puppet-agent::init':
      ensure             => $ensure,
      template           => $init_template,
      options_hash       => $real_init_options,
      settings_hash      => $module_settings,
      base_file          => 'init',
      config_file_notify => $service_autorestart,
      data_module        => $::puppet::data_module,
    }
  }

  if $create_symlinks {
    ['puppet','facter','hiera'].each |$cmd| {
      file { "/usr/local/bin/${cmd}":
        ensure => link,
        target => "/opt/puppetlabs/bin/${cmd}",
      }
    }
  }

}
