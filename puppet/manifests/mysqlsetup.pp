# == Class: mysqlsetup
#
class mysqlsetup {

    #remove all system mysql before this

    apt::source { 'percona':
        location    => 'http://repo.percona.com/apt',
        release     => $lsbdistcodename,
        repos       => 'main',
        include_src => true,
        key         => 'CD2EFD2A',
        key_server  => 'keys.gnupg.net',
        require => Apt::Pin['00percona']
    }

    apt::pin { '00percona': priority => 1001 }

    package {
        ['percona-server-server-5.5', 'percona-server-client-5.5', 'libmysqlclient-dev'] :
            ensure  => installed,
            require => [ Apt::Source['percona']];
    }

    service { 'mysql':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['percona-server-server-5.5'],
    }

    # Equivalent to /usr/bin/mysql_secure_installation without providing or setting a password
    exec { 'mysql_secure_installation':
        command => '/usr/bin/mysql -uroot -e "DELETE FROM mysql.user WHERE User=\'\'; DELETE FROM mysql.user WHERE User=\'root\' AND Host NOT IN (\'localhost\', \'127.0.0.1\', \'::1\'); DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;" mysql',
        require => Service['mysql'],
    }
}
