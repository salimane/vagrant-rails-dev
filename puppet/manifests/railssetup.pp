# == Class: railssetup
#
class railssetup ($username = 'vagrant') {

    $home_dir    = "/home/${username}"
    $rubyversion = '1.9.3-p392'
    #package {['libreadline5-dev']: ensure => 'installed'}

    rbenv::install { $username:
        group => $username,
        user  => $username,
        home  => $home_dir,
    }

    rbenv::plugin {
        'rbenv-gem-rehash':
            group  => $username,
            user   => $username,
            source => 'git://github.com/sstephenson/rbenv-gem-rehash.git';

        'rbenv-vars':
            group  => $username,
            user   => $username,
            source => 'git://github.com/sstephenson/rbenv-vars.git';

        'rbenv-each':
            group  => $username,
            user   => $username,
            source => 'git://github.com/chriseppstein/rbenv-each.git';

        'rbenv-update':
            group  => $username,
            user   => $username,
            source => 'git://github.com/rkh/rbenv-update.git';

        'rbenv-whatis':
            group  => $username,
            user   => $username,
            source => 'git://github.com/rkh/rbenv-whatis.git';

        'rbenv-use':
            group  => $username,
            user   => $username,
            source => 'git://github.com/rkh/rbenv-use.git';

        'rbenv-default-gems':
            group  => $username,
            user   => $username,
            source => 'git://github.com/sstephenson/rbenv-default-gems.git';
    }

    rbenv::compile { $rubyversion:
        group  => $username,
        user   => $username,
        home   => $home_dir,
        global => true
    }

    rbenv::gem { ['specific_install', 'rails', 'bundle', 'unicorn', 'capistrano']:
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
