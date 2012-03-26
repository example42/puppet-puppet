# Class puppet::server::mysql 
# 
# Manages Mysql on Puppet Master.
#
class puppet::server::mysql {

  require puppet

  case $puppet::db_server {
    'localhost','127.0.0.1': {
      include mysql
      mysql::grant { "puppet_server_grants_${fqdn}":
        mysql_db         => $puppet::db_name,
        mysql_user       => $puppet::db_user,
        mysql_password   => $puppet::db_password,
        mysql_privileges => 'ALL',
        mysql_host       => $puppet::db_server,
      }
    }
    default: {
      # Attempt to automanage Mysql grants on external servers.
      # TODO: Verify if it works ;-D
      @@mysql::grant { "puppet_server_grants_${fqdn}":
        mysql_db         => $puppet::db_name,
        mysql_user       => $puppet::db_user,
        mysql_password   => $puppet::db_password,
        mysql_privileges => 'ALL',
        mysql_host       => $fqdn,
        tag              => "mysql_grants_${puppet::db_server}",
      }
    }
  }

  case $operatingsystem {
    ubuntu,debian: {
      package { 'libmysql-ruby':
        ensure => present,
      }
    }

    default: { }
  }

}
