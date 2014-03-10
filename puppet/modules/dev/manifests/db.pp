# Class: dev::db
#
# This class installs/setup configuration for the dev database
#
# Parameters:
#   - env : rails environment to use
#
# Actions:
#   - create user mysql with proper group
#   - install mysql55 client package
#   - install mysql55 server package
#   - create database according to environment
#   - Setup mysql user access/privileges loaded from related environment yaml file
#
# Requires:
#   - dev::dependencies
#
# Sample Usage:
#   class { 'dev::db' : env => 'staging' }
#
#
class dev::db($env = 'development') {
  include dev::dependencies

  realize Group['mysql']
  realize User['mysql']

  $account = hiera('database')

  #Needs mysql client
  realize Exec['webtatic-replace-mysql']
  class { 'mysql::client':
    package_name => 'mysql55',
    require      => Exec['webtatic-replace-mysql']
  } ->
  class { 'mysql::server':
    package_name     => 'mysql55-server',
    root_password    => 'wrB5TvCCfYEsBN4k',
    override_options => { 'mysqld' => { 'max_connections' => '1024' }, 'bind_address'  => $account[$env]['host_ip'], },
    require          => Exec['webtatic-replace-mysql']
  }

  Database {
    require => Class['mysql::server'],
  }

  mysql::db { $account[$env]['database']:
    ensure   => 'present',
    user     => $account[$env]['username'],
    password => $account[$env]['password'],
    grant    => ['all'],
    charset  => 'utf8',
  }

  dev::db_grant { $account[$env]['access'] :
    username   => $account[$env]['username'],
    password   => $account[$env]['password'],
    database   => $account[$env]['database'],
    privileges => ['all'],
    require    => Class['mysql::server']
  }

  include mysql::server::account_security
  include mysql::server::mysqltuner

}
