# Class puppet::server::sqlite
#
# Manages sqlite on Puppet Master.
#
class puppet::server::sqlite {

  require puppet

  package { $::puppet::sqlite_package:
    ensure => present,
  }
}
