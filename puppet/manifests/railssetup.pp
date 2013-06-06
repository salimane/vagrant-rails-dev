# == Class: railssetup
#
class railssetup ($username = 'vagrant',  $rubyversion = '1.9.3-p392') {

    $home_dir    = "/home/${username}"

    import 'rubysetup.pp'

    class { 'rubysetup':
        username    => $username,
        rubyversion =>  $rubyversion
    }

    rbenv::gem { ['rails', 'bundle', 'unicorn', 'capistrano']:
        ensure  => latest,
        user    => $username,
        ruby    => $rubyversion,
        require => Rbenv::Compile[$rubyversion],
    }

    file_line { 'permituserenv':
        path    => '/etc/ssh/sshd_config',
        line    => 'PermitUserEnvironment yes',
        require => File['/etc/ssh/sshd_config']
    }
}
