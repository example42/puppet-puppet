class puppet (

  String    $agent_class    = '::puppet::profile::agent',
  String    $server_class   = '',
  String    $puppetdb_class = '',

  String[1] $data_module    = 'puppet',

) {

  if $agent_class != '' {
    include $agent_class
  }
  if $server_class != '' {
    include $server_class
  }
  if $puppetdb_class != '' {
    include $puppetdb_class
  }

}
