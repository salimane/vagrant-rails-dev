# Define Resource Type: dev::mysql_grant
#
# This ressource type helps grant mysql access privileges to multiple hosts
#
# Parameters:
#   - username : username of user access should be given to
#   - database : database to give access to
#   - privileges : privileges to set
#
# Requires:
#   - mysql
#   - mysql::server
#   - database already created with specifed user
#
# Sample Usage:
#   dev::mysql_grant { ['hostname1', 'hostname2'] :
#       username => 'my_username',
#       database => 'my_database',
#       privileges => ['all'],
#   }
#
#
define dev::mysql_grant($username, $password, $database, $privileges) {
  $host = regsubst($name, '^(.+)/([^-]+)$', '\1')
  # $database = regsubst($name, '^(.+)/([^-]+)$', '\2')

  $user_resource = {
    ensure        => 'present',
    password_hash => mysql_password($password),
    provider      => 'mysql',
    require       => Class['::mysql::server'],
  }
  ensure_resource('mysql_user', "${username}@${host}", $user_resource)
  mysql_grant { "${username}@${host}/${database}.*":
    privileges => $privileges,
    provider   => 'mysql',
    table      => "${database}.*",
    user       => "${username}@${host}",
    require    => [ Mysql_user["${username}@${host}"], Class['::mysql::server'] ],
  }
}
