# == Class: nginxsetup
#
class nginxsetup {

    class { 'nginx':
    }

    file { '/etc/nginx/conf.d/include-sites.conf':
        ensure => file,
        content => 'include /etc/nginx/sites-available/*;',
        notify => Class['nginx::service'],
    }
}
