# == Class: dev::rubysetup
#
class dev::rubysetup (
  $username        = 'vagrant',
  $group           = 'vagrant',
  $rvm_version     = '1.25.31',
  $ruby_version    = 'ruby-2.1.5',
  $bundler_version = '1.7.7'
) {

  $home_dir    = "/home/${username}"

  #Use rvm to install Ruby
  class { 'rvm':
    version => $rvm_version
  }
  rvm::system_user { $username: ; }
  rvm_system_ruby {
    $ruby_version:
      ensure      => present,
      default_use => true,
      require     => [Class['rvm::system']];
  }

  rvm_gem {
    'bundler':
      ensure       => $bundler_version,
      name         => 'bundler',
      ruby_version => $ruby_version,
      require      => Rvm_system_ruby[$ruby_version];
  }

  rvm_gem {
    'specific_install':
      ensure       => ' 0.2.11',
      name         => 'specific_install',
      ruby_version => $ruby_version,
      require      => Rvm_system_ruby[$ruby_version];
  }

  file_line { 'permituserenv':
    path    => '/etc/ssh/sshd_config',
    line    => 'PermitUserEnvironment yes',
    require => File['/etc/ssh/sshd_config']
  }
}
