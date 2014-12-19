# Class: dev::mysql
#
# This class installs/setup configuration for the mysql database
#
# Parameters:
#   - env : rails environment to use
#
# Actions:
#   - create user mysql with proper group
#   - install mysql client package
#   - install mysql server package
#   - create database according to environment
#   - Setup mysql user access/privileges loaded from related environment yaml file
#
# Requires:
#   - dev::dependencies
#
# Sample Usage:
#   class { 'dev::mysql' : env => 'staging' }
#
#
class dev::mysql($env = 'development') {
  include dev::dependencies

  realize Group['mysql']
  realize User['mysql']

  $account = hiera('database')

  #Needs mysql client
  # realize Exec['webtatic-replace-mysql']
  class { '::mysql::client' :
    package_name => 'mysql',
    # require      => Exec['webtatic-replace-mysql']
  }
  class { '::mysql::server' :
    package_name     => 'mysql-server',
    root_password    => 'wrB5TvCCfYEsBN4k',
    override_options => {
      'mysqld'       => {
        'max_connections' => '1024'
      },
      'bind_address' => $account[$env]['host_ip'],
    },
    # require          => Exec['webtatic-replace-mysql']
  }

  Database {
    require => Class['::mysql::server'],
  }

  mysql::db { $account[$env]['database']:
    ensure   => 'present',
    user     => $account[$env]['username'],
    password => $account[$env]['password'],
    grant    => ['all'],
    charset  => 'utf8',
  }

  dev::mysql_grant { $account[$env]['access'] :
    username   => $account[$env]['username'],
    password   => $account[$env]['password'],
    database   => $account[$env]['database'],
    privileges => ['all'],
    require    => Class['::mysql::server']
  }

  # mysql::db { $account['test']['database']:
  #   ensure   => 'present',
  #   user     => $account['test']['username'],
  #   password => $account['test']['password'],
  #   grant    => ['all'],
  #   charset  => 'utf8',
  # }

  dev::mysql_grant { $account['test']['access'] :
    username   => $account['test']['username'],
    password   => $account['test']['password'],
    database   => '*',
    privileges => ['all'],
  }

  mysql::db { $account['staging']['database']:
    ensure   => 'present',
    user     => $account['staging']['username'],
    password => $account['staging']['password'],
    grant    => ['all'],
    charset  => 'utf8',
  }

  dev::mysql_grant { $account['staging']['access'] :
    username   => $account['staging']['username'],
    password   => $account['staging']['password'],
    database   => $account['staging']['database'],
    privileges => ['all'],
  }

  mysql::db { $account['production']['database']:
    ensure   => 'present',
    user     => $account['production']['username'],
    password => $account['production']['password'],
    grant    => ['all'],
    charset  => 'utf8',
  }

  dev::mysql_grant { $account['production']['access'] :
    username   => $account['production']['username'],
    password   => $account['production']['password'],
    database   => $account['production']['database'],
    privileges => ['all'],
  }

  # include ::mysql::server::account_security
  include ::mysql::server::mysqltuner

}
