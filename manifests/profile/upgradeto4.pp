class puppet::profile::upgradeto4 (
  $ensure              = 'present',
  $settings            = hiera('profile::puppet::agent::settings', { }),
  $options             = hiera('profile::puppet::agent::options',{ }),
  $config_template     = hiera('profile::puppet::agent::config_template',undef),
  $init_template       = hiera('profile::puppet::agent::init_template',undef),
  $service_autorestart = true,
) {

  include ::puppet

  $tp_settings = tp_lookup('puppet-agent','settings',$::puppet::data_module,'merge')
  $module_settings = $tp_settings + $settings

  $tp_config_options=tp_lookup('puppet-agent','options::puppet-agent::config',$::puppet::data_module,merge)
  $tp_init_options=tp_lookup('puppet-agent','options::puppet-agent::init',$::puppet::data_module,merge)
  $real_config_options=$tp_config_options + $options
  $real_init_options=$tp_init_options + $options

  $real_config_template = $config_template ? {
    undef   => $::puppet::server_class ? {
      ''      => 'puppet/profile/agent/puppet.conf.erb',
      default => 'puppet/profile/server/puppet.conf.erb',
    },
    default => $template,
  }

  ::tp::install3 { 'puppet':
    ensure => absent,
    settings_hash => {
      service_name     => '',
    }, 
    data_module   => $::puppet::data_module,
  } ->
  ::tp::install3 { 'puppet-agent':
    ensure        => $ensure,
    settings_hash => $module_settings,
    data_module   => $::puppet::data_module,
    auto_conf     => false,
  }

  if $config_template {
    ::tp::conf3 { 'puppet-agent':
      ensure             => $ensure,
      template           => $config_template,
      options_hash       => $real_config_options,
      settings_hash      => $module_settings,
      config_file_notify => $service_autorestart,
      data_module        => $::puppet::data_module,
    }
  }

  if $init_template {
    ::tp::conf3 { 'puppet-agent::init':
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
