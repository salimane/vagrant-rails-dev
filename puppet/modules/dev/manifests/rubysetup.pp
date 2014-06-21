# == Class: dev::rubysetup
#
class dev::rubysetup ($username = 'vagrant',  $rubyversion = '2.1.2') {

    $home_dir    = "/home/${username}"

      # Use rvm to install Ruby 2.1.2
      class { 'rvm':
        version => '1.25.27'
      }
      rvm::system_user { $username: ; }
      rvm_system_ruby {
        'ruby-2.1.2':
          ensure      => present,
          default_use => true,
          require     => [Class['rvm::system']],
      }

      rvm_gem {
        'bundler':
          ensure       => '1.6.3',
          name         => 'bundler',
          ruby_version => 'ruby-2.1.2',
          require      => Rvm_system_ruby['ruby-2.1.2'];
      }
      rvm_gem {
        'specific_install':
          ensure       => ' 0.2.11',
          name         => 'specific_install',
          ruby_version => 'ruby-2.1.2',
          require      => Rvm_system_ruby['ruby-2.1.2'];
      }


      file_line { 'permituserenv':
        path    => '/etc/ssh/sshd_config',
        line    => 'PermitUserEnvironment yes',
        require => File['/etc/ssh/sshd_config']
    }
}
