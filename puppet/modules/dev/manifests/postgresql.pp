# == Class: dev::postgresql
#
class dev::postgresql {
  class {'::postgresql::server': }
}
