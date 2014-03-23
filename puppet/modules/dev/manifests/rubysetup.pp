# == Class: dev::rubysetup
#
class dev::rubysetup ($username = 'vagrant',  $rubyversion = '2.1.1') {

    $home_dir    = "/home/${username}"

      # Use rvm to install Ruby 2.1.1
      class { 'rvm':
        version => '1.25.14'
      }
      rvm::system_user { $username: ; }
      rvm_system_ruby {
        'ruby-2.1.1':
          ensure      => present,
          default_use => true,
          require     => [Class['rvm::system']],
      }

      rvm_gem {
        'bundler':
          ensure       => '1.5.3',
          name         => 'bundler',
          ruby_version => 'ruby-2.1.1',
          require      => Rvm_system_ruby['ruby-2.1.1'];
      }
      rvm_gem {
        'specific_install':
          ensure       => ' 0.2.9',
          name         => 'specific_install',
          ruby_version => 'ruby-2.1.1',
          require      => Rvm_system_ruby['ruby-2.1.1'];
      }


      file_line { 'permituserenv':
        path    => '/etc/ssh/sshd_config',
        line    => 'PermitUserEnvironment yes',
        require => File['/etc/ssh/sshd_config']
    }
}
