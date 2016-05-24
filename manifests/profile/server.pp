class puppet::profile::server (

  Variant[Boolean,String]  $ensure              = present,
  Hash                     $settings            = { },
  Hash                     $options             = { },
  Variant[Undef,String[1]] $config_template     = undef,
  Variant[Undef,String[1]] $init_template       = 'puppet/profile/server/init.erb',
  Boolean                  $service_autorestart = true,

) {

  include ::puppet

  ::tp::install { 'puppetserver':
    ensure        => $ensure,
    settings_hash => $settings,
    data_module   => $::puppet::data_module,
    auto_conf     => false,
  }

  if $config_template {
    ::tp::conf { 'puppetserver':
      ensure             => $ensure,
      template           => $config_template,
      settings_hash      => $settings,
      options_hash       => $options,
      config_file_notify => $service_autorestart,
      data_module        => $::puppet::data_module,
    }
  }

  if $init_template {
    ::tp::conf { 'puppetserver::init':
      ensure             => $ensure,
      template           => $init_template,
      options_hash       => $options,
      settings_hash      => $settings,
      base_file          => 'init',
      config_file_notify => $service_autorestart,
      data_module        => $::puppet::data_module,
    }
  }

}
