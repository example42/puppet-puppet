class puppet::profile::puppetdb (

  Variant[Boolean,String]  $ensure              = present,
  Hash                     $settings            = { },
  Hash                     $options             = { },
  Variant[Undef,String[1]] $config_template     = undef,
  Variant[Undef,String[1]] $init_template       = undef,
  Boolean                  $service_autorestart = true,

) {

  include ::puppet

  $tp_settings = tp_lookup('puppetdb','settings',$::puppet::data_module,'merge')
  $module_settings = $tp_settings + $settings

  $tp_config_options=tp_lookup('puppetdb','options::puppetdb::config',$::puppet::data_module,merge)
  $tp_init_options=tp_lookup('puppetdb','options::puppetdb::init',$::puppet::data_module,merge)
  $real_config_options=$tp_config_options + $options
  $real_init_options=$tp_init_options + $options

  if $module_settings['service_name'] and $service_autorestart {
    $service_notify = "Service[${module_settings['service_name']}]"
  } else {
    $service_notify = undef
  } 

  ::tp::install { 'puppetdb':
    ensure        => $ensure,
    settings_hash => $module_settings,
    data_module   => $::puppet::data_module,
    auto_conf     => false,
  }

  if $config_template {
    ::tp::conf { 'puppetdb':
      ensure             => $ensure,
      template           => $config_template,
      settings_hash      => $module_settings,
      config_file_notify => $service_autorestart,
      data_module        => $::puppet::data_module,
    }
  }

  if $init_template {
    ::tp::conf { 'puppetdb::init':
      ensure             => $ensure,
      template           => $init_template,
      options_hash       => $real_init_options,
      settings_hash      => $module_settings,
      base_file          => 'init',
      config_file_notify => $service_autorestart,
      data_module        => $::puppet::data_module,
    }
  }

}
